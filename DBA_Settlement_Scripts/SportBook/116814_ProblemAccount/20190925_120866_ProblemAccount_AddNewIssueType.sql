/*
	Created: 20190925@Helen
	Task: Insert new issueType - https://nexdev.net/issues/120866
	DB: DBTRANS/bodb02
*/
USE bodb02
GO
/*
SET IDENTITY_INSERT TicketVoiding_SubIssueType ON
INSERT INTO TicketVoiding_SubIssueType (SubIssueTypeId,IssueTypeId,SubIssueTypeName)
VALUES (32,11,'AB Bet')
SET IDENTITY_INSERT TicketVoiding_SubIssueType OFF
*/

SET IDENTITY_INSERT TicketVoiding_MessageTemplateSetting ON
INSERT INTO TicketVoiding_MessageTemplateSetting (TemplateId, SubIssueTypeId,Id)
VALUES (34,32, 53)

SET IDENTITY_INSERT TicketVoiding_MessageTemplateSetting OFF
