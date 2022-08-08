/*<info serverAlias="DBN88-bodb_N88"></info>*/
/*
	Created: 20220808@Sol
	DB: DBN88-bodb_N88
	Task: re-gen for missing data in tpBetRecord
*/

USE bodb_N88

GO

-- Resum data
EXEC dbo.Task_N88_SumWinloss @WinlostDate = '2022-07-21'

GO

-- Resum data
EXEC dbo.Task_N88_SumWinloss @WinlostDate = '2022-07-25'

GO