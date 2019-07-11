USE [bodb_oddsfeed]
GO

/*
	Created: 20190705@Percy
	DB: DBODDSFEED.bodb_oddsfeed
	Task: Add new bettypes
		1. Cricket: 501
		2. PHAIO4
*/

UPDATE dbo.SystemSetting WITH (ROWLOCK, UPDLOCK)
SET SValue = SValue + ',501'
WHERE Type = 'BetTypes' AND SName = 'SupportedBettypes'
GO