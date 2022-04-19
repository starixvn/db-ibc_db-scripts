/*<info serverAlias="DBLIC-bodb_LicenseeReport"></info>*/
/*
	Created: 20220419@Percy
	DB: DBLIC-bodb_LicenseeReport
	Task: Exchange Product - Remove duplicate data due to API's issue
	https://nexdev.net/issues/171543 (part 2)
		- Step 3: Regen sum data
*/
use bodb_LicenseeReport
go

exec GEN_rptBettingByProduct @date = '2022-04-06', @date2 = '2022-04-11', @DataSource = 'SeparatedProduct', @SeparatedProductID = 31, @ProductCodes = 'BX', @IsManual = 1