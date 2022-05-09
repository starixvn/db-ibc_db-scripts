/*<info serverAlias="DBN88-bodb_N88"></info>*/
/*
	Created: 20220509@Percy
	DB: DBN88-bodb_N88
	Task: Update data due to API source change [RedmineID: #172501]
		Part I. Ebet Live Casino
*/

USE bodb_N88
GO

-- Update raw data
/*
	SELECT TicketStatus, Stake, WinlostAmount, WinlostDate, * FROM dbo.TpBetRecord WITH (NOLOCK)
	WHERE TpId = 18 AND GameType = 28 -- E.Bet Live Casino
		AND TransId = 'BL2-220422193048_goal123_477682'
*/
-- 1 row affected
UPDATE dbo.TpBetRecord WITH (ROWLOCK)
SET TicketStatus = 3 -- Refund
WHERE TpId = 18 AND GameType = 28 -- E.Bet Live Casino
	AND TransId = 'BL2-220422193048_goal123_477682'
GO

-- Regen sum data
EXEC dbo.Task_N88_SumWinloss @WinlostDate = '2022-04-22'
GO