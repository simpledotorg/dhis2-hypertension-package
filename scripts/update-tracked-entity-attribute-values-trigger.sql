DROP TRIGGER IF EXISTS update_teav_OVERDUE_PENDING_CALL_trigger_function ON programstageinstance;

DROP FUNCTION IF EXISTS update_teav_OVERDUE_PENDING_CALL_trigger_function ();

CREATE OR REPLACE FUNCTION update_teav_OVERDUE_PENDING_CALL_trigger_function ()
    RETURNS TRIGGER
    AS $$
BEGIN
    -- Check if the status column is being updated to 'OVERDUE'
    IF NEW.status = 'OVERDUE' AND OLD.status <> NEW.status THEN
        -- Update or insert a row in the trackedentityattributevalue with value OVERDUE_PENDING_CALL
        BEGIN
            INSERT INTO trackedentityattributevalue (trackedentityinstanceid, trackedentityattributeid, value, created, lastupdated, storedby)
                VALUES ((
                        SELECT
                            trackedentityinstanceid
                        FROM
                            programinstance
                        WHERE
                            programinstanceid = NEW.programinstanceid), (
                            SELECT
                                trackedentityattributeid
                            FROM
                                trackedentityattribute
                            WHERE
                                uid = 'rgeuEnAI0nj'), 'OVERDUE_PENDING_CALL', (
                                SELECT
                                    created
                                FROM
                                    programinstance
                                WHERE
                                    programinstanceid = NEW.programinstanceid), CURRENT_TIMESTAMP, -- Use current date and time
                                'trigger');
        EXCEPTION
            WHEN unique_violation THEN
                UPDATE
                    trackedentityattributevalue
                SET
                    value = 'OVERDUE_PENDING_CALL',
                    lastupdated = CURRENT_TIMESTAMP, -- Use current date and time
                    storedby = 'trigger'
                WHERE
                    trackedentityinstanceid = (
                        SELECT
                            trackedentityinstanceid
                        FROM
                            programinstance
                        WHERE
                            programinstanceid = NEW.programinstanceid)
                    AND trackedentityattributeid = (
                        SELECT
                            trackedentityattributeid
                        FROM
                            trackedentityattribute
                        WHERE
                            uid = 'rgeuEnAI0nj');
        END;
    END IF;
    RETURN NEW;
END;

$$
LANGUAGE plpgsql;

CREATE TRIGGER update_teav_OVERDUE_PENDING_CALL_trigger_function
    AFTER UPDATE ON programstageinstance
    FOR EACH ROW
    WHEN (NEW.status IS DISTINCT FROM OLD.status)
    EXECUTE FUNCTION update_teav_OVERDUE_PENDING_CALL_trigger_function ();

-----------------------------------------------------------------------------------------------------------
DROP TRIGGER IF EXISTS update_teav_UPCOMING_VISIT_trigger_function ON programstageinstance;

DROP FUNCTION IF EXISTS update_teav_UPCOMING_VISIT_trigger_function ();

CREATE OR REPLACE FUNCTION update_teav_UPCOMING_VISIT_trigger_function ()
    RETURNS TRIGGER
    AS $$
BEGIN
    -- Check if the newly inserted row has programstageid equal to the given programstage uid
    IF NEW.programstageid = (
        SELECT
            programstageid
        FROM
            programstage
        WHERE
            uid = 'anb2cjLx3WM') AND NEW.status = 'SCHEDULE' THEN
        -- Update or insert a row in the trackedentityattributevalue with value UPCOMING_VISIT
        BEGIN
            INSERT INTO trackedentityattributevalue (trackedentityinstanceid, trackedentityattributeid, value, created, lastupdated, storedby)
                VALUES ((
                        SELECT
                            trackedentityinstanceid
                        FROM
                            programinstance
                        WHERE
                            programinstanceid = NEW.programinstanceid), (
                            SELECT
                                trackedentityattributeid
                            FROM
                                trackedentityattribute
                            WHERE
                                uid = 'rgeuEnAI0nj'), 'UPCOMING_VISIT', (
                                SELECT
                                    created
                                FROM
                                    programinstance
                                WHERE
                                    programinstanceid = NEW.programinstanceid), CURRENT_TIMESTAMP, -- Use current date and time
                                'trigger');
        EXCEPTION
            WHEN unique_violation THEN
                UPDATE
                    trackedentityattributevalue
                SET
                    value = 'UPCOMING_VISIT',
                    lastupdated = CURRENT_TIMESTAMP, -- Use current date and time
                    storedby = 'trigger'
                WHERE
                    trackedentityinstanceid = (
                        SELECT
                            trackedentityinstanceid
                        FROM
                            programinstance
                        WHERE
                            programinstanceid = NEW.programinstanceid)
                    AND trackedentityattributeid = (
                        SELECT
                            trackedentityattributeid
                        FROM
                            trackedentityattribute
                        WHERE
                            uid = 'rgeuEnAI0nj');
        END;
    END IF;
    RETURN NEW;
END;

$$
LANGUAGE plpgsql;

CREATE TRIGGER update_teav_UPCOMING_VISIT_trigger_function
    AFTER INSERT ON programstageinstance
    FOR EACH ROW
    EXECUTE FUNCTION update_teav_UPCOMING_VISIT_trigger_function ();

-----------------------------------------------------------------------------------------------------------
DROP TRIGGER IF EXISTS update_teav_CALLED_trigger_function ON programstageinstance;

DROP FUNCTION IF EXISTS update_teav_CALLED_trigger_function ();

CREATE OR REPLACE FUNCTION update_teav_CALLED_trigger_function ()
    RETURNS TRIGGER
    AS $$
BEGIN
    -- Check if the newly inserted row has programstageid equal to the given programstage uid
    IF NEW.programstageid = (
        SELECT
            programstageid
        FROM
            programstage
        WHERE
            uid = 'W7BCOaSquMd') THEN
        -- Update or insert a row in the trackedentityattributevalue with value CALLED
        BEGIN
            INSERT INTO trackedentityattributevalue (trackedentityinstanceid, trackedentityattributeid, value, created, lastupdated, storedby)
                VALUES ((
                        SELECT
                            trackedentityinstanceid
                        FROM
                            programinstance
                        WHERE
                            programinstanceid = NEW.programinstanceid), (
                            SELECT
                                trackedentityattributeid
                            FROM
                                trackedentityattribute
                            WHERE
                                uid = 'rgeuEnAI0nj'), 'CALLED', (
                                SELECT
                                    created
                                FROM
                                    programinstance
                                WHERE
                                    programinstanceid = NEW.programinstanceid), CURRENT_TIMESTAMP, -- Use current date and time
                                'trigger');
        EXCEPTION
            WHEN unique_violation THEN
                UPDATE
                    trackedentityattributevalue
                SET
                    value = 'CALLED',
                    lastupdated = CURRENT_TIMESTAMP, -- Use current date and time
                    storedby = 'trigger'
                WHERE
                    trackedentityinstanceid = (
                        SELECT
                            trackedentityinstanceid
                        FROM
                            programinstance
                        WHERE
                            programinstanceid = NEW.programinstanceid)
                    AND trackedentityattributeid = (
                        SELECT
                            trackedentityattributeid
                        FROM
                            trackedentityattribute
                        WHERE
                            uid = 'rgeuEnAI0nj');
        END;
    END IF;
    RETURN NEW;
END;

$$
LANGUAGE plpgsql;

CREATE TRIGGER update_teav_CALLED_trigger_function
    AFTER INSERT ON programstageinstance
    FOR EACH ROW
    EXECUTE FUNCTION update_teav_CALLED_trigger_function ();

-----------------------------------------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION update_overdue_pending_call_trigger_function ()
    RETURNS VOID
    AS $$
DECLARE
    overdue_row RECORD;
    tracked_entity_uid text;
    -- Variable to store trackedentityinstance UID
BEGIN
    -- Loop through each program instance with upcoming visits
    FOR overdue_row IN
    SELECT
        psi.programinstanceid,
        MAX(psi.duedate) AS max_duedate
    FROM
        programstageinstance AS psi
    WHERE
        EXISTS (
            SELECT
                1
            FROM
                programinstance AS pi
                JOIN trackedentityattributevalue AS teav ON pi.trackedentityinstanceid = teav.trackedentityinstanceid
            WHERE
                psi.programinstanceid = pi.programinstanceid
                AND psi.status IN ('SCHEDULE', 'OVERDUE')
                AND teav.trackedentityattributeid = (
                    SELECT
                        trackedentityattributeid
                    FROM
                        trackedentityattribute
                    WHERE
                        uid = 'rgeuEnAI0nj'))
        GROUP BY
            psi.programinstanceid LOOP
                -- Check if current timestamp plus 2 hours is greater than the max_duedate
                IF CURRENT_TIMESTAMP + INTERVAL '2 hours' > overdue_row.max_duedate THEN
                    -- Fetch trackedentityinstance UID corresponding to programinstanceid
                    SELECT
                        trackedentityinstanceid INTO tracked_entity_uid
                    FROM
                        programinstance
                    WHERE
                        programinstanceid = overdue_row.programinstanceid;
                    -- Attempt to update the trackedentityattributevalue with value OVERDUE_PENDING_CALL
                    BEGIN
                        -- Update the trackedentityattributevalue
                        UPDATE
                            trackedentityattributevalue
                        SET
                            value = 'OVERDUE_PENDING_CALL',
                            lastupdated = CURRENT_TIMESTAMP,
                            storedby = 'trigger'
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
                                    uid = 'rgeuEnAI0nj');
                        -- Log successful update
                        RAISE INFO 'Updated trackedentityattributevalue for program instance %', overdue_row.programinstanceid;
                    EXCEPTION
                        WHEN OTHERS THEN
                            -- Log error if update fails
                            RAISE EXCEPTION 'Error updating trackedentityattributevalue for program instance %', overdue_row.programinstanceid;
                    END;
                END IF;
    END LOOP;
END;

$$
LANGUAGE plpgsql;

