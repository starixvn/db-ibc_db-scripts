/*<info serverAlias="DBN88-bodb_N88"></info>*/
/*
	Created: 20220412@Percy
	DB: DBN88-msdb
	Task: Add job step for CustBonusSummary [RedmineID: #171245]
*/

USE [msdb]
GO

-- Add new step (Step 2)
EXEC sp_add_jobstep
		@job_name=N'bodb_N88: Generate daily data',
		@step_name=N'Generate data for CustBonusSummary', 
		@step_id=2, 
		@cmdexec_success_code=0, 
		@on_success_action=1, 
		@on_fail_action=2, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'EXEC dbo.Task_N88_CustBonusSummary_Job', 
		@database_name=N'bodb_N88', 
		@flags=0
GO

-- Edit step 1: if success then go to step 2
EXEC sp_update_jobstep
		@job_name=N'bodb_N88: Generate daily data',
		@step_name=N'Generate data for N88_SumWinloss', 
		@step_id=1, 
		@cmdexec_success_code=0, 
		@on_success_action=3, 
		@on_fail_action=1, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'EXEC Task_N88_SumWinloss_Job', 
		@database_name=N'bodb_N88', 
		@flags=0
GO
