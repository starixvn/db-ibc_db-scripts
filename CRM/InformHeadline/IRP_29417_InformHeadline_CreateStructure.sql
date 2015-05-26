USE [bodb_CRM]
GO

/****** Object:  Table [dbo].[crmInformTitle_New]    Script Date: 3/30/2015 3:39:09 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[crmInformTitle_New](
	[TitleID] [int] IDENTITY(1,1) NOT NULL,
	[Title] [nvarchar](2000) NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[Creator] [int] NOT NULL,
	[StatusID] [int] NOT NULL,
	[Filter] [xml] NOT NULL,
 CONSTRAINT [PK_crmInformTitle_New] PRIMARY KEY CLUSTERED 
(
	[TitleID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [customer_table]
) ON [customer_table] TEXTIMAGE_ON [customer_table]

GO

/****** Object:  Table [dbo].[crmInformHeadline_New]    Script Date: 3/30/2015 3:51:04 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[crmInformHeadline_New](
	[InformHeadlineID] [int] IDENTITY(1,1) NOT NULL,
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
 CONSTRAINT [PK_crmInformHeadline_New] PRIMARY KEY NONCLUSTERED 
(
	[InformHeadlineID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [customer_table]
) ON [customer_table]

GO

/****** Object:  Index [CIX_TitleID_HeadlineID]    Script Date: 5/18/2015 1:13:50 PM ******/
CREATE CLUSTERED INDEX [CIX_TitleID_HeadlineID] ON [dbo].[crmInformHeadline_New]
(
	[TitleID] ASC, 
	[HeadlineID] ASC	
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [customer_table]
GO

/****** Object:  Table [dbo].[crmLogInformHeadline_New]    Script Date: 4/6/2015 2:09:22 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[crmLogInformHeadline_New](
	[LogID] [bigint] IDENTITY(1,1) NOT NULL,
	[LogDate] [datetime] NOT NULL,
	[UserID] [int] NOT NULL,
	[ActionID] [int] NOT NULL,
	[IP] [varchar](15) NULL,
	[CustID] [int] NOT NULL,
	[TitleID] [int] NOT NULL,
	[NewValues] [xml] NULL,
	[OldValues] [xml] NULL,
 CONSTRAINT [PK_crmLogInformHeadline_New] PRIMARY KEY CLUSTERED 
(
	[LogID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [customer_table]
) ON [customer_table] TEXTIMAGE_ON [customer_table]

GO

SET ANSI_PADDING OFF
GO

/****** Object:  View [dbo].[crmStatus]    Script Date: 4/15/2015 1:48:52 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[crmStation]
AS
SELECT	SettingID StationID,
		SettingValue Name,
		DisplayOrder,
		IsActive
FROM crmSetting WITH (NOLOCK)
WHERE SettingName = 'Station'
GO