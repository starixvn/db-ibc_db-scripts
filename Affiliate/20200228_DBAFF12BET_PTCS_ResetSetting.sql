USE Affiliate_12BET
GO

/*
	Created: 20200228@Percy
	DB: DBAFF12BET.Affiliate_12BET
	Task: Reset Last Queue Id for PTCS
*/
-- 1 row
UPDATE dbo.APIProductSettings WITH (ROWLOCK)
SET SettingValue = '2446460'
WHERE SettingName = 'LastQueueId'
	AND ProductId = 3