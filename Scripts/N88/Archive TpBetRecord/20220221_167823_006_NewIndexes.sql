/*<info serverAlias="DBN88-bodb_N88"></info>*/
/*
	Created: 20220221@Percy
	DB: DBN88
	Task: New index on TpBetRecord & TpBetRecord_bk
*/
USE bodb_N88
GO

DROP INDEX IX_CustId ON dbo.TpBetRecord
GO

CREATE NONCLUSTERED INDEX IX_CustId ON dbo.TpBetRecord (CustId, GameType, TicketStatus, SettledTime) INCLUDE (TransTime, TransId, CurrencyId, Stake, ValidBet, WinlostAmount, Revenue, ProgressiveWin, ProgressiveBet)
	WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON ReportData
GO


USE bodb_N88_Archive
GO

CREATE NONCLUSTERED INDEX IX_CustId ON dbo.TpBetRecord_bk (CustId, GameType, TicketStatus, SettledTime) INCLUDE (TransTime, TransId, CurrencyId, Stake, ValidBet, WinlostAmount, Revenue, ProgressiveWin, ProgressiveBet)
	WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON ReportData
GO