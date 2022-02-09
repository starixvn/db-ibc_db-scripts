/*<info serverAlias="DBAGE-bodb02,DBBAH-bodb02,DBBAL-bodb02"></info>*/
/*
	Created: 20211118@Sol
	DB : DBAGE-bodb02,DBBAH-bodb02,DBBAL-bodb02
	Task: New indexes for Transfer table - [Redmine: #162264]
*/

USE [bodb02]

GO

CREATE NONCLUSTERED INDEX [IX_custid] ON [dbo].[Transfer]
(
	[CustId] ASC,
	[WinlostDate] ASC,
	[Bettype] ASC
)
INCLUDE([Winlost],[PlayerComm],[Actual_Stake],[RefNo]) ON [Transfer_Index]

GO

CREATE NONCLUSTERED INDEX [IX_Mrecommend] ON [dbo].[Transfer]
(
	[MRecommend] ASC,
	[WinlostDate] ASC,
	[Bettype] ASC
)
INCLUDE([CustId],[MWinlost],[AWinlost],[Winlost],[AComm],[Comm],[PlayerComm],[Actual_Stake],[Recommend],[RefNo]) ON [Transfer_Index]
GO

CREATE NONCLUSTERED INDEX [IX_Recommend] ON [dbo].[Transfer]
(
	[Recommend] ASC,
	[WinlostDate] ASC,
	[Bettype] ASC
)
INCLUDE([CustId],[AWinlost],[Winlost],[Comm],[PlayerComm],[Actual_Stake],[RefNo]) ON [Transfer_Index]
GO

CREATE NONCLUSTERED INDEX [IX_Srecommend] ON [dbo].[Transfer]
(
	[SRecommend] ASC,
	[WinlostDate] ASC,
	[Bettype] ASC
)
INCLUDE([CustId],[SWinlost],[MWinlost],[AWinlost],[Winlost],[SComm],[AComm],[Comm],[PlayerComm],[Actual_Stake],[MRecommend],[Recommend],[RefNo]) ON [Transfer_Index]
GO