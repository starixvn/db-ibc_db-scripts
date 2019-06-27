USE [bodb_CustomerLog]
GO

/*
	Created: 20190510@Percy
	DB: DBLOG.CustomerLog
	Task: Move tables to DBLOG - Create tables
*/

/****** Object:  Table [dbo].[OAS_LogAction]    Script Date: 6/21/2019 3:46:35 PM ******/
CREATE TABLE [dbo].[OAS_LogAction](
	[ActionID] [int] NOT NULL,
	[ActionTypeID] [int] NULL,
	[SPName] [varchar](50) NULL,
	[ActionNameEN] [nvarchar](256) NULL,
	[ActionNameCH] [nvarchar](256) NULL,
	[ActionNameCS] [nvarchar](256) NULL,
	[ActionNameJP] [nvarchar](256) NULL,
	[ActionNameIT] [nvarchar](256) NULL,
	[ActionNameTH] [nvarchar](256) NULL,
	[ActionNameKO] [nvarchar](256) NULL,
	[XsltContent] [varchar](max) NULL,
	[IsInternal] [tinyint] NOT NULL,
 CONSTRAINT [PK_OAS_LogAction] PRIMARY KEY CLUSTERED 
(
	[ActionID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [OWA_DATA]
) ON [OWA_DATA] TEXTIMAGE_ON [OWA_DATA]
GO

GRANT SELECT ON [dbo].[OAS_LogAction] TO [bodbAdminNet] AS [dbo]
GO

ALTER TABLE [dbo].[OAS_LogAction] ADD  CONSTRAINT [DF_OAS_LogAction_IsInternal]  DEFAULT ((0)) FOR [IsInternal]
GO


/****** Object:  Table [dbo].[OAS_LogActionType]    Script Date: 6/21/2019 3:46:38 PM ******/
CREATE TABLE [dbo].[OAS_LogActionType](
	[ActionTypeID] [int] NOT NULL,
	[ActionTypeNameEN] [nvarchar](50) NULL,
	[ActionTypeNameCH] [nvarchar](50) NULL,
	[ActionTypeNameCS] [nvarchar](50) NULL,
	[ActionTypeNameJP] [nvarchar](50) NULL,
	[ActionTypeNameIT] [nvarchar](50) NULL,
	[ActionTypeNameTH] [nvarchar](50) NULL,
	[ActionTypeNameKO] [nvarchar](50) NULL,
 CONSTRAINT [PK_OAS_LogActionType] PRIMARY KEY CLUSTERED 
(
	[ActionTypeID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [OWA_DATA]
) ON [OWA_DATA]
GO

GRANT SELECT ON [dbo].[OAS_LogActionType] TO [bodbAdminNet] AS [dbo]
GO

/****** Object:  Table [dbo].[[LA_LogAction]]    Script Date: 6/21/2019 3:47:02 PM ******/
CREATE TABLE [dbo].[LA_LogAction](
	[ActionID] [int] NOT NULL,
	[ActionTypeID] [int] NULL,
	[SPName] [varchar](50) NULL,
	[ActionNameEN] [nvarchar](256) NULL,
	[ActionNameCH] [nvarchar](256) NULL,
	[ActionNameCS] [nvarchar](256) NULL,
	[ActionNameJP] [nvarchar](256) NULL,
	[ActionNameIT] [nvarchar](256) NULL,
	[ActionNameTH] [nvarchar](256) NULL,
	[ActionNameKO] [nvarchar](256) NULL,
	[XsltContent] [varchar](max) NULL,
	[IsInternal] [tinyint] NOT NULL,
 CONSTRAINT [PK_OA_LogAction] PRIMARY KEY CLUSTERED 
(
	[ActionID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [OWA_DATA]
) ON [OWA_DATA] TEXTIMAGE_ON [OWA_DATA]
GO

ALTER TABLE [dbo].[OA_LogAction] ADD  CONSTRAINT [DF_OA_LogAction_IsInternal]  DEFAULT ((0)) FOR [IsInternal]
GO


/****** Object:  Table [dbo].[[LA_LogActionType]]    Script Date: 6/21/2019 3:47:02 PM ******/
CREATE TABLE [dbo].[LA_LogActionType](
	[ActionTypeID] [int] NOT NULL,
	[ActionTypeNameEN] [nvarchar](50) NULL,
	[ActionTypeNameCH] [nvarchar](50) NULL,
	[ActionTypeNameCS] [nvarchar](50) NULL,
	[ActionTypeNameJP] [nvarchar](50) NULL,
	[ActionTypeNameIT] [nvarchar](50) NULL,
	[ActionTypeNameTH] [nvarchar](50) NULL,
	[ActionTypeNameKO] [nvarchar](50) NULL,
 CONSTRAINT [PK_OA_LogActionType] PRIMARY KEY CLUSTERED 
(
	[ActionTypeID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [OWA_DATA]
) ON [OWA_DATA]
GO