/*<info serverAlias="DBRPT-bodb_Report"></info>*/
/*
	Created: 20220314@Percy
	DB: DBRPT-bodb_Report
	Task: New table Statement_Accum [RedmineID: #169560]
		Step 5: Setup job
*/

-- Run on DB061
USE msdb
GO

-- Add job
EXEC sp_add_job
		@job_name=N'bodb_Report: Gen data for Statement_Accum', 
		@enabled=1, 
		@notify_level_eventlog=0, 
		@notify_level_email=2, 
		@notify_level_page=2, 
		@delete_level=0, 
		@category_name=N'[Uncategorized (Local)]', 
		@owner_login_name=N'sa'
GO

-- Add job server
EXEC sp_add_jobserver
		@job_name=N'bodb_Report: Gen data for Statement_Accum',
		@server_name = N'DB061'
GO

-- Add job step
EXEC msdb.dbo.sp_add_jobstep
		@job_name=N'bodb_Report: Gen data for Statement_Accum',
		@step_name=N'Gen data', 
		@step_id=1, 
		@cmdexec_success_code=0, 
		@on_success_action=1, 
		@on_fail_action=2, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'EXEC dbo.Task_Statement_Accum_Job', 
		@database_name=N'bodb_Report', 
		@flags=0
GO

-- Set start step
EXEC sp_update_job
		@job_name=N'bodb_Report: Gen data for Statement_Accum', 
		@enabled=1, 
		@start_step_id=1, 
		@notify_level_eventlog=0, 
		@notify_level_email=2, 
		@notify_level_page=2, 
		@delete_level=0, 
		@description=N'', 
		@category_name=N'[Uncategorized (Local)]', 
		@owner_login_name=N'sa', 
		@notify_email_operator_name=N'', 
		@notify_page_operator_name=N''
GO