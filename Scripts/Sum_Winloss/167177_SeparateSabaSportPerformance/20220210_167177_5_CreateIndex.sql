/*<info serverAlias="DBAGE-bodb02"></info>*/

/*
Create: 20220210@Danny
Task: Create new index [Redmine: #167177]
DB: DBAGE-bodb02

*/


USE [bodb02]
GO


CREATE NONCLUSTERED INDEX [IX_srecommend] ON [dbo].[bettrans]
(
	[srecommend] ASC,
	[winlostdate] ASC
)
INCLUDE([transid],[refno],[statusID],[ruben],[currency],[winlost],[actual_stake],[playercomm],[awinlost],[comm],[mwinlost],[recommend],[acomm],[swinlost],[scomm],[mrecommend],[liveawayscore],[spositiontaking],[stake],[tpositiontaking],[oddsspread],[modds],[liveindicator],[actualrate],[apositiontaking],[mpositiontaking],[betid],[epositiontaking],[betdaqid]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = ON, ONLINE = ON, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [Bettrans_index1]
GO


CREATE NONCLUSTERED INDEX [IX_srecommend] ON [dbo].[bettransLC]
(
	[srecommend] ASC,
	[winlostdate] ASC
)
INCLUDE([gameID],[productID],[transid],[RefNo],[statusID],[currency],[winlost],[actual_stake],[playercomm],[awinlost],[comm],[custid],[mwinlost],[recommend],[acomm],[swinlost],[scomm],[mrecommend],[spositiontaking],[stake],[tpositiontaking],[actualrate],[apositiontaking],[mpositiontaking],[NetStake],[sdiscount]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = ON, ONLINE = ON, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 100, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [bettransLC_index]


GO

CREATE NONCLUSTERED INDEX [IX_srecommend] ON [dbo].[bettransRnG]
(
	[srecommend] ASC,
	[winlostdate] ASC
)
INCLUDE([gameID],[productID],[RefNo],[statusID],[currency],[winlost],[actual_stake],[playercomm],[awinlost],[comm],[custid],[mwinlost],[recommend],[acomm],[swinlost],[scomm],[mrecommend],[spositiontaking],[stake],[tpositiontaking],[actualrate],[apositiontaking],[mpositiontaking],[BetStake],[sdiscount]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = ON, ONLINE = ON, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 100, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [bettransRnG_index]



