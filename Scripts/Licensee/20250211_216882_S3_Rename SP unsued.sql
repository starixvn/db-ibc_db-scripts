
/*
	Created by: 20250211@Kelvin
	Task: BA Admin & LAP - Drop BA functions [RedmineID: #216882]
*/

GO

--DBLIC-bodb_LicenseeReport
--=====================================================================================================================================
USE bodb_LicenseeReport
GO
SP_RENAME 'GEN_rptBetting_BA','DEL_GEN_rptBetting_BA'
GO
SP_RENAME 'Task_rptBetting_BA_CheckData','DEL_Task_rptBetting_BA_CheckData_BA'

--=====================================================================================================================================


--DB042-bodb_Licensee
--=====================================================================================================================================
USE bodb_Licensee
GO
SP_RENAME 'Task_Archive_BATransaction_Del','DEL_Task_Archive_BATransaction_Del'
GO
SP_RENAME 'Task_BATransaction_Copy_Ticket','DEL_Task_BATransaction_Copy_Ticket'

--=====================================================================================================================================


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


--DBLIC-bodb_Licensee,DBACC-bodb_Licensee,DB042-bodb_Licensee
--=====================================================================================================================================
USE bodb_Licensee
GO
SP_RENAME 'Task_DetectBAMemberBreakRules','DEL_Task_DetectBAMemberBreakRules'

--=====================================================================================================================================


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


--DBAGE-bodb02,DBACC-bodb02
--=====================================================================================================================================
USE bodb02
GO
SP_RENAME 'Task_LicenseeBATransaction_Archive_Delete','DEL_Task_LicenseeBATransaction_Archive_Delete'
GO
SP_RENAME 'Task_LicenseeBATransaction_Archive_Copy','DEL_Task_LicenseeBATransaction_Archive_Copy'

