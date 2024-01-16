/*<info serverAlias="DBODDSFEED-bodb_OddsFeed"></info>*/
/*
	Created: 20231229@Lewis
	DB: DBODDSFEED-bodb_OddsFeed
	Task: XML Odds Feed - Modify condition to retrieve odds and matches for betradar [RedmineID: #198636]
	Description: Update licensee name 'Credit Licensees' ==> 'IBC'
*/
USE [bodb_oddsfeed]
GO

UPDATE S WITH (ROWLOCK, UPDLOCK)
SET SystemName = 'IBC'
FROM dbo.System S
WHERE S.SystemName = 'Credit Licensees'
