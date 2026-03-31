CREATE OR REPLACE FUNCTION shift_tei_dates_to_present() RETURNS VOID AS $$
DECLARE
    max_occurreddate DATE;
    days_difference INTEGER;
BEGIN
    -- 1. Get the maximum occurred date from the event table (formerly programstageinstance)
    SELECT MAX(occurreddate) INTO max_occurreddate FROM public.event;

    -- 2. Calculate the difference in days
    IF max_occurreddate IS NOT NULL THEN
        -- Using simple date subtraction is often cleaner for day counts in Postgres
        days_difference := (CURRENT_DATE - max_occurreddate)::INTEGER;
    ELSE
        days_difference := 0;
    END IF;

    -- 3. Update dates in enrollment table (formerly programinstance)
    UPDATE public.enrollment
    SET
        enrolledat = CASE WHEN enrolledat IS NOT NULL THEN enrolledat + (INTERVAL '1 day' * days_difference) ELSE enrolledat END,
        occurredat = CASE WHEN occurredat IS NOT NULL THEN occurredat + (INTERVAL '1 day' * days_difference) ELSE occurredat END,
        enddate = CASE WHEN enddate IS NOT NULL THEN enddate + (INTERVAL '1 day' * days_difference) ELSE enddate END
    WHERE 
        enrolledat IS NOT NULL
        OR occurredat IS NOT NULL
        OR enddate IS NOT NULL;

    -- 4. Update dates in event table (formerly programstageinstance)
    UPDATE public.event
    SET
        occurreddate = CASE WHEN occurreddate IS NOT NULL THEN occurreddate + (INTERVAL '1 day' * days_difference) ELSE occurreddate END,
        duedate = CASE WHEN duedate IS NOT NULL THEN duedate + (INTERVAL '1 day' * days_difference) ELSE duedate END,
        completeddate = CASE WHEN completeddate IS NOT NULL THEN completeddate + (INTERVAL '1 day' * days_difference) ELSE completeddate END
    WHERE 
        occurreddate IS NOT NULL
        OR duedate IS NOT NULL
        OR completeddate IS NOT NULL;
END;
$$ LANGUAGE plpgsql;
