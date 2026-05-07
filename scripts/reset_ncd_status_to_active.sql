-- Step 1: Create the trigger function
CREATE OR REPLACE FUNCTION public.set_ncd_status_to_active()
RETURNS trigger
LANGUAGE plpgsql
AS $$
DECLARE
    htn_diabetes_program_stage_uid TEXT := 'anb2cjLx3WM';
    ncd_status_tea_uid             TEXT := 'fI1P3Mg1zOZ';
    ncd_status_attr_id             BIGINT;
    te_id                          BIGINT; -- Tracked Entity ID
BEGIN
    -- 1. Only proceed if the Event is being marked as COMPLETED
    -- and belongs to the specific Program Stage UID
    IF NEW.status = 'COMPLETED'
       AND (
           SELECT ps.uid
           FROM programstage ps
           WHERE ps.programstageid = NEW.programstageid
       ) = htn_diabetes_program_stage_uid
    THEN
        -- 2. Get the Tracked Entity ID via the Enrollment table (2.41 naming)
        SELECT en.trackedentityid
        INTO te_id
        FROM enrollment en
        WHERE en.enrollmentid = NEW.enrollmentid;

        -- 3. Get the internal ID for the NCD Status Attribute
        SELECT tea.trackedentityattributeid
        INTO ncd_status_attr_id
        FROM trackedentityattribute tea
        WHERE tea.uid = ncd_status_tea_uid;

        -- 4. If IDs aren't found, exit to prevent trigger failure
        IF te_id IS NULL OR ncd_status_attr_id IS NULL THEN
            RETURN NEW;
        END IF;

        -- 5. UPSERT Logic: Update if exists, otherwise Insert
        IF EXISTS (
            SELECT 1
            FROM trackedentityattributevalue teav
            WHERE teav.trackedentityid = te_id
              AND teav.trackedentityattributeid = ncd_status_attr_id
        ) THEN
            UPDATE trackedentityattributevalue
            SET value       = 'ACTIVE',
                lastupdated = now(),
                storedby    = 'trigger_service'
            WHERE trackedentityid         = te_id
              AND trackedentityattributeid = ncd_status_attr_id;
        ELSE
            INSERT INTO trackedentityattributevalue (
                trackedentityid,
                trackedentityattributeid,
                value,
                created,
                lastupdated,
                storedby
            )
            VALUES (
                te_id,
                ncd_status_attr_id,
                'ACTIVE',
                now(),
                now(),
                'trigger_service'
            );
        END IF;
    END IF;

    RETURN NEW;
END;
$$;

-- Step 2: Create the trigger
CREATE TRIGGER trg_set_ncd_status_to_active
BEFORE INSERT OR UPDATE ON programstageinstance
FOR EACH ROW
WHEN (pg_trigger_depth() = 0)
EXECUTE FUNCTION set_ncd_status_to_active();