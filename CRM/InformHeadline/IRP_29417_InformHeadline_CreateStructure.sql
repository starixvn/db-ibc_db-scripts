USE [bodb_CRM]
GO

/****** Object:  Table [dbo].[crmInformTitle]    Script Date: 3/30/2015 3:39:09 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[crmInformTitle](
	[TitleID] [int] IDENTITY(1,1) NOT NULL,
	[Title] [nvarchar](2000) NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[Creator] [int] NOT NULL,
	[StatusID] [int] NOT NULL,
	[Filter] [xml] NOT NULL,
 CONSTRAINT [PK_crmInformTitle] PRIMARY KEY CLUSTERED 
(
	[TitleID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [customer_table]
) ON [customer_table] TEXTIMAGE_ON [customer_table]

GO

/****** Object:  Table [dbo].[crmInformHeadline]    Script Date: 3/30/2015 3:51:04 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[crmInformHeadline](
	[HeadlineID] [int] NOT NULL,
	[TitleID] [int] NOT NULL,
	[InformHeadlineStatusID] [int] NOT NULL,
	[GroupID] [int] NOT NULL,
	[UpdatedTime] [datetime] NULL,
	[Remark] [nvarchar](4000) NULL,
	[Handler] [int] NULL,
	[Extension] [int] NULL,
	[ProductStatus] [int] NULL,
	[IsInform] [bit] NOT NULL,
 CONSTRAINT [PK_crmInformHeadline] PRIMARY KEY CLUSTERED 
(
	[HeadlineID] ASC,
	[TitleID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [customer_table]
) ON [customer_table]

GO

/****** Object:  Table [dbo].[crmLogInformHeadline]    Script Date: 4/6/2015 2:09:22 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[crmLogInformHeadline](
	[LogID] [bigint] IDENTITY(1,1) NOT NULL,
	[LogDate] [datetime] NOT NULL,
	[UserID] [int] NOT NULL,
	[ActionID] [int] NOT NULL,
	[IP] [varchar](15) NULL,
	[CustID] [int] NOT NULL,
	[TitleID] [int] NOT NULL,
	[NewValues] [xml] NULL,
	[OldValues] [xml] NULL,
 CONSTRAINT [PK_crmLogInformHeadline1] PRIMARY KEY CLUSTERED 
(
	[LogID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [customer_table]
) ON [customer_table] TEXTIMAGE_ON [customer_table]

GO

SET ANSI_PADDING OFF
GO