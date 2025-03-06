/*<info serverAlias="DBEXT-msdb,DBACC-msdb,DBBOF-msdb"></info>*/

/*
	Created by: 20250211@Kelvin
	Task: BA Admin & LAP - Drop BA functions [RedmineID: #216882]
*/

GO

-- DBEXT, DBACC, DBBOF
--=====================================================================================================================================
USE [msdb]

GO

EXEC dbo.sp_update_job @job_name = N'bodb02: Retrieve BA Transaction', @enabled = 0 ;

GO
EXEC dbo.sp_update_job @job_name = N'bodb02: Verify BA Tickets', @enabled = 0 ;

--=====================================================================================================================================



