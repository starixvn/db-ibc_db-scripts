 /*<info serverAlias="DBLIC-bodb_LicenseeReport"></info>*/
USE [bodb_LicenseeReport]

GO

/*
	Create : 20221117@Sophia
	Task : Regen data for LAP system [Redmine: #180613] 
	DB: DBLIC.bodb_LicenseeReport
*/
 
EXEC Task_rptCustomerMatch_Bettrans14 @Date = '2022-11-08'
GO 
EXEC Task_rptCustomerMatch_Bettrans14 @Date = '2022-11-09'
GO
EXEC Task_rptCustomerMatch_Bettrans14 @Date = '2022-11-13'
GO
-------

EXEC Task_rptCustomerTurnOver_Bettrans14 @Date = '2022-11-08'
GO 
EXEC Task_rptCustomerTurnOver_Bettrans14 @Date = '2022-11-09'
GO
EXEC Task_rptCustomerTurnOver_Bettrans14 @Date = '2022-11-13'
GO
-------

EXEC Task_DailyRptLicWinlossGMT_Bettrans14 @FromDate = '2022-11-08'
GO 
EXEC Task_DailyRptLicWinlossGMT_Bettrans14 @FromDate = '2022-11-09'
GO
EXEC Task_DailyRptLicWinlossGMT_Bettrans14 @FromDate = '2022-11-13'
GO

-------

EXEC Task_rptWinlostbyleague_Bettrans14 @Date = '2022-11-08'
GO 
EXEC Task_rptWinlostbyleague_Bettrans14 @Date = '2022-11-09'
GO
EXEC Task_rptWinlostbyleague_Bettrans14 @Date = '2022-11-13'
GO

-------

EXEC GEN_rptBettingBySport14 @Date = '2022-11-08'
GO 
EXEC GEN_rptBettingBySport14 @Date = '2022-11-09'
GO
EXEC GEN_rptBettingBySport14 @Date = '2022-11-13'
GO

