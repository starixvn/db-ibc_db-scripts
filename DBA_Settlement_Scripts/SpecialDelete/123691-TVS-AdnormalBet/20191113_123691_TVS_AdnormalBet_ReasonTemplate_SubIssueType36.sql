/*
	Created: 20191204@Max 
	Task: AdnormalBet TVS - [Redmine: #123691]
	DB: DBTXN/bodb02
*/
USE bodb02
GO

INSERT INTO TicketVoiding_ReasonTemplate (Sporttype, SubIssueTypeId, ReasonEnglish, ReasonChineseSimplified)
SELECT 0, 36, 'Abnormal bet',N'由于非正常投注'  

GO