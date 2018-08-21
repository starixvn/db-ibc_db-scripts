/*
	Created: 20180806@Helen
	Task: DB05.DBPOLICY migration - [Redmine:99462]
	SERVER: DBCUST/CUSTDB
*/
USE CUSTDB

GO
---------STEP 1: Mark delete for Tables -----------------------------------
DECLARE @end INT = 1, @start INT = 1

CREATE TABLE #Tables_MarkDelete (ID INT IDENTITY (1,1),ObjectName VARCHAR (200))

INSERT INTO #Tables_MarkDelete (ObjectName)
VALUES
('Acc_P2PUpdDefaultSetting'),
('Agw_SelCustomerGivenCreditByAg'),
('Agw_SelCustomerGivenCreditByMAg'),
('Agw_SelCustomerGivenCreditBySAg'),
('Agw_SelMaxMemberCredit'),
('DBA_AccAdminDel'),
('f_IsAllowedAccUser'),
('Acc_CustomerUpdSuperLiveCS_CommissionForAllLevels'),
('Acc_ExchangeUpdateOpenToteRate'),
('Acc_RacingBetSettingUpd')

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

