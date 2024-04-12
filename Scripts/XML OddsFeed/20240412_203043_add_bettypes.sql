/*<info serverAlias="DBODDSFEED-bodb_OddsFeed"></info>*/
/*
Create: 20240315@Lewis
Task: Add bettypes crickets for xml oddsfeed  [RedmineID: #203043]
DB: DBODDSFEED-bodb_OddsFeed

Description:
*/
USE [bodb_oddsfeed]

UPDATE dbo.SystemSetting WITH (ROWLOCK, UPDLOCK)
SET SValue = Svalue + ',9401,9404,9405,9406,9407,9408,9409,9410,9411,9412,9413,9414,9415,9607,9608,9609,9610,9611,9612,9539'
WHERE Type = 'BetTypes' AND SName = 'SupportedBettypes'



