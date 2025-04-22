/*<info serverAlias="DBLIC-bodb_3rdProduct"></info>*/
/*
	Created: 20250414@Kelvin
	DB: DBLIC-bodb_3rdProduct
	Task: LAP/MPA - Upgrade ExchangeId Datatype [RedmineID: #222339]
*/


USE [bodb_3rdProduct]
GO

--[Sum_winloss_Exchange]
DROP INDEX [IX_ResettledDate] ON [dbo].[Sum_winloss_Exchange]
GO

DROP INDEX [IX_settledDate] ON [dbo].[Sum_winloss_Exchange]
GO

ALTER TABLE Sum_winloss_Exchange ALTER COLUMN Currency SMALLINT
GO

CREATE NONCLUSTERED INDEX [IX_ResettledDate] ON [dbo].[Sum_winloss_Exchange]
(
	[resettledDate] ASC,
	[CustID] ASC
)
INCLUDE([profitLoss],[marketTotal],[commission],[agentCommission],[stakeTotal],[Currency],[ExVirtualRate],[IsResettled]) 
WHERE ([resettledDate] IS NOT NULL)
WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [3rdProduct_Data]
GO

CREATE NONCLUSTERED INDEX [IX_settledDate] ON [dbo].[Sum_winloss_Exchange]
(
	[settledDate] ASC,
	[CustID] ASC
)
INCLUDE([profitLoss],[marketTotal],[commission],[agentCommission],[stakeTotal],[Currency],[ExVirtualRate],[resettledDate],[IsResettled]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [3rdProduct_Data]
GO

--[Sum_winloss_Exchange_bk]

DROP INDEX [IX_ResettledDate] ON [dbo].[Sum_winloss_Exchange_bk]
GO

DROP INDEX [IX_settledDate] ON [dbo].[Sum_winloss_Exchange_bk]
GO

ALTER TABLE Sum_winloss_Exchange_bk ALTER COLUMN Currency SMALLINT
GO

CREATE NONCLUSTERED INDEX [IX_ResettledDate] ON [dbo].[Sum_winloss_Exchange_bk]
(
	[resettledDate] ASC,
	[CustID] ASC
)
INCLUDE([profitLoss],[marketTotal],[commission],[agentCommission],[stakeTotal],[Currency],[ExVirtualRate],[IsResettled]) 
WHERE ([resettledDate] IS NOT NULL)
WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [3rdProduct_Data]
GO

CREATE NONCLUSTERED INDEX [IX_settledDate] ON [dbo].[Sum_winloss_Exchange_bk]
(
	[settledDate] ASC,
	[CustID] ASC
)
INCLUDE([profitLoss],[marketTotal],[commission],[agentCommission],[stakeTotal],[Currency],[ExVirtualRate],[resettledDate],[IsResettled]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [3rdProduct_Data]
GO

--[Sum_winloss_Exchange_CheckData]

ALTER TABLE Sum_winloss_Exchange_CheckData ALTER COLUMN Currency SMALLINT


