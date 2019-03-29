USE [bodb_3rdProduct]
GO

/*
	Created: 20190329@Percy
	DB: DBLIC.bodb_3rdProduct
	Task: New table for checking Exchange data monthly
*/

CREATE TABLE [dbo].[Sum_winloss_Exchange_CheckData](
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
	CONSTRAINT [PK_Sum_winloss_Exchange_CheckData] PRIMARY KEY CLUSTERED 
	(
		[userId] ASC,
		[marketID] ASC,
		[eventID] ASC,
		[settledDate] ASC
	)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [3rdProduct_Data]
) ON [3rdProduct_Data]
GO