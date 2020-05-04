USE bodb_LicenseeReport
GO

/*
	Created: 20200504@Percy
	DB: DBLIC.bodb_LicenseeReport
	Task: GD - Regen data manually due to 3rd data change
*/

EXEC dbo.GEN_rptBettingByProduct
	@date					= '2020-04-22'
	,@date2					= '2020-04-22'
	,@DataSource			= 'SeparatedProduct'
	,@SeparatedProductID	= 11
	,@ProductCodes			= 'GD'