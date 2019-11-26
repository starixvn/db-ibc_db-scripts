/*
	Created: 20191002@Max 
	Task: AdnormalBet TVS - [Redmine: #123691]
	DB: DBTXN/bodb02
*/
USE bodb02
GO
CREATE NONCLUSTERED INDEX IX_TicketVoiding_VoidingHistory_RequestID ON TicketVoiding_VoidingHistory (RequestId)
INCLUDE (UserId,CreatedDate,StatusID)

