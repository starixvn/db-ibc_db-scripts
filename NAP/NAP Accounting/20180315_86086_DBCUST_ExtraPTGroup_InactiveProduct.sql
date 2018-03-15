USE [CustDB]
GO

/*
	-- DBCUST
	-- Remove setting of Racing (Live Casino was removed before)
*/

DECLARE @lauchdate DATETIME = '2018-03-01' -- release date

DELETE dbo.Acc_GroupExtraPT_Product WITH (ROWLOCK, UPDLOCK)
WHERE ProductID = 2
	AND FromDate > CONVERT(DATE, GETDATE())

UPDATE dbo.Acc_GroupExtraPT_Product WITH (ROWLOCK, UPDLOCK)
SET ToDate = @lauchdate
WHERE ProductID = 2
	AND ToDate >= CONVERT(DATE, GETDATE())

DELETE dbo.Acc_GroupExtraPTSetting WITH (ROWLOCK, UPDLOCK)
WHERE ProductID = 2
	AND FromDate > CONVERT(DATE, GETDATE())

UPDATE dbo.Acc_GroupExtraPTSetting WITH (ROWLOCK, UPDLOCK)
SET ToDate = @lauchdate
WHERE ProductID = 2
AND ToDate >= CONVERT(DATE, GETDATE())