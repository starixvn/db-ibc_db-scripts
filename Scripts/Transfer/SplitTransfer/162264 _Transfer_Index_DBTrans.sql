/*<info serverAlias="DBTXN-bodb02"></info>*/
/*
	Created: 20211118@Sol
	DB : DBTXN-bodb02
	Task: New indexes for Transfer table - [Redmine: #162264]
*/

USE bodb02

GO

CREATE NONCLUSTERED INDEX [IX_WinlostDate] ON [dbo].[Transfer]
(
	[WinlostDate] ASC
) ON [Transfer_Index]
GO

CREATE NONCLUSTERED INDEX [IX_Recommend] ON [dbo].[Transfer]
(
	[Recommend] ASC,
	[WinlostDate] ASC,
	[Bettype] ASC
)
INCLUDE([MRecommend],[CustId],[Winlost],[Actual_Stake],[PlayerComm],[AWinlost],[MWinlost],[AComm],[Comm]) ON [Transfer_Index]
GO

CREATE NONCLUSTERED INDEX [IX_CustId] ON [dbo].[Transfer]
(
	[CustId] ASC,
	[WinlostDate] ASC,
	[Bettype] ASC
)
INCLUDE([Winlost],[Actual_Stake],[PlayerComm])  ON [Transfer_Index]
GO