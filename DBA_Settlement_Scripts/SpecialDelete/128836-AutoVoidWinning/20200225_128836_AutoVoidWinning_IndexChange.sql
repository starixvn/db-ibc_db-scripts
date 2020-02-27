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
CREATE NONCLUSTERED INDEX IX_TicketVoiding_AutoMarkService_AutoSetting ON TicketVoiding_AutoMarkService_AutoSetting
(
	MatchID
)
GO