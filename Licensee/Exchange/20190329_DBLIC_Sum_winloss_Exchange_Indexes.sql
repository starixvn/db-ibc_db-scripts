USE [bodb_3rdProduct]
GO

/*
	Created: 20190329@Percy
	DB: DBLIC.bodb_3rdProduct
	Task: Create indexes on Sum_winloss_Exchange and Sum_winloss_Exchange_CheckData
*/
CREATE NONCLUSTERED INDEX IX_settledDate ON [dbo].[Sum_winloss_Exchange_CheckData] (settledDate)
	INCLUDE (profitLoss, marketTotal, commission, agentCommission, stakeTotal)
	ON [3rdProduct_Data]
GO

CREATE NONCLUSTERED INDEX IX_settledDate ON [dbo].[Sum_winloss_Exchange] (settledDate)
	INCLUDE (profitLoss, marketTotal, commission, agentCommission, stakeTotal)
	ON [3rdProduct_Data]
GO