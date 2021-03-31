/*<info serverAlias="DBCUST-bodb_Licensee"></info>*/
/*
	Created: 20210319@Sol
	Task: 151607 - NAP - Enhance Manage Licensee Code to support change base currency of licensees
	DB: DBCUST/bodb_Licensee
*/

USE bodb_Licensee

GO
---1 row affected
UPDATE dbo.LicenseeTransferCode
	SET 
		ToDate = '2019-08-31'
WHERE LicenseeName = 'MayFair' AND CustID = 4044285 AND FromDate = '2019-08-01' AND ToDate = '2050-01-31' AND StatusID = 0

GO 
---1 row affected
UPDATE dbo.LicenseeTransferCode
	SET 
		ToDate = '2019-08-31'
WHERE LicenseeName = 'Win68Club' AND CustID = 36396133 AND FromDate = '2019-08-01' AND ToDate = '2050-01-31' AND StatusID = 0

GO