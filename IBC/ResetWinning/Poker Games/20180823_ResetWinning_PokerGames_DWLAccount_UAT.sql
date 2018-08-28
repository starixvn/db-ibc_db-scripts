USE [bodb_ACC]
GO

/*
	Created: 20180823@Percy
	DB: DBACC.bodb_ACC
	Task: Insert dummy DWL accounts for Poker Games [RedmineID: #100168]
*/

INSERT INTO dbo.Acc_DWLList_xtest (custid, product, seq, ProductId, IsDeleted)
	VALUES
		(32131993, 'Poker Games', 36, 33, 0),
		(32132063, 'Poker Games (Due To Partners)', 37, 33, 0)