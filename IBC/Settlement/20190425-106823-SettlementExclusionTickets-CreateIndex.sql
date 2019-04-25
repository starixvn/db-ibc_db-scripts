/*
	Created by: Kathy
    Date:20190425
    Task: Settlement with Tickets Exclusion [Redmine:#106823]
    DB: DBTXN/bodb02
   
*/
USE [bodb02]
GO
CREATE NONCLUSTERED INDEX [IX_MarkedTransaction_MatchId] ON [dbo].[MarkedTransaction]
(
	[MatchId] ASC,
	[bettype] ASC
) ON [DATA]
GO

