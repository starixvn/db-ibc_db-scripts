/*
	Created: 20200115@Helen
	Task: Daily Report for AbnormalBet - [Redmine:122800]
	DB: DBACC/bodb02
*/
USE bodb02
GO
CREATE NONCLUSTERED INDEX IX_Reasonid ON  TicketVoiding_VoidingHistory (Reasonid)
GO
DROP INDEX [TicketVoiding_VoidedTransaction].[IX_IssueTypeID_CreatedDate_CustID]
GO
CREATE NONCLUSTERED INDEX [IX_IssueTypeID_CreatedDate_CustID] ON [dbo].[TicketVoiding_VoidedTransaction] 
(
	[IssueTypeID] ASC,
	[CreatedDate] ASC,
	[CustID] ASC
)
INCLUDE ( [SubIssueTypeID],ReasonId) 
GO