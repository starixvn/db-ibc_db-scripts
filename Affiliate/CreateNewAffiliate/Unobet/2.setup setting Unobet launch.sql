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

DELETE from DeductionSetting
where GroupID not in (select GroupID from CommGroup)

GO

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
FROM dbo.AffDomainControl d
WHERE AffDomainId <> 1
	OR MemberDomainId <> 1
	
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
--,'pgmDan'
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