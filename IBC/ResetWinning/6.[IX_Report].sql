---DB06

USE [bodb02]
GO

/****** Object:  Index [IX_Report]    Script Date: 3/10/2016 1:20:12 PM ******/
CREATE NONCLUSTERED INDEX [IX_Report] ON [dbo].[bettrans]
(
	[winlostdate] ASC,
	[bettype] ASC,
	[ruben] ASC,
	[statusID] ASC,
	[matchid] ASC
)
INCLUDE ( 	[winlost],
	[awinlost],
	[mwinlost],
	[liveindicator],
	[actualrate],
	[actual_stake],
	[scomm],
	[swinlost],
	[virtualrate],
	[custid],
	[tpositiontaking],
	[oddsspread],
	[odds],
	[transid],
	[srecommend],
	BetId,
	Stake
	) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [Bettrans_index2]
GO


