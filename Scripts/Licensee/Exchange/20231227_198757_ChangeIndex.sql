/*<info serverAlias="DBLIC-bodb_3rdProduct"></info>*/
/*
	Created: 20231227@Evan
	DB: DBLIC-bodb_3rdProduct
	Task : Database - Exchange - Change index table Bettrans_Exchange, Sum_winloss_Exchange
	https://nexdev.net/issues/198757
*/
USE [bodb_3rdProduct]
GO

--Sum_winloss_Exchange

-- CREATE NONCLUSTERED INDEX [IX_settledDate] ON [dbo].[Sum_winloss_Exchange]
-- (
-- 	[settledDate] ASC
-- )
-- INCLUDE ([profitLoss], [marketTotal], [commission], [agentCommission], [stakeTotal], [CustID], [Currency], [ExVirtualRate], [IsResettled], [resettledDate])
-- WITH (ONLINE = ON, DROP_EXISTING = ON) ON [3rdProduct_Data]
-- GO

CREATE NONCLUSTERED INDEX [IX_ResettledDate] ON [dbo].[Sum_winloss_Exchange]
(
	[resettledDate] ASC,
	[settledDate] ASC
)
INCLUDE ([profitLoss], [marketTotal], [commission], [agentCommission], [stakeTotal], [CustID], [Currency], [ExVirtualRate], [IsResettled])
WHERE resettledDate IS NOT NULL 
ON [3rdProduct_Data]

GO

--Bettrans_Exchange

CREATE NONCLUSTERED INDEX IX_UserId ON [dbo].Bettrans_Exchange
(
	[userId] ASC,
	[eventID] ASC,
	[marketID] ASC
)
INCLUDE (betstatus,matchType, matchStake)
WITH (ONLINE = ON, DROP_EXISTING = ON) ON [3rdProduct_Data]
GO
