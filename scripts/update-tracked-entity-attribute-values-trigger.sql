-----------------------------------------------------------------------------------------------------------
-- 1. OVERDUE PENDING CALL TRIGGER
-----------------------------------------------------------------------------------------------------------
DROP TRIGGER IF EXISTS update_teav_OVERDUE_PENDING_CALL_trigger_function ON event;
DROP FUNCTION IF EXISTS update_teav_OVERDUE_PENDING_CALL_trigger_function ();

CREATE OR REPLACE FUNCTION update_teav_OVERDUE_PENDING_CALL_trigger_function ()
    RETURNS TRIGGER
    AS $$
BEGIN
    IF NEW.status = 'OVERDUE' AND OLD.status <> NEW.status THEN
        BEGIN
            INSERT INTO trackedentityattributevalue (trackedentityid, trackedentityattributeid, value, created, lastupdated, storedby)
                VALUES ((
                        SELECT
                            trackedentityid
                        FROM
                            enrollment
                        WHERE
                            enrollmentid = NEW.enrollmentid), (
                            SELECT
                                trackedentityattributeid
                            FROM
                                trackedentityattribute
                            WHERE
                                uid = 'rgeuEnAI0nj'), 'OVERDUE_PENDING_CALL', (
                                SELECT
                                    created
                                FROM
                                    enrollment
                                WHERE
                                    enrollmentid = NEW.enrollmentid), CURRENT_TIMESTAMP, 
                                'trigger');
        EXCEPTION
            WHEN unique_violation THEN
                UPDATE
                    trackedentityattributevalue
                SET
                    value = 'OVERDUE_PENDING_CALL',
                    lastupdated = CURRENT_TIMESTAMP,
                    storedby = 'trigger'
                WHERE
                    trackedentityid = (
                        SELECT
                            trackedentityid
                        FROM
                            enrollment
                        WHERE
                            enrollmentid = NEW.enrollmentid)
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
$$ LANGUAGE plpgsql;

CREATE TRIGGER update_teav_OVERDUE_PENDING_CALL_trigger_function
    AFTER UPDATE ON event
    FOR EACH ROW
    WHEN (NEW.status IS DISTINCT FROM OLD.status)
    EXECUTE FUNCTION update_teav_OVERDUE_PENDING_CALL_trigger_function ();

-----------------------------------------------------------------------------------------------------------
-- 2. UPCOMING VISIT TRIGGER
-----------------------------------------------------------------------------------------------------------
DROP TRIGGER IF EXISTS update_teav_UPCOMING_VISIT_trigger_function ON event;
DROP FUNCTION IF EXISTS update_teav_UPCOMING_VISIT_trigger_function ();

CREATE OR REPLACE FUNCTION update_teav_UPCOMING_VISIT_trigger_function ()
    RETURNS TRIGGER
    AS $$
BEGIN
    IF NEW.programstageid = (
        SELECT
            programstageid
        FROM
            programstage
        WHERE
            uid = 'anb2cjLx3WM') AND NEW.status = 'SCHEDULE' THEN
        BEGIN
            INSERT INTO trackedentityattributevalue (trackedentityid, trackedentityattributeid, value, created, lastupdated, storedby)
                VALUES ((
                        SELECT
                            trackedentityid
                        FROM
                            enrollment
                        WHERE
                            enrollmentid = NEW.enrollmentid), (
                            SELECT
                                trackedentityattributeid
                            FROM
                                trackedentityattribute
                            WHERE
                                uid = 'rgeuEnAI0nj'), 'UPCOMING_VISIT', (
                                SELECT
                                    created
                                FROM
                                    enrollment
                                WHERE
                                    enrollmentid = NEW.enrollmentid), CURRENT_TIMESTAMP, 
                                'trigger');
        EXCEPTION
            WHEN unique_violation THEN
                UPDATE
                    trackedentityattributevalue
                SET
                    value = 'UPCOMING_VISIT',
                    lastupdated = CURRENT_TIMESTAMP,
                    storedby = 'trigger'
                WHERE
                    trackedentityid = (
                        SELECT
                            trackedentityid
                        FROM
                            enrollment
                        WHERE
                            enrollmentid = NEW.enrollmentid)
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
$$ LANGUAGE plpgsql;

CREATE TRIGGER update_teav_UPCOMING_VISIT_trigger_function
    AFTER INSERT ON event
    FOR EACH ROW
    EXECUTE FUNCTION update_teav_UPCOMING_VISIT_trigger_function ();

-----------------------------------------------------------------------------------------------------------
-- 3. CALLED TRIGGER
-----------------------------------------------------------------------------------------------------------
DROP TRIGGER IF EXISTS update_teav_CALLED_trigger_function ON event;
DROP FUNCTION IF EXISTS update_teav_CALLED_trigger_function ();

CREATE OR REPLACE FUNCTION update_teav_CALLED_trigger_function ()
    RETURNS TRIGGER
    AS $$
BEGIN
    IF NEW.programstageid = (
        SELECT
            programstageid
        FROM
            programstage
        WHERE
            uid = 'W7BCOaSquMd') THEN
        BEGIN
            INSERT INTO trackedentityattributevalue (trackedentityid, trackedentityattributeid, value, created, lastupdated, storedby)
                VALUES ((
                        SELECT
                            trackedentityid
                        FROM
                            enrollment
                        WHERE
                            enrollmentid = NEW.enrollmentid), (
                            SELECT
                                trackedentityattributeid
                            FROM
                                trackedentityattribute
                            WHERE
                                uid = 'rgeuEnAI0nj'), 'CALLED', (
                                SELECT
                                    created
                                FROM
                                    enrollment
                                WHERE
                                    enrollmentid = NEW.enrollmentid), CURRENT_TIMESTAMP, 
                                'trigger');
        EXCEPTION
            WHEN unique_violation THEN
                UPDATE
                    trackedentityattributevalue
                SET
                    value = 'CALLED',
                    lastupdated = CURRENT_TIMESTAMP,
                    storedby = 'trigger'
                WHERE
                    trackedentityid = (
                        SELECT
                            trackedentityid
                        FROM
                            enrollment
                        WHERE
                            enrollmentid = NEW.enrollmentid)
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
$$ LANGUAGE plpgsql;

CREATE TRIGGER update_teav_CALLED_trigger_function
    AFTER INSERT ON event
    FOR EACH ROW
    EXECUTE FUNCTION update_teav_CALLED_trigger_function ();

-----------------------------------------------------------------------------------------------------------
-- 4. OVERDUE PENDING CALL GENERAL FUNCTION
-----------------------------------------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION update_overdue_pending_call_trigger_function ()
    RETURNS VOID
    AS $$
DECLARE
    overdue_row RECORD;
    tracked_entity_id bigint; -- Changed to match bigint type and naming convention
BEGIN
    FOR overdue_row IN
    SELECT
        ev.enrollmentid,
        MAX(ev.duedate) AS max_duedate
    FROM
        event AS ev
    WHERE
        ev.deleted = false AND
        EXISTS (
            SELECT
                1
            FROM
                enrollment AS en
                JOIN trackedentityattributevalue AS teav ON en.trackedentityid = teav.trackedentityid
            WHERE
                ev.enrollmentid = en.enrollmentid
                AND ev.status IN ('SCHEDULE', 'OVERDUE')
                AND teav.trackedentityattributeid = (
                    SELECT
                        trackedentityattributeid
                    FROM
                        trackedentityattribute
                    WHERE
                        uid = 'rgeuEnAI0nj'))
        GROUP BY
            ev.enrollmentid LOOP
                
                IF CURRENT_TIMESTAMP + INTERVAL '2 hours' > overdue_row.max_duedate THEN
                    SELECT
                        trackedentityid INTO tracked_entity_id
                    FROM
                        enrollment
                    WHERE
                        enrollmentid = overdue_row.enrollmentid;

                    BEGIN
                        UPDATE
                            trackedentityattributevalue
                        SET
                            value = 'OVERDUE_PENDING_CALL',
                            lastupdated = CURRENT_TIMESTAMP,
                            storedby = 'trigger'
                        WHERE
                            trackedentityid = tracked_entity_id
                            AND trackedentityattributeid = (
                                SELECT
                                    trackedentityattributeid
                                FROM
                                    trackedentityattribute
                                WHERE
                                    uid = 'rgeuEnAI0nj');
                        
                        RAISE INFO 'Updated trackedentityattributevalue for enrollment %', overdue_row.enrollmentid;
                    EXCEPTION
                        WHEN OTHERS THEN
                            RAISE EXCEPTION 'Error updating trackedentityattributevalue for enrollment %', overdue_row.enrollmentid;
                    END;
                END IF;
    END LOOP;
END;
$$ LANGUAGE plpgsql;
