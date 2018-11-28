USE [bodb02]
GO

/*
	Created: 20181120@Percy
	DB: DB052
	Task: Migrate DB053 to DB052
	Remark: Create TVP_TicketSportBettype
*/

CREATE TYPE [dbo].[TVP_TicketSportBettype] AS TABLE(
	[TransID] [bigint] NULL,
	[Refno] [bigint] NULL,
	[CustID] [int] NULL,
	[ProductID] [tinyint] NULL,
	[Bettype] [smallint] NULL,
	[EventType] [tinyint] NULL,
	[WhTicket] [tinyint] NULL
)
GO