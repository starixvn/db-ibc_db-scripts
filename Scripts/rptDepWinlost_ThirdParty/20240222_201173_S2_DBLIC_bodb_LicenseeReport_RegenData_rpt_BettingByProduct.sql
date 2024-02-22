/*<info serverAlias="DBLIC-bodb_LicenseeReport"></info>*/
/*
	Created: 20240222@Evan
	DB: DBLIC-bodb_3rdProduct
	Step 2: regen data rpt_BettingByProduct T1,2 (2024) [RedmineID: #201173]
	Run on DB052, DB053
*/

USE bodb_LicenseeReport
GO
SET NOCOUNT ON

DECLARE @fDate SMALLDATETIME = '2024-01-01'
DECLARE @tDate SMALLDATETIME = '2024-01-31'

-- regen table rpt_BettingByProduct
EXEC dbo.GEN_rptBettingByProduct @date = @fDate
									, @date2 = @tDate
									, @DataSource = 'SeparatedProduct'
									, @SeparatedProductID = 10
									, @ProductCodes = 'AGC'
									, @IsManual = 1


GO
