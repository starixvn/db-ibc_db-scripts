/*<info serverAlias="DBLIC-bodb_LicenseeReport"></info>*/

/*
	Created by: 20250211@Kelvin
	Task: BA Admin & LAP - Drop BA functions [RedmineID: #216882]
*/

--DBLIC-bodb_LicenseeReport
--=====================================================================================================================================
USE bodb_LicenseeReport
GO
SP_RENAME 'GEN_rptBetting_BA','DEL_GEN_rptBetting_BA'
GO
SP_RENAME 'Task_rptBetting_BA_CheckData','DEL_Task_rptBetting_BA_CheckData_BA'

--=====================================================================================================================================
