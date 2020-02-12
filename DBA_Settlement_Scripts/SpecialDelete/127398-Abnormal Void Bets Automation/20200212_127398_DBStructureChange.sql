/*
	Created: 20200212@Helen
	Task: Abnormal Void Bets Automation [Redmine: #128359]
	DB: DBTRANS/BODB02
*/

USE bodb02
GO
CREATE TABLE [dbo].[TicketVoiding_AutoUnmarkSetting]
(
	ID INT IDENTITY (1,1)
	, Matchid INT
	, Bettype SMALLINT
	, IsConfirm BIT
	, CreatedDate DATETIME
	
 CONSTRAINT [PK_TicketVoiding_AutoUnmarkSetting_ID] PRIMARY KEY NONCLUSTERED 
(
	ID ASC
	
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [DATA]
) ON [DATA]

GO

ALTER TABLE [dbo].[TicketVoiding_AutoUnmarkSetting] ADD  CONSTRAINT [DF_TicketVoiding_AutoUnmarkSetting_IsConfirm]  DEFAULT (0) FOR [IsConfirm]
GO
ALTER TABLE [dbo].[TicketVoiding_AutoUnmarkSetting] ADD  CONSTRAINT [DF_TicketVoiding_AutoUnmarkSetting_CreatedDate]  DEFAULT (GETDATE()) FOR [CreatedDate]
GO
CREATE CLUSTERED INDEX CIX_TicketVoiding_AutoUnmarkSetting_Matchid_Bettype ON [TicketVoiding_AutoUnmarkSetting]
(
	Matchid
	,Bettype
)
GO
CREATE NONCLUSTERED INDEX IX_TicketVoiding_AutoUnmarkSetting_CreatedDate ON [TicketVoiding_AutoUnmarkSetting]
(
	CreatedDate
)
GO

/*Action: AddRequest or CAL-HT or CAL-FT or CAL */
CREATE TABLE [dbo].[TicketVoiding_AutoVoidRequest_Queue](
	[QueueId] [int] IDENTITY(1,1) NOT NULL,
	[RequestId] [int] NOT NULL,
	[MatchId] [int] NOT NULL,
	[Action]  [varchar](100) NULL,
	[StatusId] [tinyint] NULL,
	[UserId] [int] NULL,
	[Starttime] [datetime] NULL,
	[Exectime] [datetime] NULL,
	[Duration] [int] NULL,
	[IP] [varchar](50) NULL,
	[ErrMsg] [varchar](300) NULL,
	[NegativeBalanceUsers] [varchar](MAX) NULL
) ON [DATA]

GO

ALTER TABLE [dbo].[TicketVoiding_AutoVoidRequest_Queue] ADD  CONSTRAINT [DF_TicketVoiding_AutoVoidRequest_Queue_Starttime]  DEFAULT (getdate()) FOR [Starttime]
GO

ALTER TABLE [dbo].[TicketVoiding_AutoVoidRequest_Queue] ADD  CONSTRAINT [DF_TicketVoiding_AutoVoidRequest_Queue_Duration]  DEFAULT ((0)) FOR [Duration]
GO
