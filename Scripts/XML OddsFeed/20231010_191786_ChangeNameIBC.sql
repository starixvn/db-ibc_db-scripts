/*<info serverAlias="DBODDSFEED-bodb_OddsFeed"></info>*/

/*
	Created: 20231010@Lewis
	DB: DBODDSFEED-bodb_OddsFeed
	Task: Mapping Licensee - Affiliate [RedmineID: #191786]
	Description: Update licensee name 'IBC' ==> 'Credit Licensees'
*/
USE [bodb_oddsfeed]
GO

UPDATE S WITH (ROWLOCK, UPDLOCK)
SET S.SystemName = 'Credit Licensees'
FROM dbo.System S
WHERE SystemName = 'IBC'
