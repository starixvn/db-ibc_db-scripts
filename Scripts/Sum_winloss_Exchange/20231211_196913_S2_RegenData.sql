/*<info serverAlias="DBLIC-bodb_3rdProduct"></info>*/
/*
	Created: 20231211@Evan
	DB: DBLIC-bodb_3rdProduct
	Task: Step 2: regen data rptDepWinlost_ThirdParty, rpt_BettingByProduct  T9,10 (2023) [RedmineID: #196913]
	

*/

USE bodb_3rdProduct
GO
SET NOCOUNT ON

DECLARE @fDate SMALLDATETIME = '2023-09-01'
DECLARE @tDate SMALLDATETIME = '2023-10-31'

WHILE (@fDate <= @tDate)
BEGIN
	-- regen table rptDepWinlost_ThirdParty
	EXEC Task_DOT_Exchange_DailySummary @winlostdate = @fDate	
									  , @IsManual = 1

	-- regen table rpt_BettingByProduct
	EXEC bodb_LicenseeReport.dbo.GEN_rptBettingByProduct @date = @fDate
													   , @date2 = @fDate
													   , @DataSource = 'SeparatedProduct'
													   , @SeparatedProductID = 31
													   , @ProductCodes = 'BX'
													   , @IsManual = 1
	SET @fDate = DATEADD(DAY,1,@fDate)
	
	WAITFOR DELAY '00:00:00.280'
END