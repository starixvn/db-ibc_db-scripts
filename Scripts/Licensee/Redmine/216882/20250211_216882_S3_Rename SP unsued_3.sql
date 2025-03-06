/*<info serverAlias="DBEXT-bodb02,DBACC-bodb02,DBBOF-bodb02"></info>*/

/*
	Created by: 20250211@Kelvin
	Task: BA Admin & LAP - Drop BA functions [RedmineID: #216882]
*/

--DBEXT-bodb02,DBACC-bodb02,DBBOF-bodb02
--=====================================================================================================================================
USE bodb02
GO
SP_RENAME 'Task_BATransaction_Loop_Ins','DEL_Task_BATransaction_Loop_Ins'
GO
SP_RENAME 'Task_BATransaction_Ins','DEL_Task_BATransaction_Ins'
GO
SP_RENAME 'Task_BATransaction_CheckAndCorrect','DEL_Task_BATransaction_CheckAndCorrect'


--=====================================================================================================================================
