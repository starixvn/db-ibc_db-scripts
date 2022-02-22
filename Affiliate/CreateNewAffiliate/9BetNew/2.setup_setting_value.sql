/*<info serverAlias="DBAFF12BET-Affiliate_9Bet" ></info>*/
USE [Affiliate_9Bet]
GO
/*
- Licensee Name : 9Bet
- Logo : link
- Member site domain : www.9Bet.com. Template : www.bcr999.com
- Affiliate website languages: Indonesia, Simplify Chinese (Default), English
- Affiliate admin website languages:  Simplify Chinese (Default), English
- Affiliate's currencies : IDR,USD,UUS
- Affiliate admin's currencies : IDR
- Products : Sportsbook, Number Game, Virtual Sports, Live Casino, RNG Casino
- Player's currencies : IDR,USD,UUS
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
WHERE GroupId NOT IN (102)


DECLARE @ProductID_Sportsbook INT
		,@ProductID_VS INT
		,@ProductID_NG INT
		,@ProductID_RC INT

SELECT @ProductID_Sportsbook = CASE WHEN ProductName = 'Sportsbook' THEN ProductID ELSE @ProductID_Sportsbook END
	,@ProductID_VS = CASE WHEN ProductName = 'Virtual Sports' THEN ProductID ELSE @ProductID_VS END
	,@ProductID_NG = CASE WHEN ProductName = 'Number game' THEN ProductID ELSE @ProductID_NG END
	,@ProductID_RC = CASE WHEN ProductName = 'Rng Casino' THEN ProductID ELSE @ProductID_RC END

FROM Product WHERE ProductName IN ('Sportsbook', 'Virtual Sports', 'Number game', 'Rng Casino')

INSERT INTO GroupSetting (GroupID,ProductID,TierID,MinAmount,MaxAmount,MinQM,MaxQM,Commission)
--Sportsbook
SELECT 101, @ProductID_Sportsbook, 1, 0.00, 99.99, 0, 5, 0
UNION ALL
SELECT 101, @ProductID_Sportsbook, 2, 100.00, 267999.99, 6, 10, 0.2
UNION ALL
SELECT 101, @ProductID_Sportsbook, 3, 268000.00 , 3889999.99, 11, 50, 0.3
UNION ALL
SELECT 101, @ProductID_Sportsbook, 4, 3890000.00, 100000000000000.00, 51, 1000000000, 0.4
--RNG Casino
UNION ALL
SELECT 101, @ProductID_RC, 1, 0.00, 99.99, 0, 5, 0
UNION ALL
SELECT 101, @ProductID_RC, 2, 100.00, 267999.99, 6, 10, 0.2
UNION ALL
SELECT 101, @ProductID_RC, 3, 268000.00 , 3889999.99, 11, 50, 0.3
UNION ALL
SELECT 101, @ProductID_RC, 4, 3890000.00, 100000000000000.00, 51, 1000000000, 0.4
--Number Game	
UNION ALL
SELECT 101, @ProductID_NG, 1, 0.00, 99.99, 0, 5, 0
UNION ALL
SELECT 101, @ProductID_NG, 2, 100.00, 285999.99, 6, 10, 0.2
UNION ALL
SELECT 101, @ProductID_NG, 3, 286000.00, 2859999.99, 11, 25, 0.25
UNION ALL
SELECT 101, @ProductID_NG, 4, 2860000.00 , 7149999.99, 26, 50, 0.3
UNION ALL
SELECT 101, @ProductID_NG, 5, 7150000.00 , 100000000000000, 51, 1000000000, 0.35
--Virtual Sports	
UNION ALL
SELECT 101, @ProductID_VS, 1, 0.00, 99.99, 0, 5, 0
UNION ALL
SELECT 101, @ProductID_VS, 2, 100.00, 267999.99, 6, 10, 0.2
UNION ALL
SELECT 101, @ProductID_VS, 3, 268000.00 , 3889999.99, 11, 50, 0.3
UNION ALL
SELECT 101, @ProductID_VS, 4, 3890000.00, 100000000000000.00, 51, 1000000000, 0.4



DELETE [dbo].[CommGroup]
WHERE GroupId > 102
GO

--replace aff currency
UPDATE CommGroup WITH (ROWLOCK, UPDLOCK)
SET Currency = 47
WHERE groupid = 101

UPDATE CommGroup WITH (ROWLOCK, UPDLOCK)
SET Currency = 0
WHERE groupid = 102


-- Domain Setting
DELETE MemberDomain WHERE domainid > 1
DELETE AffDomain WHERE domainid > 1

UPDATE MemberDomain
SET domainname = 'www.9Bet.com'
WHERE domainid = 1

UPDATE AffDomain
SET domainname = 'go.9Bet.com'
WHERE domainid = 1
GO

DELETE DeductionSetting WITH(ROWLOCK,  UPDLOCK)
WHERE GroupID > 102
GO

--language Setting
;WITH langTmp
AS (
	SELECT 'en-US' AS LanguageID
		,N'English' AS LanguageName
		,'GB' AS CountryID
		,3 AS Creator
		,GETDATE() AS CreatedDate
		,1 AS [Order]
		
	UNION
	SELECT 'id-ID' AS LanguageID
		,N'Indonesia' AS LanguageName
		,'IDN' AS CountryID
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
SET svalue = 'en-US'
WHERE SName = 'AFF_AdminSupportedLanguages'

UPDATE SystemSettings
SET svalue = 'en-US,id-ID'
WHERE SName = 'AFF_MemberSupportedLanguages'

UPDATE SystemSettings
SET svalue = 'en-US,id-ID'
WHERE SName = 'AFF_AffiliateSupportedLanguages'
GO


--system currency setting
UPDATE SystemSettings
SET svalue = 'IDR'
WHERE SName = 'SystemCurrency' --AFF Admin

UPDATE SystemSettings
SET svalue = 'IDR,UUS'
WHERE SName = 'AffiliateCurrencies' --AFF User

UPDATE SystemSettings
SET svalue = 'IDR,UUS'
WHERE SName = 'AFF_PlayerCurrencies' --AFF Player/Member

UPDATE SystemSettings
SET svalue = 'IDR,UUS'
WHERE SName = 'AFF_SupportedCurrencies' --Aff + Aff admin

UPDATE SystemSettings
SET svalue = '9Bet'
WHERE SName IN ('SystemName', 'SystemNameForMail')

UPDATE SystemSettings
SET svalue  = CAST(GETDATE() AS DATE)
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
		,'9betAFFPlayerUUS' AS [svalue]

	UNION
	SELECT 'Meta' AS [type]
		,'AFF_BalPlayerIDR' AS [sname]
		,'9betAFFPlayerIN' AS [svalue]
		
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
		,'AFF_MinPlayerUUS' AS [sname]
		,'100' AS [svalue]
		
	UNION 'Meta' AS [type]
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
		,'AFF_MaximumAdjustmentIDR' AS [sname]
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
WHERE code NOT IN ('IDR', 'UUS')
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
--where LicenseeName = '9Bet'

update SystemSettings
set svalue='63'
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

DECLARE @ProductID_Sportsbook INT
		,@ProductID_VS INT
		,@ProductID_NG INT
		,@ProductID_RC INT

SELECT @ProductID_Sportsbook = CASE WHEN ProductName = 'Sportsbook' THEN ProductID ELSE @ProductID_Sportsbook END
	,@ProductID_VS = CASE WHEN ProductName = 'Virtual Sports' THEN ProductID ELSE @ProductID_VS END
	,@ProductID_NG = CASE WHEN ProductName = 'Number game' THEN ProductID ELSE @ProductID_NG END
	,@ProductID_RC = CASE WHEN ProductName = 'Rng Casino' THEN ProductID ELSE @ProductID_RC END

FROM Product WITH(NOLOCK) WHERE ProductName IN ('Sportsbook', 'Virtual Sports', 'Number game', 'Rng Casino')

DELETE Product WHERE ProductId NOT IN (@ProductID_Sportsbook,@ProductID_VS ,@ProductID_NG ,@ProductID_RC )


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
,'pgmDung'
,'pgmjacob'
,'pgmJenny'
,'pgmJenny1'
,'pgmjoseph'
,'pgmViet'
,'standbyteam'
,'pgmvu'
,'twJackal'
,'twLesley'
,'twHouston'
,'twMartin'
,'standbyteam'
)


delete d
from dbo.AdminUser d
inner join #delAdmin a on d.custid = a.custid


select custid, Username
from dbo.AdminUser (nolock)

drop table #delAdmin