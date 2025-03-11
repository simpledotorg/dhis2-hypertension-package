CREATE OR REPLACE FUNCTION fix_orphaned_scheduled_visits()
RETURNS void AS
$$
DECLARE
    scheduled_visit_record RECORD;
    temp_record RECORD;
    remaining_scheduled_visits RECORD;
    program_stage_id INT;
BEGIN
    SELECT programstageid INTO program_stage_id FROM programstage WHERE uid = 'anb2cjLx3WM';

    CREATE TEMP TABLE temp_scheduled_actual_visits (
        scheduled_visit_id INT,
        scheduled_duedate DATE,
        actual_visit_id INT,
        actual_duedate DATE
    );

    FOR scheduled_visit_record IN
        SELECT 
            psi.programinstanceid,
            psi.programstageinstanceid AS scheduled_visit_id,
            psi.duedate AS scheduled_duedate
        FROM programstageinstance psi
        WHERE psi.status IN ('SCHEDULE', 'OVERDUE') 
          AND psi.executiondate IS NULL
          AND psi.programstageid = program_stage_id
          AND psi.deleted = FALSE
    LOOP
        -- For each scheduled visit, find the closest actual visit and insert into the temp table
        INSERT INTO temp_scheduled_actual_visits (scheduled_visit_id, scheduled_duedate, actual_visit_id, actual_duedate)

        SELECT 
            scheduled_visit_record.scheduled_visit_id,
            scheduled_visit_record.scheduled_duedate,
            av.programstageinstanceid AS actual_visit_id,
            av.duedate AS actual_duedate
        FROM programstageinstance av
        WHERE av.programinstanceid = scheduled_visit_record.programinstanceid
          AND av.status IN ('COMPLETED', 'ACTIVE') 
          AND av.executiondate IS NOT NULL
          AND av.executiondate >= scheduled_visit_record.scheduled_duedate
          AND av.programstageid = program_stage_id
        ORDER BY av.executiondate ASC
        LIMIT 1;
    END LOOP;

    FOR temp_record IN
      SELECT * from temp_scheduled_actual_visits order by actual_visit_id, scheduled_duedate desc
    LOOP
      UPDATE programstageinstance psi
      SET 
          -- Update duedate for the actual visit
          duedate = temp_record.scheduled_duedate
      WHERE psi.programstageinstanceid = temp_record.actual_visit_id;

      -- Mark as deleted for the orphaned scheduled visit
      UPDATE programstageinstance psi
      SET deleted = TRUE
      WHERE psi.programstageinstanceid = temp_record.scheduled_visit_id;
    END LOOP;

    DROP TABLE IF EXISTS temp_scheduled_actual_visits;

    -- Mark remaining scheduled visits with no visit after them as deleted and keep the latest one
    FOR remaining_scheduled_visits IN
      SELECT 
            psi.programinstanceid,
            max(psi.duedate) AS max_duedate,
            min(psi.duedate) AS min_duedate
        FROM programstageinstance psi
        WHERE psi.status IN ('SCHEDULE', 'OVERDUE') 
          AND psi.executiondate IS NULL
          AND psi.deleted = FALSE
          AND psi.programstageid = program_stage_id
        GROUP BY psi.programinstanceid
    LOOP
      UPDATE programstageinstance psi
      SET deleted = TRUE
      WHERE psi.programinstanceid = remaining_scheduled_visits.programinstanceid
      AND psi.duedate < remaining_scheduled_visits.max_duedate
      AND psi.programstageid = program_stage_id
      AND psi.status IN ('SCHEDULE', 'OVERDUE')
      AND deleted = FALSE;
    END LOOP;

END;
$$
LANGUAGE plpgsql;