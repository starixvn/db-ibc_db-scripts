USE [Affiliate_12BET]
GO

/*
	Created: 20181001@Percy
	DB: DBAFF12BET-Affiliate_12BET
	Task: Reset testing data
*/

UPDATE dbo.AffGroupHistory WITH (ROWLOCK, UPDLOCK)
SET GroupID = 119 -- Korean Group
WHERE AffId = 927841
	AND MonthDate IN ('2018-08-31','2018-09-30')

UPDATE dbo.AffGroupHistory WITH (ROWLOCK, UPDLOCK)
SET GroupID = 102 -- No Commission Group
WHERE AffId IN (92039950,92040664,92040667)
	AND MonthDate IN ('2018-08-31','2018-09-30')