/*<info serverAlias="DBSID-bodb02"></info>*/

/*
	Created by: 20250211@Kelvin
	Task: BA Admin & LAP - Drop BA functions [RedmineID: #216882]
*/

--DBSID-bodb02
--=====================================================================================================================================
USE bodb02
GO
SP_RENAME 'SiteDB_Task_BATransaction_CheckAndCorrect','DEL_SiteDB_Task_BATransaction_CheckAndCorrect'
GO
SP_RENAME 'SiteDB_Task_BATransaction_Ins','DEL_SiteDB_Task_BATransaction_Ins'
GO
SP_RENAME 'SiteDB_Task_Archive_BATransaction_Del','DEL_SiteDB_Task_Archive_BATransaction_Del'
GO
SP_RENAME 'SiteDB_Task_BATransaction_Loop_Ins','DEL_SiteDB_Task_BATransaction_Loop_Ins'

--=====================================================================================================================================
