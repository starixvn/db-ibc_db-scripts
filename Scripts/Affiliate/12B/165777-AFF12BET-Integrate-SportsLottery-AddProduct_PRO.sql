/*<info serverAlias="DBAFF12BET-Affiliate_12BET"></info>*/
/*
	Created: 20211207@Percy
	DB: DBAFF12BET-Affiliate_12BET
	Task: Add Sports Lottery product
*/

UPDATE dbo.Products WITH (ROWLOCK)
SET IsTest = 0
WHERE ProductId = 33