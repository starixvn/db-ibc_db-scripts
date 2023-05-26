/*<info serverAlias="DBCTG-bodb02,DBSIC-bodb02"></info>*/

/*
	Created by: Danny
	Date: 2023-05-26
	Task: alter job step
	DB: DBCTG-bodb02,DBSIC-bodb02
	
*/
USE msdb

GO
-- Add job step
EXEC msdb.dbo.sp_update_jobstep
		@job_name=N'bodb02: Task Clear balance all downlines',
		@step_id=2, 
		@command=N' DECLARE @Server_SiteDBGroupID SMALLINT
					SELECT @Server_SiteDBGroupID = dbo.f_Get_SiteDBGroupID()
					EXEC DBCUST.CustDB.dbo.Task_ClearBalance_EmailNotify @SiteDBGroupID = @Server_SiteDBGroupID
				  '
