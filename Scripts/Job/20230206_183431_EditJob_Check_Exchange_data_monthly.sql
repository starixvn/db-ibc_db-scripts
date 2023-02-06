/*<info serverAlias="DBLIC-msdb,DBBAL-msdb"></info>*/
USE msdb
GO

/*
	Created: 20230206@Evan
	DB: DBLIC-msdb, DBBAL-msdb
	Task: Update Job step [Redmine: #183431]
*/

EXEC dbo.sp_update_jobstep  
    @job_name = N'bodb_3rdProduct: Check Exchange data monthly',  
    @step_id = 2,  
	@command=N'WAITFOR DELAY ''00:00:15''' 




