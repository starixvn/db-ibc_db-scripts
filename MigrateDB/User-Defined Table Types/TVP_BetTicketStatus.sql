USE [bodb02]
GO

/*
	Created: 20181120@Percy
	DB: DB052
	Task: Migrate DB053 to DB052
	Remark: Create TVP_BetTicketStatus
*/

CREATE TYPE [dbo].[TVP_BetTicketStatus] AS TABLE(
	[StatusID] [tinyint] NULL
)
GO