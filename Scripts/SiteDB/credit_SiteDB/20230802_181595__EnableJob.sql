/*<info serverAlias="DBSIC-bodb02"></info>*/

/*
	Created by: Danny
	Date: 2023-05-26
	Task: Rename Unused Object
	DB: DBSIC-bodb02 
	
*/
USE msdb ;  
GO  

EXEC dbo.sp_update_job  
    @job_name = N'bodb02: DBA_Recover_7days_routineTasks',  
    @enabled = 1 ;  
GO  

EXEC dbo.sp_update_job  
    @job_name = N'bodb02: Task Clear balance all downlines',   
    @enabled = 1 ;  
GO
