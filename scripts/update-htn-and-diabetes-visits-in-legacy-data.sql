CREATE OR REPLACE FUNCTION update_htn_visits_and_ncd_patient_status_with_call_data (new_program_stage_id bigint, new_program_stage_instance_id bigint, new_program_instance_id bigint, new_eventdatavalues jsonb, new_status text, new_executiondate timestamp)
    RETURNS VOID
    AS $$
DECLARE
    htn_diabetes_program_stage_uid text := 'anb2cjLx3WM';
    calling_report_program_stage_uid text := 'W7BCOaSquMd';
    first_call_date_data_element_uid text := 'XMtcYl6Y3Jp';
    result_of_call_data_element_uid text := 'q362A7evMYt';
    remove_from_overdue_reason_data_element_uid text := 'MZkqsWH2KSe';
    previous_visit_date timestamp;
    first_calling_report_data jsonb;
    first_calling_report_id bigint;
    first_calling_report_date timestamp;
BEGIN
    -- Update event status from OVERDUE to SCHEDULE
    UPDATE
        programstageinstance
    SET
        status = 'SCHEDULE'
    WHERE
        status = 'OVERDUE';
    -- Check if the newly inserted row corresponds to the calling report program stage
    IF new_program_stage_id = (
        SELECT
            programstageid
        FROM
            programstage
        WHERE
            uid = calling_report_program_stage_uid) THEN
        IF (new_eventdatavalues -> result_of_call_data_element_uid ->> 'value') = 'REMOVE_FROM_OVERDUE' THEN
            PERFORM
                update_ncd_patient_status (new_program_instance_id, new_eventdatavalues -> remove_from_overdue_reason_data_element_uid ->> 'value');
            RAISE WARNING 'Updated the attribute';
        END IF;
        -- Check if the newly inserted row corresponds to the visit program stage
        -- **Note** If the health worker skips a scheduled event after or before creating
        -- an new visit event, the scheduled date is lost. This means this patient will
        -- not be counted as overdue in the statistics. This workflow needs to prevented
        -- by proper training.
        ELSEIF (new_program_stage_id = (
                SELECT
                    programstageid
                FROM programstage
                WHERE
                    uid = htn_diabetes_program_stage_uid)
            AND new_status IN ('ACTIVE', 'COMPLETED')) THEN
        -- Find the execution date of the previous visit
        SELECT
            MAX(psi.executiondate) INTO previous_visit_date
        FROM
            programstageinstance psi
            JOIN programstage ps ON psi.programstageid = ps.programstageid
        WHERE
            psi.programinstanceid = new_program_instance_id
            AND psi.executiondate < new_executiondate
            AND ps.uid = htn_diabetes_program_stage_uid;
        -- Find the execution date of the first calling report of the month between the previous visit and the current visit
        SELECT
            executiondate,
            programstageinstanceid,
            eventdatavalues INTO first_calling_report_date,
            first_calling_report_id,
            first_calling_report_data
        FROM (
            SELECT
                *,
                ROW_NUMBER() OVER (PARTITION BY psi.programinstanceid, DATE_TRUNC('month', psi.executiondate) ORDER BY psi.executiondate) AS call_number
            FROM
                programstageinstance psi
                JOIN programstage ps ON psi.programstageid = ps.programstageid
            WHERE
                psi.programinstanceid = new_program_instance_id
                AND psi.executiondate >= previous_visit_date
                AND psi.executiondate < new_executiondate
                AND ps.uid = calling_report_program_stage_uid) AS first_call_report_of_month
    WHERE
        call_number = 1
    ORDER BY
        executiondate DESC
    LIMIT 1;
        first_calling_report_data = COALESCE(new_eventdatavalues, '{}'::jsonb) || first_calling_report_data || JSONB_BUILD_OBJECT(first_call_date_data_element_uid, JSONB_BUILD_OBJECT('value', first_calling_report_date, 'created', (
                    SELECT
                        created
                    FROM programstageinstance
                    WHERE
                        programstageinstanceid = first_calling_report_id), 'lastUpdated', (
                    SELECT
                        lastupdated
                    FROM programstageinstance
                    WHERE
                        programstageinstanceid = first_calling_report_id), 'providedElsewhere', FALSE));
        UPDATE
            programstageinstance
        SET
            eventdatavalues = first_calling_report_data
        WHERE
            programstageinstanceid = new_program_stage_instance_id;
        RAISE WARNING 'Updated the HTN & Diabetes visit event with call report event details: %', first_calling_report_data;
    END IF;
EXCEPTION
    WHEN NOT_NULL_VIOLATION THEN
        RAISE WARNING 'No previous call data for the tei: %', new_program_instance_id;
    WHEN OTHERS THEN
        -- Log the error message
        RAISE WARNING 'Failed to update HTN & Diabetes visit event with call report event details: %', SQLERRM;
END;

$$
LANGUAGE plpgsql;

------------------------------------------------------------------------------------------------------------------------
--------------------------------------- Execute the function -----------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------
SELECT
    update_htn_visits_and_ncd_patient_status_with_call_data (programstageid, programstageinstanceid, programinstanceid, eventdatavalues, status, executiondate)
FROM
    programstageinstance;

------------------------------------------------------------------------------------------------------------------------
