/*
	- Created@Bobby: 20200214
	- Task: New Forecast - Soccer OST version - [Redmine:121898]
*/
USE [bodb02]
GO

/****** Object:  Index [IX_matchid]    Script Date: 2/14/2020 11:45:13 AM ******/
CREATE NONCLUSTERED INDEX [IX_matchid] ON [dbo].[odds]
(
	[matchid] ASC
)
INCLUDE ( 	
	[oddsid],
	[hdp2],
	[hdp1],
	[switch],
	[odds1a],
	[odds2a],
	[oddsstatus],
	[livehomescore],
	[liveawayscore],
	[bettype]
) WITH(DROP_EXISTING = ON) ON [Odds_index]
GO