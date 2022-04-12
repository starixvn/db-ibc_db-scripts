/*<info serverAlias="DBN88-bodb_N88"></info>*/
/*
	Creator:	20220221@Percy
	Task:		MPA - New job archive data - [Redmine: #167823]
	Database:	DBN88.bodb_N88
	Job name: bodb_N88: Archive data
*/
USE msdb
GO

EXEC dbo.sp_add_job @job_name=N'bodb_N88: Archive data',
		@enabled=1,
		@notify_level_eventlog=0,
		@notify_level_email=0,
		@notify_level_netsend=0,
		@notify_level_page=0,
		@delete_level=0,
		@description=N'No description available.',
		@category_name=N'[Uncategorized (Local)]',
		@owner_login_name=N'sa'

EXEC dbo.sp_add_jobstep @job_name=N'bodb_N88: Archive data',
		@step_name=N'Archive TpBetRecord',
		@step_id=1,
		@cmdexec_success_code=0,
		@on_success_action=1,
		@on_success_step_id=0,
		@on_fail_action=2,
		@on_fail_step_id=0,
		@retry_attempts=0,
		@retry_interval=0,
		@os_run_priority=0, @subsystem=N'TSQL',
		@command=N'Task_N88_ArchiveData_Job',
		@database_name=N'bodb_N88',
		@flags=0

EXEC dbo.sp_update_job @job_name=N'bodb_N88: Archive data',
		@start_step_id = 1

EXEC dbo.sp_add_jobschedule @job_name=N'bodb_N88: Archive data',
		@name=N'Monthly',
		@enabled=1,
		@freq_type=16,
		@freq_interval=1,
		@freq_subday_type=1,
		@freq_subday_interval=0,
		@freq_relative_interval=0,
		@freq_recurrence_factor=1,
		@active_start_date=20220412,
		@active_end_date=99991231,
		@active_start_time=1500,
		@active_end_time=235959

EXEC dbo.sp_add_jobserver @job_name=N'bodb_N88: Archive data',
		@server_name = N'(local)'