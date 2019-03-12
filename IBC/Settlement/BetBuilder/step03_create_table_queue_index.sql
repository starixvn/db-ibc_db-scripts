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

ALTER TABLE [dbo].[Single_Calculate_Queue_3rd] ADD  CONSTRAINT [PK_Single_Calculate_Queue_3rd] PRIMARY KEY CLUSTERED 
(
	[keyid] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [Event_table]
GO


CREATE NONCLUSTERED INDEX [IX_Single_Calculate_Queue_3rd_IsCalculating_execTime] ON [dbo].[Single_Calculate_Queue_3rd] 
(
	[IsCalculating] ASC,
	[execTime] DESC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [Event_table]
GO


CREATE NONCLUSTERED INDEX [IX_Single_Calculate_Queue_3rd_Starttime] ON [dbo].[Single_Calculate_Queue_3rd] 
(
	[Starttime] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [Event_table]
GO
