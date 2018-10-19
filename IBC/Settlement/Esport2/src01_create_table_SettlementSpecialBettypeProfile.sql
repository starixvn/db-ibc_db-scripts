/*
	Created: Vicky
	Task: create table SettlementSpecialBettypeProfile
	DB: DBTXN/bodb02
	Date: 20180912
*/
USE [bodb02]
GO
/****** Object:  Table [dbo].[SettlementSpecialBettypeProfile]    Script Date: 09/20/2018 17:56:09 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[SettlementSpecialBettypeProfile](
	[pfID] [smallint] NOT NULL,
	[SportType] [tinyint] NOT NULL,
	[BetType] [smallint] NOT NULL,
	[BetID] [bigint] NOT NULL,
	[ResourceID] [varchar](20) NOT NULL,
	[SettleType] [char](3) NOT NULL,
	[GroupType] [char](2) NOT NULL,
	[OrdNo] [smallint] NULL,
	[RoundID] [varchar](10) NULL
) ON [DATA]
GO



CREATE CLUSTERED INDEX [IX_SettlementSpecialBettypeProfile_resourceid_sporttype] ON [dbo].[SettlementSpecialBettypeProfile] 
(
	[ResourceID] ASC,
	[SportType] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [DATA]
GO



