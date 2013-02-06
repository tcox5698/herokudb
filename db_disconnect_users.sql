SELECT pid, (SELECT pg_terminate_backend(pid)) as killed from pg_stat_activity;
