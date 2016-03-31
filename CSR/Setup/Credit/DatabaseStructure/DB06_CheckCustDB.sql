/*
	Created by: Helen
	Created Date: 20151007
	Description: DCS 
	Database: DB05/CheckCustDB
		
*/
USE CheckCustDB
GO
--- CREATING FILE GROUP AND DATA FILE
IF NOT EXISTS (SELECT TOP 1 1 FROM sys.filegroups where name='CustPTSetting3rd_Member_table')
BEGIN
	ALTER DATABASE CheckCustDB
	ADD FILEGROUP CustPTSetting3rd_Member_table;
END
GO

IF NOT EXISTS (SELECT TOP 1 1 FROM sys.database_files where name='CustPTSetting3rd_Member_table_01')
BEGIN
ALTER DATABASE CheckCustDB 
ADD FILE 
(
	NAME = CustPTSetting3rd_Member_table_01,
	-- Local dev
	FILENAME = 'E:\CHECKDB\CHECKCustDB\CustPTSetting3rd_Member_table_01.NDF'
	--FILENAME = 'H:\USER_DB\CustDB\CustPTSetting3rd_Member_table_01.NDF'
	
)
TO FILEGROUP CustPTSetting3rd_Member_table;
END
GO
--------
IF NOT EXISTS (SELECT TOP 1 1 FROM sys.filegroups where name='CustPTSetting3rd_Agent_table')
BEGIN
	ALTER DATABASE CheckCustDB
	ADD FILEGROUP CustPTSetting3rd_Agent_table;
END
GO

IF NOT EXISTS (SELECT TOP 1 1 FROM sys.database_files where name='CustPTSetting3rd_Agent_table_01')
BEGIN
ALTER DATABASE CheckCustDB 
ADD FILE 
(
	NAME = CustPTSetting3rd_Agent_table_01,
	-- Local dev
	FILENAME = 'E:\CHECKDB\CHECKCustDB\CustPTSetting3rd_Agent_table_01.NDF'
	--FILENAME = 'H:\USER_DB\CustDB\CustPTSetting3rd_Agent_table_01.NDF'
)
TO FILEGROUP CustPTSetting3rd_Agent_table;
END
GO
IF NOT EXISTS (SELECT TOP 1 1 FROM sys.filegroups where name='CustPTGroupSetting3rd_Member_table')
BEGIN
	ALTER DATABASE CheckCustDB
	ADD FILEGROUP CustPTGroupSetting3rd_Member_table;
END
GO

IF NOT EXISTS (SELECT TOP 1 1 FROM sys.database_files where name='CustPTGroupSetting3rd_Member_table_01')
BEGIN
	ALTER DATABASE CheckCustDB 
	ADD FILE 
	(
		NAME = CustPTGroupSetting3rd_Member_table_01,
		-- Local dev
		FILENAME = 'E:\CHECKDB\CHECKCustDB\CustPTGroupSetting3rd_Member_table_01.NDF'
		--FILENAME = 'H:\USER_DB\CustDB\CustPTGroupSetting3rd_Member_table_01.NDF'
	)
	TO FILEGROUP CustPTGroupSetting3rd_Member_table;
END
GO

-------
IF NOT EXISTS (SELECT TOP 1 1 FROM sys.filegroups where name='CustSettingMode3rd_table')
BEGIN
	ALTER DATABASE CheckCustDB
	ADD FILEGROUP CustSettingMode3rd_table;
END
GO

IF NOT EXISTS (SELECT TOP 1 1 FROM sys.database_files where name='CustSettingMode3rd_table_01')
BEGIN
	ALTER DATABASE CheckCustDB 
	ADD FILE 
	(
		NAME = CustSettingMode3rd_table_01,
		-- Local dev
		FILENAME = 'E:\CHECKDB\CHECKCustDB\CustSettingMode3rd_table_01.NDF'
		--FILENAME = 'H:\USER_DB\CustDB\CustSettingMode3rd_table_01.NDF'
	)
	TO FILEGROUP CustSettingMode3rd_table;
END
GO
-------
USE CheckCustDB

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




