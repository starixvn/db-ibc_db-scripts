USE [bodb_ACC]
GO

/*
	-- DBACC
	-- Mark Live Casino, Racing is deleted
*/

INSERT INTO dbo.Acc_DWLList_xtest (custid, product, seq, ProductId, IsDeleted)
VALUES (12962878, 'Live Casino', 6, 4, 1)

INSERT INTO dbo.Acc_DWLList (custid, product, seq, ProductId, IsDeleted)
VALUES (6911917, 'Live Casino', 6, 4, 1)

UPDATE dbo.Acc_DWLList_xtest WITH (ROWLOCK, UPDLOCK)
SET IsDeleted = 1
WHERE ProductId = 2

UPDATE dbo.Acc_DWLList WITH (ROWLOCK, UPDLOCK)
SET IsDeleted = 1
WHERE ProductId = 2