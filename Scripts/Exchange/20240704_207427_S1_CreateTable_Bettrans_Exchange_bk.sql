/*<info serverAlias="DBLIC-bodb_3rdProduct"></info>*/
/*
	Created: 20240704@Kelvin
	DB: DBLIC-bodb_3rdProduct
	Task: Exchange - Archive data before 2022 [RedmineID: #207427]		
*/


USE [bodb_3rdProduct]
GO

/****** Object:  Table [dbo].[Bettrans_Exchange_bk]    Script Date: 7/4/2024 11:23:29 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[Bettrans_Exchange_bk](
	[site] [tinyint] NULL,
	[currencyType] [tinyint] NULL,
	[eventType] [int] NULL,
	[eventTypeName] [varchar](50) NULL,
	[eventName] [varchar](500) NULL,
	[eventID] [int] NULL,
	[marketName] [varchar](500) NULL,
	[marketID] [varchar](50) NULL,
	[selectionName] [varchar](100) NULL,
	[selectionID] [int] NULL,
	[matchType] [varchar](10) NULL,
	[betID] [bigint] NOT NULL,
	[betPlaced] [datetime] NULL,
	[ip] [varchar](45) NULL,
	[matchOddsReq] [smallmoney] NULL,
	[unMatchAmount] [money] NULL,
	[reduction] [money] NULL,
	[userId] [varchar](16) NOT NULL,
	[extension1] [char](7) NULL,
	[matchStake] [money] NULL,
	[matchAvgOdds] [smallmoney] NULL,
	[profitLoss] [money] NULL,
	[dateMatched] [datetime] NULL,
	[tstamp] [timestamp] NOT NULL,
	[betstatus] [varchar](15) NULL,
	[APIEndDate] [datetime] NULL,
	[fancyBetRuns] [money] NULL,
	[categoryType] [smallint] NULL,
 CONSTRAINT [PK_Bettrans_Exchange_bk] PRIMARY KEY CLUSTERED 
(
	[betID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [3rdProduct_Data]
) ON [3rdProduct_Data]
GO

/****** Object:  Index [IX_betPlaced]    Script Date: 7/4/2024 11:23:29 AM ******/
CREATE NONCLUSTERED INDEX [IX_betPlaced] ON [dbo].[Bettrans_Exchange_bk]
(
	[betPlaced] ASC
)
INCLUDE([userId],[eventTypeName],[matchStake]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [3rdProduct_Data]
GO

/****** Object:  Index [IX_tstamp]    Script Date: 7/4/2024 11:23:29 AM ******/
CREATE NONCLUSTERED INDEX [IX_tstamp] ON [dbo].[Bettrans_Exchange_bk]
(
	[tstamp] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [3rdProduct_Data]
GO

SET ANSI_PADDING ON
GO

/****** Object:  Index [IX_UserId]    Script Date: 7/4/2024 11:23:29 AM ******/
CREATE NONCLUSTERED INDEX [IX_UserId] ON [dbo].[Bettrans_Exchange_bk]
(
	[userId] ASC,
	[eventID] ASC,
	[marketID] ASC
)
INCLUDE([betstatus],[matchType],[matchStake]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [3rdProduct_Data]
GO


