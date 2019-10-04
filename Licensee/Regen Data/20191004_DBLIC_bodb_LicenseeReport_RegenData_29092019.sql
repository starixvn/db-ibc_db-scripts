USE bodb_LicenseeReport
GO

/*
	Created: 20191004@Percy
	DB: DBLIC - bodb_LicenseeReport
	Task: Regen deposit data on 2019-09-29
*/

-- rptLicWinloss2
EXEC dbo.Task_DailyRptLicWinloss2 @winlostdate = '2019-09-29'
GO

-- rptCustomerTurnover
EXEC dbo.Task_rptCustomerTurnOver_Bettrans14 @Date = '2019-09-29'
GO

-- rptWinlostbyleague
EXEC dbo.Task_rptWinlostbyleague_Bettrans14 @Date = '2019-09-29'
GO

-- rptCustomerMatch
EXEC dbo.Task_rptCustomerMatch_Bettrans14 @Date = '2019-09-29'
GO

-- rptBetting_Parlay
EXEC dbo.GEN_rptBetting_Parlay14 @datefrom ='2019-09-29', @dateto = '2019-09-29'
GO

-- rptBettingColossusBets
EXEC Task_rptBettingColossusBets_CheckData @WinlostDate = '2019-09-29'
GO

-- rptLicWinlossGMT
EXEC Task_rptLicWinlossGMT_CheckData @WinlostDate = '2019-09-29'
GO

-- ============== rpt Betting tables
EXEC Task_PrepareStaging @datefrom = '2019-09-29', @dateto = '2019-09-29'
GO

DECLARE @p1 BIT, @p2 VARCHAR(MAX)
EXEC Task_rptBetting_CheckData @WinlostDate = '2019-09-29', @HasDataMismatch = @p1 OUTPUT, @BetTypes = @p2 OUTPUT
GO

DECLARE @p1 BIT, @p2 VARCHAR(MAX)
EXEC Task_rptBetting_BA_CheckData @WinlostDate = '2019-09-29', @HasDataMismatch = @p1 OUTPUT, @BetTypes = @p2 OUTPUT
GO

EXEC GEN_rptBettingByProduct @date = '2019-09-29', @DataSource = 'rpt_Betting'
GO

DECLARE @p1 BIT, @p2 BIT
EXEC Task_rptBettingBySport_CheckData @WinlostDate = '2019-09-29', @HasDataMismatch = @p1 OUTPUT, @IsParlay = @p2 OUTPUT
GO

EXEC Task_PostStaging