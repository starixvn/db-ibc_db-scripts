USE [bodb_licensee]
GO

/*
	Created: 20190424@Percy
	DB: DBCUST.bodb_Licensee
	Task: Migrate DB - Create new tables
*/


/****** Object:  Table [dbo].[Aff_FunctionInfo]    Script Date: 4/24/2019 10:24:39 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Aff_FunctionInfo](
	[FunctionID] [int] IDENTITY(1,1) NOT NULL,
	[FunctionName] [nvarchar](50) NULL,
	[FunctionNote] [nvarchar](2000) NULL,
	[FunctionDesc] [nvarchar](50) NULL,
	[FunctionRender] [tinyint] NULL,
	[CreateDate] [datetime] NOT NULL,
	[ModifyDate] [datetime] NOT NULL,
	[DisplayOrder] [tinyint] NULL,
	[Creator] [int] NULL,
	[ParentID] [int] NULL,
	[Filenames] [varchar](2000) NULL,
 CONSTRAINT [PK_AFF_FunctionInfo] PRIMARY KEY CLUSTERED 
(
	[FunctionID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [AFF_INDEX]
) ON [AFF_INDEX]
GO
/****** Object:  Table [dbo].[Aff_GroupInfo]    Script Date: 4/24/2019 10:24:39 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Aff_GroupInfo](
	[GroupID] [int] IDENTITY(1,1) NOT NULL,
	[LicenseeID] [int] NOT NULL,
	[GroupName] [nvarchar](50) NOT NULL,
	[GroupDesc] [nvarchar](50) NOT NULL,
	[CreateDate] [datetime] NULL,
	[ModifyDate] [datetime] NULL,
	[DisplayOrder] [tinyint] NULL,
	[Creator] [int] NULL,
 CONSTRAINT [PK_Aff_GroupInfo] PRIMARY KEY CLUSTERED 
(
	[GroupID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [AFF_INDEX],
 CONSTRAINT [UC_Aff_GroupInfo_LicID_GroupName] UNIQUE NONCLUSTERED 
(
	[GroupName] ASC,
	[LicenseeID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [AFF_INDEX]
) ON [AFF_INDEX]
GO
/****** Object:  Table [dbo].[Aff_GroupPolicy]    Script Date: 4/24/2019 10:24:39 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Aff_GroupPolicy](
	[GroupID] [int] NOT NULL,
	[FunctionID] [int] NOT NULL,
	[Policy] [tinyint] NULL,
	[CreateDate] [datetime] NULL,
	[ModifyDate] [datetime] NULL,
	[Creator] [int] NULL,
 CONSTRAINT [PK_Aff_GroupPolicy] PRIMARY KEY CLUSTERED 
(
	[GroupID] ASC,
	[FunctionID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [AFF_INDEX]
) ON [AFF_INDEX]
GO
/****** Object:  Table [dbo].[Aff_LicenseeFunction]    Script Date: 4/24/2019 10:24:39 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Aff_LicenseeFunction](
	[LicenseeID] [int] NOT NULL,
	[FunctionID] [int] NOT NULL,
	[IsActive] [bit] NOT NULL,
 CONSTRAINT [PK_Aff_LicenseeFunction] PRIMARY KEY CLUSTERED 
(
	[LicenseeID] ASC,
	[FunctionID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [AFF_INDEX]
) ON [AFF_INDEX]
GO
/****** Object:  Table [dbo].[Aff_LicenseeUser]    Script Date: 4/24/2019 10:24:39 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Aff_LicenseeUser](
	[LicenseeID] [int] NOT NULL,
	[UserID] [int] NOT NULL,
	[GroupID] [int] NOT NULL,
	[IsActive] [bit] NOT NULL,
	[ModifyDate] [datetime] NULL,
	[ModifyBy] [int] NULL,
 CONSTRAINT [PK_Aff_LicenseeUser] PRIMARY KEY CLUSTERED 
(
	[LicenseeID] ASC,
	[UserID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [AFF_INDEX]
) ON [AFF_INDEX]
GO
/****** Object:  Table [dbo].[Aff_On_User]    Script Date: 4/24/2019 10:24:39 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Aff_On_User](
	[CustID] [int] NULL,
	[Reload_Time] [smalldatetime] NULL,
	[ServerID] [int] NOT NULL,
	[On_UserID] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[IP] [varchar](15) NOT NULL,
	[IsKickedOut] [bit] NULL,
	[NetSessionID] [varchar](30) NOT NULL,
 CONSTRAINT [PK_Aff_On_User] PRIMARY KEY NONCLUSTERED 
(
	[On_UserID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [AFF_INDEX]
) ON [AFF_INDEX]
GO
/****** Object:  Table [dbo].[Aff_UserPolicy]    Script Date: 4/24/2019 10:24:39 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Aff_UserPolicy](
	[UserID] [int] NOT NULL,
	[LicenseeID] [int] NOT NULL,
	[FunctionID] [int] NOT NULL,
	[Policy] [tinyint] NULL,
	[CreateDate] [datetime] NULL,
	[ModifyDate] [datetime] NULL,
	[Creator] [int] NULL,
 CONSTRAINT [PK_Aff_UserPolicy] PRIMARY KEY CLUSTERED 
(
	[UserID] ASC,
	[LicenseeID] ASC,
	[FunctionID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [AFF_INDEX]
) ON [AFF_INDEX]
GO