-- Patients Under Care - Needed as a first filter in most overdue queries
CREATE OR REPLACE FUNCTION puc(period_type TEXT, period_value TEXT)
RETURNS TABLE (
    facility_uid VARCHAR,
    facility_name VARCHAR,
    tei_uid VARCHAR,
    programinstanceid BIGINT,
    enrollment_uid VARCHAR
) AS $$
DECLARE
    report_start_date DATE;
    report_end_date DATE;
    twelve_months_ago DATE;
BEGIN
    -- Get the start and end date for the given period
    EXECUTE format(
        'SELECT startdate, enddate 
         FROM period 
         WHERE periodtypeid = (SELECT periodtypeid FROM periodtype WHERE LOWER(name) = LOWER(%L)) 
         AND startdate::TEXT LIKE %L',
        period_type, LEFT(period_value, 4) || '-' || RIGHT(period_value, 2) || '%'
    ) INTO report_start_date, report_end_date;

    -- Define the 12-months look-back period
    twelve_months_ago := report_end_date - INTERVAL '12 months';

    RETURN QUERY
    WITH last_htn_visit AS (
        SELECT 
            psi.programinstanceid,
            MAX(psi.executiondate) AS last_htn_visit_date
        FROM 
            programstageinstance psi
        JOIN 
            programinstance pi ON psi.programinstanceid = pi.programinstanceid
        WHERE 
            psi.programstageid = (SELECT programstageid FROM programstage WHERE uid = 'anb2cjLx3WM')
            AND psi.executiondate IS NOT NULL
            AND psi.executiondate <= report_end_date
            AND psi.deleted = false
        GROUP BY 
            psi.programinstanceid
    ),
    eligible_patients AS (
        SELECT 
            pi.programinstanceid,
            pi.trackedentityinstanceid,
            pi.enrollmentdate,
            pi.uid AS enrollment_uid,
            last_htn_visit.last_htn_visit_date,
            teav_htn.value AS htn_status,
            teav_alive.value AS alive_status,
            tpo.organisationunitid AS facility_id
        FROM 
            programinstance pi
        JOIN 
            last_htn_visit ON pi.programinstanceid = last_htn_visit.programinstanceid
        JOIN 
            trackedentityattributevalue teav_htn ON pi.trackedentityinstanceid = teav_htn.trackedentityinstanceid
        JOIN 
            trackedentityattributevalue teav_alive ON pi.trackedentityinstanceid = teav_alive.trackedentityinstanceid
        JOIN 
            trackedentityprogramowner tpo ON pi.trackedentityinstanceid = tpo.trackedentityinstanceid
        WHERE 
            teav_htn.trackedentityattributeid = (SELECT trackedentityattributeid FROM trackedentityattribute WHERE uid = 'jCRIT4GMMOS')
            AND teav_htn.value = 'YES'
            AND teav_alive.trackedentityattributeid = (SELECT trackedentityattributeid FROM trackedentityattribute WHERE uid = 'fI1P3Mg1zOZ')
            AND teav_alive.value NOT IN ('DIED', 'TRANSFER')
            AND pi.deleted = false
    )
    SELECT 
        ou.uid AS facility_uid,
        ou.name AS facility_name,
        tei.uid AS tei_uid,
        ep.programinstanceid,
        ep.enrollment_uid
    FROM 
        eligible_patients ep
    JOIN 
        organisationunit ou ON ep.facility_id = ou.organisationunitid
    JOIN
        trackedentityinstance tei ON tei.trackedentityinstanceid = ep.trackedentityinstanceid
    WHERE 
        ep.last_htn_visit_date BETWEEN twelve_months_ago AND report_end_date
    ORDER BY 
        ou.name;

END;
$$ LANGUAGE plpgsql;


-- Contactable overdue
CREATE OR REPLACE FUNCTION contactable_overdue(period_type TEXT, period_value TEXT)
RETURNS TABLE (
    ou_uid VARCHAR,
    ou_name VARCHAR,
    patient_count INTEGER
) AS $$
DECLARE
    report_start_date DATE;
    report_end_date DATE;
    period_query TEXT;
    period_record RECORD;
BEGIN
    -- Fetch period start and end dates
    EXECUTE format(
        'SELECT startdate, enddate 
         FROM period 
         WHERE periodtypeid = (SELECT periodtypeid FROM periodtype WHERE LOWER(name) = LOWER(%L)) 
         AND startdate::TEXT LIKE %L',
        period_type, LEFT(period_value, 4) || '-' || RIGHT(period_value, 2) || '%'
    ) INTO report_start_date, report_end_date;

    RETURN QUERY
    WITH puc_patients AS (
        -- Fetch Patients Under Care using the provided function
        SELECT
            facility_uid,
            facility_name,
            programinstanceid
        FROM 
            puc(period_type, period_value)
    ),
    overdue_patients AS (
        SELECT 
            psi.programinstanceid
        FROM 
            programstageinstance psi
        JOIN 
            programinstance pi ON psi.programinstanceid = pi.programinstanceid
        JOIN
            trackedentityattributevalue teav_phone ON pi.trackedentityinstanceid = teav_phone.trackedentityinstanceid
        WHERE 
            psi.programstageid = (SELECT programstageid FROM programstage WHERE uid = 'anb2cjLx3WM') -- HTN Visit
            AND teav_phone.trackedentityattributeid = (SELECT trackedentityattributeid FROM trackedentityattribute WHERE uid = 'YRDy9xy9jD0')
            AND (teav_phone.value IS NOT NULL OR teav_phone.value != '') -- Have a phone number -> Contactable
            AND psi.deleted = FALSE
            AND pi.enrollmentdate < report_end_date -- Ensure enrolled before period
            AND (
                -- Condition 1: SCHEDULE or OVERDUE, duedate is overdue at period start
                (psi.status IN ('SCHEDULE', 'OVERDUE') 
                 AND psi.duedate IS NOT NULL 
                 AND psi.duedate < report_start_date)
                OR
                -- Condition 2: COMPLETED or ACTIVE, duedate < executiondate, executiondate in period
                (psi.status IN ('COMPLETED', 'ACTIVE') 
                 AND psi.duedate IS NOT NULL 
                 AND psi.duedate < report_start_date
                 AND psi.executiondate IS NOT NULL 
                 AND psi.executiondate >= report_start_date
                 AND psi.duedate < psi.executiondate)
            )
    )
    SELECT 
        puc.facility_uid ou_uid,
        puc.facility_name ou_name,
        COUNT(DISTINCT puc.programinstanceid)::INTEGER AS patient_count
    FROM 
        puc_patients puc
    JOIN 
        overdue_patients ov ON puc.programinstanceid = ov.programinstanceid
    GROUP BY 
        ou_name, ou_uid
    ORDER BY 
        ou_name;
END;
$$ LANGUAGE plpgsql;

-- Contactable Overdue called by call result
CREATE OR REPLACE FUNCTION contactable_overdue_called_by_call_result(period_type TEXT, period_value TEXT)
RETURNS TABLE (
    ou_uid VARCHAR,
    ou_name VARCHAR,
    call_result VARCHAR,
    patient_count INTEGER
) AS $$
DECLARE
    report_start_date DATE;
    report_end_date DATE;
    period_query TEXT;
    period_record RECORD;
BEGIN
    -- Fetch period start and end dates
    EXECUTE format(
        'SELECT startdate, enddate 
         FROM period 
         WHERE periodtypeid = (SELECT periodtypeid FROM periodtype WHERE LOWER(name) = LOWER(%L)) 
         AND startdate::TEXT LIKE %L',
        period_type, LEFT(period_value, 4) || '-' || RIGHT(period_value, 2) || '%'
    ) INTO report_start_date, report_end_date;

    RETURN QUERY
    WITH puc_patients AS (
        -- Fetch Patients Under Care using the provided function
        SELECT 
            facility_uid,
            facility_name,
            programinstanceid
        FROM 
            puc(period_type, period_value) pp
    ),
    first_call AS (
        -- Extract the first call made within the reporting period
        SELECT 
            pp.facility_uid,                   
            pp.facility_name,
            pp.programinstanceid,
            call.executiondate AS first_call_date,
            COALESCE(NULLIF((call.eventdatavalues->'q362A7evMYt'->>'value')::VARCHAR, ''), 'UNKNOWN') AS call_result, -- Replaces empty string with 'UNKNOWN'
            ROW_NUMBER() OVER (
                PARTITION BY pp.programinstanceid 
                ORDER BY call.executiondate ASC
            ) AS row_num
        FROM 
            puc_patients pp
        JOIN 
            programstageinstance call ON pp.programinstanceid = call.programinstanceid
        WHERE 
            call.programstageid = (SELECT programstageid FROM programstage WHERE uid = 'W7BCOaSquMd') -- Calling Report
            AND call.executiondate IS NOT NULL
            AND call.executiondate BETWEEN report_start_date AND report_end_date -- First call in reporting period
            AND call.deleted = FALSE
    )
    SELECT
        fc.facility_uid AS ou_uid,
        fc.facility_name AS ou_name,
        fc.call_result::VARCHAR,
        COUNT(DISTINCT fc.programinstanceid)::INTEGER AS patient_count
    FROM 
        first_call fc
    WHERE 
        fc.row_num = 1 -- Ensure only the first call per patient is used
    GROUP BY 
        fc.facility_uid, fc.facility_name, fc.call_result
    ORDER BY 
        fc.facility_name, fc.call_result;
END;
$$ LANGUAGE plpgsql;

-- Overdue called - Agree
CREATE OR REPLACE FUNCTION contactable_overdue_called_by_call_result_agreed(period_type TEXT, period_value TEXT)
RETURNS TABLE (
    ou_uid VARCHAR,
    ou_name VARCHAR,
    call_result VARCHAR,
    patient_count INTEGER
) AS $$
BEGIN
    RETURN QUERY
    SELECT 
        pr.ou_uid,
        pr.ou_name,
        pr.call_result,
        pr.patient_count
    FROM contactable_overdue_called_by_call_result(period_type, period_value) pr
    WHERE pr.call_result = 'AGREE_TO_VISIT';
END;
$$ LANGUAGE plpgsql;

-- Overdue called - Remind
CREATE OR REPLACE FUNCTION contactable_overdue_called_by_call_result_remind(period_type TEXT, period_value TEXT)
RETURNS TABLE (
    ou_uid VARCHAR,
    ou_name VARCHAR,
    call_result VARCHAR,
    patient_count INTEGER
) AS $$
BEGIN
    RETURN QUERY
    SELECT 
        pr.ou_uid,
        pr.ou_name,
        pr.call_result,
        pr.patient_count
    FROM contactable_overdue_called_by_call_result(period_type, period_value) pr
    WHERE pr.call_result = 'REMIND_TO_CALL_LATER';
END;
$$ LANGUAGE plpgsql;

-- Overdue called - Remove
CREATE OR REPLACE FUNCTION contactable_overdue_called_by_call_result_remove(period_type TEXT, period_value TEXT)
RETURNS TABLE (
    ou_uid VARCHAR,
    ou_name VARCHAR,
    call_result VARCHAR,
    patient_count INTEGER
) AS $$
BEGIN
    RETURN QUERY
    SELECT 
        pr.ou_uid,
        pr.ou_name,
        pr.call_result,
        pr.patient_count
    FROM contactable_overdue_called_by_call_result(period_type, period_value) pr
    WHERE pr.call_result = 'REMOVE_FROM_OVERDUE';
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION contactable_overdue_called_by_call_result_unknown(period_type TEXT, period_value TEXT)
RETURNS TABLE (
    ou_uid VARCHAR,
    ou_name VARCHAR,
    call_result VARCHAR,
    patient_count INTEGER
) AS $$
BEGIN
    RETURN QUERY
    SELECT 
        pr.ou_uid,
        pr.ou_name,
        pr.call_result,
        pr.patient_count
    FROM contactable_overdue_called_by_call_result(period_type, period_value) pr
    WHERE pr.call_result = 'UNKNOWN';
END;
$$ LANGUAGE plpgsql;

-- Return to care by call result
CREATE OR REPLACE FUNCTION patients_returned_to_care_by_call_result(period_type TEXT, period_value TEXT)
RETURNS TABLE (
    ou_uid VARCHAR,
    ou_name VARCHAR,
    call_result VARCHAR,
    patient_count INTEGER
) AS $$
DECLARE
    report_start_date DATE;
    report_end_date DATE;
    period_query TEXT;
    period_record RECORD;
BEGIN
    -- Fetch period start and end dates
    EXECUTE format(
        'SELECT startdate, enddate 
         FROM period 
         WHERE periodtypeid = (SELECT periodtypeid FROM periodtype WHERE LOWER(name) = LOWER(%L)) 
         AND startdate::TEXT LIKE %L',
        period_type, LEFT(period_value, 4) || '-' || RIGHT(period_value, 2) || '%'
    ) INTO report_start_date, report_end_date;

    RETURN QUERY
    WITH puc_patients AS (
        -- Fetch Patients Under Care using the provided function
        SELECT 
            facility_uid,
            facility_name,
            programinstanceid
        FROM 
            puc(period_type, period_value) pp
    ),
    first_call AS (
        -- Extract the first call made within the reporting period
        SELECT 
            pp.facility_uid,                   
            pp.facility_name,
            pp.programinstanceid,
            call.executiondate AS first_call_date,
            COALESCE(NULLIF((call.eventdatavalues->'q362A7evMYt'->>'value')::VARCHAR, ''), 'UNKNOWN') AS call_result, -- Replaces empty string with 'UNKNOWN'
            ROW_NUMBER() OVER (
                PARTITION BY pp.programinstanceid 
                ORDER BY call.executiondate ASC
            ) AS row_num
        FROM 
            puc_patients pp
        JOIN 
            programstageinstance call ON pp.programinstanceid = call.programinstanceid
        WHERE 
            call.programstageid = (SELECT programstageid FROM programstage WHERE uid = 'W7BCOaSquMd') -- Calling Report
            AND call.executiondate IS NOT NULL
            AND call.executiondate BETWEEN report_start_date AND report_end_date -- First call in reporting period
            AND call.deleted = FALSE
    ),
    htn_visits_after_call AS (
        -- Identify HTN visits within 15 days after the first call
        SELECT 
            fc.facility_uid,             
            fc.facility_name,
            fc.call_result,
            fc.programinstanceid
        FROM 
            first_call fc
        JOIN 
            programstageinstance visit ON fc.programinstanceid = visit.programinstanceid
        WHERE 
            visit.programstageid = (SELECT programstageid FROM programstage WHERE uid = 'anb2cjLx3WM') -- HTN Visit
            AND visit.executiondate BETWEEN fc.first_call_date AND (fc.first_call_date + INTERVAL '15 days') -- Visit within 15 days of first call
            AND visit.duedate < visit.executiondate -- Visit was overdue
            AND visit.status IN ('ACTIVE', 'COMPLETED') -- Valid visit statuses
            AND visit.executiondate BETWEEN report_start_date AND (report_end_date + INTERVAL '15 days')
            AND visit.deleted = FALSE
            AND fc.row_num = 1 -- Ensures only the first call per patient is used
    )
    -- Final aggregation to get the count of patients returning to care per call result
    SELECT 
        hv.facility_uid AS ou_uid,
        hv.facility_name AS ou_name,
        hv.call_result::VARCHAR,
        COUNT(DISTINCT hv.programinstanceid)::INTEGER AS patient_count
    FROM 
        htn_visits_after_call hv
    GROUP BY 
        hv.facility_uid, hv.facility_name, hv.call_result
    ORDER BY 
        hv.facility_name, hv.call_result;
END;
$$ LANGUAGE plpgsql;

-- Returned to care - Agree
CREATE OR REPLACE FUNCTION patients_returned_to_care_by_call_result_agreed(period_type TEXT, period_value TEXT)
RETURNS TABLE (
    ou_uid VARCHAR,
    ou_name VARCHAR,
    call_result VARCHAR,
    patient_count INTEGER
) AS $$
BEGIN
    RETURN QUERY
    SELECT 
        pr.ou_uid,
        pr.ou_name,
        pr.call_result,
        pr.patient_count
    FROM patients_returned_to_care_by_call_result(period_type, period_value) pr
    WHERE pr.call_result = 'AGREE_TO_VISIT';
END;
$$ LANGUAGE plpgsql;

-- Returned to care - Remind
CREATE OR REPLACE FUNCTION patients_returned_to_care_by_call_result_remind(period_type TEXT, period_value TEXT)
RETURNS TABLE (
    ou_uid VARCHAR,
    ou_name VARCHAR,
    call_result VARCHAR,
    patient_count INTEGER
) AS $$
BEGIN
    RETURN QUERY
    SELECT 
        pr.ou_uid,
        pr.ou_name,
        pr.call_result,
        pr.patient_count
    FROM patients_returned_to_care_by_call_result(period_type, period_value) pr
    WHERE pr.call_result = 'REMIND_TO_CALL_LATER';
END;
$$ LANGUAGE plpgsql;

-- Returned to care - Remove
CREATE OR REPLACE FUNCTION patients_returned_to_care_by_call_result_remove(period_type TEXT, period_value TEXT)
RETURNS TABLE (
    ou_uid VARCHAR,
    ou_name VARCHAR,
    call_result VARCHAR,
    patient_count INTEGER
) AS $$
BEGIN
    RETURN QUERY
    SELECT 
        pr.ou_uid,
        pr.ou_name,
        pr.call_result,
        pr.patient_count
    FROM patients_returned_to_care_by_call_result(period_type, period_value) pr
    WHERE pr.call_result = 'REMOVE_FROM_OVERDUE';
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION patients_returned_to_care_by_call_result_unknown(period_type TEXT, period_value TEXT)
RETURNS TABLE (
    ou_uid VARCHAR,
    ou_name VARCHAR,
    call_result VARCHAR,
    patient_count INTEGER
) AS $$
BEGIN
    RETURN QUERY
    SELECT 
        pr.ou_uid,
        pr.ou_name,
        pr.call_result,
        pr.patient_count
    FROM patients_returned_to_care_by_call_result(period_type, period_value) pr
    WHERE pr.call_result = 'UNKNOWN';
END;
$$ LANGUAGE plpgsql;

-- Create mapping table
DROP TABLE IF EXISTS function_dataelement_map CASCADE;

CREATE TABLE function_dataelement_map (
    id SERIAL PRIMARY KEY,       -- Auto-incrementing primary key
    de_uid VARCHAR(11) NOT NULL, -- Data element UID
    coc_uid VARCHAR(11) NOT NULL, -- COC UID (normally default)
    function_name TEXT NOT NULL   -- Function to execute
);

INSERT INTO function_dataelement_map (de_uid, coc_uid, function_name)
VALUES 
    ('iRgb6hOfzEk', 'HllvX50cXC0', 'contactable_overdue'),
    ('X0pBiQ6SN5O', 'mrScGGCsXxK', 'contactable_overdue_called_by_call_result_agreed'),
    ('X0pBiQ6SN5O', 'ObTBDRrMGXZ', 'contactable_overdue_called_by_call_result_remind'),
    ('X0pBiQ6SN5O', 'nBxYtHKrjAU', 'contactable_overdue_called_by_call_result_remove'),
    ('xZ07XCMF85u', 'mrScGGCsXxK', 'patients_returned_to_care_by_call_result_agreed'),
    ('xZ07XCMF85u', 'ObTBDRrMGXZ', 'patients_returned_to_care_by_call_result_remind'),
    ('xZ07XCMF85u', 'nBxYtHKrjAU', 'patients_returned_to_care_by_call_result_remove'),
    ('X0pBiQ6SN5O', 'Gp0KLnDVtHw', 'contactable_overdue_called_by_call_result_unknown'),
    ('xZ07XCMF85u', 'Gp0KLnDVtHw', 'patients_returned_to_care_by_call_result_unknown');

-- -------------- PROCEDURE AGG
CREATE OR REPLACE PROCEDURE sql_agg_calculate_and_store()
LANGUAGE plpgsql
AS $$
DECLARE
    v_periodid BIGINT;
    v_dataelementid BIGINT;
    v_categoryoptioncomboid BIGINT;
    v_attributeoptioncomboid BIGINT;
    v_sourceid BIGINT;
    v_current_month TEXT;
    v_index INT;
    v_start_time TIMESTAMP;
    v_elapsed_time INTERVAL;
    v_elapsed_text TEXT;
    v_function_name TEXT;
    v_de_uid TEXT;
    v_coc_uid TEXT;
    rec RECORD;
    func_rec RECORD;
BEGIN
    -- Store the start time
    v_start_time := CLOCK_TIMESTAMP();

    -- Update jobconfiguration to 'RUNNING'
    BEGIN
        PERFORM 1 FROM jobconfiguration WHERE uid = 'nNumq7QS7FM'; -- Ensures row exists
        UPDATE jobconfiguration
        SET 
            lastupdated = NOW(),
            lastexecuted = NOW(),
            lastruntimeexecution = '00:00:00.000',
            lastexecutedstatus = 'RUNNING' 
        WHERE uid = 'nNumq7QS7FM';
        RAISE NOTICE 'Updated job to RUNNING';
    EXCEPTION 
        WHEN OTHERS THEN
            RAISE NOTICE 'Error updating job status to RUNNING: %', SQLERRM;
    END;

    -- Drop temp tables if they exist
    DROP TABLE IF EXISTS temp_orgunit_map;
    DROP TABLE IF EXISTS temp_period_map;

    -- Create temporary tables
    CREATE TEMP TABLE temp_orgunit_map AS
    SELECT uid AS ou_uid, organisationunitid FROM organisationunit;

    CREATE TEMP TABLE temp_period_map AS
    SELECT TO_CHAR(startdate, 'YYYYMM') AS period_iso, periodid
    FROM period
    WHERE periodtypeid = 10; -- 10 is Monthly

    -- Get the static values for categoryoptioncomboid
    SELECT categoryoptioncomboid INTO v_attributeoptioncomboid FROM categoryoptioncombo WHERE code = 'default';

    -- Loop over each function and associated data element
    FOR func_rec IN
        SELECT de_uid, coc_uid, function_name FROM function_dataelement_map
    LOOP
        v_de_uid := func_rec.de_uid;
        v_coc_uid := func_rec.coc_uid;
        v_function_name := func_rec.function_name;

        -- Get corresponding dataelementid and categoryoptioncomboid
        SELECT dataelementid INTO v_dataelementid FROM dataelement WHERE uid = v_de_uid;
        SELECT categoryoptioncomboid INTO v_categoryoptioncomboid FROM categoryoptioncombo WHERE uid = v_coc_uid;

        RAISE NOTICE 'Processing function: % for DE UID: %', v_function_name, v_de_uid;

        -- Loop over the last 13 months
        -- Execute function dynamically and insert results with error handling
        FOR v_index IN 0..12 LOOP
            v_current_month := TO_CHAR((CURRENT_DATE - INTERVAL '1 month' * v_index), 'YYYYMM');
            RAISE NOTICE 'Processing month: %', v_current_month;

            -- Get periodid safely
            SELECT periodid INTO v_periodid FROM temp_period_map WHERE period_iso = v_current_month;

            BEGIN
                -- Execute function inside TRY-CATCH block
                FOR rec IN EXECUTE FORMAT('SELECT ou_uid, ou_name, patient_count FROM %I($1, $2)', v_function_name) 
                USING 'monthly', v_current_month
                LOOP
                    RAISE NOTICE 'Processing orgunit: %', rec.ou_name;

                    -- Lookup organisationunitid
                    SELECT organisationunitid INTO v_sourceid FROM temp_orgunit_map WHERE ou_uid = rec.ou_uid;

                    -- Insert or update datavalue
                    INSERT INTO datavalue (dataelementid, periodid, sourceid, categoryoptioncomboid, attributeoptioncomboid, value, storedby, created, lastupdated, deleted)
                    VALUES (
                        v_dataelementid, v_periodid, v_sourceid,
                        v_categoryoptioncomboid, v_attributeoptioncomboid,
                        rec.patient_count, 'SQL', NOW(), NOW(), FALSE
                    )
                    ON CONFLICT (dataelementid, periodid, sourceid, categoryoptioncomboid, attributeoptioncomboid)
                    DO UPDATE SET value = rec.patient_count, lastupdated = NOW();
                END LOOP;
            EXCEPTION
                WHEN OTHERS THEN
                    RAISE NOTICE 'Error executing function % for period %: %', v_function_name, v_current_month, SQLERRM;
                    -- Ensure the failure is logged
                    UPDATE jobconfiguration
                    SET 
                        lastupdated = NOW(),
                        lastexecutedstatus = 'STOPPED',
                        lastruntimeexecution = 'ERROR: ' || SQLERRM
                    WHERE uid = 'nNumq7QS7FM';
                    RETURN;
            END;
        END LOOP;
    END LOOP;

    -- Calculate elapsed time
    v_elapsed_time := CLOCK_TIMESTAMP() - v_start_time;
    v_elapsed_text := TO_CHAR(v_elapsed_time, 'HH24:MI:SS.MS');

    -- Update jobconfiguration to 'COMPLETED'
    BEGIN
        PERFORM 1 FROM jobconfiguration WHERE uid = 'nNumq7QS7FM'; -- Ensures row exists
        UPDATE jobconfiguration
        SET 
            lastupdated = NOW(),
            lastruntimeexecution = v_elapsed_text,
            lastexecutedstatus = 'COMPLETED' 
        WHERE uid = 'nNumq7QS7FM';
        RAISE NOTICE 'Updated job to COMPLETED';
    EXCEPTION 
        WHEN OTHERS THEN
            RAISE NOTICE 'Error updating job status to COMPLETED: %', SQLERRM;
    END;

    -- Drop temp tables
    DROP TABLE temp_orgunit_map;
    DROP TABLE temp_period_map;

EXCEPTION
    WHEN OTHERS THEN
        -- Capture elapsed time
        v_elapsed_time := CLOCK_TIMESTAMP() - v_start_time;
        v_elapsed_text := TO_CHAR(v_elapsed_time, 'HH24:MI:SS.MS');

        -- Log failure in jobconfiguration
        BEGIN
            PERFORM 1 FROM jobconfiguration WHERE uid = 'nNumq7QS7FM'; -- Ensures row exists
            UPDATE jobconfiguration
            SET 
                lastupdated = NOW(),
                lastruntimeexecution = v_elapsed_text,
                lastexecutedstatus = 'STOPPED'
            WHERE uid = 'nNumq7QS7FM';
            RAISE NOTICE 'Updated job to STOPPED';
        EXCEPTION 
            WHEN OTHERS THEN
                RAISE NOTICE 'Error updating job status to STOPPED: %', SQLERRM;
        END;

        -- Rethrow error
        RAISE;
END;
$$;

