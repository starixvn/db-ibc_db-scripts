USE [bodb02]
GO

/*
	-- DBPRO
	-- Hide inactive Product
*/

DECLARE @lauchdate DATETIME = '2018-03-01' -- release date

UPDATE dbo.Products WITH (ROWLOCK, UPDLOCK)
SET Enabled = 0, EndOfSupportDate = @lauchdate
WHERE ProductID = 2