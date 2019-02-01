-- run on DB052, DB053, DB054

/*
	Created: 20190201@Percy
	DB: DB052, DB053, DB054
	Task: Manually regen data for GD on 2019 Jan 02
	RedmineID: #108659
*/

-- rptDepWinlost_ThirdParty
EXEC bodb_PlaytechCS.dbo.Task_DOT_GoldDeluxe_DailySummary @winlostdate = '2019-01-02', @IsManual = 1

-- rptBettingByProduct
EXEC bodb_LicenseeReport.dbo.GEN_rptBettingByProduct @date = '2019-01-02', @DataSource = 'SeparatedProduct', @SeparatedProductID = 11