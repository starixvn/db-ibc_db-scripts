/*
	Created: 20200225@Helen
	Task: https://nexdev.net/issues/128836
	DB: DBTRANS/bodb02
		
*/
USE bodb02
GO
CREATE NONCLUSTERED INDEX [IX_MarkedTransaction_CustID_MarkType] ON [dbo].[MarkedTransaction]
(
	MarkType,
	CustID
)
GO

DROP INDEX [MarkedTransaction].[IX_MarkedTransaction_MatchId]
GO
CREATE NONCLUSTERED INDEX [IX_MarkedTransaction_MatchId] ON [dbo].[MarkedTransaction]
(
	[MatchId] ASC,
	[bettype] ASC

)INCLUDE ([MarkType])
WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [DATA]
GO

CREATE NONCLUSTERED INDEX IX_TicketVoiding_AutoMarkService_AutoSetting ON TicketVoiding_AutoMarkService_AutoSetting
(
	MatchID
)
GO