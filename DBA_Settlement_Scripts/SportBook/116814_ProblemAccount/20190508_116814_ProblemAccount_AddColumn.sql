/*
	Created: 20190508@Helen
	Tasks: Add column to support CN88 Problem Account - [Redmine:116814]
	DB: DBTrans/bodb02
	
*/
USE bodb02
GO
ALTER TABLE TicketVoiding_VoidedTransaction
ADD IssueTypeID TINYINT
GO
ALTER TABLE TicketVoiding_VoidedTransaction
ADD SubIssueTypeID TINYINT
GO
ALTER TABLE TicketVoiding_VoidedTransaction
ADD CustID INT
GO
