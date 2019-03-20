/*
	Created: 20190320@Kathy
	DB: DBLOG.bodb_CustomerLog
	Task: new table for ticket voiding system [Redmine:#90155]
*/


USE [bodb_CustomerLog]
GO

CREATE TABLE [dbo].[TicketVoiding_Log](
	[LogId] [bigint] IDENTITY(1,1) NOT NULL,
	[LogActionId] [int] NOT NULL,
	[RequestId] [int] NOT NULL,
	[LogData] [varchar](max) NULL,
	[CreatedDate] [datetime] NULL CONSTRAINT [DF_TicketVoiding_Log_CreatedDate]  DEFAULT (getdate()),
	[UserId] [int] NULL,
	[IP] [varchar](50) NULL
) ON [DATA] TEXTIMAGE_ON [DATA]

GO
CREATE CLUSTERED INDEX [CIX_TicketVoiding_Log_CreatedDate] ON [dbo].[TicketVoiding_Log]
(
	[CreatedDate] ASC,
	[RequestId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [DATA]
GO
CREATE NONCLUSTERED INDEX [IX_TicketVoiding_Log_RequestId_LogActionId] ON [dbo].[TicketVoiding_Log]
(
	[RequestId] ASC,
	[LogActionId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [DATA]
GO