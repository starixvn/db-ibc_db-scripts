USE [bodb_oddsfeed]
GO

/*
	Created: 20190705@Percy
	DB: DBODDSFEED.bodb_oddsfeed
	Task: Add new bet type of Cricket: 501
*/

UPDATE dbo.SystemSetting WITH (ROWLOCK, UPDLOCK)
SET SValue = SValue + ',501'
WHERE Type = 'BetTypes' AND SName = 'SupportedBettypes'
GO