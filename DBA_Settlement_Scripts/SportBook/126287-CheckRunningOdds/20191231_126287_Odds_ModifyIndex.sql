/*
	created: 20191231@Helen
	Task:  Basketball | Accidentally Settled Running Match caused by Keyscore - Modify index - [Redmine:126287]
	DB: DBPRO/bodb02
*/
USE bodb02
GO
DROP INDEX [odds].[IX_matchid]
GO
CREATE NONCLUSTERED INDEX [IX_matchid] ON [dbo].[odds]
(
	[matchid] ASC
)
INCLUDE ([oddsid],
	[bettype],
	[odds2a],
	[odds1a],
	[hdp2],
	[hdp1],
	[oddsstatus],
	[switch],
	[diffbalance],
	[changetime],
	[newoffersetup],
	[livehomescore],
	[csstatus],
	[maxbet],
	[site3],
	[hometotal],
	[awaytotal],
	[liveindicator],
	[liveawayscore],
	resourceid) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [Odds_index]
GO

