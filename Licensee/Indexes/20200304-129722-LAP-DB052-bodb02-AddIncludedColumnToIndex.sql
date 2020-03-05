/*
	Created by: Kos
	Date: 20200304
	Task: Add included columns betfrom to index IX_recommend of table bettrans [RedmineID: #129722]
	DB: DB052.bodb02
*/

USE [bodb02]
GO

CREATE NONCLUSTERED INDEX [IX_recommend] ON [dbo].[bettrans]
(
	[recommend] ASC,
	[winlostdate] ASC
)
INCLUDE ( 	[transid],
	[refno],
	[statusID],
	[ruben],
	[currency],
	[winlost],
	[actual_stake],
	[playercomm],
	[awinlost],
	[comm],
	[stake],
	[modds],
	[liveawayscore],
	[apositiontaking],
	[oddsspread],
	[srecommend],
	[mrecommend],
	[actualrate],
	[oddsid],
	[odds],
	[oddstype],
	[tpositiontaking],
	[liveindicator],
	[livehomescore],
	[betdaqid],
	[betfrom]) 
WITH (ONLINE = OFF,DROP_EXISTING = ON) ON [Bettrans_index1]
GO

