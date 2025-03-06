/*<info serverAlias="DBACC-msdb"></info>*/

/*
	Created by: 20250211@Kelvin
	Task: BA Admin & LAP - Drop BA functions [RedmineID: #216882]
*/


--DBACC
--=====================================================================================================================================
USE [msdb]

GO

EXEC dbo.sp_update_job @job_name = N'bodb_Licensee: Archive BA Transaction - Correct and Delete data', @new_name = N'DEL_bodb_Licensee: Archive BA Transaction - Correct and Delete data', @enabled = 0 ;

GO
EXEC dbo.sp_update_job @job_name = N'bodb_Licensee: Archive BA Transaction - Copy data', @new_name = N'DEL_bodb_Licensee: Archive BA Transaction - Copy data', @enabled = 0 ;

--=====================================================================================================================================
