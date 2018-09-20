/*
	Created: 20180806@Helen
	Task: DB05.DBPOLICY migration - [Redmine:99462]
	SERVER: DB05/bodb02
*/
USE bodb02

GO
---------STEP 1: Mark delete for Tables -----------------------------------
DECLARE @end INT = 1, @start INT = 1

CREATE TABLE #Tables_MarkDelete (ID INT IDENTITY (1,1),ObjectName VARCHAR (200))

INSERT INTO #Tables_MarkDelete (ObjectName)
VALUES
('Acc_ExchangeRateSel'),
('Acc_ExchangeRateIns'),
('Acc_ExchangeRateSelHistory'),
('Acc_ExchangeRateUpd'),
('Acc_ExchangeRateSelInvalid'),
('Acc_CreditTermSelCheckerList'),
('Acc_MenuSelByCustID'),
('Acc_MenuSelList'),
('Acc_MenuSelGroupFunc'),
('Acc_MenuIns'),
('Acc_MenuUpd'),
('Acc_MenuDel'),
('Acc_Con_FuncInfoSelParent'),
('Acc_Con_FuncInfoSel'),
('Acc_Con_FuncInfoDel'),
('Acc_Con_FuncInfoIns'),
('Acc_Con_FuncInfoUpd'),
('Acc_CustomerIsAllowedAccess'),
('Acc_CustomerIsDummyAccount'),
('Acc_CustomerIsSpecialSite'),
('Acc_Con_AdminSelByGroupID'),
('Acc_Con_GroupInfoSel'),
('Acc_Con_GroupInfoUpd'),
('Acc_Con_GroupInfoDel'),
('Acc_Con_GroupPolicySel'),
('Acc_Con_GroupPolicyUpd'),
('Acc_Con_AdminSelByGroupID'),
('Acc_Con_GroupInfoIns'),
('Acc_Con_GroupInfoSel'),
('Acc_Con_AdminInsFromExisted'),
('Acc_Con_AdminSelByGroupID'),
('Acc_Con_CheckPermission'),
('Acc_Con_AdminPolicySelByCustID'),
('Acc_Con_AdminPolicyUpd'),
('Acc_Con_CustomerSelByUserName'),
('Acc_ExchangeRateUpdisDeleted'),
('Acc_ExchangeRateCheckValid'),
('Acc_Con_FileNameSelByCustID'),
('Acc_CustomerIsInternalAdmin'),
('Acc_Con_CheckPermission_All'),
('Acc_CustomerIsSpecialSite'),
('Acc_CustomerIsInternalAdmin'),
('Acc_Con_CheckPermission'),
('Acc_Con_AdminNapU3SelByGroupID'),
('Acc_AdminGroupSel'),
('Acc_Con_AdminDel'),
('Acc_Con_AdminPolicyUpd'),
('Acc_Con_FileNameSelByCustID'),
('Acc_CustomerIsInternalAdmin'),
('Acc_Con_AdminSelByCustID')


SET @end = (SELECT MAX(ID) FROM #Tables_MarkDelete)
DECLARE @sql NVARCHAR(MAX) = ''

WHILE @start < = @end
BEGIN
	SELECT @sql = 'sp_rename '''	+  ObjectName + ''',''' + ObjectName + '_delete'''
	FROM #Tables_MarkDelete
	WHERE ID = @start
	
	PRINT 'In progress:' + @sql
	
	BEGIN TRY
		EXEC (@sql)
		PRINT 'Done: ' + @sql
	END TRY
	BEGIN CATCH
		PRINT 'Failed: OBJECT NOT EXISTS - ' + @sql 
	END CATCH

	SET @start = @start + 1
	
END

DROP TABLE #Tables_MarkDelete

GO

