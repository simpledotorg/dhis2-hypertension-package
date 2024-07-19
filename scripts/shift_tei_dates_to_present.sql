CREATE OR REPLACE FUNCTION shift_tei_dates_to_present() RETURNS VOID AS $$
DECLARE
    max_executiondate DATE;
    days_difference INTEGER;
BEGIN
    -- Get the maximum execution date from the programstageinstance table
    SELECT MAX(executiondate) INTO max_executiondate FROM public.programstageinstance;

    -- Calculate the difference in days between today's date and the maximum execution date
    IF max_executiondate IS NOT NULL THEN
        SELECT EXTRACT(DAY FROM (CURRENT_DATE - max_executiondate)) INTO days_difference;
    ELSE
        days_difference := 0; -- If there is no max execution date, no days difference
    END IF;

    -- Update dates in programinstance table
    UPDATE public.programinstance
    SET
        enrollmentdate = CASE WHEN enrollmentdate IS NOT NULL THEN enrollmentdate + (days_difference || ' days')::INTERVAL ELSE enrollmentdate END,
        incidentdate = CASE WHEN incidentdate IS NOT NULL THEN incidentdate + (days_difference || ' days')::INTERVAL ELSE incidentdate END,
        enddate = CASE WHEN enddate IS NOT NULL THEN enddate + (days_difference || ' days')::INTERVAL ELSE enddate END
    WHERE 
        enrollmentdate IS NOT NULL
        OR incidentdate IS NOT NULL
        OR enddate IS NOT NULL;

    -- Update dates in programstageinstance table
    UPDATE public.programstageinstance
    SET
        executiondate = CASE WHEN executiondate IS NOT NULL THEN executiondate + (days_difference || ' days')::INTERVAL ELSE executiondate END,
        duedate = CASE WHEN duedate IS NOT NULL THEN duedate + (days_difference || ' days')::INTERVAL ELSE duedate END,
        completeddate = CASE WHEN completeddate IS NOT NULL THEN completeddate + (days_difference || ' days')::INTERVAL ELSE completeddate END
    WHERE 
        executiondate IS NOT NULL
        OR duedate IS NOT NULL
        OR completeddate IS NOT NULL;
END;
$$ LANGUAGE plpgsql;
