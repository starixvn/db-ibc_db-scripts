/*<info serverAlias="DBAFF12BET-Affiliate_12BET"></info>*/

/*
	Created: 20220208@Malcolm
	DB: DBAFF12BET-Affiliate_12BET
	Task: Update LastQueueId

*/
UPDATE APIProductSettings WITH(ROWLOCK)
	SET SettingValue = '7648357'
WHERE ProductId = 3 AND SettingName = 'LastQueueId' 