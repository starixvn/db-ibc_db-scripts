USE [bodb_CustomerLog]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[eaUserLog_Login](
	[LogID] [bigint] IDENTITY(1,1) NOT NULL,
	[UserID] [int] NOT NULL,
	[IP] [varchar](50) NOT NULL,
	[LogDate] [datetime] NULL,
	[ActionID] [int] NULL,
	[TrackingValue] [nvarchar](300) NULL,
	[DomainName] [varchar](256) NULL,
	[BrowserName] [varchar](256) NULL,
	[Platform] [varchar](256) NULL,
	[CountryCode] [varchar](50) NULL,
	[Duration] [int] NULL,
	[CreatedDate] [datetime] NULL
) ON [eaLogLogin]

GO

SET ANSI_PADDING OFF
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[eaUserLog_RunSP](
	[LogID] [bigint] IDENTITY(1,1) NOT NULL,
	[UserID] [int] NULL,
	[Logdate] [datetime] NULL,
	[CustID] [int] NULL,
	[ActionID] [int] NULL,
	[TrackingValue] [nvarchar](max) NULL,
	[TrackingValue2] [nvarchar](max) NULL,
	[Duration] [int] NULL
) ON [eaLogUserCtrl] TEXTIMAGE_ON [eaLogUserCtrl]

GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[eaUserLog_UserControl](
	[LogID] [bigint] IDENTITY(1,1) NOT NULL,
	[CustID] [int] NOT NULL,
	[LogDate] [datetime] NOT NULL,
	[UserID] [int] NOT NULL,
	[TypeID] [tinyint] NOT NULL,
	[ActionID] [int] NOT NULL,
	[Duration] [int] NOT NULL,
	[TrackingValue] [nvarchar](max) NULL
) ON [eaLogUserCtrl] TEXTIMAGE_ON [eaLogUserCtrl]

GO

CREATE CLUSTERED INDEX [CIX_logdate] ON [dbo].[eaUserLog_Login]
(
	[LogDate] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [eaLogLogin]
GO

CREATE CLUSTERED INDEX [CIX_logdate] ON [dbo].[eaUserLog_RunSP]
(
	[Logdate] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [eaLogUserCtrl]
GO

CREATE CLUSTERED INDEX [CIX_eaUserLog_UserControl] ON [dbo].[eaUserLog_UserControl]
(
	[CustID] ASC,
	[LogDate] ASC,
	[ActionID] ASC,
	[TypeID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [eaLogUserCtrl]
GO


