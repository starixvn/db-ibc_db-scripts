USE bodb_LicenseeReport
GO

/*
	Created: 20200427@Percy
	DB: DBLIC.bodb_LicenseeReport
	Task: rpt_BettingByProduct - Correct data on bettrans_bk & bettrans14 range
		Get data from rpt_Betting
*/

EXEC dbo.GEN_rptBettingByProduct
	@date			= '2020-04-16'
	,@date2			= '2020-04-19'
	,@DataSource	= 'Rpt_Betting'
	,@ProductCodes	= 'TG'