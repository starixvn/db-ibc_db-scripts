/*<info serverAlias="DBLIC-msdb"></info>*/
USE MSDB
GO

/*
	Created: 20210827@Danny
	DB: DBLIC-msdb
	Task: Update Job step and schedule 
*/



EXEC dbo.sp_update_jobstep  
    @job_name = N'bodb_LicenseeReport: DW - Generate Daily',  
    @step_id = 1,  
	@command=N'EXEC bodb_LicenseeReport.dbo.Task_PostStaging'


EXEC dbo.sp_update_schedule   
    @name =  N'End of business day',
	@active_start_time=11500
	