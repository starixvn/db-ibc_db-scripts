USE [bodb_CustomerLog]
GO

/*
	Created: 20190424@Percy
	DB: DBCUST.bodb_CustomerLog
	Task: Migrate DB - New table Log of AFF
*/


CREATE TABLE [dbo].[UserLog_Login_Aff]
(
	[LogID] [bigint] IDENTITY(1,1) NOT NULL,
	[UserID] [int] NOT NULL,
	[ServerID] [int] NOT NULL,
	[IP] [varchar](15) NOT NULL,
	[LogDate] [datetime] NULL,
	[ActionID] [int] NULL,
	[Doing] [varchar](4000) NULL,
	[DomainName] [nvarchar](253) NULL,
	[BrowserName] [nvarchar](255) NULL,
	[Platform] [nvarchar](255) NULL,
	[CountryCode] [varchar](64) NULL,
	[Duration] [int] NULL
) ON [DATA]
GO

GRANT INSERT ON [dbo].[UserLog_Login_Aff] TO [bodbAdminNet] AS [dbo]
GO

GRANT SELECT ON [dbo].[UserLog_Login_Aff] TO [bodbAdminNet] AS [dbo]
GO

GRANT INSERT ON [dbo].[UserLog_Login_Aff] TO [bodbLicenseeNet] AS [dbo]
GO

GRANT SELECT ON [dbo].[UserLog_Login_Aff] TO [bodbLicenseeNet] AS [dbo]
GO