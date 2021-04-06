/*<info serverAlias="DBCUST-bodb_Licensee"></info>*/
/*
	Created: 20210331@Sol
	Task: 152655 - NAP - Change back Setting of boma365, GESAB, WKCUR, WKPHIL, VWIN66 to EUR base currency
	DB: DBCUST/bodb_Licensee
*/

USE bodb_Licensee

GO


-- update licensees with new currency

DECLARE @tblLicensees TABLE(LicenseeName VARCHAR(50), MemberId INT, UserName NVARCHAR(50))

;WITH cteLicensees AS 
(
	SELECT LicenseeName, ci.custid, ci.Username
	FROM 
	(
		VALUES 
			('boma365', 'PHL-LSEE-BOMA365 CNY'),
			('GESAB', 'PHL-LSEE-GESAB CNY'),
			('WKCUR', 'PHL-LSEE-WKCUR CNY'),
			('WKPHIL', 'PHL-LSEE-WKPHIL CNY'),
			('VWIN66', 'PHL-LSEE-VWIN66 CNY')
			
	) AS T(LicenseeName, licenseeCode) 
		INNER JOIN CustDB.dbo.custInfo ci WITH(NOLOCK)
			ON t.licenseeCode = ci.username AND ci.roleid = 1
)
INSERT INTO @tblLicensees(LicenseeName, MemberId, Username)
SELECT lc.LicenseeName, lc.custid, lc.username
FROM cteLicensees lc

-- 5 row affected
DELETE lc 
FROM dbo.LicenseeTransferCode lc
	INNER JOIN @tblLicensees t
		ON lc.LicenseeName = t.LicenseeName AND lc.CustID = t.MemberId
WHERE 
	lc.FromDate = '2021-03-01'
	AND lc.ToDate = '2050-01-31'

GO