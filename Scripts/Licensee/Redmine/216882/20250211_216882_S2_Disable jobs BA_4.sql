/*<info serverAlias="DBAGE-msdb"></info>*/

/*
	Created by: 20250211@Kelvin
	Task: BA Admin & LAP - Drop BA functions [RedmineID: #216882]
*/

--DBAGE
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
