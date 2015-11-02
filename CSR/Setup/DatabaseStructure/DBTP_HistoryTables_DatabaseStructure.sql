/*
	Created by: Helen
	Created Date: 20151007
	Description: DCS 
	Database: DBTP/bodb_CustHistory (local dev: server232 -   local test: server234)
	
	Filegroup in local test - Server 234: "D:\DB234_SQLSERVER2008R2\IBC_DB\bodb_history"
	Filegroup in local dev -  Server 232: "E:\IBC_DB\bodb_CustHistory"
*/
USE bodb_CustHistory
GO
--- CREATING FILE GROUP AND DATA FILE
IF NOT EXISTS (SELECT TOP 1 1 FROM sys.filegroups where name='CustPTSetting3rd_Member_table')
BEGIN
	ALTER DATABASE bodb_CustHistory
	ADD FILEGROUP CustPTSetting3rd_Member_table;
END
GO

IF NOT EXISTS (SELECT TOP 1 1 FROM sys.database_files where name='CustPTSetting3rd_Member_table_01')
BEGIN
ALTER DATABASE bodb_CustHistory 
ADD FILE 
(
	NAME = CustPTSetting3rd_Member_table_01,
	--local test
	--FILENAME = 'D:\DB234_SQLSERVER2008R2\IBC_DB\bodb_history\CustPTSetting3rd_Member_table_01.NDF' 
	--local dev
	--FILENAME = 'E:\IBC_DB\bodb_CustHistory\CustPTSetting3rd_Member_table_01.NDF' 
	--Production 
	FILENAME = 'P:\IBC_DB\bodb_CustHistory\CustPTSetting3rd_Member_table_01.NDF'
)
TO FILEGROUP CustPTSetting3rd_Member_table;
END
GO

IF NOT EXISTS (SELECT TOP 1 1 FROM sys.filegroups where name='CustPTSetting3rd_Agent_table')
BEGIN
	ALTER DATABASE bodb_CustHistory
	ADD FILEGROUP CustPTSetting3rd_Agent_table;
END
GO

IF NOT EXISTS (SELECT TOP 1 1 FROM sys.database_files where name='CustPTSetting3rd_Agent_table_01')
BEGIN
	ALTER DATABASE bodb_CustHistory 
	ADD FILE 
	(
		NAME = CustPTSetting3rd_Agent_table_01,
		--local test
		--FILENAME = 'D:\DB234_SQLSERVER2008R2\IBC_DB\bodb_history\CustPTSetting3rd_Agent_table_01.NDF'
		--local dev
		--FILENAME = 'E:\IBC_DB\bodb_CustHistory\CustPTSetting3rd_Agent_table_01.NDF'--local dev
		-- Production
		FILENAME = 'P:\IBC_DB\bodb_CustHistory\CustPTSetting3rd_Agent_table_01.NDF'
	)
	TO FILEGROUP CustPTSetting3rd_Agent_table;
END
GO

IF NOT EXISTS (SELECT TOP 1 1 FROM sys.filegroups where name='CustPTGroupSetting3rd_Member_table')
BEGIN
	ALTER DATABASE bodb_CustHistory
	ADD FILEGROUP CustPTGroupSetting3rd_Member_table;
END
GO

IF NOT EXISTS (SELECT TOP 1 1 FROM sys.database_files where name='CustPTGroupSetting3rd_Member_table_01')
BEGIN
	ALTER DATABASE bodb_CustHistory 
	ADD FILE 
	(
		NAME = CustPTGroupSetting3rd_Member_table_01,
		--Local Test
		--FILENAME = 'D:\DB234_SQLSERVER2008R2\IBC_DB\bodb_history\CustPTGroupSetting3rd_Member_table_01.NDF'--local test
		-- Local dev
		--FILENAME = 'E:\IBC_DB\bodb_CustHistory\CustPTGroupSetting3rd_Member_table_01.NDF'
		--Production
		FILENAME = 'P:\IBC_DB\bodb_CustHistory\CustPTGroupSetting3rd_Member_table_01.NDF'
	)
	TO FILEGROUP CustPTGroupSetting3rd_Member_table;
END
GO

IF NOT EXISTS (SELECT TOP 1 1 FROM sys.filegroups where name='CustSettingMode3rd_table')
BEGIN
	ALTER DATABASE bodb_CustHistory
	ADD FILEGROUP CustSettingMode3rd_table;
END
GO

IF NOT EXISTS (SELECT TOP 1 1 FROM sys.database_files where name='CustSettingMode3rd_table_01')
BEGIN
	ALTER DATABASE bodb_CustHistory 
	ADD FILE 
	(
		NAME = CustSettingMode3rd_table_01,
		-- Local test
		--FILENAME = 'D:\DB234_SQLSERVER2008R2\IBC_DB\bodb_history\CustSettingMode3rd_table_01.NDF'--local test
		--Local dev
		--FILENAME = 'E:\IBC_DB\bodb_CustHistory\CustSettingMode3rd_table_01.NDF'--local dev
		-- Production
		FILENAME = 'P:\IBC_DB\bodb_CustHistory\CustSettingMode3rd_table_01.NDF'
	)
	TO FILEGROUP CustSettingMode3rd_table;
END
GO


IF NOT EXISTS (SELECT TOP 1 1 FROM sys.filegroups where name='CustBetSetting3rd_Member_table')
BEGIN
	ALTER DATABASE bodb_CustHistory
	ADD FILEGROUP CustBetSetting3rd_Member_table;
END
GO

IF NOT EXISTS (SELECT TOP 1 1 FROM sys.database_files where name='CustBetSetting3rd_Member_table_01')
BEGIN
	ALTER DATABASE bodb_CustHistory 
	ADD FILE 
	(
		NAME = CustBetSetting3rd_Member_table_01,
		-- Local test
		--FILENAME = 'D:\DB234_SQLSERVER2008R2\IBC_DB\bodb_history\CustBetSetting3rd_Member_table_01.NDF'
		-- Local dev
		--FILENAME = 'E:\IBC_DB\bodb_CustHistory\CustBetSetting3rd_Member_table_01.NDF'
		-- Production
		FILENAME = 'P:\IBC_DB\bodb_CustHistory\CustBetSetting3rd_Member_table_01.NDF'
	)
	TO FILEGROUP CustBetSetting3rd_Member_table;
END
GO
-------
IF NOT EXISTS (SELECT TOP 1 1 FROM sys.filegroups where name='CustBetSetting3rd_Agent_table')
BEGIN
	ALTER DATABASE bodb_CustHistory
	ADD FILEGROUP CustBetSetting3rd_Agent_table;
END
GO

IF NOT EXISTS (SELECT TOP 1 1 FROM sys.database_files where name='CustBetSetting3rd_Agent_table_01')
BEGIN
	ALTER DATABASE bodb_CustHistory 
	ADD FILE 
	(
		NAME = CustBetSetting3rd_Agent_table_01,
		-- Local Test
		--FILENAME = 'D:\DB234_SQLSERVER2008R2\IBC_DB\bodb_history\CustBetSetting3rd_Agent_table_01.NDF'
		-- Local Dev
		--FILENAME = 'E:\IBC_DB\bodb_CustHistory\CustBetSetting3rd_Agent_table_01.NDF'
		-- Production
		FILENAME = 'P:\IBC_DB\bodb_CustHistory\CustBetSetting3rd_Agent_table_01.NDF'
	)
	TO FILEGROUP CustBetSetting3rd_Agent_table;
END
GO
-------
IF NOT EXISTS (SELECT TOP 1 1 FROM sys.filegroups where name='CustDiscount3rd_Member_table')
BEGIN
	ALTER DATABASE bodb_CustHistory
	ADD FILEGROUP CustDiscount3rd_Member_table;
END
GO

IF NOT EXISTS (SELECT TOP 1 1 FROM sys.database_files where name='CustDiscount3rd_Member_table_01')
BEGIN
	ALTER DATABASE bodb_CustHistory 
	ADD FILE 
	(
		NAME = CustDiscount3rd_Member_table_01,
		-- Local Test
		--FILENAME = 'D:\DB234_SQLSERVER2008R2\IBC_DB\bodb_history\CustDiscount3rd_Member_table_01.NDF'
		-- Local Dev
		--FILENAME = 'E:\IBC_DB\bodb_CustHistory\CustDiscount3rd_Member_table_01.NDF'
		-- Production
		FILENAME = 'P:\IBC_DB\bodb_CustHistory\CustDiscount3rd_Member_table_01.NDF'
	)
	TO FILEGROUP CustDiscount3rd_Member_table;
END
GO
-------
IF NOT EXISTS (SELECT TOP 1 1 FROM sys.filegroups where name='CustDiscount3rd_Agent_table')
BEGIN
	ALTER DATABASE bodb_CustHistory
	ADD FILEGROUP CustDiscount3rd_Agent_table;
END
GO

IF NOT EXISTS (SELECT TOP 1 1 FROM sys.database_files where name='CustDiscount3rd_Agent_table_01')
BEGIN
	ALTER DATABASE bodb_CustHistory 
	ADD FILE 
	(
		NAME = CustDiscount3rd_Agent_table_01,
		-- Local Test
		--FILENAME = 'D:\DB234_SQLSERVER2008R2\IBC_DB\bodb_history\CustDiscount3rd_Agent_table_01.NDF'
		--Local Dev
		--FILENAME = 'E:\IBC_DB\bodb_CustHistory\CustDiscount3rd_Agent_table_01.NDF'
		-- Production
		FILENAME = 'P:\IBC_DB\bodb_CustHistory\CustDiscount3rd_Agent_table_01.NDF'
	)
	TO FILEGROUP CustDiscount3rd_Agent_table;
END
GO
------
IF NOT EXISTS (SELECT TOP 1 1 FROM sys.filegroups where name='CustProductStatus_table')
BEGIN
	ALTER DATABASE bodb_CustHistory
	ADD FILEGROUP CustProductStatus_table;
END
GO

IF NOT EXISTS (SELECT TOP 1 1 FROM sys.database_files where name='CustProductStatus_table_01')
BEGIN
	ALTER DATABASE bodb_CustHistory 
	ADD FILE 
	(
		NAME = CustProductStatus_table_01,
		-- Local Test
		--FILENAME = 'D:\DB234_SQLSERVER2008R2\IBC_DB\bodb_history\CustProductStatus_table_01.NDF'
		-- Local Dev
		--FILENAME = 'E:\IBC_DB\bodb_CustHistory\CustProductStatus_table_01.NDF'
		-- Production
		FILENAME = 'P:\IBC_DB\bodb_CustHistory\CustProductStatus_table_01.NDF'
	)
	TO FILEGROUP CustProductStatus_table;
END
GO

USE bodb_CustHistory
GO
CREATE TABLE [dbo].[CustPTSetting3rd_Member_history](
	[UpdateTime] [datetime] NOT NULL,
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
	[AutoSuperPT] [tinyint] NOT NULL
 
) ON [CustPTSetting3rd_Member_Table]

GO
ALTER TABLE [dbo].[CustPTSetting3rd_Member_history] ADD  CONSTRAINT [DF_CustPTSetting3rd_Member_history_UpdateTime]  DEFAULT (getdate()) FOR [UpdateTime]

ALTER TABLE [dbo].[CustPTSetting3rd_Member_history] ADD  DEFAULT ((0)) FOR [SuperPT]
GO

ALTER TABLE [dbo].[CustPTSetting3rd_Member_history] ADD  DEFAULT ((0)) FOR [MasterPT]
GO

ALTER TABLE [dbo].[CustPTSetting3rd_Member_history] ADD  DEFAULT ((0)) FOR [AgentPT]
GO

ALTER TABLE [dbo].[CustPTSetting3rd_Member_history] ADD  DEFAULT ((0)) FOR [IsAutoMasterPT]
GO

ALTER TABLE [dbo].[CustPTSetting3rd_Member_history] ADD  DEFAULT ((0)) FOR [AutoMasterPT]
GO

ALTER TABLE [dbo].[CustPTSetting3rd_Member_history] ADD  DEFAULT ((0)) FOR [IsAutoSuperPT]
GO

ALTER TABLE [dbo].[CustPTSetting3rd_Member_history] ADD  DEFAULT ((0)) FOR [AutoSuperPT]
GO
CREATE CLUSTERED INDEX [CustPTSetting3rd_Member_His_Index] ON [dbo].[CustPTSetting3rd_Member_history] 
(
	[UpdateTime] ASC,
	[custid] ASC
) 

GO
CREATE TABLE [dbo].[CustPTSetting3rd_Agent_history](
	[UpdateTime] [datetime] NOT NULL,
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
	[MaxPT] [tinyint] NOT NULL
) ON [CustPTSetting3rd_Agent_Table]

GO

ALTER TABLE [dbo].[CustPTSetting3rd_Agent_history] ADD  CONSTRAINT [DF_CustPTSetting3rd_Agent_history_UpdateTime]  DEFAULT (getdate()) FOR [UpdateTime]
GO
ALTER TABLE [dbo].[CustPTSetting3rd_Agent_history] ADD  DEFAULT ((0)) FOR [SuperPT]
GO

ALTER TABLE [dbo].[CustPTSetting3rd_Agent_history] ADD  DEFAULT ((0)) FOR [MasterPT]
GO

ALTER TABLE [dbo].[CustPTSetting3rd_Agent_history] ADD  DEFAULT ((0)) FOR [AgentPT]
GO

ALTER TABLE [dbo].[CustPTSetting3rd_Agent_history] ADD  DEFAULT ((0)) FOR [IsAutoMasterPT]
GO

ALTER TABLE [dbo].[CustPTSetting3rd_Agent_history] ADD  DEFAULT ((0)) FOR [AutoMasterPT]
GO

ALTER TABLE [dbo].[CustPTSetting3rd_Agent_history] ADD  DEFAULT ((0)) FOR [IsAutoSuperPT]
GO

ALTER TABLE [dbo].[CustPTSetting3rd_Agent_history] ADD  DEFAULT ((0)) FOR [AutoSuperPT]
GO

ALTER TABLE [dbo].[CustPTSetting3rd_Agent_history] ADD  DEFAULT ((0)) FOR [MinPT]
GO

ALTER TABLE [dbo].[CustPTSetting3rd_Agent_history] ADD  DEFAULT ((0.9)) FOR [MaxPT]
GO

CREATE CLUSTERED INDEX [CustPTSetting3rd_Agent_His_Index] ON [dbo].[CustPTSetting3rd_Agent_history] 
(
	[UpdateTime] ASC,
	[custid] ASC
) 

GO

CREATE TABLE [dbo].[CustPTGroupSetting3rd_Member_history](
	[UpdateTime] [datetime] NOT NULL,
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
	[AutoSuperPT] [tinyint] NOT NULL
 
) ON [CustPTGroupSetting3rd_Member_table]

GO
ALTER TABLE [dbo].[CustPTGroupSetting3rd_Member_history] ADD  CONSTRAINT [DF_CustPTGroupSetting3rd_Member_history_UpdateTime]  DEFAULT (getdate()) FOR [UpdateTime]
GO
ALTER TABLE [dbo].[CustPTGroupSetting3rd_Member_history] ADD  DEFAULT ((0)) FOR [SuperPT]
GO

ALTER TABLE [dbo].[CustPTGroupSetting3rd_Member_history] ADD  DEFAULT ((0)) FOR [MasterPT]
GO

ALTER TABLE [dbo].[CustPTGroupSetting3rd_Member_history] ADD  DEFAULT ((0)) FOR [AgentPT]
GO

ALTER TABLE [dbo].[CustPTGroupSetting3rd_Member_history] ADD  DEFAULT ((0)) FOR [IsAutoMasterPT]
GO

ALTER TABLE [dbo].[CustPTGroupSetting3rd_Member_history] ADD  DEFAULT ((0)) FOR [AutoMasterPT]
GO

ALTER TABLE [dbo].[CustPTGroupSetting3rd_Member_history] ADD  DEFAULT ((0)) FOR [IsAutoSuperPT]
GO

ALTER TABLE [dbo].[CustPTGroupSetting3rd_Member_history] ADD  DEFAULT ((0)) FOR [AutoSuperPT]
GO
CREATE CLUSTERED INDEX [CustPTGroupSetting3rd_Member_His_Index] ON [dbo].[CustPTGroupSetting3rd_Member_history] 
(
	[UpdateTime] ASC,
	[AgentID] ASC
) 
GO

CREATE TABLE [dbo].[CustSettingMode3rd_history](
	[UpdateTime] [datetime] NOT NULL,
	[CustID] [int] NOT NULL,
	[IsGrouped] [bit] NOT NULL
) ON [CustSettingMode3rd_table]

GO
ALTER TABLE [dbo].[CustSettingMode3rd_history] ADD  CONSTRAINT [DF_CustSettingMode3rd_history_UpdateTime]  DEFAULT (getdate()) FOR [UpdateTime]
GO
ALTER TABLE [dbo].[CustSettingMode3rd_history] ADD  DEFAULT ((1)) FOR [IsGrouped]
GO
CREATE CLUSTERED INDEX [CustSettingMode3rd_His_Index] ON [dbo].[CustSettingMode3rd_history] 
(
	[UpdateTime] ASC,
	[CustID] ASC
) 
GO

CREATE TABLE [dbo].[CustBetSetting3rd_Member_history](
	[UpdateTime] [datetime] NOT NULL,
	[CustID] [int] NOT NULL,
	[SportType] [smallint] NOT NULL,
	[BetType] [smallint] NOT NULL,
	[MinBet] [money] NULL,
	[MaxBet] [money] NULL,
	[MaxPerMatch] [money] NULL
) ON [CustBetSetting3rd_Member_Table]

GO

ALTER TABLE [dbo].[CustBetSetting3rd_Member_history] ADD  CONSTRAINT [DF_CustBetSetting3rd_Member_history_UpdateTime]  DEFAULT (getdate()) FOR [UpdateTime]
GO
ALTER TABLE [dbo].[CustBetSetting3rd_Member_history] ADD  DEFAULT ((0)) FOR [MinBet]
GO

ALTER TABLE [dbo].[CustBetSetting3rd_Member_history] ADD  DEFAULT ((0)) FOR [MaxBet]
GO

ALTER TABLE [dbo].[CustBetSetting3rd_Member_history] ADD  DEFAULT ((0)) FOR [MaxPerMatch]
GO
CREATE CLUSTERED INDEX [CustBetSetting3rd_Member_His_Index] ON [dbo].[CustBetSetting3rd_Member_history] 
(
	[UpdateTime] ASC,
	[CustID] ASC
) 
GO

CREATE TABLE [dbo].[CustBetSetting3rd_Agent_history](
	[UpdateTime] [datetime] NOT NULL,
	[CustID] [int] NOT NULL,
	[SportType] [smallint] NOT NULL,
	[BetType] [smallint] NOT NULL,
	[MinBet] [money] NULL,
	[MaxBet] [money] NULL,
	[MaxPerMatch] [money] NULL

) ON [CustBetSetting3rd_Agent_Table]

GO
ALTER TABLE [dbo].[CustBetSetting3rd_Agent_history] ADD  CONSTRAINT [DF_CustBetSetting3rd_Agent_history_UpdateTime]  DEFAULT (getdate()) FOR [UpdateTime]
GO
ALTER TABLE [dbo].[CustBetSetting3rd_Agent_history] ADD  DEFAULT ((0)) FOR [MinBet]
GO

ALTER TABLE [dbo].[CustBetSetting3rd_Agent_history] ADD  DEFAULT ((0)) FOR [MaxBet]
GO

ALTER TABLE [dbo].[CustBetSetting3rd_Agent_history] ADD  DEFAULT ((0)) FOR [MaxPerMatch]
GO

CREATE CLUSTERED INDEX [CustBetSetting3rd_Agent_His_Index] ON [dbo].[CustBetSetting3rd_Agent_history] 
(
	[UpdateTime] ASC,
	[CustID] ASC
) 
GO


CREATE TABLE [dbo].[CustDiscount3rd_Member_history](
	[UpdateTime] [datetime] NOT NULL,
	[CustID] [int] NOT NULL,
	[SportType] [smallint] NOT NULL,
	[BetType] [smallint] NOT NULL,
	[PlayerDiscount] [decimal](9, 8) NOT NULL,
	[AgentDiscount] [decimal](9, 8) NOT NULL,
	[MasterDiscount] [decimal](9, 8) NOT NULL,
	[SuperDiscount] [decimal](9, 8) NOT NULL
) ON [CustDiscount3rd_Member_Table]

GO
ALTER TABLE [dbo].[CustDiscount3rd_Member_history] ADD  CONSTRAINT [DF_CustDiscount3rd_Member_history_UpdateTime]  DEFAULT (getdate()) FOR [UpdateTime]
GO
ALTER TABLE [dbo].[CustDiscount3rd_Member_history] ADD  DEFAULT ((0)) FOR [PlayerDiscount]
GO

ALTER TABLE [dbo].[CustDiscount3rd_Member_history] ADD  DEFAULT ((0)) FOR [AgentDiscount]
GO

ALTER TABLE [dbo].[CustDiscount3rd_Member_history] ADD  DEFAULT ((0)) FOR [MasterDiscount]
GO

ALTER TABLE [dbo].[CustDiscount3rd_Member_history] ADD  DEFAULT ((0)) FOR [SuperDiscount]
GO
CREATE CLUSTERED INDEX [CustDiscount3rd_Member_His_Index] ON [dbo].[CustDiscount3rd_Member_history] 
(
	[UpdateTime] ASC,
	[CustID] ASC
) 
GO
CREATE TABLE [dbo].[CustDiscount3rd_Agent_history](
	[UpdateTime] [datetime] NOT NULL,
	[CustID] [int] NOT NULL,
	[SportType] [smallint] NOT NULL,
	[BetType] [smallint] NOT NULL,
	[Discount] [decimal](9, 8) NOT NULL

) ON [CustDiscount3rd_Agent_Table]

GO
ALTER TABLE [dbo].[CustDiscount3rd_Agent_history] ADD  CONSTRAINT [DF_CustDiscount3rd_Agent_history_UpdateTime]  DEFAULT (getdate()) FOR [UpdateTime]
GO
ALTER TABLE [dbo].[CustDiscount3rd_Agent_history] ADD  DEFAULT ((0)) FOR [Discount]
GO
CREATE CLUSTERED INDEX [CustDiscount3rd_Agent_His_Index] ON [dbo].[CustDiscount3rd_Agent_history] 
(
	[UpdateTime] ASC,
	[CustID] ASC
) 
GO
CREATE TABLE [dbo].[CustProductStatus_history](
	[UpdateTime] [datetime] NOT NULL,
	[CustID] [int] NOT NULL,
	[bitmapHasSynced] [binary](32) NOT NULL,
	[bitmapIsHidden] [binary](32) NOT NULL,
	[bitmapIsDisabled] [binary](32) NOT NULL
 
) ON [CustProductStatus_Table]

GO
ALTER TABLE [dbo].[CustProductStatus_history] ADD  CONSTRAINT [DF_CustProductStatus_history_UpdateTime]  DEFAULT (getdate()) FOR [UpdateTime]
GO
ALTER TABLE [dbo].[CustProductStatus_history] ADD  CONSTRAINT [DF_CustProductStatus_history_bitmapHasSynced]  DEFAULT (0x00) FOR [bitmapHasSynced]
GO

ALTER TABLE [dbo].[CustProductStatus_history] ADD  CONSTRAINT [DF_CustProductStatus_history_bitmapIsHidden]  DEFAULT (0x00) FOR [bitmapIsHidden]
GO

ALTER TABLE [dbo].[CustProductStatus_history] ADD  CONSTRAINT [DF_CustProductStatus_history_bitmapIsDisabled]  DEFAULT (0x00) FOR [bitmapIsDisabled]
GO
CREATE CLUSTERED INDEX [CustProductStatus_His_Index] ON [dbo].[CustProductStatus_history] 
(
	[UpdateTime] ASC,
	[CustID] ASC
) 
GO




