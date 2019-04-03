/*
	Created:20190304@Kathy
	DB: DBTXN/bodb02
	Task: Update sub issue type [Redmine:#90155]
*/
USE bodb02
GO

UPDATE TicketVoiding_SubIssueType	
	SET SubIssueTypeName = 'Non-Live'
WHERE SubIssueTypeId = 12
GO