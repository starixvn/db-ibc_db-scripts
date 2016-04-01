/*
	Created by: Winnie
	Created Date: 20160401
	Description: DCS 
	Database: DBTP/bodb_CustHistory
		
*/

-------

USE bodb_CustHistory

GO

CREATE TABLE [dbo].[Dep_CustPTSetting_Member_history](
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
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON Dep_CustSetting3rd_table
) ON Dep_CustSetting3rd_table

GO

ALTER TABLE [dbo].[Dep_CustPTSetting_Member_history] ADD  DEFAULT ((0)) FOR [SuperPT]
GO

ALTER TABLE [dbo].[Dep_CustPTSetting_Member_history] ADD  DEFAULT ((0)) FOR [MasterPT]
GO

ALTER TABLE [dbo].[Dep_CustPTSetting_Member_history] ADD  DEFAULT ((0)) FOR [AgentPT]
GO

CREATE TABLE [dbo].Dep_CustPTSetting_Agent_history(
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
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON Dep_CustSetting3rd_table
) ON Dep_CustSetting3rd_table

GO

ALTER TABLE [dbo].Dep_CustPTSetting_Agent_history ADD  DEFAULT ((0)) FOR [SuperPT]
GO

ALTER TABLE [dbo].Dep_CustPTSetting_Agent_history ADD  DEFAULT ((0)) FOR [MasterPT]
GO

ALTER TABLE [dbo].Dep_CustPTSetting_Agent_history ADD  DEFAULT ((0)) FOR [AgentPT]
GO

CREATE TABLE [dbo].Dep_CustPTGroupSetting_Member_history(
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
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON Dep_CustSetting3rd_table
) ON Dep_CustSetting3rd_table

GO

ALTER TABLE [dbo].Dep_CustPTGroupSetting_Member_history ADD  DEFAULT ((0)) FOR [SuperPT]
GO

ALTER TABLE [dbo].Dep_CustPTGroupSetting_Member_history ADD  DEFAULT ((0)) FOR [MasterPT]
GO

ALTER TABLE [dbo].Dep_CustPTGroupSetting_Member_history ADD  DEFAULT ((0)) FOR [AgentPT]
GO

CREATE TABLE [dbo].Dep_CustSettingMode_history(
	[CustID] [int] NOT NULL,
	[IsGroupedPT] [bit] NOT NULL,
	IsGroupedComm [bit] NOT NULL,
	IsGroupedBetLimit [bit] NOT NULL,
	IsGroupStakeLevel [bit] NOT NULL
 CONSTRAINT [PK_Dep_CustSettingMode] PRIMARY KEY CLUSTERED 
(
	[CustID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON Dep_CustSetting3rd_table
) ON Dep_CustSetting3rd_table

GO

ALTER TABLE [dbo].Dep_CustSettingMode_history ADD  DEFAULT ((1)) FOR [IsGroupedPT]
GO
ALTER TABLE [dbo].Dep_CustSettingMode_history ADD  DEFAULT ((1)) FOR IsGroupedComm
GO
ALTER TABLE [dbo].Dep_CustSettingMode_history ADD  DEFAULT ((1)) FOR IsGroupedBetLimit
GO
ALTER TABLE [dbo].Dep_CustSettingMode_history ADD  DEFAULT ((1)) FOR IsGroupStakeLevel
GO

CREATE TABLE [dbo].Dep_CustProductStatus_history(
	[CustID] [int] NOT NULL,
	[bitmapIsHidden] [binary](32) NOT NULL,
	[bitmapIsDisabled] [binary](32) NOT NULL,
 CONSTRAINT [CIX_Dep_CustProductStatus_custid] PRIMARY KEY CLUSTERED 
(
	[CustID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON Dep_CustSetting3rd_table
) ON Dep_CustSetting3rd_table

GO

ALTER TABLE [dbo].Dep_CustProductStatus_history ADD  CONSTRAINT [DF_Dep_CustPRoductStatus_bitmapIsHidden]  DEFAULT (0x00) FOR [bitmapIsHidden]
GO

ALTER TABLE [dbo].Dep_CustProductStatus_history ADD  CONSTRAINT [DF_Dep_CustPRoductStatus_bitmapIsDisabled]  DEFAULT (0x00) FOR [bitmapIsDisabled]
GO

---
CREATE TABLE [dbo].Dep_CustStakeLevel_Agent_history(
	[CustID] [int] NOT NULL,
	[SportType] [smallint] NOT NULL,
	[BetType] [smallint] NOT NULL,
	[StakeLevelList] [varchar](200) NULL,
 CONSTRAINT [PK_Dep_CustStakeLevel_Agent] PRIMARY KEY CLUSTERED 
(
	[CustID] ASC,
	[SportType] ASC,
	[BetType] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON Dep_CustSetting3rd_table
) ON Dep_CustSetting3rd_table

GO

CREATE TABLE [dbo].Dep_CustStakeLevel_Member_history(
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
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON Dep_CustSetting3rd_table
) ON Dep_CustSetting3rd_table

GO
