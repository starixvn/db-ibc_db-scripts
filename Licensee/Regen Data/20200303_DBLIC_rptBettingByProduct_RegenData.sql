USE bodb_LicenseeReport
GO

/*
	Created: 20200303@Percy
	DB: DBLIC
	Task: Regen data 2020 Feb 17 for GD
*/

EXEC dbo.GEN_rptBettingByProduct
	@date					= '2020-02-17'
	, @DataSource			= 'SeparatedProduct'
	, @SeparatedProductID	= 11
GO