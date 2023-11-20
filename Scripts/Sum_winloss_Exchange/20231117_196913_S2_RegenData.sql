/*<info serverAlias="DBLIC-bodb_3rdProduct"></info>*/
/*
	Created: 20231117@Evan
	DB: DBLIC-bodb_3rdProduct
	Task: Step 2: regen data rptDepWinlost_ThirdParty, rpt_BettingByProduct [RedmineID: #196913]
	

*/

USE bodb_3rdProduct
GO
SET NOCOUNT ON

DECLARE @fDate SMALLDATETIME = '2023-11-01'
DECLARE @WinlossDate SMALLDATETIME = DATEADD(DAY, -1, CONVERT(VARCHAR(10), GETDATE(), 120))

WHILE (@fDate <= @WinlossDate)
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
	
END