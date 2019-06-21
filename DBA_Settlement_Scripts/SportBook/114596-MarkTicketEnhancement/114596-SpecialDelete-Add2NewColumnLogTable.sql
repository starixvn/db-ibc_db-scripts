USE bodb_CustomerLog
GO
/*
	Created: 20190606@Kathy
	Task : Add 2 new columns 
	DB: DBLOG.bodb_CustomerLog [Redmine:#114596]
*/

-- Add 2 new columns
ALTER table dbo.TicketVoiding_Log ADD SessionId INT CONSTRAINT DF_TicketVoiding_Log_SessionId DEFAULT (0)
GO
ALTER table dbo.TicketVoiding_Log ADD MatchId INT CONSTRAINT DF_TicketVoiding_Log_MatchId DEFAULT (0)

GO