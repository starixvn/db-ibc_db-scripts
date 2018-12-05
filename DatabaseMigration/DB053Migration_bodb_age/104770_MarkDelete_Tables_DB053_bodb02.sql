/*
	Created: 20181122@Helen
	Task: DB053.bodb_AGE/BODB02 & DB052.bodb_Summary Migration - [Redmine:104770]
	SERVER: DB053/bodb02
*/
USE bodb02

GO
---------STEP 1: Mark delete for Tables -----------------------------------
DECLARE @end INT = 1, @start INT = 1

CREATE TABLE #Tables_MarkDelete (ID INT IDENTITY (1,1),ObjectName VARCHAR (200))

INSERT INTO #Tables_MarkDelete (ObjectName)
VALUES
('Acc_ExternalSettlement'),
('Acc_GroupExtraPT_Product'),
('bettrans_forecast_agent'),
('bettrans_running_bkup'),
('bettrans_running_toDelete'),
('bettrans_trigger_agent'),
('CommandExcluded'),
('custbankinfo'),
('DownlineTurnOver_GlobalSetting'),
('DownlineTurnOver_Setting'),
('DownlineTurnOver_Setting_Delete'),
('DownlineTurnOver_Setting_tmp'),
('DownlineTurnOver_Trigger'),
('DownlineTurnOver_Trigger_tmp'),
('Exchange_History'),
('Exchange_History_Old'),
('GameType_tmp'),
('GlobalVariables'),
('invalid_cs'),
('JackpotWin'),
('jwait'),
('LCS_custgametype'),
('LCS_StakeLevel'),
('Logs'),
('Match_HedgeForecast'),
('message'),
('RefCombination_backup'),
('RefCombinationSet_backup'),
('tmp'),
('tmpa'),
('tmpCustomer'),
('tmpDepSuperID'),
('RecommendExceptionList')

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

