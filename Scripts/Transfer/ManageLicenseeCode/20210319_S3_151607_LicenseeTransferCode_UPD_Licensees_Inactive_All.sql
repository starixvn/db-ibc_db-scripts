/*<info serverAlias="DBCUST-bodb_Licensee"></info>*/
/*
	Created: 20210319@Sol
	Task: 151607 - NAP - Enhance Manage Licensee Code to support change base currency of licensees
	DB: DBCUST/bodb_Licensee
*/

USE bodb_Licensee

GO

---79 rows affected
UPDATE l
	SET ToDate = '2019-08-31'
FROM LicenseeTransferCode l WITH(NOLOCK)
	INNER JOIN dblic.bodb_licensee.dbo.Licensees li WITH(NOLOCK)
		ON l.LicenseeName = li.LicenseeName
WHERE li.IsActive = 0 AND l.ToDate = '2050-01-31' 

GO