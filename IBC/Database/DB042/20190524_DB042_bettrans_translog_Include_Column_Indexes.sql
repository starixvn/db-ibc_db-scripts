USE [bodb02]
GO

/*
	Created: 20190524@Percy
	DB: DB042.bodb02
	Task: Include columns to indexes on bettrans, translog

		1. bettrans
			IX_betrunning_srecommend:	winlostdate
			IX_betrunning_mrecommend:	winlostdate
			IX_betrunning_recommend:	winlostdate
		2. translog
			IX_betrunning_srecommend:	winlostdate, currency
			IX_betrunning_mrecommend:	winlostdate, currency
			IX_betrunning_recommend:	winlostdate, currency
*/

-- bettrans - IX_betrunning_srecommend
CREATE NONCLUSTERED INDEX [IX_betrunning_srecommend] ON [dbo].[bettrans]
(
	[srecommend] ASC,
	[bettype] ASC,
	[matchid] ASC
)
INCLUDE ( 	[odds],
	[stake],
	[livehomescore],
	[liveawayscore],
	[liveindicator],
	[betteam],
	[spositiontaking],
	[custid],
	[mpositiontaking],
	[actual_stake],
	[mrecommend],
	[recommend],
	[Username],
	[refno],
	[transid],
	[betid],
	[hdp1],
	[hdp2],
	[modds],
	[SecAcceptFlag],
	[checktime],
	[status],
	[transdate],
	[apositiontaking],
	[tpositiontaking],
	[discount],
	[adiscount],
	[sdiscount],
	[ip],
	[oddstype],
	[comstatus],
	[betcheck],
	[oddsspread],
	[currency],
	[ExtraInfo],
	[winlostdate]) 
WHERE ([statusID] IN ((0), (1)))
WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = ON, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [bettrans_index1]
GO

-- bettrans - IX_betrunning_mrecommend
CREATE NONCLUSTERED INDEX [IX_betrunning_mrecommend] ON [dbo].[bettrans]
(
	[mrecommend] ASC,
	[bettype] ASC,
	[matchid] ASC
)
INCLUDE ( 	[odds],
	[stake],
	[mpositiontaking],
	[livehomescore],
	[liveawayscore],
	[liveindicator],
	[betteam],
	[spositiontaking],
	[actual_stake],
	[recommend],
	[custid],
	[Username],
	[refno],
	[transid],
	[betid],
	[hdp1],
	[hdp2],
	[modds],
	[SecAcceptFlag],
	[checktime],
	[status],
	[transdate],
	[apositiontaking],
	[tpositiontaking],
	[discount],
	[adiscount],
	[sdiscount],
	[ip],
	[oddstype],
	[comstatus],
	[betcheck],
	[oddsspread],
	[currency],
	[ExtraInfo],
	[winlostdate]) 
WHERE ([statusID] IN ((0), (1)))
WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = ON, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [bettrans_index1]
GO

-- bettrans - IX_betrunning_recommend
CREATE NONCLUSTERED INDEX [IX_betrunning_recommend] ON [dbo].[bettrans]
(
	[recommend] ASC,
	[bettype] ASC,
	[matchid] ASC
)
INCLUDE ( 	[odds],
	[stake],
	[apositiontaking],
	[livehomescore],
	[liveawayscore],
	[liveindicator],
	[betteam],
	[custid],
	[actual_stake],
	[mpositiontaking],
	[spositiontaking],
	[Username],
	[refno],
	[transid],
	[betid],
	[hdp1],
	[hdp2],
	[modds],
	[SecAcceptFlag],
	[checktime],
	[status],
	[transdate],
	[tpositiontaking],
	[discount],
	[adiscount],
	[sdiscount],
	[ip],
	[oddstype],
	[comstatus],
	[betcheck],
	[oddsspread],
	[currency],
	[ExtraInfo],
	[winlostdate]) 
WHERE ([statusID] IN ((0), (1)))
WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = ON, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [bettrans_index1]
GO

-- translog - IX_betrunning_srecommend
CREATE INDEX [IX_betrunning_srecommend] ON [dbo].[translog]
(
	[srecommend] ASC,
	[gameID] ASC
)
INCLUDE ( 	[spositiontaking],
	[actual_stake],
	[mrecommend],
	[winlostdate],
	[currency]) 
WHERE ([statusID] IN ((0), (1)))
WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = ON, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [translog_index]
GO

-- translog - IX_betrunning_mrecommend
CREATE NONCLUSTERED INDEX [IX_betrunning_mrecommend] ON [dbo].[translog]
(
	[mrecommend] ASC,
	[gameID] ASC
)
INCLUDE ( 	[mpositiontaking],
	[spositiontaking],
	[actual_stake],
	[recommend],
	[winlostdate],
	[currency]) 
WHERE ([statusID] IN ((0), (1)))
WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = ON, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [translog_index]
GO

-- translog - IX_betrunning_recommend
CREATE NONCLUSTERED INDEX [IX_betrunning_recommend] ON [dbo].[translog]
(
	[recommend] ASC,
	[gameID] ASC
)
INCLUDE ( 	[custid],
	[apositiontaking],
	[actual_stake],
	[mpositiontaking],
	[spositiontaking],
	[winlostdate],
	[currency]) 
WHERE ([statusID] IN ((0), (1)))
WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = ON, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [translog_index]
GO