USE [bodb_CustomerLog]
GO

/*
	Created: 20190510@Percy
	DB: DBCUST.CustomerLog, DBLOG.CustomerLog
	Task: Move tables to DBLOG - Create tables
	Remark: Run on DBCUST and DBLOG
*/

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
) ON [OWA_DATA] TEXTIMAGE_ON [OWA_DATA]
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
) ON [OWA_DATA]
GO

GRANT SELECT ON [dbo].[OAS_UserLog_Login] TO [bodbAdminNet] AS [dbo]
GO

/****** Object:  Table [dbo].[[LA_UserLog_RunSP]]    Script Date: 6/21/2019 3:47:02 PM ******/
CREATE TABLE [dbo].[LA_UserLog_RunSP](
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
) ON [OWA_DATA] TEXTIMAGE_ON [OWA_DATA]
GO

ALTER TABLE [dbo].[OA_UserLog_RunSP] ADD  CONSTRAINT [DF_userlog_runSP_logdate]  DEFAULT (getdate()) FOR [LogDate]
GO

ALTER TABLE [dbo].[OA_UserLog_RunSP] ADD  CONSTRAINT [DF_UserLog_RunSP_Duration]  DEFAULT ((0)) FOR [Duration]
GO