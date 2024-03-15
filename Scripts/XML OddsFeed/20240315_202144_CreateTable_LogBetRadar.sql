/*<info serverAlias="DBODDSFEED-bodb_OddsFeed"></info>*/
/*
Create: 20240315@Lewis
Task: Create table - Log for BetRadar  [RedmineID: #202144]
DB: DBODDSFEED-bodb_OddsFeed

Description:
*/
USE [bodb_oddsfeed]

CREATE TABLE [dbo].[UserLog_RunSP](
	[LogID] [int] IDENTITY(1,1) NOT NULL,
	[LogDate] [datetime] NOT NULL,
	[PartnerID] [int] NOT NULL,
	[IP] [varchar](50) NULL,
	[TrackingValue] [nvarchar](max) NULL,
	[Duration] [int] NULL,
	[ExecutionTime] [datetime] NULL,
	[MatchIDs] [nvarchar](max) NOT NULL,
	CONSTRAINT [PK_UserLog_RunSP_LogID] PRIMARY KEY CLUSTERED([LogID] ASC)
) ON [DATA]
GO

CREATE NONCLUSTERED INDEX [IX_UserLog_RunSP_LogDate] ON [dbo].[UserLog_RunSP]
(
	[LogDate] ASC
) ON [DATA]
GO



