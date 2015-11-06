/*
	Created by: Helen
	Created Date: 20151007
	Description: DCS 
	Database: DB05/bodb_Customer
		
*/
USE bodb_Customer
GO
--- CREATING FILE GROUP AND DATA FILE
IF NOT EXISTS (SELECT TOP 1 1 FROM sys.filegroups where name='CustPTSetting3rd_table')
BEGIN
	ALTER DATABASE bodb_Customer
	ADD FILEGROUP CustPTSetting3rd_Member_table;
END
GO

IF NOT EXISTS (SELECT TOP 1 1 FROM sys.database_files where name='CustPTSetting3rd_table_01')
BEGIN
ALTER DATABASE bodb_Customer 
ADD FILE 
(
	NAME = CustPTSetting3rd_table_01,
	FILENAME = 'G:\IBC_DB\bodb_Customer\CustPTSetting3rd_table_01.NDF'
	, SIZE = 32MB , MAXSIZE = UNLIMITED, FILEGROWTH = 32MB
)
TO FILEGROUP CustPTSetting3rd_table;
END
GO

GO
--GROUP SETTING TABLE
IF NOT EXISTS (SELECT TOP 1 1 FROM sys.filegroups where name='CustPTGroupSetting3rd_table')
BEGIN
	ALTER DATABASE bodb_Customer
	ADD FILEGROUP CustPTGroupSetting3rd_table;
END
GO

IF NOT EXISTS (SELECT TOP 1 1 FROM sys.database_files where name='CustPTGroupSetting3rd_table_01')
BEGIN
	ALTER DATABASE bodb_Customer 
	ADD FILE 
	(
		NAME = CustPTGroupSetting3rd_table_01,
		FILENAME = 'G:\IBC_DB\bodb_Customer\CustPTGroupSetting3rd_table_01.NDF'
		, SIZE = 32MB , MAXSIZE = UNLIMITED, FILEGROWTH = 32MB
	)
	TO FILEGROUP CustPTGroupSetting3rd_table;
END
GO

IF NOT EXISTS (SELECT TOP 1 1 FROM sys.filegroups where name='CustBetSetting3rd_table')
BEGIN
	ALTER DATABASE bodb_Customer
	ADD FILEGROUP CustBetSetting3rd_Member_table;
END
GO

IF NOT EXISTS (SELECT TOP 1 1 FROM sys.database_files where name='CustBetSetting3rd_table_01')
BEGIN
	ALTER DATABASE bodb_Customer 
	ADD FILE 
	(
		NAME = CustBetSetting3rd_table_01,
		FILENAME = 'G:\IBC_DB\bodb_Customer\CustBetSetting3rd_table_01.NDF'
		, SIZE = 32MB , MAXSIZE = UNLIMITED, FILEGROWTH = 32MB
	)
	TO FILEGROUP CustBetSetting3rd_table;
END
GO

IF NOT EXISTS (SELECT TOP 1 1 FROM sys.filegroups where name='CustDiscount3rd_table')
BEGIN
	ALTER DATABASE bodb_Customer
	ADD FILEGROUP CustDiscount3rd_Member_table;
END
GO

IF NOT EXISTS (SELECT TOP 1 1 FROM sys.database_files where name='CustDiscount3rd_table_01')
BEGIN
	ALTER DATABASE bodb_Customer 
	ADD FILE 
	(
		NAME = CustDiscount3rd_table_01,
		FILENAME = 'G:\IBC_DB\bodb_Customer\CustDiscount3rd_table_01.NDF'
		, SIZE = 32MB , MAXSIZE = UNLIMITED, FILEGROWTH = 32MB
	)
	TO FILEGROUP CustDiscount3rd_table;
END
GO

IF NOT EXISTS (SELECT TOP 1 1 FROM sys.filegroups where name='CustProductStatus_table')
BEGIN
	ALTER DATABASE bodb_Customer
	ADD FILEGROUP CustProductStatus_table;
END
GO

IF NOT EXISTS (SELECT TOP 1 1 FROM sys.database_files where name='CustProductStatus_table_01')
BEGIN
	ALTER DATABASE bodb_Customer 
	ADD FILE 
	(
		NAME = CustProductStatus_table_01,
		FILENAME = 'G:\IBC_DB\bodb_Customer\CustProductStatus_table_01.NDF'
		, SIZE = 32MB , MAXSIZE = UNLIMITED, FILEGROWTH = 32MB
	)
	TO FILEGROUP CustProductStatus_table;
END
GO


IF NOT EXISTS (SELECT TOP 1 1 FROM sys.filegroups where name='CustCommRate_table')
BEGIN
	ALTER DATABASE bodb_Customer
	ADD FILEGROUP CustCommRate_table;
END
GO

IF NOT EXISTS (SELECT TOP 1 1 FROM sys.database_files where name='CustCommRate_table_01')
BEGIN
	ALTER DATABASE bodb_Customer 
	ADD FILE 
	(
		NAME = CustCommRate_table_01,
		FILENAME = 'G:\IBC_DB\bodb_Customer\CustCommRate_table_01.NDF'
		, SIZE = 32MB , MAXSIZE = UNLIMITED, FILEGROWTH = 32MB
	)
	TO FILEGROUP CustCommRate_table;
END
GO
------- Creating Talbes 
USE bodb_Customer

GO
CREATE TABLE [dbo].[CustPTSetting3rd_Member_old](
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
 CONSTRAINT [PK_CustPTSetting3rd_Member_old] PRIMARY KEY CLUSTERED 
(
	[CustID] ASC,
	[SportType] ASC,
	[BetType] ASC,
	[IsLive] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [CustPTSetting3rd_Table]
) ON [CustPTSetting3rd_Table]

GO

ALTER TABLE [dbo].[CustPTSetting3rd_Member_old] ADD CONSTRAINT [DF_CustPTSetting3rd_Member_SuperPT] DEFAULT ((0)) FOR [SuperPT]
GO

ALTER TABLE [dbo].[CustPTSetting3rd_Member_old] ADD CONSTRAINT [DF_CustPTSetting3rd_Member_MasterPT] DEFAULT ((0)) FOR [MasterPT]
GO

ALTER TABLE [dbo].[CustPTSetting3rd_Member_old] ADD CONSTRAINT [DF_CustPTSetting3rd_Member_AgentPT] DEFAULT ((0)) FOR [AgentPT]
GO

ALTER TABLE [dbo].[CustPTSetting3rd_Member_old] ADD CONSTRAINT [DF_CustPTSetting3rd_Member_IsAutoMasterPT] DEFAULT ((0)) FOR [IsAutoMasterPT]
GO

ALTER TABLE [dbo].[CustPTSetting3rd_Member_old] ADD CONSTRAINT [DF_CustPTSetting3rd_Member_AutoMasterPT] DEFAULT ((0)) FOR [AutoMasterPT]
GO

ALTER TABLE [dbo].[CustPTSetting3rd_Member_old] ADD CONSTRAINT [DF_CustPTSetting3rd_Member_IsAutoSuperPT] DEFAULT ((0)) FOR [IsAutoSuperPT]
GO

ALTER TABLE [dbo].[CustPTSetting3rd_Member_old] ADD CONSTRAINT [DF_CustPTSetting3rd_Member_AutoSuperPT] DEFAULT ((0)) FOR [AutoSuperPT]

GO

CREATE TABLE [dbo].[CustPTGroupSetting3rd_Member_old](
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
 CONSTRAINT [PK_CustPTGroupSetting3rd_Member_old] PRIMARY KEY CLUSTERED 
(
	[AgentID] ASC,
	[SportType] ASC,
	[BetType] ASC,
	[IsLive] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [CustPTGroupSetting3rd_table]
) ON [CustPTGroupSetting3rd_table]

GO

ALTER TABLE [dbo].[CustPTGroupSetting3rd_Member_old] ADD CONSTRAINT [DF_CustPTGroupSetting3rd_Member_SuperPT] DEFAULT ((0)) FOR [SuperPT]
GO

ALTER TABLE [dbo].[CustPTGroupSetting3rd_Member_old] ADD CONSTRAINT [DF_CustPTGroupSetting3rd_Member_MasterPT]  DEFAULT ((0)) FOR [MasterPT]
GO

ALTER TABLE [dbo].[CustPTGroupSetting3rd_Member_old] ADD CONSTRAINT [DF_CustPTGroupSetting3rd_Member_AgentPT]  DEFAULT ((0)) FOR [AgentPT]
GO

ALTER TABLE [dbo].[CustPTGroupSetting3rd_Member_old] ADD CONSTRAINT [DF_CustPTGroupSetting3rd_Member_IsAutoMasterPT]  DEFAULT ((0)) FOR [IsAutoMasterPT]
GO

ALTER TABLE [dbo].[CustPTGroupSetting3rd_Member_old] ADD CONSTRAINT [DF_CustPTGroupSetting3rd_Member_AutoMasterPT]  DEFAULT ((0)) FOR [AutoMasterPT]
GO

ALTER TABLE [dbo].[CustPTGroupSetting3rd_Member_old] ADD CONSTRAINT [DF_CustPTGroupSetting3rd_Member_IsAutoSuperPT]  DEFAULT ((0)) FOR [IsAutoSuperPT]
GO

ALTER TABLE [dbo].[CustPTGroupSetting3rd_Member_old] ADD CONSTRAINT [DF_CustPTGroupSetting3rd_Member_AutoSuperPT]  DEFAULT ((0)) FOR [AutoSuperPT]
GO


CREATE TABLE [dbo].[CustSettingMode3rd_old](
	[CustID] [int] NOT NULL,
	[IsGrouped] [bit] NOT NULL,
 CONSTRAINT [PK_CustSettingMode3rd_old] PRIMARY KEY CLUSTERED 
(
	[CustID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [CustPTGroupSetting3rd_table]
) ON [CustPTGroupSetting3rd_table]

GO

ALTER TABLE [dbo].[CustSettingMode3rd_old] ADD  CONSTRAINT [DF_CustSettingMode3rd_IsGrouped] DEFAULT ((1)) FOR [IsGrouped]
GO

CREATE TABLE [dbo].[CustBetSetting3rd_Member_old](
	[CustID] [int] NOT NULL,
	[SportType] [smallint] NOT NULL,
	[BetType] [smallint] NOT NULL,
	[MinBet] [money] NULL,
	[MaxBet] [money] NULL,
	[MaxPerMatch] [money] NULL,
 CONSTRAINT [PK_CustBetSetting3rd_Member_old] PRIMARY KEY CLUSTERED 
(
	[CustID] ASC,
	[SportType] ASC,
	[BetType] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [CustBetSetting3rd_Table]
) ON [CustBetSetting3rd_Table]

GO

ALTER TABLE [dbo].[CustBetSetting3rd_Member_old] ADD CONSTRAINT [DF_CustBetSetting3rd_Member_MinBet] DEFAULT ((0)) FOR [MinBet]
GO

ALTER TABLE [dbo].[CustBetSetting3rd_Member_old] ADD CONSTRAINT [DF_CustBetSetting3rd_Member_MaxBet] DEFAULT ((0)) FOR [MaxBet]
GO

ALTER TABLE [dbo].[CustBetSetting3rd_Member_old] ADD  CONSTRAINT [DF_CustBetSetting3rd_Member_MaxPerMatch] DEFAULT ((0)) FOR [MaxPerMatch]
GO


CREATE TABLE [dbo].[CustDiscount3rd_Member_old](
	[CustID] [int] NOT NULL,
	[SportType] [smallint] NOT NULL,
	[BetType] [smallint] NOT NULL,
	[PlayerDiscount] [decimal](9, 8) NOT NULL,
	[AgentDiscount] [decimal](9, 8) NOT NULL,
	[MasterDiscount] [decimal](9, 8) NOT NULL,
	[SuperDiscount] [decimal](9, 8) NOT NULL,
 CONSTRAINT [PK_CustDiscount3rd_Member_old] PRIMARY KEY CLUSTERED 
(
	[CustID] ASC,
	[SportType] ASC,
	[BetType] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [CustDiscount3rd_Table]
) ON [CustDiscount3rd_Table]

GO

ALTER TABLE [dbo].[CustDiscount3rd_Member_old] ADD CONSTRAINT [DF_CustDiscount3rd_Member_PlayerDiscount] DEFAULT ((0)) FOR [PlayerDiscount]
GO

ALTER TABLE [dbo].[CustDiscount3rd_Member_old] ADD CONSTRAINT [DF_CustDiscount3rd_Member_AgentDiscount]  DEFAULT ((0)) FOR [AgentDiscount]
GO

ALTER TABLE [dbo].[CustDiscount3rd_Member_old] ADD CONSTRAINT [DF_CustDiscount3rd_Member_MasterDiscount]  DEFAULT ((0)) FOR [MasterDiscount]
GO

ALTER TABLE [dbo].[CustDiscount3rd_Member_old] ADD CONSTRAINT [DF_CustDiscount3rd_Member_SuperDiscount]  DEFAULT ((0)) FOR [SuperDiscount]
GO
CREATE TABLE [dbo].[CustProductStatus_old](
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

ALTER TABLE [dbo].[CustProductStatus_old] ADD  CONSTRAINT [DF_CustProductStatus_bitmapHasSynced]  DEFAULT (0x00) FOR [bitmapHasSynced]
GO

ALTER TABLE [dbo].[CustProductStatus_old] ADD  CONSTRAINT [DF_CustProductStatus_bitmapIsHidden]  DEFAULT (0x00) FOR [bitmapIsHidden]
GO

ALTER TABLE [dbo].[CustProductStatus_old] ADD  CONSTRAINT [DF_CustProductStatus_bitmapIsDisabled]  DEFAULT (0x00) FOR [bitmapIsDisabled]
GO
CREATE TABLE [dbo].[CustCommRate_old](
	[CustId] [int] NOT NULL,
	[Sporttype] [smallint] NOT NULL,
	[Bettype] [smallint] NOT NULL,
	[sdiscount] [decimal](9, 8) NULL,
	[adiscount] [decimal](9, 8) NULL,
	[discount] [decimal](9, 8) NULL,
	[playerdiscount] [decimal](9, 8) NULL,
 CONSTRAINT [PK_CustCommRate] PRIMARY KEY CLUSTERED 
(
	[CustId] ASC,
	[Sporttype] ASC,
	[Bettype] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [CustCommRate_table]
) ON [CustCommRate_table]

GO










