USE [bodb_LicenseeReport]
GO

/*
	Created: 20190418@Percy
	DB: DBLIC.bodb_LicenseeReport
	Task: Regen data manually [RedmineID: #111937]
*/


-- Step 1. Prepare bettrans staging
DECLARE @WinlostDate SMALLDATETIME = '2019-04-07', @ErrorMsgStaging INT = 0
EXEC dbo.Task_PrepareStaging @datefrom = @WinlostDate, @dateto = @WinlostDate , @ErrorMsg = @ErrorMsgStaging OUTPUT	
SELECT @ErrorMsgStaging AS HasError

GO

-- Step 2.1. Gen rpt_Betting
DECLARE @WinlostDate SMALLDATETIME = '2019-04-07'
EXEC dbo.GEN_rptBetting @date = @WinlostDate, @date2 = @WinlostDate

GO

-- Step 2.2. Gen rpt_Betting_BA
DECLARE @WinlostDate SMALLDATETIME = '2019-04-07'
EXEC dbo.GEN_rptBetting_BA @date = @WinlostDate, @date2 = @WinlostDate

GO

-- Step 2.3. Gen rpt_BettingByProduct
DECLARE @WinlostDate SMALLDATETIME = '2019-04-07'
EXEC dbo.GEN_rptBettingByProduct @date = @WinlostDate, @date2 = @WinlostDate, @DataSource = 'rpt_betting' , @SeparatedProductID = 0   

GO

-- Step 3. Clear bettrans staging
EXEC dbo.Task_PostStaging
GO

-- Step 4. Gen rptBetting_ColossusBets
DECLARE @WinlostDate SMALLDATETIME = '2019-04-07'
EXEC dbo.GEN_rptBetting_ColossusBets14 @date  = @WinlostDate, @date2 = @WinlostDate

GO