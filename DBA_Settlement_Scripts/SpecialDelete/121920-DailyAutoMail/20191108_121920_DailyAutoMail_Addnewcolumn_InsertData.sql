/*
	Created: 20191108@Helen
	Task: Implement Daily Auto Mail for Abnormal Bets - https://nexdev.net/issues/121920
	DB: DBTXN/bodb02
*/
USE bodb02
GO
ALTER TABLE TicketVoiding_SubIssueType
ADD SubIssueTypeNameCS NVARCHAR(256) NULL

GO

UPDATE TicketVoiding_SubIssueType
SET SubIssueTypeNameCS = N'非正常'
WHERE IssueTypeId = 11 AND SubIssueTypeName = 'Abnormal'

GO

UPDATE TicketVoiding_SubIssueType
SET SubIssueTypeNameCS = N'群组投注'
WHERE IssueTypeId = 11 AND SubIssueTypeName = 'Group Betting'

GO

UPDATE TicketVoiding_SubIssueType
SET SubIssueTypeNameCS = N'出货集团'
WHERE IssueTypeId = 11 AND SubIssueTypeName = 'Hedging'
GO

UPDATE TicketVoiding_SubIssueType
SET SubIssueTypeNameCS = N'打水套利'
WHERE IssueTypeId = 11 AND SubIssueTypeName = 'Arbitrage'
GO
UPDATE TicketVoiding_SubIssueType
SET SubIssueTypeNameCS = N'内定赛事'
WHERE IssueTypeId = 11 AND SubIssueTypeName = 'Fixed Game'

GO

UPDATE TicketVoiding_SubIssueType
SET SubIssueTypeNameCS = N'单'
WHERE IssueTypeId = 11 AND SubIssueTypeName = 'AB Bet'

GO

SELECT  * FROM TicketVoiding_SubIssueType (nolock)
WHERE IssueTypeId = 11