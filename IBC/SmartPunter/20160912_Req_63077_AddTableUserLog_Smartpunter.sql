USE [bodb_CustomerLog]
GO
/*
	Created: 20160912@Winnie
	Task: Add new table [UserLog_SmartPunter] - [Redmine: #63077]
	DB: DBLOG/[bodb_CustomerLog]
*/
/****** Object:  Table [dbo].[UserLog_RunSP]    Script Date: 09/12/2016 13:05:48 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[UserLog_SmartPunter](
	[Logid] [bigint] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[Logdate] [datetime] NOT NULL,
	[UserId] [int] NOT NULL,
	[CustId] [int] NOT NULL,
	[ActionID] [int] NOT NULL,
	[IP] [varchar](15) NULL,
	[IsRestricted] [bit] NOT NULL,
	[UplineId] [int] NULL
) ON [DATA]
GO
SET ANSI_PADDING OFF
GO
CREATE CLUSTERED INDEX [IX_UserLog_SmartPunter] ON [dbo].[UserLog_SmartPunter] 
(
	[Logdate] ASC,
	[UserId] ASC,
	[CustId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [DATA]
GO
