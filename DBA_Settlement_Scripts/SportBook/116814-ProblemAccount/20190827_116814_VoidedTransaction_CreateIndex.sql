/*
	Created: 20190827@Helen
	Task: CN88 Problem account - [Redmine:#116814]
	DB: DB061.bodb02
*/
USE [bodb02]
GO
CREATE NONCLUSTERED INDEX [IX_CustID_createdDate] ON dbo.TicketVoiding_VoidedTransaction
(
	CustID ASC,
	CreatedDate ASC
)
GO
