/*<info serverAlias="DBRPT-bodb_Report"></info>*/
/*
	Created: 20220911@Danny
	DB: DBRPT-bodb_Report
	Task: Setup Statement_Accum job [RedmineID: #169560]
*/

-- Run on DB061
USE msdb
GO


-- Add job step
EXEC msdb.dbo.sp_add_jobstep
		@job_name=N'bodb_Report: Daily Summary rptStatement',
		@step_name=N'Gen data Statement_Accum', 
		@step_id=3, 
		@cmdexec_success_code=0, 
		@on_success_action=1, 
		@on_fail_action=2, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'EXEC dbo.Task_Statement_Accum', 
		@database_name=N'bodb_Report', 
		@flags=0
GO

-- Add job step
EXEC msdb.dbo.sp_add_jobstep
		@job_name=N'bodb02: Check and Correct Data - After MBU',
		@step_name=N'Statement_Accum check and correct data', 
		@step_id=5, 
		@cmdexec_success_code=0, 
		@on_success_action=1, 
		@on_fail_action=2, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'EXEC bodb_report.dbo.Task_Statement_Accum_CheckData', 
		@database_name=N'bodb_Report', 
		@flags=0
GO
