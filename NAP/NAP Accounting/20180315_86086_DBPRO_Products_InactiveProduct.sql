USE [bodb02]
GO

/*
	-- DBPRO
	-- Hide inactive Product
*/

DECLARE @lauchdate DATETIME = '2017-11-30' -- end of support date

UPDATE dbo.Products WITH (ROWLOCK, UPDLOCK)
SET Enabled = 0, EndOfSupportDate = @lauchdate
WHERE ProductID = 2