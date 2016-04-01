/*
	Created by: Winnie
	Created Date: 20160401
	Description: DCS 
	Database: DB05/bodb_Customer
		
*/
USE bodb_Customer
GO
--- CREATING FILE GROUP AND DATA FILE
IF NOT EXISTS (SELECT TOP 1 1 FROM sys.filegroups where name='Dep_CustPTSetting_Member_table')
BEGIN
	ALTER DATABASE bodb_Customer
	ADD FILEGROUP Dep_CustPTSetting_Member_table;
END
GO

IF NOT EXISTS (SELECT TOP 1 1 FROM sys.database_files where name='Dep_CustPTSetting_Member_table_01')
BEGIN
ALTER DATABASE bodb_Customer 
ADD FILE 
(
	NAME = Dep_CustPTSetting_Member_table_01,
	FILENAME = 'D:\IBC_DB\bodb_Customer\Dep_CustPTSetting_Member_table_01.NDF'
)
TO FILEGROUP Dep_CustPTSetting_Member_table;
END
GO
--------

IF NOT EXISTS (SELECT TOP 1 1 FROM sys.filegroups where name='Dep_CustPTGroupSetting_Member_table')
BEGIN
	ALTER DATABASE bodb_Customer
	ADD FILEGROUP Dep_CustPTGroupSetting_Member_table;
END
GO

IF NOT EXISTS (SELECT TOP 1 1 FROM sys.database_files where name='Dep_CustPTGroupSetting_Member_table_01')
BEGIN
	ALTER DATABASE bodb_Customer 
	ADD FILE 
	(
		NAME = Dep_CustPTGroupSetting_Member_table_01,
		FILENAME = 'D:\IBC_DB\bodb_Customer\Dep_CustPTGroupSetting_Member_table_01.NDF'
	)
	TO FILEGROUP Dep_CustPTGroupSetting_Member_table;
END
GO

-------
IF NOT EXISTS (SELECT TOP 1 1 FROM sys.filegroups where name='Dep_CustSettingMode_table')
BEGIN
	ALTER DATABASE bodb_Customer
	ADD FILEGROUP Dep_CustSettingMode_table;
END
GO

IF NOT EXISTS (SELECT TOP 1 1 FROM sys.database_files where name='Dep_CustSettingMode_table_01')
BEGIN
	ALTER DATABASE bodb_Customer 
	ADD FILE 
	(
		NAME = Dep_CustSettingMode_table_01,
		FILENAME = 'D:\IBC_DB\bodb_Customer\Dep_CustSettingMode_table_01.NDF'
	)
	TO FILEGROUP Dep_CustSettingMode_table;
END
GO
-------

------
IF NOT EXISTS (SELECT TOP 1 1 FROM sys.filegroups where name='Dep_CustProductStatus_table')
BEGIN
	ALTER DATABASE bodb_Customer
	ADD FILEGROUP Dep_CustProductStatus_table;
END
GO

IF NOT EXISTS (SELECT TOP 1 1 FROM sys.database_files where name='Dep_CustProductStatus_table_01')
BEGIN
	ALTER DATABASE bodb_Customer 
	ADD FILE 
	(
		NAME = Dep_CustProductStatus_table_01,
		FILENAME = 'D:\IBC_DB\bodb_Customer\Dep_CustProductStatus_table_01.NDF'
	)
	TO FILEGROUP Dep_CustProductStatus_table;
END
GO

-------
IF NOT EXISTS (SELECT TOP 1 1 FROM sys.filegroups where name='Dep_CustStakeLevel_Member_table')
BEGIN
	ALTER DATABASE bodb_Customer
	ADD FILEGROUP Dep_CustStakeLevel_Member_table;
END
GO

IF NOT EXISTS (SELECT TOP 1 1 FROM sys.database_files where name='Dep_CustStakeLevel_Member_table_01')
BEGIN
	ALTER DATABASE bodb_Customer 
	ADD FILE 
	(
		NAME = Dep_CustStakeLevel_Member_table_01,
		FILENAME = 'D:\IBC_DB\bodb_Customer\Dep_CustStakeLevel_Member_table_01.NDF'
	)
	TO FILEGROUP Dep_CustStakeLevel_Member_table;
END
GO
-------

USE bodb_Customer

GO

CREATE TABLE [dbo].[Dep_CustPTSetting_Member_old](
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

ALTER TABLE [dbo].[Dep_CustPTSetting_Member_old] ADD  DEFAULT ((0)) FOR [SuperPT]
GO

ALTER TABLE [dbo].[Dep_CustPTSetting_Member_old] ADD  DEFAULT ((0)) FOR [MasterPT]
GO

ALTER TABLE [dbo].[Dep_CustPTSetting_Member_old] ADD  DEFAULT ((0)) FOR [AgentPT]
GO


CREATE TABLE [dbo].Dep_CustPTGroupSetting_Member_old(
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

ALTER TABLE [dbo].Dep_CustPTGroupSetting_Member_old ADD  DEFAULT ((0)) FOR [SuperPT]
GO

ALTER TABLE [dbo].Dep_CustPTGroupSetting_Member_old ADD  DEFAULT ((0)) FOR [MasterPT]
GO

ALTER TABLE [dbo].Dep_CustPTGroupSetting_Member_old ADD  DEFAULT ((0)) FOR [AgentPT]
GO

CREATE TABLE [dbo].Dep_CustSettingMode_old(
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

ALTER TABLE [dbo].Dep_CustSettingMode_old ADD  DEFAULT ((1)) FOR [IsGroupedPT]
GO
ALTER TABLE [dbo].Dep_CustSettingMode_old ADD  DEFAULT ((1)) FOR IsGroupedComm
GO
ALTER TABLE [dbo].Dep_CustSettingMode_old ADD  DEFAULT ((1)) FOR IsGroupedBetLimit
GO
ALTER TABLE [dbo].Dep_CustSettingMode_old ADD  DEFAULT ((1)) FOR IsGroupStakeLevel
GO

CREATE TABLE [dbo].Dep_CustProductStatus_old(
	[CustID] [int] NOT NULL,
	[bitmapIsHidden] [binary](32) NOT NULL,
	[bitmapIsDisabled] [binary](32) NOT NULL,
 CONSTRAINT [CIX_Dep_CustProductStatus_custid] PRIMARY KEY CLUSTERED 
(
	[CustID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [Dep_CustProductStatus_Table]
) ON [Dep_CustProductStatus_Table]

GO

ALTER TABLE [dbo].Dep_CustProductStatus_old ADD  CONSTRAINT [DF_Dep_CustPRoductStatus_bitmapIsHidden]  DEFAULT (0x00) FOR [bitmapIsHidden]
GO

ALTER TABLE [dbo].Dep_CustProductStatus_old ADD  CONSTRAINT [DF_Dep_CustPRoductStatus_bitmapIsDisabled]  DEFAULT (0x00) FOR [bitmapIsDisabled]
GO

---


CREATE TABLE [dbo].Dep_CustStakeLevel_Member_old(
	[CustID] [int] NOT NULL,
	[SportType] [smallint] NOT NULL,
	[BetType] [smallint] NOT NULL,
	[StakeLevelList] [varchar](200) NULL,
	[LastUpdated] [datetime] NULL,
 CONSTRAINT [PK_Dep_CustStakeLevel_Member] PRIMARY KEY CLUSTERED 
(
	[CustID] ASC,
	[SportType] ASC,
	[BetType] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON Dep_CustStakeLevel_Member_table
) ON Dep_CustStakeLevel_Member_table

GO
