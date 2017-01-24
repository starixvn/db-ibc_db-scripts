/*
	Created: 20170120@Helen
	Task: Migrate data - https://nexdev.net/issues/61220
	DB: DBCUST/CUSTDB
*/

USE [CustDB]
GO
CREATE TABLE PRO_WinLimit_CustGameMonitoring(
	[CustID] [int] NOT NULL,
	[ProductID] [tinyint] NOT NULL,
	[BettypeID] [smallint] NOT NULL,
	[WinlostDate] [smalldatetime] NOT NULL,
	[LevelID] [tinyint] NOT NULL,
	[MaxWinLimit] [money] NOT NULL,
	[TotalWinAmt] [money] NOT NULL,
	[WinAmt] [money] NOT NULL,
	[ModifiedDate] [datetime] NOT NULL,
	[IsNotified] [bit] NOT NULL,
	[ModifiedBy] [int] NULL,
	[CreatedBy] [int] NULL,
 CONSTRAINT [PK_PRO_WinLimit_CustGameMonitoring] PRIMARY KEY CLUSTERED 
(
	[CustID] ASC,
	[ProductID] ASC,
	[BettypeID] ASC,
	[WinlostDate] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [WinlimitSetting_Tables]
) ON [WinlimitSetting_Tables]

GO
CREATE TABLE [dbo].[PRO_WinLimit_CustGameMonitoring_History](
	[LogID] [bigint] IDENTITY(1,1) NOT NULL,
	[CustID] [int] NOT NULL,
	[ProductID] [tinyint] NOT NULL,
	[BettypeID] [smallint] NOT NULL,
	[WinlostDate] [smalldatetime] NOT NULL,
	[LevelID] [tinyint] NOT NULL,
	[MaxWinLimit] [money] NOT NULL,
	[TotalWinAmt] [money] NOT NULL,
	[WinAmt] [money] NOT NULL,
	[ActionID] [tinyint] NOT NULL,
	[ModifiedDate] [datetime] NOT NULL,
	[IsNotified] [bit] NOT NULL,
	[ModifiedBy] [int] NULL,
	[CreatedBy] [int] NULL,
 CONSTRAINT [PK_PRO_WinLimit_CustGameMonitoring_History] PRIMARY KEY NONCLUSTERED 
(
	[LogID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [WinlimitSetting_Tables]
) ON [WinlimitSetting_Tables]

GO

CREATE TABLE [dbo].[PRO_WinLimit_CustGameSetting](
	[CustID] [int] NOT NULL,
	[ProductID] [tinyint] NOT NULL,
	[BettypeID] [smallint] NOT NULL,
	[LevelID] [tinyint] NOT NULL,
	[MaxWinLimit] [money] NOT NULL,
 CONSTRAINT [PK_PRO_WinLimit_CustGameSetting] PRIMARY KEY CLUSTERED 
(
	[CustID] ASC,
	[ProductID] ASC,
	[BettypeID] ASC,
	[LevelID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [WinlimitSetting_Tables]
) ON [WinlimitSetting_Tables]

GO

CREATE TABLE [dbo].[PRO_WinLimit_ProductSettingDetail](
	[ProductID] [tinyint] NOT NULL,
	[BettypeID] [smallint] NOT NULL,
	[ExchangeID] [int] NOT NULL,
	[SiteID] [int] NOT NULL,
	[LevelID] [tinyint] NOT NULL,
	[MaxWinLimit] [money] NOT NULL,
	[IsBlockedPlaceBet] [bit] NOT NULL,
	[IsBlockedTransfer] [bit] NOT NULL,
 CONSTRAINT [PK_PRO_WinLimit_ProductSettingDetail] PRIMARY KEY CLUSTERED 
(
	[ProductID] ASC,
	[BettypeID] ASC,
	[ExchangeID] ASC,
	[SiteID] ASC,
	[LevelID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [WinlimitSetting_Tables]
) ON [WinlimitSetting_Tables]

GO

CREATE CLUSTERED INDEX [CIX_CustID_ProductID_BetTypeID_WinlostDate] ON [dbo].[PRO_WinLimit_CustGameMonitoring_History]
(
	[CustID] ASC,
	[ProductID] ASC,
	[BettypeID] ASC,
	[WinlostDate] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [WinlimitSetting_Tables]
GO

ALTER TABLE [dbo].[PRO_WinLimit_CustGameMonitoring] ADD  CONSTRAINT [DF_PRO_WinLimit_CustGameMonitoring_MaxWinLimit]  DEFAULT ((0)) FOR [MaxWinLimit]
GO

ALTER TABLE [dbo].[PRO_WinLimit_CustGameMonitoring] ADD  CONSTRAINT [DF_PRO_WinLimit_CustGameMonitoring_TotalWinAmt]  DEFAULT ((0)) FOR [TotalWinAmt]
GO

ALTER TABLE [dbo].[PRO_WinLimit_CustGameMonitoring] ADD  CONSTRAINT [DF_PRO_WinLimit_CustGameMonitoring_WinAmt]  DEFAULT ((0)) FOR [WinAmt]
GO

ALTER TABLE [dbo].[PRO_WinLimit_CustGameMonitoring_History] ADD  CONSTRAINT [DF_PRO_WinLimit_CustGameMonitoring_History_MaxWinLimit]  DEFAULT ((0)) FOR [MaxWinLimit]
GO

ALTER TABLE [dbo].[PRO_WinLimit_CustGameMonitoring_History] ADD  CONSTRAINT [DF_PRO_WinLimit_CustGameMonitoring_History_TotalWinAmt]  DEFAULT ((0)) FOR [TotalWinAmt]
GO

ALTER TABLE [dbo].[PRO_WinLimit_CustGameMonitoring_History] ADD  CONSTRAINT [DF_PRO_WinLimit_CustGameMonitoring_History_WinAmt]  DEFAULT ((0)) FOR [WinAmt]
GO

ALTER TABLE [dbo].[PRO_WinLimit_CustGameMonitoring_History] ADD  CONSTRAINT [DF_PRO_WinLimit_CustGameMonitoring_History_ActionID]  DEFAULT ((0)) FOR [ActionID]
GO

ALTER TABLE [dbo].[PRO_WinLimit_CustGameSetting] ADD  CONSTRAINT [DF_PRO_WinLimit_CustGameSetting_MaxWinLimit]  DEFAULT ((0)) FOR [MaxWinLimit]
GO

ALTER TABLE [dbo].[PRO_WinLimit_ProductSettingDetail] ADD  CONSTRAINT [DF_PRO_WinLimit_ProductSettingDetail_MaxWinLimit]  DEFAULT ((0)) FOR [MaxWinLimit]
GO

ALTER TABLE [dbo].[PRO_WinLimit_ProductSettingDetail] ADD  CONSTRAINT [DF_PRO_WinLimit_ProductSettingDetail_IsBlockedPlaceBet]  DEFAULT ((0)) FOR [IsBlockedPlaceBet]
GO

ALTER TABLE [dbo].[PRO_WinLimit_ProductSettingDetail] ADD  CONSTRAINT [DF_PRO_WinLimit_ProductSettingDetail_IsBlockedTransfer]  DEFAULT ((0)) FOR [IsBlockedTransfer]
GO

INSERT INTO PRO_WinLimit_CustGameSetting (CustID, ProductID, BettypeID, LevelID, MaxWinLimit)
SELECT CustID, ProductID, BettypeID, LevelID, MaxWinLimit
FROM WinLimit_CustGameSetting WITH (NOLOCK)

GO
INSERT INTO PRO_WinLimit_ProductSettingDetail(ProductID, BettypeID, ExchangeID, SiteID, LevelID, MaxWinLimit, IsBlockedPlaceBet, IsBlockedTransfer)
SELECT ProductID, BettypeID, ExchangeID, SiteID, LevelID, MaxWinLimit, IsBlockedPlaceBet, IsBlockedTransfer
FROM WinLimit_ProductSettingDetail WITH (NOLOCK)
GO

INSERT INTO PRO_WinLimit_CustGameMonitoring(CustID, ProductID, BettypeID, WinlostDate, LevelID, MaxWinLimit, TotalWinAmt, WinAmt, ModifiedDate, IsNotified, ModifiedBy, CreatedBy)
SELECT CustID, ProductID, BettypeID, WinlostDate, LevelID, MaxWinLimit, TotalWinAmt, WinAmt, ModifiedDate, IsNotified, ModifiedBy, CreatedBy 
FROM WinLimit_CustGameMonitoring WITH (NOLOCK)

GO
INSERT INTO PRO_WinLimit_CustGameMonitoring_History (CustID, ProductID, BettypeID, WinlostDate, LevelID, MaxWinLimit, TotalWinAmt, WinAmt, ActionID, ModifiedDate, IsNotified, ModifiedBy, CreatedBy)
SELECT  CustID, ProductID, BettypeID, WinlostDate, LevelID, MaxWinLimit, TotalWinAmt, WinAmt, ActionID, ModifiedDate, IsNotified, ModifiedBy, CreatedBy
FROM WinLimit_CustGameMonitoring_History WITH (NOLOCK)