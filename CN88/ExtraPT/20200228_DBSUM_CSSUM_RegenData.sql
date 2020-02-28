USE bodb_Summary
GO

/*
	Created: 20200228@Percy
	DB: DBSUM.bodb_Summary
	Task: Regen data due to ExtraPT change
*/

EXEC dbo.Task_CS_SumCancelled_xtest @WinlostDate = '2020-02-25'
GO

EXEC dbo.Task_CS_SumWinloss_xtest @WinlostDate = '2020-02-25'
GO