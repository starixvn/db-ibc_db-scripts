/*<info serverAlias="DBAFF12BET-Affiliate_9Bet" ></info>*/
/*
	Created: 20220228@Malcolm
	DB: DBAFF12BET.Affiliate_9Bet
	Task: truncate data
*/
UPDATE GroupSetting WITH(ROWLOCK)
	SET Commission = 0
WHERE GroupID = 102