USE [msdb]
GO

/*
	Created: 20190906@Percy
	DB: DB052/DB053
	Task: Move step 6: Gen data for Active Customer Report @bodb_LicenseeReport in the last step
*/

BEGIN TRANSACTION
DECLARE @ReturnCode INT = 0

-- Remove Step Gen data for Active Customer Report @bodb_LicenseeReport (step 6)
EXEC @ReturnCode = msdb.dbo.sp_delete_jobstep
    @job_name=N'bodb_LicenseeReport: DW - Generate Daily'
    ,@step_id=6
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback

-- Add Step Gen data for Active Customer Report @bodb_LicenseeReport in the last step (Step 9)
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep
		@job_name=N'bodb_LicenseeReport: DW - Generate Daily',
		@step_name=N'Gen data for Active Customer Report @bodb_LicenseeReport',
		@step_id=9,
		@cmdexec_success_code=0,
		@on_success_action=1,
		@on_success_step_id=0,
		@on_fail_action=2,
		@on_fail_step_id=0,
		@retry_attempts=0,
		@retry_interval=0,
		@os_run_priority=0, @subsystem=N'TSQL',
		@command=N'DECLARE @TransDate DATE
SET @TransDate = DATEADD(DAY, -1, CONVERT(VARCHAR(10), GETDATE(), 120))
EXEC dbo.Task_CustomerActive_GenDataDaily @TransDate = @TransDate', 
		@database_name=N'bodb_LicenseeReport',
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback

-- Modify Step 8 for next action call Step 9
EXEC @ReturnCode = msdb.dbo.sp_update_jobstep
	@job_name=N'bodb_LicenseeReport: DW - Generate Daily',
	@step_id=8,
	@on_success_action=3

IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback

COMMIT TRANSACTION
GOTO EndSave

QuitWithRollback:
    IF (@@TRANCOUNT > 0) ROLLBACK TRANSACTION
EndSave:
GO