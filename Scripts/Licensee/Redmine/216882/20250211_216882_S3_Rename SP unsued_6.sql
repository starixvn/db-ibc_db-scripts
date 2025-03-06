/*<info serverAlias="DBAGE-bodb02,DBACC-bodb02"></info>*/

/*
	Created by: 20250211@Kelvin
	Task: BA Admin & LAP - Drop BA functions [RedmineID: #216882]
*/

--DBAGE-bodb02,DBACC-bodb02
--=====================================================================================================================================
USE bodb02
GO
SP_RENAME 'Task_LicenseeBATransaction_Archive_Delete','DEL_Task_LicenseeBATransaction_Archive_Delete'
GO
SP_RENAME 'Task_LicenseeBATransaction_Archive_Copy','DEL_Task_LicenseeBATransaction_Archive_Copy'
