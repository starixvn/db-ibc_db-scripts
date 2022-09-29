/*<info serverAlias="DBLIC-bodb_LicenseeReport"></info>*/
/*
	Created: 20220919@Sol
	DB: DBLIC-bodb_LicenseeReport
	Task: insert data into rptDepWinlost_ThirdParty - [Redmine: #177979]
*/

--## RUN IN DB052 ONLY ##--

USE bodb_LicenseeReport

GO 

---exec sp to gen data
EXEC bodb_LicenseeReport.[dbo].[GEN_rptBettingByProduct]
	@date = '20220801',
	@date2 = '20220831',
	@DataSource	= 'SeparatedProduct',
	@SeparatedProductID	= 31,
	@ProductCodes = 'BX',
	@IsManual = 0

GO