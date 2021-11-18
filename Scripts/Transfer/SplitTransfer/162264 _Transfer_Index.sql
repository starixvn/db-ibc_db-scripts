/*<info serverAlias="DBTXN-bodb02,DBACC-bodb02,DBAGE-bodb02,DBBOF-bodb02,DBBAH-bodb02,DBBAL-bodb02" step="2"></info>*/

USE bodb02

GO

CREATE NONCLUSTERED INDEX [IX_WinlostDate] ON [dbo].[Transfer]
(
	[WinlostDate] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [Transfer_Index]
GO

CREATE NONCLUSTERED INDEX [IX_RefNo] ON [dbo].[Transfer]
(
	[RefNo] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [Transfer_Index]
GO

CREATE NONCLUSTERED INDEX [IX_Recommend] ON [dbo].[Transfer]
(
	[Recommend] ASC,
	[WinlostDate] ASC,
	[Bettype] ASC
)
INCLUDE([MRecommend],[CustId],[Winlost],[Actual_Stake],[PlayerComm],[AWinlost],[MWinlost],[AComm],[Comm]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [Transfer_Index]
GO

CREATE NONCLUSTERED INDEX [IX_CustId] ON [dbo].[Transfer]
(
	[CustId] ASC,
	[WinlostDate] ASC,
	[Bettype] ASC
)
INCLUDE([Winlost],[Actual_Stake],[PlayerComm]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [Transfer_Index]
GO