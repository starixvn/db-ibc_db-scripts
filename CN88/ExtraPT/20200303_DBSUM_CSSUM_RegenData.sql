USE bodb_Summary
GO

/*
	Created: 20200303@Percy
	DB: DBSUM.bodb_Summary
	Task: Manually regen data for CN88 Customer on 25 Feb 2020
*/

EXEC dbo.Task_CS_SumCancelled_CheckAndCorrect_xtest @WinlostDate = '2020-02-25'
GO

EXEC dbo.Task_CS_SumWinloss_CheckAndCorrect_xtest @WinlostDate = '2020-02-25'
GO