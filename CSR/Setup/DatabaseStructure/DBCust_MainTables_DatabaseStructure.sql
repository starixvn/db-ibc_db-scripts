/*
	Created by: Helen
	Created Date: 20151007
	Description: DCS 
	Database: DBCUST/CustDB
		
*/
USE CustDB
GO
--- CREATING FILE GROUP AND DATA FILE
IF NOT EXISTS (SELECT TOP 1 1 FROM sys.filegroups where name='CustPTSetting3rd_Member_table')
BEGIN
	ALTER DATABASE CustDB
	ADD FILEGROUP CustPTSetting3rd_Member_table;
END
GO

IF NOT EXISTS (SELECT TOP 1 1 FROM sys.database_files where name='CustPTSetting3rd_Member_table_01')
BEGIN
ALTER DATABASE CustDB 
ADD FILE 
(
	NAME = CustPTSetting3rd_Member_table_01,
	FILENAME = 'H:\USER_DB\CustDB\CustPTSetting3rd_Member_table_01.NDF'
)
TO FILEGROUP CustPTSetting3rd_Member_table;
END
GO
--------
IF NOT EXISTS (SELECT TOP 1 1 FROM sys.filegroups where name='CustPTSetting3rd_Agent_table')
BEGIN
	ALTER DATABASE CustDB
	ADD FILEGROUP CustPTSetting3rd_Agent_table;
END
GO

IF NOT EXISTS (SELECT TOP 1 1 FROM sys.database_files where name='CustPTSetting3rd_Agent_table_01')
BEGIN
ALTER DATABASE CustDB 
ADD FILE 
(
	NAME = CustPTSetting3rd_Agent_table_01,
	FILENAME = 'H:\USER_DB\CustDB\CustPTSetting3rd_Agent_table_01.NDF'
)
TO FILEGROUP CustPTSetting3rd_Agent_table;
END
GO
IF NOT EXISTS (SELECT TOP 1 1 FROM sys.filegroups where name='CustPTGroupSetting3rd_Member_table')
BEGIN
	ALTER DATABASE CustDB
	ADD FILEGROUP CustPTGroupSetting3rd_Member_table;
END
GO

IF NOT EXISTS (SELECT TOP 1 1 FROM sys.database_files where name='CustPTGroupSetting3rd_Member_table_01')
BEGIN
	ALTER DATABASE CustDB 
	ADD FILE 
	(
		NAME = CustPTGroupSetting3rd_Member_table_01,
		FILENAME = 'H:\USER_DB\CustDB\CustPTGroupSetting3rd_Member_table_01.NDF'
	)
	TO FILEGROUP CustPTGroupSetting3rd_Member_table;
END
GO

-------
IF NOT EXISTS (SELECT TOP 1 1 FROM sys.filegroups where name='CustSettingMode3rd_table')
BEGIN
	ALTER DATABASE CustDB
	ADD FILEGROUP CustSettingMode3rd_table;
END
GO

IF NOT EXISTS (SELECT TOP 1 1 FROM sys.database_files where name='CustSettingMode3rd_table_01')
BEGIN
	ALTER DATABASE CustDB 
	ADD FILE 
	(
		NAME = CustSettingMode3rd_table_01,
		FILENAME = 'H:\USER_DB\CustDB\CustSettingMode3rd_table_01.NDF'
	)
	TO FILEGROUP CustSettingMode3rd_table;
END
GO
-------
IF NOT EXISTS (SELECT TOP 1 1 FROM sys.filegroups where name='CustBetSetting3rd_Member_table')
BEGIN
	ALTER DATABASE CustDB
	ADD FILEGROUP CustBetSetting3rd_Member_table;
END
GO

IF NOT EXISTS (SELECT TOP 1 1 FROM sys.database_files where name='CustBetSetting3rd_Member_table_01')
BEGIN
	ALTER DATABASE CustDB 
	ADD FILE 
	(
		NAME = CustBetSetting3rd_Member_table_01,
		FILENAME = 'H:\USER_DB\CustDB\CustBetSetting3rd_Member_table_01.NDF'
	)
	TO FILEGROUP CustBetSetting3rd_Member_table;
END
GO
-------
IF NOT EXISTS (SELECT TOP 1 1 FROM sys.filegroups where name='CustBetSetting3rd_Agent_table')
BEGIN
	ALTER DATABASE CustDB
	ADD FILEGROUP CustBetSetting3rd_Agent_table;
END
GO

IF NOT EXISTS (SELECT TOP 1 1 FROM sys.database_files where name='CustBetSetting3rd_Agent_table_01')
BEGIN
	ALTER DATABASE CustDB 
	ADD FILE 
	(
		NAME = CustBetSetting3rd_Agent_table_01,
		FILENAME = 'H:\USER_DB\CustDB\CustBetSetting3rd_Agent_table_01.NDF'
	)
	TO FILEGROUP CustBetSetting3rd_Agent_table;
END
GO
-------
IF NOT EXISTS (SELECT TOP 1 1 FROM sys.filegroups where name='CustDiscount3rd_Member_table')
BEGIN
	ALTER DATABASE CustDB
	ADD FILEGROUP CustDiscount3rd_Member_table;
END
GO

IF NOT EXISTS (SELECT TOP 1 1 FROM sys.database_files where name='CustDiscount3rd_Member_table_01')
BEGIN
	ALTER DATABASE CustDB 
	ADD FILE 
	(
		NAME = CustBetSetting3rd_Agent_table_01,
		FILENAME = 'H:\USER_DB\CustDB\CustDiscount3rd_Member_table_01.NDF'
	)
	TO FILEGROUP CustDiscount3rd_Member_table;
END
GO
-------
IF NOT EXISTS (SELECT TOP 1 1 FROM sys.filegroups where name='CustDiscount3rd_Agent_table')
BEGIN
	ALTER DATABASE CustDB
	ADD FILEGROUP CustDiscount3rd_Agent_table;
END
GO

IF NOT EXISTS (SELECT TOP 1 1 FROM sys.database_files where name='CustDiscount3rd_Agent_table_01')
BEGIN
	ALTER DATABASE CustDB 
	ADD FILE 
	(
		NAME = CustDiscount3rd_Agent_table_01,
		FILENAME = 'H:\USER_DB\CustDB\CustDiscount3rd_Agent_table_01.NDF'
	)
	TO FILEGROUP CustDiscount3rd_Agent_table;
END
GO
------
IF NOT EXISTS (SELECT TOP 1 1 FROM sys.filegroups where name='CustProductStatus_table')
BEGIN
	ALTER DATABASE CustDB
	ADD FILEGROUP CustProductStatus_table;
END
GO

IF NOT EXISTS (SELECT TOP 1 1 FROM sys.database_files where name='CustProductStatus_table_01')
BEGIN
	ALTER DATABASE CustDB 
	ADD FILE 
	(
		NAME = CustProductStatus_table_01,
		FILENAME = 'H:\USER_DB\CustDB\CustProductStatus_table_01.NDF'
	)
	TO FILEGROUP CustProductStatus_table;
END
GO
------
IF NOT EXISTS (SELECT TOP 1 1 FROM sys.filegroups where name='ProductSettingDetail_table')
BEGIN
	ALTER DATABASE CustDB
	ADD FILEGROUP ProductSettingDetail_table;
END
GO

IF NOT EXISTS (SELECT TOP 1 1 FROM sys.database_files where name='ProductSettingDetail_table_01')
BEGIN
	ALTER DATABASE CustDB 
	ADD FILE 
	(
		NAME = ProductSettingDetail_table_01,
		FILENAME = 'H:\USER_DB\CustDB\ProductSettingDetail_table_01.NDF'
	)
	TO FILEGROUP ProductSettingDetail_table;
END
GO
-------
USE CustDB

GO

CREATE TABLE [dbo].[CustPTSetting3rd_Member](
	[CustID] [int] NOT NULL,
	[SportType] [smallint] NOT NULL,
	[BetType] [smallint] NOT NULL,
	[IsLive] [bit] NOT NULL,
	[SuperPT] [tinyint] NOT NULL,
	[MasterPT] [tinyint] NOT NULL,
	[AgentPT] [tinyint] NOT NULL,
	[IsAutoMasterPT] [bit] NOT NULL,
	[AutoMasterPT] [tinyint] NOT NULL,
	[IsAutoSuperPT] [bit] NOT NULL,
	[AutoSuperPT] [tinyint] NOT NULL,
 CONSTRAINT [PK_CustPTSetting3rd_Member] PRIMARY KEY CLUSTERED 
(
	[CustID] ASC,
	[SportType] ASC,
	[BetType] ASC,
	[IsLive] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [CustPTSetting3rd_Member_Table]
) ON [CustPTSetting3rd_Member_Table]

GO

ALTER TABLE [dbo].[CustPTSetting3rd_Member] ADD  DEFAULT ((0)) FOR [SuperPT]
GO

ALTER TABLE [dbo].[CustPTSetting3rd_Member] ADD  DEFAULT ((0)) FOR [MasterPT]
GO

ALTER TABLE [dbo].[CustPTSetting3rd_Member] ADD  DEFAULT ((0)) FOR [AgentPT]
GO

ALTER TABLE [dbo].[CustPTSetting3rd_Member] ADD  DEFAULT ((0)) FOR [IsAutoMasterPT]
GO

ALTER TABLE [dbo].[CustPTSetting3rd_Member] ADD  DEFAULT ((0)) FOR [AutoMasterPT]
GO

ALTER TABLE [dbo].[CustPTSetting3rd_Member] ADD  DEFAULT ((0)) FOR [IsAutoSuperPT]
GO

ALTER TABLE [dbo].[CustPTSetting3rd_Member] ADD  DEFAULT ((0)) FOR [AutoSuperPT]
GO


CREATE TABLE [dbo].[CustPTSetting3rd_Agent](
	[CustID] [int] NOT NULL,
	[SportType] [smallint] NOT NULL,
	[BetType] [smallint] NOT NULL,
	[IsLive] [bit] NOT NULL,
	[SuperPT] [tinyint] NOT NULL,
	[MasterPT] [tinyint] NOT NULL,
	[AgentPT] [tinyint] NOT NULL,
	[IsAutoMasterPT] [bit] NOT NULL,
	[AutoMasterPT] [tinyint] NOT NULL,
	[IsAutoSuperPT] [bit] NOT NULL,
	[AutoSuperPT] [tinyint] NOT NULL,
	[MinPT] [tinyint] NOT NULL,
	[MaxPT] [tinyint] NOT NULL,
 CONSTRAINT [PK_CustPTSetting3rd_Agent] PRIMARY KEY CLUSTERED 
(
	[CustID] ASC,
	[SportType] ASC,
	[BetType] ASC,
	[IsLive] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [CustPTSetting3rd_Agent_Table]
) ON [CustPTSetting3rd_Agent_Table]

GO

ALTER TABLE [dbo].[CustPTSetting3rd_Agent] ADD  DEFAULT ((0)) FOR [SuperPT]
GO

ALTER TABLE [dbo].[CustPTSetting3rd_Agent] ADD  DEFAULT ((0)) FOR [MasterPT]
GO

ALTER TABLE [dbo].[CustPTSetting3rd_Agent] ADD  DEFAULT ((0)) FOR [AgentPT]
GO

ALTER TABLE [dbo].[CustPTSetting3rd_Agent] ADD  DEFAULT ((0)) FOR [IsAutoMasterPT]
GO

ALTER TABLE [dbo].[CustPTSetting3rd_Agent] ADD  DEFAULT ((0)) FOR [AutoMasterPT]
GO

ALTER TABLE [dbo].[CustPTSetting3rd_Agent] ADD  DEFAULT ((0)) FOR [IsAutoSuperPT]
GO

ALTER TABLE [dbo].[CustPTSetting3rd_Agent] ADD  DEFAULT ((0)) FOR [AutoSuperPT]
GO

ALTER TABLE [dbo].[CustPTSetting3rd_Agent] ADD  DEFAULT ((0)) FOR [MinPT]
GO

ALTER TABLE [dbo].[CustPTSetting3rd_Agent] ADD  DEFAULT ((0.9)) FOR [MaxPT]
GO

CREATE TABLE [dbo].[CustPTGroupSetting3rd_Member](
	[AgentID] [int] NOT NULL,
	[SportType] [smallint] NOT NULL,
	[BetType] [smallint] NOT NULL,
	[IsLive] [bit] NOT NULL,
	[SuperPT] [tinyint] NOT NULL,
	[MasterPT] [tinyint] NOT NULL,
	[AgentPT] [tinyint] NOT NULL,
	[IsAutoMasterPT] [bit] NOT NULL,
	[AutoMasterPT] [tinyint] NOT NULL,
	[IsAutoSuperPT] [bit] NOT NULL,
	[AutoSuperPT] [tinyint] NOT NULL,
 CONSTRAINT [PK_CustPTGroupSetting3rd_Member] PRIMARY KEY CLUSTERED 
(
	[AgentID] ASC,
	[SportType] ASC,
	[BetType] ASC,
	[IsLive] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [CustPTGroupSetting3rd_Member_table]
) ON [CustPTGroupSetting3rd_Member_table]

GO

ALTER TABLE [dbo].[CustPTGroupSetting3rd_Member] ADD  DEFAULT ((0)) FOR [SuperPT]
GO

ALTER TABLE [dbo].[CustPTGroupSetting3rd_Member] ADD  DEFAULT ((0)) FOR [MasterPT]
GO

ALTER TABLE [dbo].[CustPTGroupSetting3rd_Member] ADD  DEFAULT ((0)) FOR [AgentPT]
GO

ALTER TABLE [dbo].[CustPTGroupSetting3rd_Member] ADD  DEFAULT ((0)) FOR [IsAutoMasterPT]
GO

ALTER TABLE [dbo].[CustPTGroupSetting3rd_Member] ADD  DEFAULT ((0)) FOR [AutoMasterPT]
GO

ALTER TABLE [dbo].[CustPTGroupSetting3rd_Member] ADD  DEFAULT ((0)) FOR [IsAutoSuperPT]
GO

ALTER TABLE [dbo].[CustPTGroupSetting3rd_Member] ADD  DEFAULT ((0)) FOR [AutoSuperPT]
GO


CREATE TABLE [dbo].[CustSettingMode3rd](
	[CustID] [int] NOT NULL,
	[IsGrouped] [bit] NOT NULL,
 CONSTRAINT [PK_CustSettingMode3rd] PRIMARY KEY CLUSTERED 
(
	[CustID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [CustSettingMode3rd_table]
) ON [CustSettingMode3rd_table]

GO

ALTER TABLE [dbo].[CustSettingMode3rd] ADD  DEFAULT ((1)) FOR [IsGrouped]
GO

CREATE TABLE [dbo].[CustBetSetting3rd_Member](
	[CustID] [int] NOT NULL,
	[SportType] [smallint] NOT NULL,
	[BetType] [smallint] NOT NULL,
	[MinBet] [money] NULL,
	[MaxBet] [money] NULL,
	[MaxPerMatch] [money] NULL,
 CONSTRAINT [PK_CustBetSetting3rd_Member] PRIMARY KEY CLUSTERED 
(
	[CustID] ASC,
	[SportType] ASC,
	[BetType] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [CustBetSetting3rd_Member_Table]
) ON [CustBetSetting3rd_Member_Table]

GO

ALTER TABLE [dbo].[CustBetSetting3rd_Member] ADD  DEFAULT ((0)) FOR [MinBet]
GO

ALTER TABLE [dbo].[CustBetSetting3rd_Member] ADD  DEFAULT ((0)) FOR [MaxBet]
GO

ALTER TABLE [dbo].[CustBetSetting3rd_Member] ADD  DEFAULT ((0)) FOR [MaxPerMatch]
GO

CREATE TABLE [dbo].[CustBetSetting3rd_Agent](
	[CustID] [int] NOT NULL,
	[SportType] [smallint] NOT NULL,
	[BetType] [smallint] NOT NULL,
	[MinBet] [money] NULL,
	[MaxBet] [money] NULL,
	[MaxPerMatch] [money] NULL,
 CONSTRAINT [PK_CustBetSetting3rd_Agent] PRIMARY KEY CLUSTERED 
(
	[CustID] ASC,
	[SportType] ASC,
	[BetType] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [CustBetSetting3rd_Agent_Table]
) ON [CustBetSetting3rd_Agent_Table]

GO

ALTER TABLE [dbo].[CustBetSetting3rd_Agent] ADD  DEFAULT ((0)) FOR [MinBet]
GO

ALTER TABLE [dbo].[CustBetSetting3rd_Agent] ADD  DEFAULT ((0)) FOR [MaxBet]
GO

ALTER TABLE [dbo].[CustBetSetting3rd_Agent] ADD  DEFAULT ((0)) FOR [MaxPerMatch]
GO


CREATE TABLE [dbo].[CustDiscount3rd_Member](
	[CustID] [int] NOT NULL,
	[SportType] [smallint] NOT NULL,
	[BetType] [smallint] NOT NULL,
	[PlayerDiscount] [decimal](9, 8) NOT NULL,
	[AgentDiscount] [decimal](9, 8) NOT NULL,
	[MasterDiscount] [decimal](9, 8) NOT NULL,
	[SuperDiscount] [decimal](9, 8) NOT NULL,
 CONSTRAINT [PK_CustDiscount3rd_Member] PRIMARY KEY CLUSTERED 
(
	[CustID] ASC,
	[SportType] ASC,
	[BetType] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [CustDiscount3rd_Member_Table]
) ON [CustDiscount3rd_Member_Table]

GO

ALTER TABLE [dbo].[CustDiscount3rd_Member] ADD  DEFAULT ((0)) FOR [PlayerDiscount]
GO

ALTER TABLE [dbo].[CustDiscount3rd_Member] ADD  DEFAULT ((0)) FOR [AgentDiscount]
GO

ALTER TABLE [dbo].[CustDiscount3rd_Member] ADD  DEFAULT ((0)) FOR [MasterDiscount]
GO

ALTER TABLE [dbo].[CustDiscount3rd_Member] ADD  DEFAULT ((0)) FOR [SuperDiscount]
GO

CREATE TABLE [dbo].[CustDiscount3rd_Agent](
	[CustID] [int] NOT NULL,
	[SportType] [smallint] NOT NULL,
	[BetType] [smallint] NOT NULL,
	[Discount] [decimal](9, 8) NOT NULL,
 CONSTRAINT [PK_CustDiscount3rd_Agent] PRIMARY KEY CLUSTERED 
(
	[CustID] ASC,
	[SportType] ASC,
	[BetType] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [CustDiscount3rd_Agent_Table]
) ON [CustDiscount3rd_Agent_Table]

GO

ALTER TABLE [dbo].[CustDiscount3rd_Agent] ADD  DEFAULT ((0)) FOR [Discount]
GO

CREATE TABLE [dbo].[CustProductStatus](
	[CustID] [int] NOT NULL,
	[bitmapHasSynced] [binary](32) NOT NULL,
	[bitmapIsHidden] [binary](32) NOT NULL,
	[bitmapIsDisabled] [binary](32) NOT NULL,
 CONSTRAINT [CIX_custid] PRIMARY KEY CLUSTERED 
(
	[CustID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [CustProductStatus_Table]
) ON [CustProductStatus_Table]

GO

SET ANSI_PADDING OFF
GO

ALTER TABLE [dbo].[CustProductStatus] ADD  CONSTRAINT [DF_CustPRoductStatus_bitmapHasSynced]  DEFAULT (0x00) FOR [bitmapHasSynced]
GO

ALTER TABLE [dbo].[CustProductStatus] ADD  CONSTRAINT [DF_CustPRoductStatus_bitmapIsHidden]  DEFAULT (0x00) FOR [bitmapIsHidden]
GO

ALTER TABLE [dbo].[CustProductStatus] ADD  CONSTRAINT [DF_CustPRoductStatus_bitmapIsDisabled]  DEFAULT (0x00) FOR [bitmapIsDisabled]
GO


-----------------
CREATE TABLE [dbo].[ProductSettingDetail](
	[SettingType] [smallint] NOT NULL,
	[SportType] [smallint] NOT NULL,
	[BetType] [smallint] NOT NULL,
	[IsLive] [bit] NOT NULL,
	[ProductID] [tinyint] NOT NULL,
	[MaxPT] [tinyint] NULL,
	[MaxDiscount] [decimal](9, 8) NULL,
	[IsSync] [bit] NULL,
	[IsHidden] [bit] NULL,
	[IsDisabled] [bit] NULL,
	[SettingLevel] [tinyint] NULL,
	[DisplayOrder] [tinyint] NOT NULL,
	[SettingStatus] [tinyint] NULL,
 CONSTRAINT [PK_ProductSettingDetail] PRIMARY KEY CLUSTERED 
(
	[SettingType] ASC,
	[SportType] ASC,
	[BetType] ASC,
	[IsLive] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [ProductSettingDetail_table]
) ON [ProductSettingDetail_table]

GO

ALTER TABLE [dbo].[ProductSettingDetail] ADD  DEFAULT ((0.9)) FOR [MaxPT]
GO

ALTER TABLE [dbo].[ProductSettingDetail] ADD  DEFAULT ((0.01)) FOR [MaxDiscount]
GO

ALTER TABLE [dbo].[ProductSettingDetail] ADD  DEFAULT ((0)) FOR [IsSync]
GO

ALTER TABLE [dbo].[ProductSettingDetail] ADD  DEFAULT ((1)) FOR [IsHidden]
GO

ALTER TABLE [dbo].[ProductSettingDetail] ADD  DEFAULT ((0)) FOR [IsDisabled]
GO

ALTER TABLE [dbo].[ProductSettingDetail] ADD  DEFAULT ((0)) FOR [DisplayOrder]
GO

ALTER TABLE [dbo].[ProductSettingDetail] ADD  DEFAULT ((0)) FOR [SettingStatus]
GO
CREATE TABLE [dbo].[ProductSettingSystemDisplay](
	[SystemID] [tinyint] NOT NULL,
	[ProductID] [tinyint] NOT NULL,
	[SettingType] [smallint] NOT NULL,
	[DisplayMode] [tinyint] NULL,
 CONSTRAINT [PK_ProductSettingSystemDisplay] PRIMARY KEY CLUSTERED 
(
	[SystemID] ASC,
	[ProductID] ASC,
	[SettingType] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [ProductSettingDetail_table]
) ON [ProductSettingDetail_table]

GO

CREATE TABLE [dbo].[SettingSystem](
	[SystemID] [tinyint] NOT NULL,
	[SystemName] [varchar](50) NULL,
	[Description] [varchar](100) NULL,
	[SystemPrefix] [varchar](10) NULL,
 CONSTRAINT [PK_SettingSystem] PRIMARY KEY CLUSTERED 
(
	[SystemID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [ProductSettingDetail_table]
) ON [ProductSettingDetail_table]

GO
CREATE TABLE [dbo].[ProductStatusProfile](
	[Sporttype] [smallint] NOT NULL,
	[Bettype] [smallint] NOT NULL,
	[bitmapOrder] [tinyint] NOT NULL,
 CONSTRAINT [PK_ProductStatusProfile] PRIMARY KEY NONCLUSTERED 
(
	[Sporttype] ASC,
	[Bettype] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [ProductSettingDetail_table]
) ON [ProductSettingDetail_table]

GO






