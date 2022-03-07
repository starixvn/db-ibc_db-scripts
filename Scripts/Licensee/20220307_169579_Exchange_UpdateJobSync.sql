/*<info serverAlias="DBPTCS-bodb_PlaytechCS"></info>*/
/*
	Created: 20220307@Percy
	DB: DBPTCS-bodb_PlaytechCS
	Task: 
*/
USE bodb_PlaytechCS
GO

UPDATE dbo.Product3rd_ResettledBetHistory WITH (ROWLOCK, UPDLOCK)
SET Status = 'Completed'
WHERE SettledDate < '2022-03-01'
	AND Status = 'waiting'