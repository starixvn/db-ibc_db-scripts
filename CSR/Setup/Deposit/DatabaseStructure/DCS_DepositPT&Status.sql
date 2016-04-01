/*
	Created by: Winnie
	Created Date: 20160401
	Description: DCS 
	Database: DBCUST/CustDB
		
*/
USE CustDB
GO
--- CREATING FILE GROUP AND DATA FILE
IF NOT EXISTS (SELECT TOP 1 1 FROM sys.filegroups where name='Dep_CustPTSetting_Member_table')
BEGIN
	ALTER DATABASE CustDB
	ADD FILEGROUP Dep_CustPTSetting_Member_table;
END
GO

IF NOT EXISTS (SELECT TOP 1 1 FROM sys.database_files where name='Dep_CustPTSetting_Member_table_01')
BEGIN
ALTER DATABASE CustDB 
ADD FILE 
(
	NAME = Dep_CustPTSetting_Member_table_01,
	FILENAME = 'D:\DB233\IBC_DB\CustDB\Dep_CustPTSetting_Member_table_01.NDF'
)
TO FILEGROUP Dep_CustPTSetting_Member_table;
END
GO
--------
IF NOT EXISTS (SELECT TOP 1 1 FROM sys.filegroups where name='Dep_CustPTSetting_Agent_table')
BEGIN
	ALTER DATABASE CustDB
	ADD FILEGROUP Dep_CustPTSetting_Agent_table;
END
GO

IF NOT EXISTS (SELECT TOP 1 1 FROM sys.database_files where name='Dep_CustPTSetting_Agent_table_01')
BEGIN
ALTER DATABASE CustDB 
ADD FILE 
(
	NAME = Dep_CustPTSetting_Agent_table_01,
	FILENAME = 'D:\DB233\IBC_DB\CustDB\Dep_CustPTSetting_Agent_table_01.NDF'
)
TO FILEGROUP Dep_CustPTSetting_Agent_table;
END
GO
IF NOT EXISTS (SELECT TOP 1 1 FROM sys.filegroups where name='Dep_CustPTGroupSetting_Member_table')
BEGIN
	ALTER DATABASE CustDB
	ADD FILEGROUP Dep_CustPTGroupSetting_Member_table;
END
GO

IF NOT EXISTS (SELECT TOP 1 1 FROM sys.database_files where name='Dep_CustPTGroupSetting_Member_table_01')
BEGIN
	ALTER DATABASE CustDB 
	ADD FILE 
	(
		NAME = Dep_CustPTGroupSetting_Member_table_01,
		FILENAME = 'D:\DB233\IBC_DB\CustDB\Dep_CustPTGroupSetting_Member_table_01.NDF'
	)
	TO FILEGROUP Dep_CustPTGroupSetting_Member_table;
END
GO

-------
IF NOT EXISTS (SELECT TOP 1 1 FROM sys.filegroups where name='Dep_CustSettingMode_table')
BEGIN
	ALTER DATABASE CustDB
	ADD FILEGROUP Dep_CustSettingMode_table;
END
GO

IF NOT EXISTS (SELECT TOP 1 1 FROM sys.database_files where name='Dep_CustSettingMode_table_01')
BEGIN
	ALTER DATABASE CustDB 
	ADD FILE 
	(
		NAME = Dep_CustSettingMode_table_01,
		FILENAME = 'D:\DB233\IBC_DB\CustDB\Dep_CustSettingMode_table_01.NDF'
	)
	TO FILEGROUP Dep_CustSettingMode_table;
END
GO
-------

------
IF NOT EXISTS (SELECT TOP 1 1 FROM sys.filegroups where name='Dep_CustProductStatus_table')
BEGIN
	ALTER DATABASE CustDB
	ADD FILEGROUP Dep_CustProductStatus_table;
END
GO

IF NOT EXISTS (SELECT TOP 1 1 FROM sys.database_files where name='Dep_CustProductStatus_table_01')
BEGIN
	ALTER DATABASE CustDB 
	ADD FILE 
	(
		NAME = Dep_CustProductStatus_table_01,
		FILENAME = 'D:\DB233\IBC_DB\CustDB\Dep_CustProductStatus_table_01.NDF'
	)
	TO FILEGROUP Dep_CustProductStatus_table;
END
GO
------
IF NOT EXISTS (SELECT TOP 1 1 FROM sys.filegroups where name='Dep_ProductSettingDetail_table')
BEGIN
	ALTER DATABASE CustDB
	ADD FILEGROUP Dep_ProductSettingDetail_table;
END
GO

IF NOT EXISTS (SELECT TOP 1 1 FROM sys.database_files where name='Dep_ProductSettingDetail_table_01')
BEGIN
	ALTER DATABASE CustDB 
	ADD FILE 
	(
		NAME = Dep_ProductSettingDetail_table_01,
		FILENAME = 'D:\DB233\IBC_DB\CustDB\Dep_ProductSettingDetail_table_01.NDF'
	)
	TO FILEGROUP Dep_ProductSettingDetail_table;
END
GO
-------
USE CustDB

GO

CREATE TABLE [dbo].[Dep_CustPTSetting_Member](
	[CustID] [int] NOT NULL,
	[SportType] [smallint] NOT NULL,
	[BetType] [smallint] NOT NULL,
	[IsLive] [bit] NOT NULL,
	[SuperPT] [tinyint] NOT NULL,
	[MasterPT] [tinyint] NOT NULL,
	[AgentPT] [tinyint] NOT NULL
	
 CONSTRAINT [PK_Dep_CustPTSetting_Member] PRIMARY KEY CLUSTERED 
(
	[CustID] ASC,
	[SportType] ASC,
	[BetType] ASC,
	[IsLive] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [Dep_CustPTSetting_Member_Table]
) ON [Dep_CustPTSetting_Member_Table]

GO

ALTER TABLE [dbo].[Dep_CustPTSetting_Member] ADD  DEFAULT ((0)) FOR [SuperPT]
GO

ALTER TABLE [dbo].[Dep_CustPTSetting_Member] ADD  DEFAULT ((0)) FOR [MasterPT]
GO

ALTER TABLE [dbo].[Dep_CustPTSetting_Member] ADD  DEFAULT ((0)) FOR [AgentPT]
GO

CREATE TABLE [dbo].[Dep_CustPTSetting_Agent](
	[CustID] [int] NOT NULL,
	[SportType] [smallint] NOT NULL,
	[BetType] [smallint] NOT NULL,
	[IsLive] [bit] NOT NULL,
	[SuperPT] [tinyint] NOT NULL,
	[MasterPT] [tinyint] NOT NULL,
	[AgentPT] [tinyint] NOT NULL	
 CONSTRAINT [PK_Dep_CustPTSetting_Agent] PRIMARY KEY CLUSTERED 
(
	[CustID] ASC,
	[SportType] ASC,
	[BetType] ASC,
	[IsLive] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [Dep_CustPTSetting_Agent_Table]
) ON [Dep_CustPTSetting_Agent_Table]

GO

ALTER TABLE [dbo].[Dep_CustPTSetting_Agent] ADD  DEFAULT ((0)) FOR [SuperPT]
GO

ALTER TABLE [dbo].[Dep_CustPTSetting_Agent] ADD  DEFAULT ((0)) FOR [MasterPT]
GO

ALTER TABLE [dbo].[Dep_CustPTSetting_Agent] ADD  DEFAULT ((0)) FOR [AgentPT]
GO

CREATE TABLE [dbo].[Dep_CustPTGroupSetting_Member](
	[AgentID] [int] NOT NULL,
	[SportType] [smallint] NOT NULL,
	[BetType] [smallint] NOT NULL,
	[IsLive] [bit] NOT NULL,
	[SuperPT] [tinyint] NOT NULL,
	[MasterPT] [tinyint] NOT NULL,
	[AgentPT] [tinyint] NOT NULL
 CONSTRAINT [PK_Dep_CustPTGroupSetting_Member] PRIMARY KEY CLUSTERED 
(
	[AgentID] ASC,
	[SportType] ASC,
	[BetType] ASC,
	[IsLive] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [Dep_CustPTGroupSetting_Member_table]
) ON [Dep_CustPTGroupSetting_Member_table]

GO

ALTER TABLE [dbo].[Dep_CustPTGroupSetting_Member] ADD  DEFAULT ((0)) FOR [SuperPT]
GO

ALTER TABLE [dbo].[Dep_CustPTGroupSetting_Member] ADD  DEFAULT ((0)) FOR [MasterPT]
GO

ALTER TABLE [dbo].[Dep_CustPTGroupSetting_Member] ADD  DEFAULT ((0)) FOR [AgentPT]
GO




CREATE TABLE [dbo].[Dep_CustSettingMode](
	[CustID] [int] NOT NULL,
	[IsGroupedPT] [bit] NOT NULL,
	IsGroupedComm [bit] NOT NULL,
	IsGroupedBetLimit [bit] NOT NULL,
	IsGroupStakeLevel [bit] NOT NULL
 CONSTRAINT [PK_Dep_CustSettingMode] PRIMARY KEY CLUSTERED 
(
	[CustID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [Dep_CustSettingMode_table]
) ON [Dep_CustSettingMode_table]

GO

ALTER TABLE [dbo].[Dep_CustSettingMode] ADD  DEFAULT ((1)) FOR [IsGroupedPT]
GO
ALTER TABLE [dbo].[Dep_CustSettingMode] ADD  DEFAULT ((1)) FOR IsGroupedComm
GO
ALTER TABLE [dbo].[Dep_CustSettingMode] ADD  DEFAULT ((1)) FOR IsGroupedBetLimit
GO
ALTER TABLE [dbo].[Dep_CustSettingMode] ADD  DEFAULT ((1)) FOR IsGroupStakeLevel
GO

CREATE TABLE [dbo].[Dep_CustProductStatus](
	[CustID] [int] NOT NULL,
	[bitmapIsHidden] [binary](32) NOT NULL,
	[bitmapIsDisabled] [binary](32) NOT NULL,
 CONSTRAINT [CIX_Dep_CustProductStatus_custid] PRIMARY KEY CLUSTERED 
(
	[CustID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [Dep_CustProductStatus_Table]
) ON [Dep_CustProductStatus_Table]

GO

ALTER TABLE [dbo].[Dep_CustProductStatus] ADD  CONSTRAINT [DF_Dep_CustPRoductStatus_bitmapIsHidden]  DEFAULT (0x00) FOR [bitmapIsHidden]
GO

ALTER TABLE [dbo].[Dep_CustProductStatus] ADD  CONSTRAINT [DF_Dep_CustPRoductStatus_bitmapIsDisabled]  DEFAULT (0x00) FOR [bitmapIsDisabled]
GO

CREATE TABLE [dbo].[Dep_ProductStatusProfile](
	[Sporttype] [smallint] NOT NULL,
	[Bettype] [smallint] NOT NULL,
	[bitmapOrder] [tinyint] NOT NULL,
 CONSTRAINT [PK_Dep_ProductStatusProfile] PRIMARY KEY NONCLUSTERED 
(
	[Sporttype] ASC,
	[Bettype] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [Dep_CustProductStatus_Table]
) ON [Dep_CustProductStatus_Table]

GO

-----------------
CREATE TABLE [dbo].[Dep_ProductSettingDetail](
	ProductSettingID [int] NOT NULL,
	[SportType] [smallint] NOT NULL,
	[BetType] [smallint] NOT NULL,
	[IsLive] [bit] NOT NULL,	
	MaxDefaultValue [decimal](9, 8) NULL,	
	[IsHidden] [bit] NULL,
	[IsDisabled] [bit] NULL,
	[SettingStatus] [tinyint] NULL,
 CONSTRAINT [PK_Dep_ProductSettingDetail] PRIMARY KEY CLUSTERED 
(
	ProductSettingID ASC,
	[SportType] ASC,
	[BetType] ASC,
	[IsLive] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [Dep_ProductSettingDetail_table]
) ON [Dep_ProductSettingDetail_table]

GO
ALTER TABLE [dbo].[Dep_ProductSettingDetail] ADD  DEFAULT ((0)) FOR MaxDefaultValue
GO

ALTER TABLE [dbo].[Dep_ProductSettingDetail] ADD  DEFAULT ((0)) FOR [IsHidden]
GO

ALTER TABLE [dbo].[Dep_ProductSettingDetail] ADD  DEFAULT ((0)) FOR [IsDisabled]
GO

CREATE TABLE [dbo].[Dep_LicenseeProductSetting](
	[CustID] [int] NOT NULL,
	[ProductSettingID] [int] NOT NULL,
 CONSTRAINT [PK_Dep_LicenseeProductSetting] PRIMARY KEY CLUSTERED 
(
	[CustID] ASC,
	[ProductSettingID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [Dep_ProductSettingDetail_table]
) ON [Dep_ProductSettingDetail_table]

GO

CREATE TABLE [dbo].[Dep_ProductSetting](
	[ProductSettingID] [int] NOT NULL,
	[ProductID] [smallint] NOT NULL,
	[SettingType] [tinyint] NOT NULL,
	[Template] [tinyint] NOT NULL,
	[TemplateName] [varchar](50) NULL,
	[DisplayOrder] [tinyint] NOT NULL,
	[SettingLevel] [tinyint] NOT NULL,
 CONSTRAINT [PK_Dep_ProductSetting] PRIMARY KEY CLUSTERED 
(
	[ProductSettingID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [Dep_ProductSettingDetail_table]
) ON [Dep_ProductSettingDetail_table]

GO

ALTER TABLE [dbo].[Dep_ProductSetting] ADD  CONSTRAINT [DF_Dep_ProductSetting_Template]  DEFAULT ((0)) FOR [Template]
GO






