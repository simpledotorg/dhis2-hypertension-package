CREATE OR REPLACE FUNCTION fix_orphaned_scheduled_visits()
RETURNS void AS
$$
DECLARE
    scheduled_visit_record RECORD;
    temp_record RECORD;
    remaining_scheduled_visits RECORD;
    program_stage_id INT;
BEGIN
    -- Get the internal ID for the program stage
    SELECT programstageid INTO program_stage_id FROM programstage WHERE uid = 'anb2cjLx3WM';

    -- Create temp table using 2.41 column naming conventions
    CREATE TEMP TABLE temp_scheduled_actual_visits (
        scheduled_visit_id INT,
        scheduled_duedate DATE,
        actual_visit_id INT,
        actual_duedate DATE
    );

    FOR scheduled_visit_record IN
        SELECT 
            ev.enrollmentid,
            ev.eventid AS scheduled_visit_id,
            ev.duedate AS scheduled_duedate
        FROM event ev
        WHERE ev.status IN ('SCHEDULE', 'OVERDUE') 
          AND ev.occurreddate IS NULL  -- executiondate is now occurreddate
          AND ev.programstageid = program_stage_id
          AND ev.deleted = FALSE
    LOOP
        -- For each scheduled visit, find the closest actual visit and insert into the temp table
        INSERT INTO temp_scheduled_actual_visits (scheduled_visit_id, scheduled_duedate, actual_visit_id, actual_duedate)
        SELECT 
            scheduled_visit_record.scheduled_visit_id,
            scheduled_visit_record.scheduled_duedate,
            av.eventid AS actual_visit_id,
            av.duedate AS actual_duedate
        FROM event av
        WHERE av.enrollmentid = scheduled_visit_record.enrollmentid
          AND av.status IN ('COMPLETED', 'ACTIVE') 
          AND av.occurreddate IS NOT NULL
          AND av.occurreddate >= scheduled_visit_record.scheduled_duedate
          AND av.programstageid = program_stage_id
        ORDER BY av.occurreddate ASC
        LIMIT 1;
    END LOOP;

    FOR temp_record IN
      SELECT * FROM temp_scheduled_actual_visits ORDER BY actual_visit_id, scheduled_duedate DESC
    LOOP
      -- Update the actual visit with the scheduled due date
      UPDATE event ev
      SET duedate = temp_record.scheduled_duedate
      WHERE ev.eventid = temp_record.actual_visit_id;

      -- Mark the orphaned scheduled visit as deleted
      UPDATE event ev
      SET deleted = TRUE
      WHERE ev.eventid = temp_record.scheduled_visit_id;
    END LOOP;

    DROP TABLE IF EXISTS temp_scheduled_actual_visits;

    -- Cleanup: Mark redundant scheduled visits as deleted, keeping only the latest one
    FOR remaining_scheduled_visits IN
      SELECT 
            ev.enrollmentid,
            max(ev.duedate) AS max_duedate
        FROM event ev
        WHERE ev.status IN ('SCHEDULE', 'OVERDUE') 
          AND ev.occurreddate IS NULL
          AND ev.deleted = FALSE
          AND ev.programstageid = program_stage_id
        GROUP BY ev.enrollmentid
    LOOP
      UPDATE event ev
      SET deleted = TRUE
      WHERE ev.enrollmentid = remaining_scheduled_visits.enrollmentid
      AND ev.duedate < remaining_scheduled_visits.max_duedate
      AND ev.programstageid = program_stage_id
      AND ev.status IN ('SCHEDULE', 'OVERDUE')
      AND ev.deleted = FALSE;
    END LOOP;

END;
$$
LANGUAGE plpgsql;
