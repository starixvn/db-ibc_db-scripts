/*<info serverAlias="DB042-bodb_Licensee"></info>*/

/*
	Created by: 20250211@Kelvin
	Task: BA Admin & LAP - Drop BA functions [RedmineID: #216882]
*/

--DB042-bodb_Licensee
--=====================================================================================================================================
USE bodb_Licensee
GO
SP_RENAME 'Task_Archive_BATransaction_Del','DEL_Task_Archive_BATransaction_Del'
GO
SP_RENAME 'Task_BATransaction_Copy_Ticket','DEL_Task_BATransaction_Copy_Ticket'

--=====================================================================================================================================
