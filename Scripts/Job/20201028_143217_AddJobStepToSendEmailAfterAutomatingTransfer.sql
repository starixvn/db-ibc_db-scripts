/*<info serverAlias="DBTRANS-msdb"></info>*/
USE MSDB
GO

/*
	Created: 20201028@Malcolm
	DB: DBTRANS-msdb
	Task: Add new job step to send email after automating transfer
*/

exec sp_add_jobstep
	@job_name = N'bodb02: Task Clear balance all downlines'
	,@step_name = 'Send email'
	,@step_id = 2
	,@cmdexec_success_code = 0
	,@on_success_action = 1
	,@on_success_step_id = 0
	,@on_fail_action = 2
	,@on_fail_step_id = 0
	,@retry_attempts = 0
	,@retry_interval = 0
	,@os_run_priority = 0
	,@subsystem = N'TSQL'
	,@command = N'EXEC DBCUST.CustDB.dbo.Task_ClearBalance_EmailNotify'
	,@database_name = N'bodb02'
	,@flags = 0

exec sp_update_jobstep
	@job_name = N'bodb02: Task Clear balance all downlines'
	,@step_id = 1
	,@on_success_action = 3