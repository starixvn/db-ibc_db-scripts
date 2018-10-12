/*
	Created: 20180924@Helen
	Task: DB052.bodb_NAP Migration to DBCust - [Redmine:100493]
	DB:DBCUST/NAP_UserControl
	
	Tables: 12 - DBNAP
		UserMarkedMenus
		MenuItems
		Sites
		SiteURL
		UserFunction
		Users
		UserSite
		Functions
		OnUser
		ObjectType
		GroupFunction
		Groups

*/
USE NAP_UserControl
GO
CREATE TABLE [dbo].[NAP_Functions](
	[FunctionId] [smallint] IDENTITY(1,1) NOT NULL,
	[SiteId] [tinyint] NOT NULL,
	[FunctionName] [nvarchar](50) NOT NULL,
	[FunctionKey] [nvarchar](50) NOT NULL,
	[Description] [nvarchar](200) NULL,
	[ParentId] [smallint] NULL,
	[ParentName] [nvarchar](50) NULL,
	[CRUD] [tinyint] NOT NULL,
	[DisplayOrder] [smallint] NOT NULL,
	[IsActive] [bit] NOT NULL,
	[CreatedBy] [int] NULL,
	[CreatedDate] [datetime] NOT NULL,
	[ModifiedBy] [int] NULL,
	[ModifiedDate] [datetime] NOT NULL,
	[Environment] [varchar](10) NULL,
 CONSTRAINT [PK_NAP_Functions] PRIMARY KEY CLUSTERED 
(
	[FunctionId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [NAP_UserControl_table]
) ON [NAP_UserControl_table]

GO
CREATE TABLE [dbo].[NAP_GroupFunction](
	[GroupId] [smallint] NOT NULL,
	[FunctionId] [smallint] NOT NULL,
	[SiteId] [tinyint] NULL,
	[Policy] [tinyint] NOT NULL,
	[CreatedBy] [int] NULL,
	[CreatedDate] [datetime] NOT NULL,
	[ModifiedBy] [int] NULL,
	[ModifiedDate] [datetime] NOT NULL,
 CONSTRAINT [PK_NAP_GroupFunction] PRIMARY KEY CLUSTERED 
(
	[GroupId] ASC,
	[FunctionId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [NAP_UserControl_table]
) ON [NAP_UserControl_table]

GO


CREATE TABLE [dbo].[NAP_Groups](
	[GroupId] [smallint] IDENTITY(1,1) NOT NULL,
	[GroupName] [varchar](50) NOT NULL,
	[Description] [varchar](200) NULL,
	[IsActive] [bit] NOT NULL,
	[CreatedBy] [int] NULL,
	[CreatedDate] [datetime] NOT NULL,
	[ModifiedBy] [int] NULL,
	[ModifiedDate] [datetime] NOT NULL,
 CONSTRAINT [PK_NAP_Groups] PRIMARY KEY CLUSTERED 
(
	[GroupId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [NAP_UserControl_table]
) ON [NAP_UserControl_table]

GO

SET ANSI_PADDING OFF
GO

ALTER TABLE [dbo].[NAP_Groups] ADD  CONSTRAINT [DF_NAP_Groups_IsActive]  DEFAULT ((1)) FOR [IsActive]
GO


CREATE TABLE [dbo].[NAP_MenuItems](
	[MenuItemId] [int] IDENTITY(1,1) NOT NULL,
	[FunctionId] [smallint] NOT NULL,
	[SiteId] [tinyint] NOT NULL,
	[MenuItemName] [nvarchar](50) NOT NULL,
	[Description] [nvarchar](200) NULL,
	[ParentId] [smallint] NULL,
	[ParentName] [nvarchar](50) NULL,
	[Policy] [tinyint] NOT NULL,
	[URL] [varchar](200) NULL,
	[DisplayOrder] [smallint] NOT NULL,
	[IsActive] [bit] NOT NULL,
	[CreatedBy] [int] NULL,
	[CreatedDate] [datetime] NOT NULL,
	[ModifiedBy] [int] NULL,
	[ModifiedDate] [datetime] NOT NULL,
	[Environment] [varchar](10) NULL,
 CONSTRAINT [PK_NAP_Menus] PRIMARY KEY CLUSTERED 
(
	[MenuItemId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [NAP_UserControl_table]
) ON [NAP_UserControl_table]

GO

CREATE TABLE [dbo].[NAP_ObjectType](
	[ObjectTypeId] [int] NOT NULL,
	[ObjectTypeName] [varchar](50) NOT NULL,
 CONSTRAINT [PK_NAP_ObjectType] PRIMARY KEY CLUSTERED 
(
	[ObjectTypeId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [NAP_UserControl_table]
) ON [NAP_UserControl_table]

GO

CREATE TABLE [dbo].[NAP_OnUser](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[UserId] [int] NULL,
	[SiteId] [int] NULL,
	[ReloadTime] [smalldatetime] NULL,
	[IsKickedOut] [bit] NULL,
	[IP] [varchar](50) NULL,
	[NetSessionId] [varchar](30) NULL,
 CONSTRAINT [PK_NAP_On_User] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [NAP_UserControl_table]
) ON [NAP_UserControl_table]

GO

ALTER TABLE [dbo].[NAP_OnUser] ADD  CONSTRAINT [DF_NAP_On_User_iskickedout]  DEFAULT ((0)) FOR [IsKickedOut]
GO

CREATE TABLE [dbo].[NAP_Sites](
	[SiteId] [tinyint] IDENTITY(1,1) NOT NULL,
	[SiteName] [varchar](50) NOT NULL,
	[Description] [varchar](200) NULL,
	[URL] [varchar](200) NULL,
	[TestURL] [varchar](200) NULL,
	[IsActive] [bit] NOT NULL,
	[Environment] [varchar](10) NULL,
	[SecretAccessKey] [varchar](200) NULL,
	[SiteKey] [varchar](50) NULL,
 CONSTRAINT [PK_NAP_Sites] PRIMARY KEY CLUSTERED 
(
	[SiteId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [NAP_UserControl_table]
) ON [NAP_UserControl_table]

GO
ALTER TABLE [dbo].[NAP_Sites] ADD  CONSTRAINT [DF_NAP_Site_IsActive]  DEFAULT ((1)) FOR [IsActive]
GO
CREATE TABLE [dbo].[NAP_SiteURL](
	[SiteURLId] [int] IDENTITY(1,1) NOT NULL,
	[SiteId] [tinyint] NOT NULL,
	[URL] [varchar](100) NOT NULL,
	[Environment] [varchar](10) NOT NULL,
	[IsDefault] [bit] NOT NULL,
	[IsActive] [bit] NOT NULL,
 CONSTRAINT [PK_NAP_SiteURLs] PRIMARY KEY CLUSTERED 
(
	[SiteURLId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [NAP_UserControl_table]
) ON [NAP_UserControl_table]


CREATE TABLE [dbo].[NAP_UserFunction](
	[UserId] [int] NOT NULL,
	[FunctionId] [smallint] NOT NULL,
	[SiteId] [tinyint] NOT NULL,
	[Policy] [tinyint] NOT NULL,
	[CreatedBy] [int] NULL,
	[CreatedDate] [datetime] NOT NULL,
	[ModifiedBy] [int] NULL,
	[ModifiedDate] [datetime] NOT NULL,
 CONSTRAINT [PK_NAP_UserFunction] PRIMARY KEY CLUSTERED 
(
	[UserId] ASC,
	[FunctionId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [NAP_UserControl_table]
) ON [NAP_UserControl_table]

GO

CREATE TABLE [dbo].[NAP_UserMarkedMenus](
	[UserId] [int] NOT NULL,
	[MenuItemId] [int] NOT NULL,
	[IsMarked] [bit] NOT NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[ModifiedBy] [int] NULL,
	[ModifiedDate] [datetime] NULL,
 CONSTRAINT [PK_NAP_UserMarkedFunctions] PRIMARY KEY CLUSTERED 
(
	[UserId] ASC,
	[MenuItemId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [NAP_UserControl_table]
) ON [NAP_UserControl_table]

GO

CREATE TABLE [dbo].[NAP_Users](
	[UserId] [int] NOT NULL,
	[GroupId] [smallint] NULL,
	[LastLoginDate] [datetime] NULL,
	[CreatedBy] [int] NULL,
	[CreatedDate] [datetime] NOT NULL,
	[ModifiedBy] [int] NULL,
	[ModifiedDate] [datetime] NOT NULL,
 CONSTRAINT [PK_NAP_Users] PRIMARY KEY CLUSTERED 
(
	[UserId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [NAP_UserControl_table]
) ON [NAP_UserControl_table]

GO

CREATE TABLE [dbo].[NAP_UserSite](
	[UserId] [int] NOT NULL,
	[SiteId] [tinyint] NOT NULL,
	[Level] [int] NOT NULL,
	[IsActive] [bit] NOT NULL,
	[LastLoginDate] [datetime] NULL,
	[CreatedBy] [int] NULL,
	[CreatedDate] [datetime] NOT NULL,
	[ModifiedBy] [int] NULL,
	[ModifiedDate] [datetime] NOT NULL,
	[ExpiredDate] [smalldatetime] NULL,
	[IsNeverExpired] [bit] NULL,
 CONSTRAINT [PK_NAP_UserSite] PRIMARY KEY CLUSTERED 
(
	[UserId] ASC,
	[SiteId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [NAP_UserControl_table]
) ON [NAP_UserControl_table]

GO

ALTER TABLE [dbo].[NAP_UserSite] ADD  CONSTRAINT [DF_NAP_UserSite_Level]  DEFAULT ((1)) FOR [Level]
GO

ALTER TABLE [dbo].[NAP_UserSite] ADD  CONSTRAINT [DF_NAP_UserSite_IsActive]  DEFAULT ((1)) FOR [IsActive]
GO














