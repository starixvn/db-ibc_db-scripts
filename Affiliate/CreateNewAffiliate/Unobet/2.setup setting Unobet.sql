USE [Affiliate_Unobet]
GO
/*
- Licensee Name : Unobet.
- Logo : see attached file.
- Member site domain : www.unobet.com
- Template : wx7777.com
- Affiliate website languages: Bahasa Indonesia , Chinese Simplified, Chinese Traditional, English and Thai
- Affiliate admin website languages:  English
- Affiliate's currencies code: MYR, USD, THB, CNY, EUR and IDR
- Affiliate admin's currencies : USD.
- Products : Sportsbook, Virtual Sports, Number game, Live casino, and RNG casino.
- Player's currencies : MYR, USD, THB, CNY, EUR, IDR, UUS.
*/



TRUNCATE TABLE UserLog_IISErr

TRUNCATE TABLE TaskLog

TRUNCATE TABLE On_User

TRUNCATE TABLE News



TRUNCATE TABLE AffInfo

TRUNCATE TABLE AffDetail

TRUNCATE TABLE AffTrans

TRUNCATE TABLE AffPayout

TRUNCATE TABLE AffDaily

TRUNCATE TABLE AffDailySummary

TRUNCATE TABLE AffCommission

TRUNCATE TABLE MemberInfo

TRUNCATE TABLE MemberDaily

TRUNCATE TABLE MemberRemoval

TRUNCATE TABLE MemberRemoval

TRUNCATE TABLE MemberDailyRemoved

TRUNCATE TABLE Branch

TRUNCATE TABLE BankTrans

TRUNCATE TABLE AdminNotes

TRUNCATE TABLE AdminFavorite

TRUNCATE TABLE AdminBranch

TRUNCATE TABLE ErrorLog

TRUNCATE TABLE EmailHistory

TRUNCATE TABLE MemberDailyTransaction

TRUNCATE TABLE UserLog_RunSP

TRUNCATE TABLE Banners

TRUNCATE TABLE GroupSettingHistory

TRUNCATE TABLE CommGroupHistory

TRUNCATE TABLE DeductionSettingHistory

TRUNCATE TABLE AffGroupHistory
GO

-- delete redundant data
-- just keep GroupId IN (101,102) - Normal(Default) & NoComission commission group
DELETE RefResources
WHERE RefID = 'News';

DELETE bannertypes
WHERE Type = 'Size';

-- Reset Commission Group Setting
DELETE GroupSetting
WHERE GroupId > 102

DELETE [dbo].[CommGroup]
WHERE GroupId > 102
GO

--replace aff currency
UPDATE CommGroup WITH (ROWLOCK, UPDLOCK)
SET Currency = 109 --USD
WHERE groupid = 101

UPDATE CommGroup WITH (ROWLOCK, UPDLOCK)
SET Currency = 0
WHERE groupid = 102

-- Domain Setting
UPDATE MemberDomain
SET domainname = 'www.unobet.com'
WHERE domainid = 1

UPDATE AffDomain
SET domainname = 'go.unobet.com'
WHERE domainid = 1
GO

--language Setting
;WITH langTmp
AS (
	SELECT 'id-ID' AS LanguageID
		,N'Indonesia' AS LanguageName
		,'ID' AS CountryID
		,3 AS Creator
		,GETDATE() AS CreatedDate
		,1 AS [Order]
	UNION
	SELECT 'zh-CN' AS LanguageID
		,N'中文简体' AS LanguageName
		,'CN' AS CountryID
		,3 AS Creator
		,GETDATE() AS CreatedDate
		,2 AS [Order]

	UNION
	SELECT 'zh-TW' AS LanguageID
		,N'中文繁体' AS LanguageName
		,'TW' AS CountryID
		,3 AS Creator
		,GETDATE() AS CreatedDate
		,3 AS [Order]

	UNION
	SELECT 'en-US' AS LanguageID
		,N'English' AS LanguageName
		,'-' AS CountryID
		,3 AS Creator
		,GETDATE() AS CreatedDate
		,4 AS [Order]
	UNION
	SELECT 'th-TH' AS LanguageID
		,N'ภาษาไทย' AS LanguageName
		,'TH' AS CountryID
		,3 AS Creator
		,GETDATE() AS CreatedDate
		,5 AS [Order]
	)
MERGE INTO dbo.[Language] t
USING langTmp s ON t.LanguageID = s.LanguageID
WHEN MATCHED THEN
	UPDATE 
	SET [Order] = s.[Order]
WHEN NOT MATCHED BY target THEN
		INSERT (
			[LanguageID]
			,[LanguageName]
			,[CountryID]
			,[Creator]
			,[CreatedDate]
			,[Order]
			)
		VALUES (
			s.[LanguageID]
			,s.[LanguageName]
			,s.[CountryID]
			,s.[Creator]
			,s.[CreatedDate]
			,s.[Order]
			)
WHEN NOT MATCHED BY source THEN
		DELETE;
GO

UPDATE SystemSettings
SET svalue = 'en-US'
WHERE SName = 'AFF_AdminSupportedLanguages'

UPDATE SystemSettings
SET svalue = 'id-ID,zh-CN,zh-TW,en-US,th-TH'
WHERE SName = 'AFF_MemberSupportedLanguages'

UPDATE SystemSettings
SET svalue = 'id-ID,zh-CN,zh-TW,en-US,th-TH'
WHERE SName = 'AFF_AffiliateSupportedLanguages'
GO

--reset language
DECLARE @AFF_AffiliateSupportedLanguages NVARCHAR(255)

SELECT @AFF_AffiliateSupportedLanguages = svalue
FROM SystemSettings
WHERE SName = 'AFF_AffiliateSupportedLanguages'

UPDATE upd
SET PreferredLanguage = 'en-US'
FROM dbo.AffDetail upd WITH (ROWLOCK, UPDLOCK)
WHERE [PreferredLanguage] NOT IN (
		SELECT val
		FROM dbo.strSplit(@AFF_AffiliateSupportedLanguages, ',')
	)
GO

--system currency setting
UPDATE SystemSettings
SET svalue = 'USD'
WHERE SName = 'SystemCurrency' --AFF Admin

UPDATE SystemSettings
SET svalue = 'MYR,USD,THB,CNY,EUR,IDR'
WHERE SName = 'AffiliateCurrencies' --AFF User

UPDATE SystemSettings
SET svalue = 'MYR,USD,THB,CNY,EUR,IDR,UUS'
WHERE SName = 'AFF_PlayerCurrencies' --AFF Player/Member

UPDATE SystemSettings
SET svalue = 'MYR,USD,THB,CNY,EUR,IDR,UUS'
WHERE SName = 'AFF_SupportedCurrencies' --Aff + Aff admin + Player

UPDATE SystemSettings
SET svalue = 'Unobet'
WHERE SName IN ('SystemName', 'SystemNameForMail')

UPDATE SystemSettings
SET svalue = CAST(GETDATE() AS DATE)
WHERE SName = 'SystemStartDate'
GO

select *
from SystemSettings
WHERE SName = 'SystemStartDate'
GO

-- clean up domain info
DELETE d
FROM dbo.MemberDomain d
WHERE DomainId <> 1

DELETE d
FROM dbo.AffDomain d
WHERE DomainId <> 1


DELETE d
FROM dbo.AffDomain d
WHERE AffDomainId <> 1
	OR MemberDomainId <> 1
	
-- dummy acc bal (player currency)
;WITH dummyBal
AS (
	SELECT 'Meta' AS [type]
		,'AFF_BalPlayerUUS' AS [sname]
		,'UnobetAFFPlayerUUS' AS [svalue]

	UNION
	SELECT 'Meta' AS [type]
		,'AFF_BalPlayerCNY' AS [sname]
		,'UnobetAFFPlayerRMB' AS [svalue]
	UNION
	SELECT 'Meta' AS [type]
		,'AFF_BalPlayerMYR' AS [sname]
		,'UnobetAFFPlayerRM' AS [svalue]

	UNION
	SELECT 'Meta' AS [type]
		,'AFF_BalPlayerUSD' AS [sname]
		,'UnobetAFFPlayerUS$' AS [svalue]
	UNION
	SELECT 'Meta' AS [type]
		,'AFF_BalPlayerTHB' AS [sname]
		,'UnobetAFFPlayerTB' AS [svalue]

	UNION
	SELECT 'Meta' AS [type]
		,'AFF_BalPlayerEUR' AS [sname]
		,'UnobetAFFPlayerEURO' AS [svalue]
	UNION
	SELECT 'Meta' AS [type]
		,'AFF_BalPlayerIDR' AS [sname]
		,'UnobetAFFPlayerIN' AS [svalue]

	)
MERGE INTO dbo.SystemSettings t
USING dummyBal s ON t.[type] = s.[type]
		AND t.sname = s.sname
WHEN MATCHED THEN
		UPDATE
		SET svalue = s.svalue
WHEN NOT MATCHED THEN
		INSERT (
			[type]
			,[sname]
			,[svalue]
			)
		VALUES (
			s.[type]
			,s.[sname]
			,s.[svalue]
			);
GO

-- system setting - min payout 
;WITH minPayout
AS (
	
	SELECT 'Meta' AS [type]
		,'AFF_MinPlayerCNY' AS [sname]
		,'100' AS [svalue]
	
	UNION
	SELECT 'Meta' AS [type]
		,'AFF_MinPlayerUUS' AS [sname]
		,'100' AS [svalue]
	UNION
	SELECT 'Meta' AS [type]
		,'AFF_MinPlayerMYR' AS [sname]
		,'100' AS [svalue]
	
	UNION
	SELECT 'Meta' AS [type]
		,'AFF_MinPlayerUSD' AS [sname]
		,'100' AS [svalue]
	UNION
	SELECT 'Meta' AS [type]
		,'AFF_MinPlayerTHB' AS [sname]
		,'100' AS [svalue]
	
	UNION
	SELECT 'Meta' AS [type]
		,'AFF_MinPlayerEUR' AS [sname]
		,'100' AS [svalue]
	UNION
	SELECT 'Meta' AS [type]
		,'AFF_MinPlayerIDR' AS [sname]
		,'100' AS [svalue]
)
MERGE INTO dbo.SystemSettings t
USING minPayout s ON t.[type] = s.[type]
		AND t.sname = s.sname
WHEN MATCHED THEN
		UPDATE
		SET svalue = s.svalue
WHEN NOT MATCHED THEN
		INSERT (
			[type]
			,[sname]
			,[svalue]
			)
		VALUES (
			s.[type]
			,s.[sname]
			,s.[svalue]
			);
GO

-- system setting - max adjust
;WITH maxAdjustment
AS (
	SELECT 'Meta' AS [type]
		,'AFF_MaximumAdjustmentCNY' AS [sname]
		,'100000' AS [svalue]
	
	UNION
	SELECT 'Meta' AS [type]
		,'AFF_MaximumAdjustmentUUS' AS [sname]
		,'100000' AS [svalue]
	UNION
	SELECT 'Meta' AS [type]
		,'AFF_MaximumAdjustmentMYR' AS [sname]
		,'100000' AS [svalue]
	
	UNION
	SELECT 'Meta' AS [type]
		,'AFF_MaximumAdjustmentUSD' AS [sname]
		,'100000' AS [svalue]
	UNION
	SELECT 'Meta' AS [type]
		,'AFF_MaximumAdjustmentTHB' AS [sname]
		,'100000' AS [svalue]
	
	UNION
	SELECT 'Meta' AS [type]
		,'AFF_MaximumAdjustmentEUR' AS [sname]
		,'100000' AS [svalue]
	UNION
	SELECT 'Meta' AS [type]
		,'AFF_MaximumAdjustmentIDR' AS [sname]
		,'100000' AS [svalue]
	
)
MERGE INTO dbo.SystemSettings t
USING maxAdjustment s ON t.[type] = s.[type]
		AND t.sname = s.sname
WHEN MATCHED THEN
		UPDATE
		SET svalue = s.svalue
WHEN NOT MATCHED THEN
		INSERT (
			[type]
			,[sname]
			,[svalue]
			)
		VALUES (
			s.[type]
			,s.[sname]
			,s.[svalue]
			);
GO

-- remove exchange
DELETE Exchange
WHERE code NOT IN ('CNY', 'UUS', 'MYR', 'USD', 'THB', 'EUR', 'IDR')
GO

DELETE ExchangeDaily
WHERE ExchangeID NOT IN (
		SELECT ExchangeID
		FROM Exchange(NOLOCK)
		)
GO

--update LicenseeID
--get in bodb_Licensee to @LicenseeID
declare @LicenseeID INT 
select @LicenseeID = LicenseeID from DBEXT.bodb_Licensee.dbo.Licensees with(nolock)
where LicenseeName = 'Unobet'

update SystemSettings
set svalue=@LicenseeID
	,Description = 'LicenseeID Unobet from DBEXT.bodb_Licensee.dbo.Licensees'
where SName in ('LicenseeID')
GO

select * from SystemSettings
where SName in ('LicenseeID')
GO

update SystemSettings
set svalue='0'
where SName in ('AFF_ForceMinNegativeCommission')
GO

--product setting
UPDATE d
SET [CreatedDate] 		= GETDATE()
	,[EffectiveDate] 	= GETDATE()
FROM [dbo].[Product] d
GO

select * FROM [dbo].[Product] d
go

SELECT *
FROM SystemSettings


select *
from commgroup
go


select custid, Username
into #delAdmin
from dbo.AdminUser (nolock)
where Username not in ('Admin'
,'dbaThien'
,'pgmAnn'
,'pgmBobby'
,'pgmBrian'
,'pgmDan'
,'pgmDung'
,'pgmjacob'
,'pgmJenny'
,'pgmJenny1'
--,'pgmKahn'
,'pgmJohnny'
,'pgmViet'
,'standbyteam'
,'pgmvu'
,'twJackal'
,'twLesley'
,'twMartin')


delete d
from dbo.AdminUser d
inner join #delAdmin a on d.custid = a.custid


select custid, Username
from dbo.AdminUser (nolock)

drop table #delAdmin