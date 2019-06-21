USE [bodb_CustomerLog]
GO

/*
	Created: 20190510@Percy
	DB: DBCUST.CustomerLog, DBLOG.CustomerLog
	Task: Move tables to DBLOG - Create tables
	Remark: Run on DBCUST and DBLOG
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

/****** Object:  Table [dbo].[OAS_UserLog_RunSP]    Script Date: 6/21/2019 3:47:02 PM ******/
CREATE TABLE [dbo].[OAS_UserLog_RunSP](
	[LogID] [bigint] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[UserID] [int] NULL,
	[SPName] [varchar](50) NULL,
	[Doing] [varchar](4000) NULL,
	[LogDate] [datetime] NULL,
	[CustID] [int] NULL,
	[ActionID] [int] NULL,
	[TrackingValue] [nvarchar](max) NULL,
	[Duration] [int] NULL,
	[TrackingValue2] [nvarchar](max) NULL
) ON [userlog_table] TEXTIMAGE_ON [userlog_table]
GO

GRANT SELECT ON [dbo].[OAS_UserLog_RunSP] TO [bodbAdminNet] AS [dbo]
GO

ALTER TABLE [dbo].[OAS_UserLog_RunSP] ADD  CONSTRAINT [DF_OAS_UserLog_RunSP_LogDate]  DEFAULT (getdate()) FOR [LogDate]
GO

ALTER TABLE [dbo].[OAS_UserLog_RunSP] ADD  CONSTRAINT [DF_OAS_UserLog_RunSP_Duration]  DEFAULT ((0)) FOR [Duration]
GO

/****** Object:  Table [dbo].[OAS_UserLog_Login]    Script Date: 6/21/2019 3:46:59 PM ******/
CREATE TABLE [dbo].[OAS_UserLog_Login](
	[LogID] [bigint] IDENTITY(1,1) NOT NULL,
	[UserID] [int] NOT NULL,
	[IP] [varchar](15) NOT NULL,
	[LogDate] [datetime] NULL,
	[Doing] [varchar](300) NULL,
	[DomainName] [nvarchar](253) NULL,
	[BrowserName] [nvarchar](255) NULL,
	[Platform] [nvarchar](255) NULL,
	[CountryCode] [varchar](64) NULL,
	[Duration] [int] NULL
) ON [userlog_table]
GO

GRANT SELECT ON [dbo].[OAS_UserLog_Login] TO [bodbAdminNet] AS [dbo]
GO