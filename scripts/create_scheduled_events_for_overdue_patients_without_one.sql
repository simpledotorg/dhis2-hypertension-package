DO $$
DECLARE 
    next_id INT;
    reset_seq_value INT;
BEGIN
    -- 1. Get the next available ID from the new 'event' table
    SELECT COALESCE(MAX(eventid) + 1, 1) INTO next_id
    FROM event;

    -- 2. Create temporary sequence
    EXECUTE 'CREATE SEQUENCE event_id_temp_seq START WITH ' || next_id || ' INCREMENT BY 1;';

WITH LatestEvent AS (
    SELECT 
        en.trackedentityid,
        ev.eventid,
        ev.occurreddate, -- In 2.41, executiondate is often referred to as occurreddate in the API, but the column is occurreddate
        ev.programstageid,
        ev.enrollmentid,
        tei.organisationunitid,
        teav.value AS ncd_status,
        ROW_NUMBER() OVER (PARTITION BY ev.enrollmentid ORDER BY ev.occurreddate DESC) AS rn
    FROM 
        event ev
    INNER JOIN
        enrollment en ON en.enrollmentid = ev.enrollmentid
    INNER JOIN 
        trackedentity tei ON en.trackedentityid = tei.trackedentityid
    INNER JOIN
        trackedentityattributevalue teav ON tei.trackedentityid = teav.trackedentityid
        AND teav.trackedentityattributeid = (SELECT trackedentityattributeid FROM trackedentityattribute WHERE uid = 'fI1P3Mg1zOZ')
    WHERE 
        ev.deleted = FALSE
        AND ev.programstageid = (SELECT programstageid FROM programstage WHERE uid = 'anb2cjLx3WM')
),
OverdueInstances AS (
    SELECT 
        le.trackedentityid
    FROM 
        LatestEvent le
    WHERE 
        le.rn = 1 -- Latest event
        AND le.occurreddate >= CURRENT_DATE - INTERVAL '366 days' 
        AND le.occurreddate < CURRENT_DATE - INTERVAL '28 days' 
        AND le.ncd_status NOT IN ('DIED', 'TRANSFER')
),
InsertData AS (
    SELECT DISTINCT ON (le.trackedentityid)
        le.trackedentityid,
        le.enrollmentid,
        le.programstageid,
        le.organisationunitid,
        le.occurreddate + INTERVAL '28 days' AS duedate
    FROM 
        LatestEvent le
    WHERE 
        le.trackedentityid IN (SELECT trackedentityid FROM OverdueInstances)
)
-- 3. Insert into the 'event' table using 2.41 schema
INSERT INTO event (eventid, uid, created, lastupdated, lastsynchronized, enrollmentid, programstageid, organisationunitid, deleted, status, duedate, eventdatavalues, attributeoptioncomboid)
SELECT
    nextval('event_id_temp_seq'),
    generate_uid(),
    CURRENT_TIMESTAMP,
    CURRENT_TIMESTAMP,
    CURRENT_TIMESTAMP,
    id.enrollmentid,
    id.programstageid,
    id.organisationunitid,
    FALSE,
    'SCHEDULE',
    id.duedate, 
    '{}'::jsonb,
    (SELECT categoryoptioncomboid FROM categoryoptioncombo WHERE uid = 'bRowv6yZOF2') -- Added default AOC (usually 'default')
FROM 
    InsertData id;

-- 4. Sync the permanent sequence
SELECT nextval('event_id_temp_seq') INTO reset_seq_value;

-- Note: The sequence name in 2.41 is typically 'event_sequence'
EXECUTE 'ALTER SEQUENCE event_sequence RESTART WITH ' || reset_seq_value;

DROP SEQUENCE event_id_temp_seq;

END $$;
