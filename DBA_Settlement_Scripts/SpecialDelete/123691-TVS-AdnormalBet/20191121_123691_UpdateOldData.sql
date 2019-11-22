/*
	Created: 20191121@Max
	Task: AdnormalBet TVS - [Redmine: #123691]
	DB: DBTXN/bodb02
*/
USE bodb02
GO

UPDATE tr
	SET IssueTypeId = ts.IssueTypeId
FROM TicketVoiding_Request tr WITH (ROWLOCK)
	INNER JOIN TicketVoiding_SubIssueType ts WITH (NOLOCK) ON ts.SubIssueTypeId = tr.SubIssueTypeId
WHERE tr.IssueTypeId IS NULL

GO

UPDATE tr
	SET tr.IsTest = 1
FROM TicketVoiding_Request tr WITH (ROWLOCK)
WHERE tr.IsTest IS NULL

GO




	 