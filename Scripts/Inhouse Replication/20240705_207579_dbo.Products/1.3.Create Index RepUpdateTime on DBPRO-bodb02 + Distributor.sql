/*<info serverAlias="DBPRO-bodb02,DBCustRepl-ReplCustDB"></info>*/
/*
	Created: 20240705@Lewis
	DB: 
		+ DBPRO-bodb02
		+ DBCustRepl-ReplCustDB
	Task: InHouse Replication - Create Index RepUpdateTime for Products on DBPRO-bodb02
*/

CREATE NONCLUSTERED INDEX [IX_Products_RepUpdateTime] ON [dbo].[Products]
(
	[RepUpdateTime] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [DATA]
GO