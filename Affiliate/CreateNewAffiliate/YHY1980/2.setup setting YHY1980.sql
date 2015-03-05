USE [Affiliate_YHY1980]
GO
/*
- Licensee Name : YHY1980
- Logo : link
- Member site domain : www.yhy1980.com. Template : www.bcr999.com
- Affiliate website languages: Simplify Chinese (Default), English
- Affiliate admin website languages:  Simplify Chinese (Default), English
- Affiliate's currencies : CNY
- Affiliate admin's currencies : CNY
- Products : Sportsbook, Number Game, Virtual Sports, Live Casino, RNG Casino
- Player's currencies : RMB, UUS.
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
SET Currency = 22
WHERE groupid = 101

UPDATE CommGroup WITH (ROWLOCK, UPDLOCK)
SET Currency = 0
WHERE groupid = 102

-- Domain Setting
UPDATE MemberDomain
SET domainname = 'www.yhy1980.com'
WHERE domainid = 1

UPDATE AffDomain
SET domainname = 'go.yhy1980.com'
WHERE domainid = 1
GO

--language Setting
;WITH langTmp
AS (
	SELECT 'zh-CN' AS LanguageID
		,N'中文简体' AS LanguageName
		,'CN' AS CountryID
		,3 AS Creator
		,GETDATE() AS CreatedDate
		,1 AS [Order]

	UNION
	SELECT 'en-US' AS LanguageID
		,N'English' AS LanguageName
		,'AF' AS CountryID
		,3 AS Creator
		,GETDATE() AS CreatedDate
		,2 AS [Order]
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
SET svalue = 'zh-CN,en-US'
WHERE SName = 'AFF_AdminSupportedLanguages'

UPDATE SystemSettings
SET svalue = 'zh-CN,en-US'
WHERE SName = 'AFF_MemberSupportedLanguages'

UPDATE SystemSettings
SET svalue = 'zh-CN,en-US'
WHERE SName = 'AFF_AffiliateSupportedLanguages'
GO

--reset language
DECLARE @AFF_AffiliateSupportedLanguages NVARCHAR(255)

SELECT @AFF_AffiliateSupportedLanguages = svalue
FROM SystemSettings
WHERE SName = 'AFF_AffiliateSupportedLanguages'

UPDATE upd
SET PreferredLanguage = 'zh-CN'
FROM dbo.AffDetail upd WITH (ROWLOCK, UPDLOCK)
WHERE [PreferredLanguage] NOT IN (
		SELECT val
		FROM dbo.strSplit(@AFF_AffiliateSupportedLanguages, ',')
	)
GO

--system currency setting
UPDATE SystemSettings
SET svalue = 'CNY'
WHERE SName = 'SystemCurrency' --AFF Admin

UPDATE SystemSettings
SET svalue = 'CNY'
WHERE SName = 'AffiliateCurrencies' --AFF User

UPDATE SystemSettings
SET svalue = 'CNY,UUS'
WHERE SName = 'AFF_PlayerCurrencies' --AFF Player/Member

UPDATE SystemSettings
SET svalue = 'CNY,UUS'
WHERE SName = 'AFF_SupportedCurrencies' --Aff + Aff admin

UPDATE SystemSettings
SET svalue = 'YHY1980'
WHERE SName IN ('SystemName', 'SystemNameForMail')

UPDATE SystemSettings
SET svalue = CAST(GETDATE() AS DATE)
WHERE SName = 'SystemStartDate'
GO

select *
from SystemSettings
WHERE SName = 'SystemStartDate'
GO

-- dummy acc bal (player currency)
;WITH dummyBal
AS (
	SELECT 'Meta' AS [type]
		,'AFF_BalPlayerUUS' AS [sname]
		,'YHY1980AFFPlayerUUS' AS [svalue]

	UNION
	SELECT 'Meta' AS [type]
		,'AFF_BalPlayerCNY' AS [sname]
		,'YHY1980AFFPlayerRMB' AS [svalue]
		
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
WHERE code NOT IN ('CNY', 'UUS')
GO

DELETE ExchangeDaily
WHERE ExchangeID NOT IN (
		SELECT ExchangeID
		FROM Exchange(NOLOCK)
		)
GO

--update LicenseeID
--get in bodb_Licensee to @LicenseeID
--select * from Licensees (nolock)
--where LicenseeName = 'YHY1980'

update SystemSettings
set svalue='0'
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
,'pgmKahn'
,'pgmLong'
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