 /*<info serverAlias="DBLIC-bodb_LicenseeReport"></info>*/
/*
	Create : 20211021@Danny 
	Regen data for AGCasino - [Redmine: #162947] 
	DB: DBLIC.bodb_LicenseeReport
*/
USE bodb_LicenseeReport

-- DBLIC - bodb_LicenseeReport 
-- regen data AGC 
EXEC dbo.GEN_rptBettingByProduct
	@date					= '2021-10-01',
	@date2					= '2021-10-20',
	@DataSource				= 'SeparatedProduct',
	@SeparatedProductID		= 10,
	@ProductCodes			= 'AGC',
	@IsManual				= 1