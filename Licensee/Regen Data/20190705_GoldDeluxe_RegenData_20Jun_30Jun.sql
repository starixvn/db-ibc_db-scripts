-- DBLIC (DB052, DB053, DB054)

/*
	Created: 20190705@Percy
	DB: DBLIC (DB052, DB053, DB054)
	Task: Re-gen sum data due to re-pull API's data [RedmineID: #116437]
*/

-- 20-Jun and 30-Jun
EXEC bodb_PlaytechCS.dbo.Task_DOT_GoldDeluxe_DailySummary @winlostdate = '2019-06-20', @IsManual = 1
GO

EXEC bodb_PlaytechCS.dbo.Task_DOT_GoldDeluxe_DailySummary @winlostdate = '2019-06-30', @IsManual = 1
GO


EXEC bodb_LicenseeReport.dbo.GEN_rptBettingByProduct
		@date = '2019-06-20', @date2 = '2019-06-20'
		,@DataSource = 'SeparatedProduct'
		,@SeparatedProductID = 11 -- GD
GO

EXEC bodb_LicenseeReport.dbo.GEN_rptBettingByProduct
		@date = '2019-06-30', @date2 = '2019-06-30'
		,@DataSource = 'SeparatedProduct'
		,@SeparatedProductID = 11 -- GD
GO