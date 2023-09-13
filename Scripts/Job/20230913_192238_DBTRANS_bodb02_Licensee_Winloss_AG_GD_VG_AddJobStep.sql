/*<info serverAlias="DBTRANS-msdb"></info>*/
USE msdb
GO

/*
	Created: 20230822@Evan
	DB: DBTRANS-msdb
	Task: Add new job step to generate new trans for bettype 998 (Parlay Boost Adjustment) [RedmineID: #192238]
*/
DECLARE @JobName NVARCHAR(100) =  N'bodb02: Licensee Winloss AG GD VG'
DECLARE @NewJobName NVARCHAR(100) =  N'bodb02: Licensee Winloss - Daily summary data into Bettrans'

EXEC dbo.sp_update_jobstep @job_name = @JobName
						 , @step_id = 1
						 , @step_name = N'Daily summary odds addjustment'
						 
EXEC dbo.sp_update_jobstep @job_name = @JobName
						 , @step_id = 2
						 , @step_name = N'Daily summary parlay boost addjustment'
						 , @command=N'EXEC dbo.Task_Dep_DailySum_ParlayBoostAdjust_Job'
						 , @on_success_action = 3

EXEC dbo.sp_add_jobstep @job_name = @JobName
					, @step_name = N'Daily summary separate wallet products '
					, @step_id = 3
					, @cmdexec_success_code = 0
					, @on_success_action = 1
					, @on_success_step_id = 0
					, @on_fail_action = 2
					, @on_fail_step_id = 0
					, @retry_attempts = 0
					, @retry_interval = 0
					, @os_run_priority = 0
					, @subsystem = N'TSQL'
					, @command = N'DECLARE @WinlostDate SMALLDATETIME
SELECT  @WinlostDate = CONVERT(VARCHAR(10), DATEADD(DAY, -1, GETDATE()), 112)
EXEC dbo.Task_DEP_SeparatedWallet_GenerateData @WinlostDate = @WinlostDate'
					, @database_name = N'MARICOAPP'
					, @flags = 0

EXEC dbo.sp_update_job @job_name = @JobName
					 , @new_name = @NewJobName


GO  