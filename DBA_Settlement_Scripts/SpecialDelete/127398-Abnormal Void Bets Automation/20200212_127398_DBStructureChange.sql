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
	, IsAutoUnMark BIT
	, CreatedDate DATETIME
	
 CONSTRAINT [PK_TicketVoiding_AutoUnmarkSetting_ID] PRIMARY KEY NONCLUSTERED 
(
	ID ASC
	
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [DATA]
) ON [DATA]

GO

ALTER TABLE [dbo].[TicketVoiding_AutoUnmarkSetting] ADD  CONSTRAINT [DF_TicketVoiding_AutoUnmarkSetting_IsAutoUnMark]  DEFAULT (0) FOR [IsAutoUnMark]
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
