/*<info serverAlias="DBCUST-bodb_Licensee"></info>*/
/*
	Created: 20210319@Sol
	Task: 151607 - NAP - Enhance Manage Licensee Code to support change base currency of licensees
	DB: DBCUST/bodb_Licensee
*/

USE bodb_Licensee

GO
-- 1 row affected
DELETE FROM dbo.LicenseeTransferCode WHERE LicenseeName = 'Spark' AND CustID = 49081033 AND FromDate = '2021-03-01' AND ToDate = '2050-01-31'

GO 
-- 1 row affected
UPDATE dbo.LicenseeTransferCode
	SET 
		ToDate = '2050-01-31'
WHERE LicenseeName = 'Spark' AND CustID = 38698241 AND FromDate = '2019-08-01' AND ToDate = '2021-02-28'

GO