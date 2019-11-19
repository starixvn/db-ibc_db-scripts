/*
	Created: 20191002@Max 
	Task: AdnormalBet TVS - [Redmine: #123691]
	DB: DBTXN/bodb02
*/
USE bodb02
GO

INSERT INTO TicketVoiding_ReasonTemplate (Sporttype, SubIssueTypeId, ReasonEnglish, ReasonChineseSimplified)
SELECT 0, SubIssueTypeId, 'Abnormal bet',N'由于非正常投注'  
FROM TicketVoiding_SubIssueType WITH (NOLOCK)
WHERE IssueTypeId = 11

GO