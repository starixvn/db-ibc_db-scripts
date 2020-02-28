USE Affiliate_12BET
GO

/*
	Created: 20200228@Percy
	DB: DBAFF12BET.Affiliate_12BET
	Task: Re-run job for Playtech Casino from Feb 2020
*/

-- 657 rows
UPDATE dbo.APIProduct_ImportQueue WITH (ROWLOCK)
SET FinishedTime = NULL
WHERE ProductId = 3
	AND WinlostDate >= '2020-02-01'