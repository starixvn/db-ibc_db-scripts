
/*
	Created by: 20250211@Kelvin
	Task: BA Admin & LAP - Drop BA functions [RedmineID: #216882]
*/

GO

/* <info serverAlias="DBEXT-msdb, DBACC-msdb, DBBOF-msdb"></info>*/
--=====================================================================================================================================
USE [msdb]

GO

EXEC dbo.sp_update_job @job_name = N'bodb02: Retrieve BA Transaction', @enabled = 0 ;

GO
EXEC dbo.sp_update_job @job_name = N'bodb02: Verify BA Tickets', @enabled = 0 ;

--=====================================================================================================================================


/*<info serverAlias="DBSID-msdb"></info>*/
--=====================================================================================================================================
USE [msdb]

GO

EXEC dbo.sp_update_job @job_name = N'SiteDB bodb02: Verify BA Tickets', @enabled = 0 ;

GO
EXEC dbo.sp_update_job @job_name = N'SiteDB bodb02: Retrieve BA Transaction', @enabled = 0 ;

GO
EXEC dbo.sp_update_job @job_name = N'SiteDB bodb02: Remove data BA Transaction after MoveBets day', @enabled = 0 ;

--=====================================================================================================================================


/*<info serverAlias="DBACC-msdb"></info>*/
--=====================================================================================================================================
USE [msdb]

GO

EXEC dbo.sp_update_job @job_name = N'bodb_Licensee: Archive BA Transaction - Correct and Delete data', @enabled = 0 ;

GO
EXEC dbo.sp_update_job @job_name = N'bodb_Licensee: Archive BA Transaction - Copy data', @enabled = 0 ;

--=====================================================================================================================================


/*<info serverAlias="DBAGE-msdb"></info>*/
--=====================================================================================================================================

USE [msdb]

GO

EXEC dbo.sp_delete_jobstep
	@job_name = N'bodb_LicenseeReport: Licensee Winloss - Check and Correct Data',
	@step_id = 5
	---@step_name=N'Archive BA Transaction - Correct and Delete data'

GO

EXEC dbo.sp_delete_jobstep
	@job_name = N'bodb_LicenseeReport: Daily Summary Licensee Winloss',
	@step_id = 2
	---@step_name=N'Archive BA Transaction - Copy data'

--=====================================================================================================================================
