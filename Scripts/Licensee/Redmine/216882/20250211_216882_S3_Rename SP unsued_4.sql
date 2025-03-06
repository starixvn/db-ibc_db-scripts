/*<info serverAlias="DBLIC-bodb_Licensee,DBACC-bodb_Licensee,DB042-bodb_Licensee"></info>*/

/*
	Created by: 20250211@Kelvin
	Task: BA Admin & LAP - Drop BA functions [RedmineID: #216882]
*/

--DBLIC-bodb_Licensee,DBACC-bodb_Licensee,DB042-bodb_Licensee
--=====================================================================================================================================
USE bodb_Licensee
GO
SP_RENAME 'Task_DetectBAMemberBreakRules','DEL_Task_DetectBAMemberBreakRules'

--=====================================================================================================================================
