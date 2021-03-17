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
		FromDate = '2019-08-01',
		ToDate = '2050-01-31'

GO

-- update licensees with new currency

DECLARE @tblLicenseeWithNewCode TABLE(LicenseeName VARCHAR(50), OldMemberId INT, NewMemberId INT, OldUserName NVARCHAR(50), NewUserName NVARCHAR(50))
DECLARE @tblLicenseeUpdated TABLE(LicenseeName VARCHAR(50), CustID INT, FromDate DATE, ToDate DATE)
DECLARE @tblLicenseeInserted TABLE(LicenseeName VARCHAR(50), CustID INT, FromDate DATE, ToDate DATE)

DECLARE @cutOffToDate DATE = '20210228'

;WITH cteLicenseeWithNewCode AS 
(
	SELECT NewUsername, ciNew.custid NewCustId, LicenseeName
	FROM 
	(
		VALUES 
			('18Luck', 'PHL-LSEE-18LUCK CNY'),
			('24AVIA', 'PHL-LSEE-24AVIA CNY'),
			('365online', 'PHL-LSEE-365ONLINE CNY'),
			('7kplatform', 'PHL-LSEE-7KPLATFORM CNY'),
			('818Bet', 'PHL-LSEE-818BET CNY'),
			('88MACAO', 'PHL-LSEE-88MACAO CNY'),
			('9dianyule', 'PHL-LSEE-9DIANYULE CNY'),
			('ABCASINO', 'PHL-LSEE-ABCASINO CNY'),
			('AG', 'PHL-LSEE-AG CNY'),
			('allwincity', 'PHL-LSEE-ALLWINCITY CNY'),
			('ANGbet', 'PHL-LSEE-ANGBET CNY'),
			('AnvoFH', 'PHL-LSEE-ANVOFH CNY'),
			('Baolong', 'PHL-LSEE-BAOLONG CNY'),
			('BETSUN', 'PHL-LSEE-BETSUN CNY'),
			('BigGaming', 'PHL-LSEE-BIGGAMING CNY'),
			('BOMA365', 'PHL-LSEE-BOMA365 CNY'),
			('Boying', 'PHL-LSEE-BOYING CNY'),
			('Bsdbet', 'PHL-LSEE-BSDBET CNY'),
			('BSSB168', 'PHL-LSEE-BSSB168 CNY'),
			('BWGaming', 'PHL-LSEE-BWGAMING CNY'),
			('Callmeboss', 'PHL-LSEE-CALLMEBOSS CNY'),
			('CGame', 'PHL-LSEE-CGAME CNY'),
			('CGame4', 'PHL-LSEE-CGAME4 CNY'),
			('Champion', 'PHL-LSEE-CHAMPION CNY'),
			('Datang001', 'PHL-LSEE-DATANG001 CNY'),
			('Dawoo', 'PHL-LSEE-DAWOO CNY'),
			('e8casino', 'PHL-LSEE-E8CASINO CNY'),
			('erhaozhan', 'PHL-LSEE-ERHAOZHAN CNY'),
			('FLC', 'PHL-LSEE-FLC CNY'),
			('FYyule', 'PHL-LSEE-FYYULE CNY'),
			('GAMEBee', 'PHL-LSEE-GAMEBEE CNY'),
			('Gampag', 'PHL-LSEE-GAMPAG CNY'),
			('Gaobet', 'PHL-LSEE-GAOBET CNY'),
			('gbkj', 'PHL-LSEE-GBKJ CNY'),
			('GESAB', 'PHL-LSEE-GESAB CNY'),
			('HBO999', 'PHL-LSEE-HBO999 CNY'),
			('HC6YAYOU', 'PHL-LSEE-HC6YAYOU CNY'),
			('Heaven', 'PHL-LSEE-HEAVEN CNY'),
			('HECBET', 'PHL-LSEE-HECBET CNY'),
			('HAPPY1668', 'PHL-LSEE-HEJI CNY'),
			('Hejiyongle', 'PHL-LSEE-HEJIYONGLE CNY'),
			('hjccasino', 'PHL-LSEE-HJCCASINO CNY'),
			('HONBET', 'PHL-LSEE-HONBET CNY'),
			('HONORW', 'PHL-LSEE-HONORW CNY'),
			('HuangMa', 'PHL-LSEE-HUANGMA CNY'),
			('J9YAYOU', 'PHL-LSEE-J9YAYOU CNY'),
			('JIBET', 'PHL-LSEE-JIBET CNY'),
			('Junbet', 'PHL-LSEE-JUNBET CNY'),
			('JZFortune', 'PHL-LSEE-JZFORTUNE CNY'),
			('liv66', 'PHL-LSEE-LIV66 CNY'),
			('liv66SW', 'PHL-LSEE-LIV66SW CNY'),
			('KEENOCEAN', 'PHL-LSEE-LIVV88 CNY'),
			('livv88sw', 'PHL-LSEE-LIVV88SW CNY'),
			('MARS', 'PHL-LSEE-MARS CNY'),
			('Mayayule', 'PHL-LSEE-MAYAYULE CNY'),
			('Mayibet', 'PHL-LSEE-MAYIBET CNY'),
			('NEWHONBET', 'PHL-LSEE-NEWHONBET CNY'),
			('OLE777', 'PHL-LSEE-OLE Group CNY'),
			('Onegaming', 'PHL-LSEE-ONEGAMING CNY'),
			('OPEbet', 'PHL-LSEE-OPEBET CNY'),
			('Pinbo', 'PHL-LSEE-PINBO CNY'),
			('PKbet', 'PHL-LSEE-PKBET CNY'),
			('PKKing', 'PHL-LSEE-PKKING CNY'),
			('Saibo', 'PHL-LSEE-SAIBO CNY'),
			('SDY', 'PHL-LSEE-SDY CNY'),
			('Soon88', 'PHL-LSEE-SOON88 CNY'),
			('Spark', 'PHL-LSEE-SPARK CNY'),
			('TangChao', 'PHL-LSEE-TANGCHAO CNY'),
			('TaoCai', 'PHL-LSEE-TAOCAI CNY'),
			('TCbet', 'PHL-LSEE-TCBET CNY'),
			('TGO', 'PHL-LSEE-TGO CNY'),
			('TSEnter', 'PHL-LSEE-TSENTER CNY'),
			('TYCgame', 'PHL-LSEE-TYCGAME CNY'),
			('US8YAYOU', 'PHL-LSEE-US8YAYOU CNY'),
			('UwinY', 'PHL-LSEE-UWINY CNY'),
			('VCBA', 'PHL-LSEE-VCBA CNY'),
			('VWIN66', 'PHL-LSEE-VWIN66 CNY'),
			('WBS', 'PHL-LSEE-WBS CNY'),
			('win365', 'PHL-LSEE-WIN365 CNY'),
			('WKCUR', 'PHL-LSEE-WKCUR CNY'),
			('WKPHIL', 'PHL-LSEE-WKPHIL CNY'),
			('wmcasino', 'PHL-LSEE-WMCASINO CNY'),
			('Xinbo', 'PHL-LSEE-XINBO CNY'),
			('Yibo', 'PHL-LSEE-YIBO CNY'),
			('YTX', 'PHL-LSEE-YTX CNY'),
			('Yunji', 'PHL-LSEE-YUNJI CNY'),
			('OneSports', 'PHL-LSEE-ONESPORTS CNY'),
			('OSUSDT', 'PHL-LSEE-OSUSDT CNY'),
			('HAIFA', 'phl-lsee-bbin cny'),
			('BBIN2', 'PHL-LSEE-BBIN2 CNY'),
			('BBIN3', 'PHL-LSEE-BBIN3 CNY'),
			('Bobbet', 'PHL-LSEE-BOBBET CNY'),
			('Tianbo', 'PHL-LSEE-TIANBO CNY')
	) AS T(LicenseeName, NewUsername) 
		INNER JOIN CustDB.dbo.custInfo ciNew WITH(NOLOCK)
			ON t.NewUsername = ciNew.username AND ciNew.roleid = 1
)
INSERT INTO @tblLicenseeWithNewCode(LicenseeName, OldMemberId, NewMemberId, OldUserName, NewUsername)
SELECT lc.LicenseeName, ci.custid, t.NewCustId, ci.username, t.NewUsername
FROM 
	dbo.LicenseeTransferCode lc WITH(NOLOCK)
		INNER JOIN CustDB.dbo.custInfo ci WITH(NOLOCK)
			ON lc.CustID = ci.custid AND ci.roleid = 1
		INNER JOIN cteLicenseeWithNewCode t
			ON lc.LicenseeName = t.LicenseeName
WHERE t.NewCustId <> lc.CustID

---update current licensee of old licensee code to inactive
UPDATE l
	SET 
		ToDate = @cutOffToDate
OUTPUT INSERTED.LicenseeName, INSERTED.CustID, INSERTED.FromDate, INSERTED.ToDate INTO @tblLicenseeUpdated
FROM dbo.LicenseeTransferCode l
	INNER JOIN @tblLicenseeWithNewCode t
		ON l.LicenseeName = t.LicenseeName AND l.CustID = t.OldMemberId

---insert new currency with new time range
INSERT INTO dbo.LicenseeTransferCode(LicenseeName,CustID,StatusId, FromDate, ToDate)
OUTPUT INSERTED.LicenseeName, INSERTED.CustID, INSERTED.FromDate, INSERTED.ToDate INTO	@tblLicenseeInserted
SELECT t.LicenseeName, t.NewMemberId, 0, DATEADD(Day, 1, @cutOffToDate), '20500131'
FROM @tblLicenseeWithNewCode t

---review data
SELECT *
FROM dbo.LicenseeTransferCode l WITH(NOLOCK)
	LEFT JOIN @tblLicenseeInserted i
		ON l.LicenseeName = i.LicenseeName AND l.CustID = i.CustID
	LEFT JOIN @tblLicenseeUpdated u
		ON l.LicenseeName = u.LicenseeName AND l.CustID = u.CustID

GO