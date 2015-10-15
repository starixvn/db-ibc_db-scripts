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

UPDATE AffInfo
SET GroupId = 102 --NoCommission

TRUNCATE TABLE AffTrans

TRUNCATE TABLE AffPayout

TRUNCATE TABLE AffDaily

TRUNCATE TABLE AffDailySummary

TRUNCATE TABLE AffCommission

TRUNCATE TABLE MemberDaily

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
SET Currency = 47
WHERE groupid = 101

UPDATE CommGroup WITH (ROWLOCK, UPDLOCK)
SET Currency = 0
WHERE groupid = 102

/*
update dbo.AdminUser
set Username = 'pgmVinh'
where Username = 'pgmLong'

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
,'pgmKahn'
,'pgmVinh'
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
*/