CREATE OR REPLACE FUNCTION update_overdue_pending_call_for_existing_data_function ()
    RETURNS VOID
    AS $$
DECLARE
    overdue_row RECORD;
    start_time timestamp;
    end_time timestamp;
    num_inserts int := 0;
    tracked_entity_uid text;
    -- Variable to store trackedentityinstance UID
    attribute_exists boolean;
BEGIN
    -- Record the start time
    start_time := clock_timestamp();
    -- Loop through each program instance with upcoming visits
    FOR overdue_row IN
    SELECT
        psi.programinstanceid,
        MAX(psi.duedate) AS max_duedate
    FROM
        programstageinstance AS psi
    WHERE
        psi.deleted = false AND
        psi.programinstanceid IN (
            SELECT
                pi.programinstanceid
            FROM
                programinstance AS pi
            WHERE
                pi.status = 'ACTIVE')
        AND psi.status IN ('SCHEDULE', 'OVERDUE')
    GROUP BY
        psi.programinstanceid LOOP
            -- Check if current timestamp plus 2 hours is greater than the max_duedate
            IF CURRENT_TIMESTAMP + INTERVAL '2 hours' > overdue_row.max_duedate THEN
                -- Fetch trackedentityinstance UID corresponding to programinstanceid
                SELECT
                    uid INTO tracked_entity_uid
                FROM
                    trackedentityinstance
                WHERE
                    trackedentityinstanceid = (
                        SELECT
                            trackedentityinstanceid
                        FROM
                            programinstance
                        WHERE
                            programinstanceid = overdue_row.programinstanceid);
                -- Check if there is already a value of OVERDUE_PENDING_CALL for the attribute
                SELECT
                    EXISTS (
                        SELECT
                            1
                        FROM
                            trackedentityattributevalue
                        WHERE
                            trackedentityinstanceid = (
                                SELECT
                                    trackedentityinstanceid
                                FROM
                                    programinstance
                                WHERE
                                    programinstanceid = overdue_row.programinstanceid)
                                AND trackedentityattributeid = (
                                    SELECT
                                        trackedentityattributeid
                                    FROM
                                        trackedentityattribute
                                    WHERE
                                        uid = 'rgeuEnAI0nj')
                                    AND value IS NOT NULL) INTO attribute_exists;
                -- If the attribute value does not exist, proceed with the insert
                IF NOT attribute_exists THEN
                    -- Attempt to insert a new trackedentityattributevalue with value OVERDUE_PENDING_CALL
                    BEGIN
                        -- Insert into the trackedentityattributevalue table
                        INSERT INTO trackedentityattributevalue (trackedentityinstanceid, trackedentityattributeid, value, created, lastupdated, storedby)
                            VALUES ((
                                    SELECT
                                        trackedentityinstanceid
                                    FROM
                                        programinstance
                                    WHERE
                                        programinstanceid = overdue_row.programinstanceid), (
                                        SELECT
                                            trackedentityattributeid
                                        FROM
                                            trackedentityattribute
                                        WHERE
                                            uid = 'rgeuEnAI0nj'), 'OVERDUE_PENDING_CALL', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, -- Use current date and time
                                        'trigger');
                        -- Increment the number of inserts
                        num_inserts := num_inserts + 1;
                        -- Log successful insert
                        RAISE INFO 'Inserted trackedentityattributevalue for trackedentityinstance UID: %', tracked_entity_uid;
                    EXCEPTION
                        WHEN OTHERS THEN
                            -- Log error if insert fails
                            RAISE EXCEPTION 'Error inserting trackedentityattributevalue for program instance %', overdue_row.programinstanceid;
                    END;
            ELSE
                -- Log skipping the insert if attribute value already exists
                RAISE INFO 'Skipped insert for trackedentityinstance UID: % because OVERDUE_PENDING_CALL already exists', tracked_entity_uid;
                END IF;
            END IF;
    END LOOP;
    -- Record the end time
    end_time := clock_timestamp();
    -- Log performance statistics
    RAISE INFO 'Function execution time: %', end_time - start_time;
    RAISE INFO 'Number of rows inserted: %', num_inserts;
END;

$$
LANGUAGE plpgsql;

SELECT
    update_overdue_pending_call_for_existing_data_function ();

