/*<info serverAlias="DBAFFN88-Affiliate_N88"></info>*/
/*
	Created: 20220127@Percy
	DB: DBAFFN88-Affiliate_N88
	Task: Move all affiliates from commission group AF-FX-5-55 (GroupId = 32) to AF-FX-5-45 (GroupId = 24)
*/

USE Affiliate_N88
GO
--SELECT * FROM dbo.CommGroup WITH (NOLOCK) WHERE GroupId IN (24, 32)


-- 309 rows
UPDATE dbo.AffInfo WITH (ROWLOCK)
SET GroupId = 24
WHERE GroupId = 32

-- 309 rows
UPDATE dbo.AffGroupHistory WITH (ROWLOCK)
SET GroupId = 24
WHERE GroupId = 32 AND MonthDate = '2022-01-31'