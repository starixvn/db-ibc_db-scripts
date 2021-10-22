/*<info serverAlias="DBLIC-msdb,DBBAL-msdb"></info>*/
USE MSDB
GO

/*
	Created: 20210827@Danny
	DB: DBLIC-msdb, DBBAL-msdb
	Task: Update Job step and schedule 
*/



EXEC dbo.sp_update_jobstep  
    @job_name = N'bodb_LicenseeReport: DW - Generate Daily',  
    @step_id = 1,  
	@command=N'EXEC bodb_LicenseeReport.dbo.Task_ImportQueue_CheckReady'

EXEC dbo.sp_update_jobstep  
    @job_name = N'bodb_LicenseeReport: DW - Generate Daily',  
    @step_id = 2,  
	@command=N'EXEC dbo.Task_PostStaging
EXEC dbo.Task_PrepareStaging'



