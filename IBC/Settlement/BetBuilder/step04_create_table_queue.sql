/*
	Created: Vicky
	Task: Betbuilder
	DB: DBTXN/bodb02
	Date: 20190130
*/
USE [bodb02]
GO

/****** Object:  Table [dbo].[Single_Calculate_Queue_3rd]    Script Date: 02/12/2019 16:15:59 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



CREATE TABLE [dbo].[Single_Calculate_Queue_3rd](
	[keyid] [INT] IDENTITY(1,1) NOT NULL,
	[matchid] [INT] NOT NULL,
	[matchcode] [NVARCHAR](50) NULL,
	[IsCalculating] [INT] NULL,
	[LeagueID] [INT] NULL,
	[SportType] [INT] NULL,
	[AdminId] [INT] NULL,
	[IP] [VARCHAR](15) NULL,
	[Starttime] [DATETIME] NULL,
	[Action] [VARCHAR](20) NULL,
	[ActionID] [INT] NULL,
	[sqlCommand] [NVARCHAR](MAX) NULL,
	[TryCount] [INT] NULL,
	[execTime] [DATETIME] NULL,
	[duration] [INT] NULL
) ON [Event_table]

GO


ALTER TABLE [dbo].[Single_Calculate_Queue_3rd] ADD  CONSTRAINT [DF_Single_Calculate_Queue_3rd_Starttime]  DEFAULT (getdate()) FOR [Starttime]
GO

ALTER TABLE [dbo].[Single_Calculate_Queue_3rd] ADD  CONSTRAINT [DF_Single_Calculate_Queue_3rd_TryCount]  DEFAULT ((0)) FOR [TryCount]
GO


/****** Object:  Index [IX_Single_Calculate_Queue_3rd_Starttime]    Script Date: 02/12/2019 17:14:17 ******/
CREATE NONCLUSTERED INDEX [IX_Single_Calculate_Queue_3rd_Starttime] ON [dbo].[Single_Calculate_Queue_3rd] 
(
	[Starttime] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [Event_table]
GO


