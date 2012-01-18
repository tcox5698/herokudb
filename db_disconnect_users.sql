SELECT procpid, (SELECT pg_terminate_backend(procpid)) as killed from pg_stat_activity
   WHERE current_query LIKE '<IDLE>';