USE [bodb_AGE]
GO

/*
	Created: 20191107@Percy
	DB: DB052.bodb_Age
	Task: Create Limit Loss tables on DB052
*/

-- 1. LimitLoss_ActionConfig
CREATE TABLE [dbo].[LimitLoss_ActionConfig](
	[ConfigID] [int] IDENTITY(1,1) NOT NULL,
	[LevelID] [tinyint] NOT NULL,
	[ActionID] [tinyint] NOT NULL,
	[Value] [int] NOT NULL,
 CONSTRAINT [PK_LimitLoss_ActionConfig] PRIMARY KEY CLUSTERED 
(
	[ConfigID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [ageDATA]
) ON [ageDATA]
GO


-- 2. LimitLoss_ActionItem
CREATE TABLE [dbo].[LimitLoss_ActionItem](
	[ActionID] [tinyint] NOT NULL,
	[ActionDesc] [varchar](500) NULL,
 CONSTRAINT [PK_LimitLoss_ActionItem] PRIMARY KEY CLUSTERED 
(
	[ActionID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [ageDATA]
) ON [ageDATA]
GO

-- 3. LimitLoss_HeadlineSetting
CREATE TABLE [dbo].[LimitLoss_HeadlineSetting](
	[GroupHeadlineID] [int] NOT NULL,
	[MaxLoss] [money] NOT NULL,
	[TotalBalance] [money] NULL,
	[LevelID] [tinyint] NOT NULL,
	[YesterdayBalance] [money] NULL,
	[OldLevelID] [tinyint] NULL,
	[NotifyLetsTalk] [bit] NULL,
 CONSTRAINT [PK_LimitLoss_HeadlineSetting] PRIMARY KEY CLUSTERED 
(
	[GroupHeadlineID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [ageDATA]
) ON [ageDATA]
GO

GRANT INSERT ON [dbo].[LimitLoss_HeadlineSetting] TO [bodbAdminNet] AS [dbo]
GO
GRANT SELECT ON [dbo].[LimitLoss_HeadlineSetting] TO [bodbAdminNet] AS [dbo]
GO
GRANT UPDATE ON [dbo].[LimitLoss_HeadlineSetting] TO [bodbAdminNet] AS [dbo]
GO
ALTER TABLE [dbo].[LimitLoss_HeadlineSetting] ADD  CONSTRAINT [DF_LimitLoss_HeadlineSetting_LevelID]  DEFAULT ((0)) FOR [LevelID]
GO


-- 4. LimitLoss_Setting
CREATE TABLE [dbo].[LimitLoss_Setting](
	[CustID] [int] NOT NULL,
	[MaxLoss] [money] NULL,
	[TotalBalance] [money] NULL,
	[LevelID] [tinyint] NOT NULL,
	[YesterdayBalance] [money] NULL,
	[OldLevelID] [tinyint] NULL,
	[NotifyLetsTalk] [bit] NULL,
 CONSTRAINT [PK_LimitLoss_Setting] PRIMARY KEY CLUSTERED 
(
	[CustID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [ageDATA]
) ON [ageDATA]
GO

GRANT INSERT ON [dbo].[LimitLoss_Setting] TO [bodbAdminNet] AS [dbo]
GO
GRANT SELECT ON [dbo].[LimitLoss_Setting] TO [bodbAdminNet] AS [dbo]
GO
GRANT UPDATE ON [dbo].[LimitLoss_Setting] TO [bodbAdminNet] AS [dbo]
GO
GRANT INSERT ON [dbo].[LimitLoss_Setting] TO [bodbDownlineNet] AS [dbo]
GO
GRANT SELECT ON [dbo].[LimitLoss_Setting] TO [bodbDownlineNet] AS [dbo]
GO
GRANT UPDATE ON [dbo].[LimitLoss_Setting] TO [bodbDownlineNet] AS [dbo]
GO
GRANT INSERT ON [dbo].[LimitLoss_Setting] TO [bodbExtAccNet] AS [dbo]
GO
GRANT SELECT ON [dbo].[LimitLoss_Setting] TO [bodbExtAccNet] AS [dbo]
GO
GRANT UPDATE ON [dbo].[LimitLoss_Setting] TO [bodbExtAccNet] AS [dbo]
GO
ALTER TABLE [dbo].[LimitLoss_Setting] ADD  CONSTRAINT [DF_LimitLoss_Setting_LevelID]  DEFAULT ((0)) FOR [LevelID]
GO
ALTER TABLE [dbo].[LimitLoss_Setting] ADD  CONSTRAINT [DF_LimitLoss_Setting_OldLevelID]  DEFAULT ((0)) FOR [OldLevelID]
GO