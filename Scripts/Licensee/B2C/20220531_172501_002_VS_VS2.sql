/*<info serverAlias="DBN88-bodb_N88"></info>*/
/*
	Created: 20220531@Percy
	DB: DBN88-bodb_N88
	Task: Update data due to API source change [RedmineID: #172501]
		Part II. VS & VS2
*/

USE bodb_N88
GO

-- Update raw data: 4 rows
UPDATE dbo.TpBetRecord WITH (ROWLOCK)
SET GameType		= CASE WHEN TransId IN ('115141397249', '115147197467') THEN 24 ELSE 3 END
	,TicketStatus	= CASE WHEN TransId IN ('115141397249', '115236396375') THEN 1 ELSE 2 END
	,OriginalState	= CASE WHEN TransId IN ('115141397249', '115236396375') THEN 'won' ELSE 'lose' END
	,ValidBet		= Stake
	,WinlostAmount	= CASE TransId
						WHEN '115141397249' THEN 6500
						WHEN '115236396375' THEN 36000
						ELSE WinlostAmount END
WHERE TpId = 1 AND GameType IN (3, 24)
	AND TransId IN ('115136295339', '115147197467', '115141397249', '115236396375')

-- Regen sum data
EXEC dbo.Task_N88_SumWinloss @WinlostDate = '2022-04-04'
EXEC dbo.Task_N88_SumWinloss @WinlostDate = '2022-04-05'
EXEC dbo.Task_N88_SumWinloss @WinlostDate = '2022-04-06'
EXEC dbo.Task_N88_SumWinloss @WinlostDate = '2022-04-20'
GO