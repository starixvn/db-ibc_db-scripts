USE Affiliate_Bolanation
GO

TRUNCATE TABLE UserLog_IISErr

TRUNCATE TABLE TaskLog

TRUNCATE TABLE On_User

TRUNCATE TABLE News

TRUNCATE TABLE AffTrans

TRUNCATE TABLE AffPayout

TRUNCATE TABLE AffDailySummary

TRUNCATE TABLE AffCommission

TRUNCATE TABLE Branch

TRUNCATE TABLE BankTrans

TRUNCATE TABLE AdminBranch

TRUNCATE TABLE ErrorLog

TRUNCATE TABLE EmailHistory

TRUNCATE TABLE MemberDailyTransaction

TRUNCATE TABLE UserLog_RunSP

TRUNCATE TABLE Banners
GO

-- delete redundant data
-- just keep GroupId IN (101,102) - Normal(Default) & NoComission commission group
DELETE RefResources
WHERE RefID = 'News';

DELETE bannertypes
WHERE Type = 'Size';

-- Reset Commission Group Setting
DELETE [dbo].[CommGroup]
WHERE GroupId > 102

DELETE GroupSetting
WHERE GroupId > 102

TRUNCATE TABLE GroupSettingHistory

TRUNCATE TABLE DeductionSetting

TRUNCATE TABLE DeductionSettingHistory

TRUNCATE TABLE AffGroupHistory


GO

--correct data
--reset language
TRUNCATE TABLE dbo.AffInfo

TRUNCATE TABLE dbo.AffDetail

TRUNCATE TABLE AffGroupHistory

TRUNCATE TABLE dbo.MemberInfo

TRUNCATE TABLE MemberDaily

TRUNCATE TABLE MemberDailyRemoved

TRUNCATE TABLE AffDaily

--Update [AffDailySummary] table
TRUNCATE TABLE [dbo].[AffDailySummary]

-- Domain Setting
UPDATE MemberDomain
SET domainname = 'www.bolanation.net'
WHERE domainid = 1

UPDATE AffDomain
SET domainname = 'go.bolanation.com'
WHERE domainid = 1
GO

--language Setting
;WITH langTmp
AS (
	SELECT 'id-ID' AS LanguageID
		,N'Indonesian' AS LanguageName
		,'TH' AS CountryID
		,3 AS Creator
		,GETDATE() AS CreatedDate
		,10 AS [Order]
	
	UNION ALL
	SELECT 'en-US' AS LanguageID
		,N'English' AS LanguageName
		,'AF' AS CountryID
		,3 AS Creator
		,GETDATE() AS CreatedDate
		,0 AS [Order]

	UNION ALL
	SELECT 'zh-CN' AS LanguageID
		,N'中文简体' AS LanguageName
		,'CN' AS CountryID
		,3 AS Creator
		,GETDATE() AS CreatedDate
		,10 AS [Order]

	UNION ALL
	SELECT 'zh-TW' AS LanguageID
		,N'中文繁体' AS LanguageName
		,'TW' AS CountryID
		,3 AS Creator
		,GETDATE() AS CreatedDate
		,10 AS [Order]
	)
MERGE INTO [Language] t
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
SET svalue = 'en-US,id-ID,vi-VN,zh-CN,zh-TW'
WHERE SName = 'AFF_MemberSupportedLanguages'

UPDATE SystemSettings
SET svalue = 'en-US,id-ID,vi-VN,zh-CN,zh-TW'
WHERE SName = 'AFF_AffiliateSupportedLanguages'
GO

--system currency setting
UPDATE SystemSettings
SET svalue = 'IDR'
WHERE SName = 'SystemCurrency' --AFF Admin

UPDATE SystemSettings
SET svalue = 'IDR'
WHERE SName = 'AffiliateCurrencies' --AFF User

UPDATE SystemSettings
SET svalue = 'IDR,UUS'
WHERE SName = 'AFF_PlayerCurrencies' --AFF Player/Member

UPDATE SystemSettings
SET svalue = 'IDR'
WHERE SName = 'AFF_SupportedCurrencies' --Aff User + Aff admin

UPDATE SystemSettings
SET svalue = 'Bolanation'
WHERE SName IN ('SystemName', 'SystemNameForMail')

UPDATE SystemSettings
SET svalue = CAST(GETDATE() AS DATE)
WHERE SName = 'SystemStartDate'
GO

-- dummy acc bal (player currency)
WITH dummyBal
AS (
	SELECT 'Meta' AS [type]
		,'AFF_BalPlayerIN' AS [sname]
		,'BolanationAFFPlayerIN' AS [svalue]
	
	UNION ALL
	SELECT 'Meta' AS [type]
		,'AFF_BalPlayerUUS' AS [sname]
		,'BolanationAFFPlayerUUS' AS [svalue]
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
WITH minPayout
AS (
	SELECT 'Meta' AS [type]
		,'AFF_BalPlayerIN' AS [sname]
		,'100' AS [svalue]

	UNION ALL
	SELECT 'Meta' AS [type]
		,'AFF_BalPlayerUUS' AS [sname]
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
WITH maxAdjustment
AS (
	SELECT 'Meta' AS [type]
		,'AFF_MaximumAdjustmentIN' AS [sname]
		,'100000' AS [svalue]

	UNION ALL
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
WHERE code NOT IN ('IDR', 'UUS')
GO

DELETE ExchangeDaily
WHERE ExchangeID NOT IN (
		SELECT ExchangeID
		FROM Exchange(NOLOCK)
		)
GO

--update LicenseeID
/*
--get in bodb_Licensee to @LicenseeID
select * from DBLIC.bodb_Licensee.dbo.Licensees with(nolock)
where LicenseeName = 'Aragon88'

update SystemSettings
set svalue='5'
where SName in ('LicenseeID')
*/
