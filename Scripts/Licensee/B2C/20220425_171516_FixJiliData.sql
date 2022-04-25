/*<info serverAlias="DBN88-bodb_N88"></info>*/
/*
	Created: 20220425@Percy
	DB: DBN88-bodb_N88
	Task: Update data due to API source change [RedmineID: #171516]
*/

USE bodb_N88
GO

-- Update raw data
UPDATE dbo.TpBetRecord WITH (ROWLOCK)
SET TicketStatus = 3
WHERE TpId = 32
	AND GameType = 53
	AND TransId IN ('1648111781765676103','1648110924291354049','1648110924291291049','1648110924291055049')
GO

-- Regen sum data
EXEC dbo.Task_N88_SumWinloss @WinlostDate = '2022-03-24'
GO