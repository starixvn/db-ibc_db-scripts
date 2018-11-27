/*
	Created: 20181122@Helen
	Task: DB053.bodb_AGE/BODB02 & DB052.bodb_Summary Migration - [Redmine:104770]
	SERVER: DB053/bodb_AGE
*/
USE bodb_AGE

GO
---------STEP 1: Mark delete for Tables -----------------------------------
DECLARE @end INT = 1, @start INT = 1

CREATE TABLE #Tables_MarkDelete (ID INT IDENTITY (1,1),ObjectName VARCHAR (200))

INSERT INTO #Tables_MarkDelete (ObjectName)
VALUES
('AgeRWLastSyncVersion'),
('bettrans_forecast_agent'),
('bettrans_running_20180126_bk'),
('bettrans_running_del'),
('bettrans_running_toDelete'),
('bettrans_trigger_agent'),
('DownlineTo_LeagueControl'),
('DownlineTo_Match_SMAControl'),
('DownlineTo_MatchControl'),
('DownlineTo_SMAControl'),
('DownlineTo_SportControl'),
('LimitLoss_Setting_20140627_BK'),
('LimitLoss_Setting_UAT'),
('LimitLoss_ActionConfig_20140627_BK'),
('LimitLoss_ActionConfig_UAT'),
('tmp_binary_dst2'),
('tmp_v_tablediff2'),
('rptProgressiveGamesContribution_20180607_bk'),
('rptProgressiveGamesContribution_20180608_bk'),
('rptProgressiveGamesContribution_tmp'),
('sum_winlossFB'),
('transfer_fi_on_date_May13'),
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
	SELECT @sql = 'DROP TABLE ' + ObjectName + '_delete'
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

