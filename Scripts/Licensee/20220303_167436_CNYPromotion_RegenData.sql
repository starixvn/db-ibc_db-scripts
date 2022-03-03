/*<info serverAlias="DBLIC-bodb_LicenseeReport"></info>*/
/*
	Created: 20220303@Percy
	DB: DBLIC-bodb_LicenseeReport
	Task: Manually regen data for SB Promotion on 28 Feb 2022
*/

USE bodb_LicenseeReport
GO

-- Prepare Staging
EXEC dbo.Task_PostStaging

EXEC dbo.Task_PrepareStaging @DateFrom = '2022-02-28', @DateTo = '2022-02-28', @ProductCodes = 'SPR'

-- Gen rpt_Betting
EXEC dbo.GEN_rptBetting @date = '2022-02-28', @date2 = '2022-02-28', @ProductCodes = 'SPR'

-- Gen rpt_BettingByProduct
EXEC dbo.GEN_rptBettingByProduct @date = '2022-02-28', @date2 = '2022-02-28', @DataSource = 'Rpt_Betting', @ProductCodes = 'SPR', @IsManual = 1

-- Post Staging
EXEC dbo.Task_PostStaging