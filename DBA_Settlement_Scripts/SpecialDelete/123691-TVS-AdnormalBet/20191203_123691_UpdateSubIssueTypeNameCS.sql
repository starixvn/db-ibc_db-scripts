/*
	Created: 20191203@Max
	Task: AdnormalBet TVS - [Redmine: #123691]
	DB: DBTXN/bodb02
*/
USE bodb02
GO

UPDATE ts
	SET SubIssueTypeNameCS = N'机械投注'
FROM TicketVoiding_SubIssueType ts WITH (ROWLOCK)
WHERE ts.SubIssueTypeId = 36 AND ts.IssueTypeID = 11 AND ts.SubIssueTypeName = 'Robot Betting'

GO





	 