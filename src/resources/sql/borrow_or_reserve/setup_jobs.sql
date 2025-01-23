-- schedule job

-- run expire_reservations_daily at midnight every day
SELECT cron.schedule(
               '0 2 * * *',
               $$SELECT expire_reservations_daily();$$
       );


-- check if job is created
select *
FROM cron.job;

-- unschedule a specific job by jobid:
SELECT cron.unschedule(jobid)
FROM cron.job
WHERE jobid = 3;

-- delete job by jobid
-- DELETE FROM cron.job where jobid = 1;