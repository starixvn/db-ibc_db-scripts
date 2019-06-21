USE [bodb_CustomerLog]
GO

/*
	Created: 20190621@Kathy
	DB: DBLOG/bodb_CustomerLog
	Task: Backup table before update/insert data on table TicketVoiding_Log [Redmine:#114596]
*/
-- Step 1: Create new table to backup data
CREATE TABLE [dbo].[TicketVoiding_Log_BK](
	[LogId] [bigint] IDENTITY(1,1) NOT NULL,
	[LogActionId] [int] NOT NULL,
	[RequestId] [int] NOT NULL,
	[LogData] [varchar](max) NULL,
	[CreatedDate] [datetime] NULL ,
	[UserId] [int] NULL,
	[IP] [varchar](50) NULL,
	[SessionId] [int] NULL ,
	[MatchId] [int] NULL 
) ON [DATA] TEXTIMAGE_ON [DATA]

GO

SET ANSI_PADDING OFF
GO

-- Step2: backup data
INSERT INTO TicketVoiding_Log_BK(LogId, LogActionId, RequestId, LogData, CreatedDate, UserId, IP, SessionId, MatchId)
SELECT	LogId, LogActionId, RequestId, LogData, CreatedDate, UserId, IP, SessionId, MatchId
FROM	dbo.TicketVoiding_Log WITH(NOLOCK)
