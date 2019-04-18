USE [bodb_ACC]
GO

/*
	Created: 20190412@Percy
	DB: DBACC.bodb_ACC
	Task: PRO - Add Bet Builder & Pragmatic
*/

UPDATE dbo.Acc_DWLList WITH (ROWLOCK, UPDLOCK)
SET seq = seq + 3
WHERE seq BETWEEN 5 AND 9

UPDATE dbo.Acc_DWLList WITH (ROWLOCK, UPDLOCK)
SET seq = seq + 1
WHERE seq BETWEEN 36 AND 37

INSERT INTO dbo.Acc_DWLList (custid, product, seq, ProductId, IsDeleted)
SELECT 35739415, 'Bet Builder', 5, 1, 0 UNION ALL
SELECT 35999735, 'Bet Builder (Due To Partners)', 6, 1, 0 UNION ALL
SELECT 35999728, 'PP (Due To Partners)', 36, 32, 0