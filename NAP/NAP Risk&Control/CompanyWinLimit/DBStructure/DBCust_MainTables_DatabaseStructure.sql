/*
	Created by: Helen
	Created Date: 20160613
	Description: Company Win Limit Structure - Phase 2 
	Database: DBCUST/CustDB
	
	Local Test: D:\DB233\IBC_DB\CustDB
	Local Dev: D:\SQLSERVER2008R2\IBC_DB\CustDB
	Production: H:\USER_DB\CustDB
		
*/
USE CustDB
GO

--- CREATING FILE GROUP AND DATA FILE

IF NOT EXISTS (SELECT TOP 1 1 FROM sys.filegroups where name='WinlimitSetting_Tables')
BEGIN
	ALTER DATABASE CustDB
	ADD FILEGROUP WinlimitSetting_Tables;
END
GO

IF NOT EXISTS (SELECT TOP 1 1 FROM sys.database_files where name='WinlimitSetting_Tables_01')
BEGIN
	ALTER DATABASE CustDB 
	ADD FILE 
	(
		NAME = WinlimitSetting_Tables_01,
		-- local dev
		--FILENAME = 'D:\SQLSERVER2008R2\IBC_DB\CustDB\WinlimitSetting_Tables_01.NDF'
		-- local test
		--FILENAME = 'D:\DB233\IBC_DB\CustDB\WinlimitSetting_Tables_01.NDF'
		-- Production
		FILENAME = 'H:\USER_DB\CustDB\WinlimitSetting_Tables_01.NDF'
		-- SIT
		--FILENAME = 'H:\USER_DB\CustDB\WinlimitSetting_Tables_01.NDF'
		
	)
	TO FILEGROUP WinlimitSetting_Tables;
END
GO


USE CustDB

GO

CREATE TABLE [dbo].[WinLimit_CustGameSetting](
	[CustID] [int] NOT NULL,
	[ProductID] [tinyint] NOT NULL,
	[BettypeID] [smallint] NOT NULL,
	[LevelID]	[tinyint] NOT NULL,
	[MaxWinLimit] [money] NOT NULL
 CONSTRAINT [PK_WinLimit_CustGameSetting] PRIMARY KEY CLUSTERED 
(
	[CustID] ASC,
	[ProductID] ASC,
	[BettypeID] ASC,
	[LevelID]
	
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [WinlimitSetting_Tables]
) ON [WinlimitSetting_Tables]

GO
ALTER TABLE [dbo].[WinLimit_CustGameSetting] ADD CONSTRAINT [DF_WinLimit_CustGameSetting_MaxWinLimit] DEFAULT ((0)) FOR [MaxWinLimit]
GO
CREATE TABLE [dbo].[WinLimit_CustGameStatus](
	[CustID] [int] NOT NULL,
	[ProductID] [tinyint] NOT NULL,
	[BettypeID] [smallint] NOT NULL,
	[IsBlockedPlaceBet]	[bit] NOT NULL,
	[IsBlockedTransfer] [bit] NOT NULL,
	[ActionID] [tinyint] NOT NULL,
	[ModifiedDate] [datetime] NOT NULL
 CONSTRAINT [PK_WinLimit_CustGameStatus] PRIMARY KEY CLUSTERED 
(
	[CustID] ASC,
	[ProductID] ASC,
	[BettypeID] ASC
	
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [WinlimitSetting_Tables]
) ON [WinlimitSetting_Tables]

GO
ALTER TABLE [dbo].[WinLimit_CustGameStatus] ADD  CONSTRAINT [DF_WinLimit_CustGameStatus_IsBlockedPlaceBet] DEFAULT ((0)) FOR [IsBlockedPlaceBet]
GO
ALTER TABLE [dbo].[WinLimit_CustGameStatus] ADD  CONSTRAINT [DF_WinLimit_CustGameStatus_IsBlockedTransfer] DEFAULT ((0)) FOR [IsBlockedTransfer]
go
ALTER TABLE [dbo].[WinLimit_CustGameStatus] ADD  CONSTRAINT [DF_WinLimit_CustGameStatus_ActionID] DEFAULT ((0)) FOR [ActionID]

GO
CREATE TABLE [dbo].[Winlimit_LevelSetting](
	[LevelID] [tinyint] NOT NULL,
	[LevelName] [varchar](50) NOT NULL
	
 CONSTRAINT [PK_Winlimit_LevelSetting] PRIMARY KEY CLUSTERED 
(
	[LevelID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [WinlimitSetting_Tables]
) ON [WinlimitSetting_Tables]

GO

CREATE TABLE [dbo].[Winlimit_ActionSetting](
	[ActionID] [tinyint] NOT NULL,
	[ActionName] [varchar](50) NOT NULL
 CONSTRAINT [PK_Winlimit_ActionSetting] PRIMARY KEY CLUSTERED 
(
	[ActionID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [WinlimitSetting_Tables]
) ON [WinlimitSetting_Tables]

GO

CREATE TABLE [dbo].[Winlimit_ProductSetting](
	[ProductID] [tinyint] NOT NULL,
	[BettypeID] [smallint] NOT NULL,
	[LevelID]	[tinyint] NOT NULL,
	[SettingStatus] [tinyint] NOT NULL
 CONSTRAINT [PK_Winlimit_ProductSetting] PRIMARY KEY CLUSTERED 
(
	[ProductID] ASC,
	[BettypeID] ASC,
	[LevelID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [WinlimitSetting_Tables]
) ON [WinlimitSetting_Tables]

ALTER TABLE [dbo].[Winlimit_ProductSetting] ADD CONSTRAINT [DF_Winlimit_ProductSetting_SettingStatus] DEFAULT ((0)) FOR [SettingStatus]

GO

CREATE TABLE [dbo].[WinLimit_ProductSettingDetail](
	[ProductID] [tinyint] NOT NULL,
	[BettypeID] [smallint] NOT NULL,
	[ExchangeID] [int] NOT NULL,
	[SiteID]	[int] NOT NULL,
	[LevelID]	[tinyint] NOT NULL,
	[MaxWinLimit] [money] NOT NULL,
	[IsBlockedPlaceBet] [bit] NOT NULL,
	[IsBlockedTransfer] [bit] NOT NULL
	
 CONSTRAINT [PK_WinLimit_ProductSettingDetail] PRIMARY KEY CLUSTERED 
(
	[ProductID] ASC,
	[BettypeID] ASC,
	[ExchangeID] ASC,
	[SiteID] ASC,
	[LevelID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [WinlimitSetting_Tables]
) ON [WinlimitSetting_Tables]

ALTER TABLE [dbo].[WinLimit_ProductSettingDetail] ADD CONSTRAINT [DF_WinLimit_ProductSettingDetail_MaxWinLimit]  DEFAULT ((0)) FOR [MaxWinLimit]
go
ALTER TABLE [dbo].[WinLimit_ProductSettingDetail] ADD CONSTRAINT [DF_WinLimit_ProductSettingDetail_IsBlockedPlaceBet] DEFAULT ((0)) FOR [IsBlockedPlaceBet]
GO
ALTER TABLE [dbo].[WinLimit_ProductSettingDetail] ADD CONSTRAINT [DF_WinLimit_ProductSettingDetail_IsBlockedTransfer] DEFAULT ((0)) FOR [IsBlockedTransfer]
GO
CREATE TABLE [dbo].[WinLimit_CustGameMonitoring](
	[CustID] [int] NOT NULL,
	[ProductID] [tinyint] NOT NULL,
	[BettypeID] [smallint] NOT NULL,
	[WinlostDate] [smalldatetime] NOT NULL,
	[LevelID]	[tinyint] NOT NULL,
	[MaxWinLimit] [money] NOT NULL,
	[TotalWinAmt] [money] NOT NULL,
	[WinAmt] [money] NOT NULL,
	[ModifiedDate] [datetime] NOT NULL,
	[IsNotified] [bit] NOT NULL,
	[ModifiedBy] [int],
	[CreatedBy] [int]
	
	
 CONSTRAINT [PK_WinLimit_CustGameMonitoring] PRIMARY KEY CLUSTERED 
(
	[CustID] ASC,
	[ProductID] ASC,
	[BettypeID] ASC,
	[WinlostDate] ASC
	
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [WinlimitSetting_Tables]
) ON [WinlimitSetting_Tables]

GO
ALTER TABLE [dbo].[WinLimit_CustGameMonitoring] ADD  CONSTRAINT [DF_WinLimit_CustGameMonitoring_MaxWinLimit] DEFAULT ((0)) FOR [MaxWinLimit]
GO
ALTER TABLE [dbo].[WinLimit_CustGameMonitoring] ADD  CONSTRAINT [DF_WinLimit_CustGameMonitoring_TotalWinAmt] DEFAULT ((0)) FOR [TotalWinAmt]
GO
ALTER TABLE [dbo].[WinLimit_CustGameMonitoring] ADD  CONSTRAINT [DF_WinLimit_CustGameMonitoring_WinAmt] DEFAULT ((0)) FOR [WinAmt]
GO

CREATE TABLE [dbo].[WinLimit_CustGameMonitoring_History](
	[LogID] [bigint] IDENTITY NOT NULL,
	[CustID] [int] NOT NULL,
	[ProductID] [tinyint] NOT NULL,
	[BettypeID] [smallint] NOT NULL,
	[WinlostDate] [smalldatetime] NOT NULL,
	[LevelID]	[tinyint] NOT NULL,
	[MaxWinLimit] [money] NOT NULL,
	[TotalWinAmt] [money] NOT NULL,
	[WinAmt] [money] NOT NULL,
	[ActionID] [tinyint] NOT NULL,
	[ModifiedDate] [datetime] NOT NULL,
	[IsNotified] [bit] NOT NULL,
	[ModifiedBy] [int],
	[CreatedBy] [int]
	
 CONSTRAINT [PK_WinLimit_CustGameMonitoring_History] PRIMARY KEY NONCLUSTERED  ([LogID])

WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [WinlimitSetting_Tables]
) ON [WinlimitSetting_Tables]

GO
CREATE CLUSTERED INDEX CIX_CustID_ProductID_BetTypeID_WinlostDate ON [WinLimit_CustGameMonitoring_History] (CustID,ProductID,BetTypeID,WinlostDate)
GO
ALTER TABLE [dbo].[WinLimit_CustGameMonitoring_History] ADD CONSTRAINT [DF_WinLimit_CustGameMonitoring_History_MaxWinLimit] DEFAULT ((0)) FOR [MaxWinLimit]
GO
ALTER TABLE [dbo].[WinLimit_CustGameMonitoring_History] ADD CONSTRAINT [DF_WinLimit_CustGameMonitoring_History_TotalWinAmt] DEFAULT ((0)) FOR [TotalWinAmt]
GO
ALTER TABLE [dbo].[WinLimit_CustGameMonitoring_History] ADD CONSTRAINT [DF_WinLimit_CustGameMonitoring_History_WinAmt] DEFAULT ((0)) FOR [WinAmt]
go
ALTER TABLE [dbo].[WinLimit_CustGameMonitoring_History] ADD CONSTRAINT [DF_WinLimit_CustGameMonitoring_History_ActionID] DEFAULT ((0)) FOR [ActionID]
GO