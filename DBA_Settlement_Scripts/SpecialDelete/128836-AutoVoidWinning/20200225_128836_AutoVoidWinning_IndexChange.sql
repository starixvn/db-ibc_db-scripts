/*
	Created: 20200225@Helen
	Task: https://nexdev.net/issues/128836
	DB: DBTRANS/bodb02
		
*/
USE bodb02
GO
DROP INDEX MarkedTransaction.IX_MarkedTransaction_MatchId
GO
CREATE NONCLUSTERED INDEX [IX_MarkedTransaction_MatchId] ON [dbo].[MarkedTransaction]
(
	[MatchId] ASC,
	[bettype] ASC
)
INCLUDE (MarkType)