DO $$
DECLARE 
    next_id INT;
    reset_seq_value INT;
BEGIN
    SELECT COALESCE(MAX(programstageinstanceid) + 1, 1) INTO next_id
    FROM programstageinstance;

    EXECUTE 'CREATE SEQUENCE programstageinstance_id_seq START WITH ' || next_id || ' INCREMENT BY 1;';

WITH LatestEvent AS (
    SELECT 
        pi.trackedentityinstanceid,
        psi.programstageinstanceid,
        psi.executiondate,
        psi.programstageid,
        psi.programinstanceid,
        tei.organisationunitid,
        teav.value AS ncd_status,
        ROW_NUMBER() OVER (PARTITION BY psi.programinstanceid ORDER BY psi.executiondate DESC) AS rn
    FROM 
        programstageinstance psi
    INNER JOIN
	    programinstance pi ON pi.programinstanceid = psi.programinstanceid
    INNER JOIN 
        trackedentityinstance tei ON pi.trackedentityinstanceid = tei.trackedentityinstanceid
    INNER JOIN
        trackedentityattributevalue teav ON tei.trackedentityinstanceid = teav.trackedentityinstanceid
        AND teav.trackedentityattributeid = (SELECT trackedentityattributeid FROM trackedentityattribute WHERE uid = 'fI1P3Mg1zOZ')
    WHERE 
        psi.deleted = FALSE
        AND psi.programstageid = (SELECT programstageid FROM programstage WHERE uid = 'anb2cjLx3WM')
),
OverdueInstances AS (
    SELECT 
        le.trackedentityinstanceid
    FROM 
        LatestEvent le
    WHERE 
        le.rn = 1 -- Latest event
        AND le.executiondate >= CURRENT_DATE - INTERVAL '366 days' -- Start date
        AND le.executiondate < CURRENT_DATE - INTERVAL '28 days' -- End date
        AND le.ncd_status NOT IN ('DIED', 'TRANSFER')
),
InsertData AS (
    SELECT DISTINCT ON (oe.trackedentityinstanceid)
        oe.trackedentityinstanceid,
        oe.programinstanceid,
        oe.programstageid,
        oe.organisationunitid,
        oe.executiondate + INTERVAL '28 days' AS duedate -- Add 28 days to the executiondate
    FROM 
        LatestEvent oe
    WHERE 
        oe.trackedentityinstanceid IN (SELECT trackedentityinstanceid FROM OverdueInstances)
)
INSERT INTO programstageinstance (programstageinstanceid, uid, created, lastupdated, lastsynchronized, programinstanceid, programstageid, organisationunitid, deleted, status, duedate, eventdatavalues)
SELECT
    nextval('programstageinstance_id_seq'),
    generate_uid(),
    CURRENT_TIMESTAMP,
    CURRENT_TIMESTAMP,
    CURRENT_TIMESTAMP,
    id.programinstanceid,
    id.programstageid,
    id.organisationunitid,
    FALSE,
    'SCHEDULE',
    id.duedate,	
    '{}'::jsonb
FROM 
    InsertData id;

SELECT nextval('programstageinstance_id_seq') INTO reset_seq_value;

EXECUTE 'ALTER SEQUENCE programstageinstance_sequence RESTART WITH ' || reset_seq_value;

DROP SEQUENCE programstageinstance_id_seq;

END $$;