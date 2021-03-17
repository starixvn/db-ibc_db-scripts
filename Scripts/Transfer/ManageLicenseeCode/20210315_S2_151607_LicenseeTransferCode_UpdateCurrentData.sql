/*<info serverAlias="DBCUST-bodb_Licensee"></info>*/
/*
	Created: 20210315@Sol
	Task: 151607 - NAP - Enhance Manage Licensee Code to support change base currency of licensees
	DB: DBCUST/bodb_Licensee
*/

USE bodb_Licensee

GO


UPDATE dbo.LicenseeTransferCode
	SET 
		FromDate = '2019-07-01',
		ToDate = '2050-01-01'

GO

-- update licensees with new currency

DECLARE @tblLicenseeWithNewCode TABLE(LicenseeName VARCHAR(50), OldMemberId INT, NewMemberId INT)
DECLARE @cutOffToDate DATE = '20210331'

;WITH cteLicenseeWithNewCode AS 
(
	SELECT OldUsername, ci.custid OldCustId, NewUsername, ciNew.custid NewCustId, LicenseeName
	FROM 
	(
		VALUES 
			('PHL-LSEE-M88 EUR', 'PHL-LSEE-M88 CNY', 'Mansion88')
	) AS T(OldUsername, NewUsername, LicenseeName) 
		INNER JOIN CustDB.dbo.custInfo ci WITH(NOLOCK)
			ON t.OldUsername = ci.username AND ci.roleid = 1
		INNER JOIN CustDB.dbo.custInfo ciNew WITH(NOLOCK)
			ON t.NewUsername = ciNew.username AND ciNew.roleid = 1
)
INSERT INTO @tblLicenseeWithNewCode(LicenseeName, OldMemberId, NewMemberId)
SELECT lc.LicenseeName, t.OldCustId, t.NewCustId
FROM 
	dbo.LicenseeTransferCode lc WITH(NOLOCK)
		INNER JOIN cteLicenseeWithNewCode t
			ON lc.LicenseeName = t.LicenseeName AND lc.CustID = t.OldCustId

---update current licensee of old licensee code to inactive
UPDATE l
	SET 
		ToDate = @cutOffToDate
FROM dbo.LicenseeTransferCode l
	INNER JOIN @tblLicenseeWithNewCode t
		ON l.LicenseeName = t.LicenseeName AND l.CustID = t.OldMemberId

---insert new currency with new time range
INSERT INTO dbo.LicenseeTransferCode(LicenseeName,CustID,StatusId, FromDate, ToDate)
SELECT t.LicenseeName, t.NewMemberId, 0, DATEADD(Day, 1, @cutOffToDate), '20500130'
FROM @tblLicenseeWithNewCode t

GO