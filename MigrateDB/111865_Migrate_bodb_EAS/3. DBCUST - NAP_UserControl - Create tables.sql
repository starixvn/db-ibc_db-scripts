USE [NAP_UserControl]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[eaFunction](
	[FuncID] [int] IDENTITY(1,1) NOT NULL,
	[FuncName] [varchar](50) NOT NULL,
	[FuncDesc] [varchar](100) NULL,
	[FuncKey] [varchar](100) NOT NULL,
	[ParentID] [int] NULL,
	[ParentName] [varchar](50) NULL,
	[CreatedDate] [datetime] NULL,
	[Creator] [int] NULL,
	[Modifier] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[DisplayOrder] [int] NULL,
	[isTest] [bit] NULL,
 CONSTRAINT [PK_eaFunction] PRIMARY KEY CLUSTERED 
(
	[FuncID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [NAP_UserControl_table]
) ON [NAP_UserControl_table]

GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[eaGroup](
	[GroupID] [int] IDENTITY(1,1) NOT NULL,
	[GroupName] [varchar](100) NOT NULL,
	[Description] [varchar](200) NULL,
	[CreatedDate] [datetime] NULL,
	[Creator] [int] NULL,
	[Currency] [varchar](300) NULL,
	[CurrencyCode] [varchar](300) NULL,
	[Site] [varchar](300) NULL,
 CONSTRAINT [PK_eaGroup] PRIMARY KEY CLUSTERED 
(
	[GroupID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [NAP_UserControl_table]
) ON [NAP_UserControl_table]

GO

GRANT SELECT ON [dbo].[eaGroup] TO [bodbAdminNet] AS [dbo]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[eaGroupConfiguration](
	[ProductId] [tinyint] NOT NULL,
	[GroupId] [int] NOT NULL,
	[IsShow] [bit] NOT NULL,
 CONSTRAINT [PK_eaGroupConfiguration] PRIMARY KEY CLUSTERED 
(
	[ProductId] ASC,
	[GroupId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [NAP_UserControl_table]
) ON [NAP_UserControl_table]

GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[eaGroupPolicy](
	[GroupID] [int] NOT NULL,
	[FuncID] [int] NOT NULL,
	[Policy] [tinyint] NOT NULL,
 CONSTRAINT [PK_eaGroupPolicy] PRIMARY KEY CLUSTERED 
(
	[GroupID] ASC,
	[FuncID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [NAP_UserControl_table]
) ON [NAP_UserControl_table]

GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[eaMenu](
	[MenuID] [int] IDENTITY(1,1) NOT NULL,
	[MenuName] [varchar](50) NOT NULL,
	[MenuDesc] [varchar](100) NULL,
	[Url] [varchar](500) NULL,
	[FuncID] [int] NULL,
	[ParentID] [int] NOT NULL,
	[ParentName] [varchar](50) NULL,
	[DisplayOrder] [int] NULL,
	[active] [bit] NULL,
	[Creator] [int] NULL,
	[CreatedDate] [datetime] NULL,
	[Modifier] [int] NULL,
	[ModifiedDate] [datetime] NULL,
 CONSTRAINT [PK_eaMenu] PRIMARY KEY CLUSTERED 
(
	[MenuID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [NAP_UserControl_table]
) ON [NAP_UserControl_table]

GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[eaOn_User](
	[on_userid] [int] IDENTITY(1,1) NOT NULL,
	[custid] [int] NULL,
	[reload_time] [smalldatetime] NULL,
	[IP] [varchar](50) NULL,
	[iskickedout] [bit] NULL,
	[NetSessionID] [varchar](50) NULL,
 CONSTRAINT [PK_eaOnUser] PRIMARY KEY CLUSTERED 
(
	[on_userid] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [NAP_UserControl_table]
) ON [NAP_UserControl_table]

GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[eaUserInfo](
	[UserID] [int] NOT NULL,
	[GroupID] [int] NOT NULL,
	[enabled] [bit] NOT NULL,
	[creator] [int] NULL,
	[createddate] [datetime] NULL,
 CONSTRAINT [PK_eaUserInfo] PRIMARY KEY CLUSTERED 
(
	[UserID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [NAP_UserControl_table]
) ON [NAP_UserControl_table]

GO

GRANT SELECT ON [dbo].[eaUserInfo] TO [bodbAdminNet] AS [dbo]
GO

GRANT INSERT ON [dbo].[eaUserInfo] TO [bodbExtAccNet] AS [dbo]
GO

GRANT SELECT ON [dbo].[eaUserInfo] TO [bodbExtAccNet] AS [dbo]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[eaUserPolicy](
	[UserID] [int] NOT NULL,
	[FuncID] [int] NOT NULL,
	[Policy] [tinyint] NOT NULL,
 CONSTRAINT [PK_eaUserPolicy] PRIMARY KEY CLUSTERED 
(
	[UserID] ASC,
	[FuncID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [NAP_UserControl_table]
) ON [NAP_UserControl_table]

GO

ALTER TABLE [dbo].[eaGroupConfiguration] ADD  CONSTRAINT [DF_eaGroupConfiguration_IsShow]  DEFAULT ((0)) FOR [IsShow]
GO


