/*<info serverAlias="DBLIC-bodb_LicenseeReport"></info>*/
/*
	Created: 20210205@Percy
	DB: DBLIC-bodb_LicenseeReport
	Task: Regen data for AG Casino
*/
use bodb_LicenseeReport
go

exec dbo.GEN_rptBettingByProduct
	@date = '2021-01-14'
	,@date2 = '2021-01-14'
	,@DataSource = 'SeparatedProduct'
	,@SeparatedProductID = 10
	,@ProductCodes = ''