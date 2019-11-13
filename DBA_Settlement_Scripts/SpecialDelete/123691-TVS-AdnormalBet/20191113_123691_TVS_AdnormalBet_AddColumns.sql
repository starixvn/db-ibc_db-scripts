/*
	Created: 20191002@Max 
	Task: AdnormalBet TVS - [Redmine: #123691]
	DB: DBTXN/bodb02
*/
USE bodb02
GO

ALTER TABLE TicketVoiding_Request ADD IsTest BIT NULL
GO

ALTER TABLE TicketVoiding_RequestDetail ADD TransIds VARCHAR(MAX) NULL
GO

ALTER TABLE TicketVoiding_VoidingHistory ADD TransIds VARCHAR(MAX) NULL
GO