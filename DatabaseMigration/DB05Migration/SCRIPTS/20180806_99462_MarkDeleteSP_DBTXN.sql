/*
	Created: 20180806@Helen
	Task: DB05.DBPOLICY migration - [Redmine:99462]
	SERVER: DBTXN/bodb02
*/
USE bodb02

GO
---------STEP 1: Mark delete for Tables -----------------------------------
DECLARE @end INT = 1, @start INT = 1

CREATE TABLE #Tables_MarkDelete (ID INT IDENTITY (1,1),ObjectName VARCHAR (200))

INSERT INTO #Tables_MarkDelete (ObjectName)
VALUES
('Acc_BettransDelBet'),
('Acc_BettransDelBet_Parlay'),
('Acc_BettransDelSpecial'),
('Acc_BettransDelSpecial_LeagueSelOutright'),
('Acc_BettransDelSpecial_LiveCS'),
('Acc_BettransDelSpecial_NumberGame'),
('Acc_BettransDelSpecial_VirtualSports'),
('Acc_BettransDelSpecialDel_EarlyKO'),
('Acc_BettransDelSpecialDel_MixParlay'),
('Acc_BettransRecoverBet_LiveCS'),
('Acc_BettransRecoverBet_NumberGame'),
('Acc_Rpt_DailyWLDirect_HorseRacing'),
('Acc_Rpt_DailyWLDirect_Sporttype14'),
('Acc_Rpt_Winloss_M88_BetList'),
('Acc_Rpt_Winloss_M88_BetList_History'),
('Acc_Rpt_WinlostHR_Details14'),
('Acc_VirtualRateMulDelTmpExcel'),
('Acc_VirtualRateMulInsTmpExcel'),
('Acc_VirtualRateMulSelCheck'),
('Acc_CustomerUpdEditCustomer_Ag'),
('Admin_ProcessLogin'),
('Age_CustomerUpdClearCredit'),
('Age_Result_Outright'),
('Agw_CheckExistedUserName'),
('Agw_Rpt_WinlossDetail_SAg'),
('Agw_Rpt_WinlossTotal_Ag'),
('Agw_Rpt_WinlossTotal_MAg'),
('Agw_Rpt_WinlossTotal_SAg'),
('Agw_SelCommValues_Ag'),
('Agw_SelCustomerGivenCreditByAg'),
('Agw_SelCustomerGivenCreditByMAg'),
('Agw_SelCustomerGivenCreditBySAg'),
('Agw_SelMaxMemberCredit'),
('Agw_SelSuitablePTRange_Ag'),
('Agw_Transfer_SelList_Ag'),
('Agw_Transfer_SelList_MAg'),
('Agw_Transfer_SelList_SAg'),
('DBA_Settlement_AbandonedMatch'),
('NAP_BettransDelSpecial_LiveCS'),
('NAP_BettransRecoverBet_LiveCS'),
('NAP_BettransDelSpecialDel_MixParlay'),
('NAP_BettransDelSpecial')

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

