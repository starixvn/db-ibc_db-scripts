/*	Created by: Dominic
	Date 20190704
	Task: Add 6 new tables into publication - [Redmine:#14830]
	DB: publication [CustDB_CustSetting]
		
*/  

USE [CustDB]
GO

--Table #1: VRLeagueGroup
	CREATE TABLE [dbo].[VRLeagueGroup](
		[GroupID] [smallint] NOT NULL,
		[GroupName] [varchar](200) NOT NULL,
		[SportType] [smallint] NOT NULL,
	 CONSTRAINT [PK_VRLeagueGroup] PRIMARY KEY CLUSTERED 
	(
		[GroupID] ASC
	)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [virtualrate_table]
	) ON [virtualrate_table]
	GO

--Table #2: VRLeagueGroupMapping
	CREATE TABLE [dbo].[VRLeagueGroupMapping](
		[LeagueGroupID] [smallint] NOT NULL,
		[VRLeagueGroupID] [smallint] NOT NULL,
	 CONSTRAINT [PK_VRLeagueGroupMapping] PRIMARY KEY CLUSTERED 
	(
		[LeagueGroupID] ASC
	)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [virtualrate_table]
	) ON [virtualrate_table]
	GO

--Table #3: VRBettypeGroup
	CREATE TABLE [dbo].[VRBettypeGroup](
		[GroupID] [smallint] NOT NULL,
		[GroupName] [varchar](200) NOT NULL,
		[SportType] [smallint] NOT NULL,
	 CONSTRAINT [PK_VRBettypeGroup] PRIMARY KEY CLUSTERED 
	(
		[GroupID] ASC
	)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [virtualrate_table]
	) ON [virtualrate_table]
	GO

--Table #4: VRValueMapping
	CREATE TABLE [dbo].[VRValueMapping](
		[ValueID] [tinyint] NOT NULL,
		[Value] [smallmoney] NULL,
	 CONSTRAINT [PK_VRValueMapping] PRIMARY KEY CLUSTERED 
	(
		[ValueID] ASC
	)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [virtualrate_table]
	) ON [virtualrate_table]
	GO

--Table #5: VRSetttingHierarchy
	CREATE TABLE [dbo].[VRSettingHierarchy](
		[LevelID] [int] NOT NULL,
		[SportType] [smallint] NOT NULL,
		[VRLeagueGroupID] [smallint] NOT NULL,
		[VRBetTypeGroupID] [smallint] NOT NULL,
		[BetType] [int] NOT NULL,
		[ParentLevelID] [int] NOT NULL,
	 CONSTRAINT [PK_VRSettingHierarchy] PRIMARY KEY CLUSTERED 
	(
		[LevelID] ASC
	)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [virtualrate_table]
	) ON [virtualrate_table]
	GO

	CREATE NONCLUSTERED INDEX IX_SportLeague ON VRSettingHierarchy(SportType, BetType, VRLeagueGroupID) ON virtualrate_table

--Table #6: VRCustSetting
	CREATE TABLE [dbo].[VRCustSetting](
		[CustID] [int] NOT NULL,
		[LevelID] [int] NOT NULL,
		[ValueIDLIVE] [tinyint] NOT NULL,
		[ValueIDNonLIVE] [tinyint] NOT NULL,
	 CONSTRAINT [PK_VRCustSetting] PRIMARY KEY CLUSTERED 
	(
		[CustID] ASC,
		[LevelID] ASC
	)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [virtualrate_table]
	) ON [virtualrate_table]
	GO





