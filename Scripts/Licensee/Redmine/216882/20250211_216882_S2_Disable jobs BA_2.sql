/*<info serverAlias="DBSID-msdb"></info>*/

/*
	Created by: 20250211@Kelvin
	Task: BA Admin & LAP - Drop BA functions [RedmineID: #216882]
*/


--DBSID
--=====================================================================================================================================
USE [msdb]

GO

EXEC dbo.sp_update_job @job_name = N'SiteDB bodb02: Verify BA Tickets', @new_name = N'DEL_SiteDB bodb02: Verify BA Tickets', @enabled = 0 ;

GO
EXEC dbo.sp_update_job @job_name = N'SiteDB bodb02: Retrieve BA Transaction', @new_name = N'DEL_SiteDB bodb02: Retrieve BA Transaction', @enabled = 0 ;

GO
EXEC dbo.sp_update_job @job_name = N'SiteDB bodb02: Remove data BA Transaction after MoveBets day', @new_name = N'DEL_SiteDB bodb02: Remove data BA Transaction after MoveBets day', @enabled = 0 ;

--=====================================================================================================================================
