/*
	Created: 20210122@Percy
	Task: Generate all sql jobs
*/

USE msdb
GO

DECLARE @SQLJobs TABLE (Id SMALLINT IDENTITY (1,1), Command NVARCHAR(MAX))
INSERT INTO @SQLJobs (Command)
SELECT 'USE msdb
GO'

-- Add job
INSERT INTO @SQLJobs (Command)
SELECT
	N'EXEC dbo.sp_add_job
		@job_name=N''' + replace(j.name, '''', '''''') + ''',
		@enabled=0,
		@notify_level_eventlog=' + convert(varchar(20), j.notify_level_eventlog) + ',
		@notify_level_email=' + convert(varchar(20), j.notify_level_email) + ',
		@notify_level_netsend=' + convert(varchar(20), j.notify_level_netsend) + ',
		@notify_level_page=' + convert(varchar(20), j.notify_level_page) + ',
		@delete_level=' + convert(varchar(20), j.delete_level) + ',
		' + isnull('@description=N''' + replace(j.description, '''', '''''') + ''',', '') + '
		@category_name=N''[Uncategorized (Local)]'',
		@owner_login_name=N''sa''
GO'
FROM dbo.sysjobs j
ORDER BY j.name

-- Add job step
INSERT INTO @SQLJobs (Command)
SELECT
	N'EXEC dbo.sp_add_jobstep
		@job_name=N''' + replace(j.name, '''', '''''') + ''',
		@step_name=N''' + replace(js.step_name, '''', '''''') + ''',
		@step_id=' + convert(varchar(20), js.step_id) + ',
		@cmdexec_success_code=' + convert(varchar(20), js.cmdexec_success_code) + ',
		@on_success_action=' + convert(varchar(20), js.on_success_action) + ',
		@on_success_step_id=' + convert(varchar(20), js.on_success_step_id) + ',
		@on_fail_action=' + convert(varchar(20), js.on_fail_action) + ',
		@on_fail_step_id=' + convert(varchar(20), js.on_fail_step_id) + ',
		@retry_attempts=' + convert(varchar(20), js.retry_attempts) + ',
		@retry_interval=' + convert(varchar(20), js.retry_interval) + ',
		@os_run_priority=' + convert(varchar(20), js.os_run_priority) + ',
		@subsystem=N''' + js.subsystem + ''', 
		@command=N''' + replace(js.command, '''', '''''') + ''',
		' + isnull('@database_name=N''' + js.database_name + ''',', '') + '
		@flags=' + convert(varchar(20), js.flags) + '
GO'
FROM dbo.sysjobs j
	INNER JOIN dbo.sysjobsteps js ON j.job_id = js.job_id
ORDER BY j.name, js.step_id

-- Add schedule
INSERT INTO @SQLJobs (Command)
SELECT
	N'EXEC dbo.sp_add_jobschedule
		@job_name=N''' + replace(j.name, '''', '''''') + ''',
		@name=N''' + convert(varchar(20), js.schedule_id) + ''', 
		@enabled=' + convert(varchar(20), s.enabled) + ', 
		@freq_type=' + convert(varchar(20), s.freq_type) + ', 
		@freq_interval=' + convert(varchar(20), s.freq_interval) + ', 
		@freq_subday_type=' + convert(varchar(20), s.freq_subday_type) + ', 
		@freq_subday_interval=' + convert(varchar(20), s.freq_subday_interval) + ', 
		@freq_relative_interval=' + convert(varchar(20), s.freq_relative_interval) + ', 
		@freq_recurrence_factor=' + convert(varchar(20), s.freq_recurrence_factor) + ', 
		@active_start_date=' + convert(varchar(20), s.active_start_date) + ', 
		@active_end_date=' + convert(varchar(20), s.active_end_date) + ', 
		@active_start_time=' + convert(varchar(20), s.active_start_time) + ', 
		@active_end_time=' + convert(varchar(20), s.active_end_time) + '
GO'
FROM dbo.sysjobs j
	INNER JOIN dbo.sysjobschedules js ON j.job_id = js.job_id
	INNER JOIN dbo.sysschedules s ON js.schedule_id = s.schedule_id
ORDER BY j.name, s.schedule_id

SELECT * FROM @SQLJobs ORDER BY Id