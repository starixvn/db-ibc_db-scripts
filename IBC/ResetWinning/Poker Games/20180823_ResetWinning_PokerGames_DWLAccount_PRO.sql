USE [bodb_ACC]
GO

/*
	Created: 20180823@Percy
	DB: DBACC.bodb_ACC
	Task: Insert DWL accounts for Poker Games [RedmineID: #100168]
*/

INSERT INTO dbo.Acc_DWLList (custid, product, seq, ProductId, IsDeleted)
	VALUES
		(32131757, 'Poker Games', 36, 33, 0),
		(32131917, 'Poker Games (Due To Partners)', 37, 33, 0)