/*<info serverAlias="DBCUST-bodb_licensee"></info>*/

/*
	Created: 20220215@Danny
	DB: DBCUST.bodb_licensee
	Description: 
*/

--UPDATE [bodb_Licensee].[dbo].[LicenseeTransferCode] WITH(ROWLOCK) 
--SET CustID = 60898539 --PHL-LSEE-YAKAGAMING EUR
--WHERE LicenseeName = 'YakaGaming'

UPDATE [bodb_Licensee].[dbo].[LicenseeTransferCode] WITH(ROWLOCK) 
SET CustID = 60929533 --PHL-LSEE-XIAOXIANG EUR
WHERE LicenseeName = 'Xiaoxiang'