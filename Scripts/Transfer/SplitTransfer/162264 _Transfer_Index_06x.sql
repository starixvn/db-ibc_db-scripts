/*<info serverAlias="DBACC-bodb02"></info>*/
/*
	Created: 20211118@Sol
	DB : DBACC-bodb02
	Task: New indexes for Transfer table - [Redmine: #162264]
*/

USE [bodb02]

GO

CREATE NONCLUSTERED INDEX [IX_CustId] ON [dbo].[Transfer]
(
	[CustId] ASC,
	[WinlostDate] ASC,
	[Bettype] ASC
)
INCLUDE([TransDate],[TransDesc],[RefNo],[Username],[Stake],[Winlost],[Actual_Stake],[PlayerComm],[Creator]) ON [Transfer_Index]
GO

CREATE NONCLUSTERED INDEX [IX_Recommend] ON [dbo].[Transfer]
(
	[Recommend] ASC,
	[WinlostDate] ASC,
	[Bettype] ASC
)
INCLUDE([Stake],[Winlost],[Actual_Stake],[AWinlost],[MWinlost],[PlayerComm],[Comm],[AComm]) ON [Transfer_Index]
GO

CREATE NONCLUSTERED INDEX [IX_RefNo] ON [dbo].[Transfer]
(
	[RefNo] ASC
) ON [Transfer_Index]
GO

CREATE NONCLUSTERED INDEX [IX_Srecommend] ON [dbo].[Transfer]
(
	[SRecommend] ASC,
	[MRecommend] ASC,
	[Recommend] ASC,
	[CustId] ASC
)
INCLUDE([WinlostDate],[Bettype],[SWinlost],[MWinlost],[AWinlost],[Winlost],[SComm],[AComm],[Comm],[PlayerComm],[Actual_Stake],[ActualRate]) ON [Transfer_Index]
GO

CREATE NONCLUSTERED INDEX [IX_WinlostDate] ON [dbo].[Transfer]
(
	[WinlostDate] ASC,
	[Bettype] ASC
)
INCLUDE([RefNo],[Username],[Winlost],[Actual_Stake],[AWinlost],[MWinlost],[SWinlost],[SComm],[ActualRate],[Creator],[SerialNo],[CheckTime],[TransDate],[TransDesc]) ON [Transfer_Index]
GO