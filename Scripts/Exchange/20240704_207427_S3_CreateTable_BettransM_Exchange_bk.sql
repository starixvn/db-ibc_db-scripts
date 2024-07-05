/*<info serverAlias="DBLIC-bodb_3rdProduct"></info>*/
/*
	Created: 20240704@Kelvin
	DB: DBLIC-bodb_3rdProduct
	Task: Exchange - Archive data before 2022 [RedmineID: #207427]		
*/

USE [bodb_3rdProduct]
GO

/****** Object:  Table [dbo].[BettransM_Exchange_bk]    Script Date: 7/4/2024 2:01:02 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO
--DROP TABLE [BettransM_Exchange_bk]
CREATE TABLE [dbo].[BettransM_Exchange_bk](
	[TransID] [bigint] NOT NULL,
	[BetID] [bigint] NOT NULL,
	[betTaken] [datetime] NULL,
	[txStake] [money] NULL,
	[txOddsMatched] [smallmoney] NULL,
	[actualOdds] [smallmoney] NULL,
	[txFancyBetRuns] [money] NULL,
 CONSTRAINT [PK_BettransM_Exchange_bk] PRIMARY KEY CLUSTERED 
(
	[TransID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [3rdProduct_Data]
) ON [3rdProduct_Data]
GO

/****** Object:  Index [IX_BetID]    Script Date: 7/4/2024 2:01:02 PM ******/
CREATE NONCLUSTERED INDEX [IX_BetID] ON [dbo].[BettransM_Exchange_bk]
(
	[BetID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [3rdProduct_Data]
GO


