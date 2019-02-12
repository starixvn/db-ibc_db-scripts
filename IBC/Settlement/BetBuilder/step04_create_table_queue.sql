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

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[Single_Calculate_Queue_3rd](
	[keyid] [int] IDENTITY(1,1) NOT NULL,
	[matchid] [int] NOT NULL,
	[matchcode] [nvarchar](50) NULL,
	[IsCalculating] [int] NULL,
	[LeagueID] [int] NULL,
	[SportType] [int] NULL,
	[AdminId] [int] NULL,
	[IP] [varchar](15) NULL,
	[Starttime] [datetime] NULL,
	[Action] [varchar](20) NULL,
	[sqlCommand] [nvarchar](max) NULL,
	[TryCount] [int] NULL,
	[execTime] [datetime] NULL,
	[duration] [int] NULL
) ON [Event_table]

GO

SET ANSI_PADDING OFF
GO

ALTER TABLE [dbo].[Single_Calculate_Queue_3rd] ADD  CONSTRAINT [DF_Single_Calculate_Queue_3rd_Starttime]  DEFAULT (getdate()) FOR [Starttime]
GO

ALTER TABLE [dbo].[Single_Calculate_Queue_3rd] ADD  CONSTRAINT [DF_Single_Calculate_Queue_3rd_TryCount]  DEFAULT ((0)) FOR [TryCount]
GO

/****** Object:  Index [CIX_Single_Calculate_Queue_3rd_Starttime]    Script Date: 02/12/2019 16:16:24 ******/
CREATE CLUSTERED INDEX [CIX_Single_Calculate_Queue_3rd_Starttime] ON [dbo].[Single_Calculate_Queue_3rd] 
(
	[Starttime] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [Event_table]
GO


