/*<info serverAlias="DBLIC-bodb_LicenseeReport"></info>*/
/*
	Created: 20240314@Evan
	DB: DBLIC-bodb_3rdProduct
	Step 2: regen data rpt_BettingByProduct T3 (2024) [RedmineID: #200273]
	Run on DB052, DB053
*/

USE bodb_LicenseeReport
GO
SET NOCOUNT ON

DECLARE @fDate SMALLDATETIME = '2024-03-01'
DECLARE @tDate SMALLDATETIME = CAST(CURRENT_TIMESTAMP AS DATE)

-- regen table rpt_BettingByProduct
EXEC dbo.GEN_rptBettingByProduct @date = @fDate
									, @date2 = @tDate
									, @DataSource = 'SeparatedProduct'
									, @SeparatedProductID = 10
									, @ProductCodes = 'AGC'
									, @IsManual = 1


GO
