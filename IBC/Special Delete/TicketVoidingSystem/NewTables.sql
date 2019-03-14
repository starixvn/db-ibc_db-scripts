/*
	Created: 20190122@Kathy
	DB: DBTXN.bodb02
	Task: new table for ticket voiding system [Redmine:#90155]
*/

USE [bodb02]
GO

CREATE TABLE [dbo].[TicketVoiding_Action](
	[ActionId] [tinyint] IDENTITY(1,1) NOT NULL,
	[ActionName] [varchar](50) NULL,
 CONSTRAINT [PK_TicketVoiding_Action_ActionId] PRIMARY KEY CLUSTERED 
(
	[ActionId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [DATA]
) ON [DATA]
GO

------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------
CREATE TABLE [dbo].[TicketVoiding_OperatorInfo](
	[RequestId] [int] NOT NULL,
	[OperatorId] [int] NOT NULL,
	[OperatorTypeId] [tinyint] NOT NULL
) ON [DATA]
GO
CREATE CLUSTERED INDEX [CIX_TicketVoiding_OperatorInfo_RequestId] ON [dbo].[TicketVoiding_OperatorInfo]
(
	[RequestId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [DATA]
GO

------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------
CREATE TABLE [dbo].[TicketVoiding_Queue](
	[QueueId] [int] IDENTITY(1,1) NOT NULL,
	[RequestId] [int] NOT NULL,
	[MatchId] [int] NOT NULL,
	[VoidingHistoryId] [int] NOT NULL,
	[TransIds] [varchar](max) NULL,
	[StatusId] [tinyint] NULL,
	[UserId] [int] NULL,
	[Starttime] [datetime] NULL CONSTRAINT [DF_TicketVoiding_Queue_Starttime]  DEFAULT (getdate()),
	[Exectime] [datetime] NULL,
	[Duration] [int] NULL CONSTRAINT [DF_TicketVoiding_Queue_Duration]  DEFAULT ((0)),
	[IP] [varchar](50) NULL,
	[VoidingTypeId] [tinyint] NULL,
	[TotalTicket] [int] NULL,
	[ErrMsg] [varchar](300) NULL,
	[FailedTransIds] [varchar](max) NULL,
	[NegativeBalanceUsers] [varchar](max) NULL
) ON [DATA] TEXTIMAGE_ON [DATA]
GO
CREATE CLUSTERED INDEX [CIX_TicketVoiding_Queue_VoidingHistoryId] ON [dbo].[TicketVoiding_Queue]
(
	[VoidingHistoryId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [DATA]
GO

CREATE UNIQUE NONCLUSTERED INDEX [IX_TicketVoiding_Queue_QueueId] ON [dbo].[TicketVoiding_Queue]
(
	[QueueId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [DATA]
GO

------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------
CREATE TABLE [dbo].[TicketVoiding_ReasonTemplate](
	[Sporttype] [smallint] NOT NULL,
	[SubIssueTypeId] [tinyint] NOT NULL,
	[ReasonEnglish] [nvarchar](150) NULL,
	[ReasonChineseSimplified] [nvarchar](150) NULL
) ON [DATA]
GO
CREATE CLUSTERED INDEX [CIX_TicketVoiding_ReasonTemplate_Sporttype_SubIssueTypeId] ON [dbo].[TicketVoiding_ReasonTemplate]
(
	[Sporttype] ASC,
	[SubIssueTypeId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [DATA]
GO

------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------
CREATE TABLE [dbo].[TicketVoiding_Request](
	[RequestId] [int] IDENTITY(1,1) NOT NULL,
	[Sporttype] [smallint] NULL,
	[SubIssueTypeId] [smallint] NULL,
	[ActionId] [tinyint] NULL,
	[Provider] [nvarchar](200) NULL,
	[Source] [nvarchar](200) NULL,
	[DecidedBy] [nvarchar](200) NULL,
	[MistakenBy] [nvarchar](200) NULL,
	[Remark] [nvarchar](max) NULL,
	[CheckedBy] [int] NULL,
	[UserId] [int] NULL,
	[CreatedDate] [datetime] NULL CONSTRAINT [DF_TicketVoiding_Request_CreatedDate]  DEFAULT (getdate()),
	[LastModifiedBy] [int] NULL,
	[LastModifiedDate] [datetime] NULL CONSTRAINT [DF_TicketVoiding_Request_LastModifiedDate]  DEFAULT (getdate()),
 CONSTRAINT [PK_TicketVoiding_Request_RequestId] PRIMARY KEY CLUSTERED 
(
	[RequestId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [DATA]
) ON [DATA] TEXTIMAGE_ON [DATA]
GO
CREATE NONCLUSTERED INDEX [IX_TicketVoiding_Request_CreatedDate] ON [dbo].[TicketVoiding_Request]
(
	[CreatedDate] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [DATA]
GO

------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------
CREATE TABLE [dbo].[TicketVoiding_RequestDetail](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[RequestId] [int] NOT NULL,
	[MatchId] [int] NOT NULL,
	[LeagueId] [int] NULL,
	[HomeId] [int] NULL,
	[AwayId] [int] NULL,
	[KickOffTime] [datetime] NULL,
	[LiveHomeScore] [int] NULL,
	[LiveAwayScore] [int] NULL,
	[IssueDetail] [nvarchar](300) NULL
) ON [DATA]
GO

CREATE CLUSTERED INDEX [CIX_TicketVoiding_RequestDetail_RequestId] ON [dbo].[TicketVoiding_RequestDetail]
(
	[RequestId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [DATA]
GO

CREATE NONCLUSTERED INDEX [IX_TicketVoiding_RequestDetail_MatchId] ON [dbo].[TicketVoiding_RequestDetail]
(
	[MatchId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [DATA]
GO

------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------
CREATE TABLE [dbo].[TicketVoiding_VoidingHistory](
	[VoidingHistoryId] [int] IDENTITY(1,1) NOT NULL,
	[RequestId] [int] NOT NULL,
	[MessageId] [int] NULL,
	[StatusId] [tinyint] NULL,
	[ReasonId] [int] NULL,
	[UserId] [int] NULL,
	[CreatedDate] [datetime] NULL CONSTRAINT [DF_TicketVoiding_VoidingHistory_CreatedDate]  DEFAULT (getdate()),
	[ModifiedDate] [datetime] NULL CONSTRAINT [DF_TicketVoiding_VoidingHistory_ModifiedDate]  DEFAULT (getdate()),
 CONSTRAINT [PK_TicketVoiding_VoidingHistory_VoidingHistoryId] PRIMARY KEY NONCLUSTERED 
(
	[VoidingHistoryId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [DATA]
) ON [DATA]
GO
CREATE CLUSTERED INDEX [CIX_TicketVoiding_VoidingHistory_RequestId] ON [dbo].[TicketVoiding_VoidingHistory]
(
	[RequestId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [DATA]
GO




