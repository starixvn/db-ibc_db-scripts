/*
	Created: 20191108@Helen
	Task: Implement Daily Auto Mail for Abnormal Bets - Modify index - https://nexdev.net/issues/121920
	DB: DBACC/bodb02
*/

DROP INDEX TicketVoiding_VoidedTransaction.[IX_CustID_createdDate]
GO
CREATE NONCLUSTERED INDEX [IX_IssueTypeID_CreatedDate_CustID] ON [dbo].[TicketVoiding_VoidedTransaction]
(
	[IssueTypeID],[CreatedDate],[CustID] 
)
INCLUDE ([SubIssueTypeID]) 
GO
