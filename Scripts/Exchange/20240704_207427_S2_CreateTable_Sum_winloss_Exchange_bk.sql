/*<info serverAlias="DBLIC-bodb_3rdProduct"></info>*/
/*
	Created: 20240704@Kelvin
	DB: DBLIC-bodb_3rdProduct
	Task: Exchange - Archive data before 2022 [RedmineID: #207427]		
*/

USE [bodb_3rdProduct]
GO

/****** Object:  Table [dbo].[Sum_winloss_Exchange_bk]    Script Date: 7/4/2024 1:09:55 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[Sum_winloss_Exchange_bk](
	[userId] [varchar](16) NOT NULL,
	[agentId] [varchar](16) NULL,
	[eventTypeName] [varchar](50) NULL,
	[eventName] [varchar](500) NULL,
	[eventID] [int] NOT NULL,
	[marketName] [varchar](500) NULL,
	[marketID] [varchar](50) NOT NULL,
	[startTime] [datetime] NULL,
	[settledDate] [datetime] NOT NULL,
	[profitLoss] [money] NULL,
	[marketTotal] [money] NULL,
	[commission] [money] NULL,
	[agentCommission] [money] NULL,
	[stakeTotal] [money] NULL,
	[resettledDate] [datetime] NULL,
	[CustID] [int] NULL,
	[Currency] [tinyint] NULL,
	[ExVirtualRate] [float] NULL,
	[IsResettled] [bit] NULL,
 CONSTRAINT [PK_Sum_winloss_Exchange_bk] PRIMARY KEY CLUSTERED 
(
	[userId] ASC,
	[marketID] ASC,
	[eventID] ASC,
	[settledDate] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [3rdProduct_Data]
) ON [3rdProduct_Data]
GO

/****** Object:  Index [IX_CustId]    Script Date: 7/4/2024 1:09:55 PM ******/
CREATE NONCLUSTERED INDEX [IX_CustId] ON [dbo].[Sum_winloss_Exchange_bk]
(
	[CustID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [3rdProduct_Data]
GO

/****** Object:  Index [IX_ResettledDate]    Script Date: 7/4/2024 1:09:55 PM ******/
CREATE NONCLUSTERED INDEX [IX_ResettledDate] ON [dbo].[Sum_winloss_Exchange_bk]
(
	[resettledDate] ASC,
	[CustID] ASC
)
INCLUDE([profitLoss],[marketTotal],[commission],[agentCommission],[stakeTotal],[Currency],[ExVirtualRate],[IsResettled]) 
WHERE ([resettledDate] IS NOT NULL)
WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [3rdProduct_Data]
GO

/****** Object:  Index [IX_settledDate]    Script Date: 7/4/2024 1:09:55 PM ******/
CREATE NONCLUSTERED INDEX [IX_settledDate] ON [dbo].[Sum_winloss_Exchange_bk]
(
	[settledDate] ASC,
	[CustID] ASC
)
INCLUDE([profitLoss],[marketTotal],[commission],[agentCommission],[stakeTotal],[Currency],[ExVirtualRate],[resettledDate],[IsResettled]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [3rdProduct_Data]
GO


