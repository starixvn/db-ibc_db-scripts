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
SET Stake = 349800, ValidBet = 349800, WinlostAmount = -76500
WHERE TpId = 24 and GameType = 40 AND TransId IN ('r-1016276724')

UPDATE dbo.TpBetRecord WITH (ROWLOCK)
SET Stake = 52500, ValidBet = 52500, WinlostAmount = -1600
WHERE TpId = 24 and GameType = 40 AND TransId IN ('r-962399286')

GO

-- Regen sum data
EXEC dbo.Task_N88_SumWinloss @WinlostDate = '2022-03-23'

EXEC dbo.Task_N88_SumWinloss @WinlostDate = '2022-03-31'
GO