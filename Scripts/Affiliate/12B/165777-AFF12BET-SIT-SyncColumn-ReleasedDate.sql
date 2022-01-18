/*<info serverAlias="DBAFF12BET-Affiliate_12BET"></info>*/
/*
	Created: 20211207@Percy
	DB: DBAFF12BET-Affiliate_12BET
	Task: SIT - Add ReleasedDate column - Sync from PRO
*/
ALTER TABLE dbo.Products
	ADD ReleasedDate SMALLDATETIME
GO