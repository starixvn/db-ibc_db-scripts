/*
	Created: 20190320@Kathy
	DB: DBLOG.bodb_CustomerLog
	Task: enable service broker for TicketVoiding [Redmine:#90155]
*/


USE [bodb_CustomerLog]
GO

ALTER QUEUE [dbo].[Queue_TicketVoiding] WITH STATUS = ON , RETENTION = OFF , ACTIVATION (  STATUS = ON , PROCEDURE_NAME = [sb].[TicketVoiding_ReceiveLog] , MAX_QUEUE_READERS = 10 , EXECUTE AS N'dbo'  ), POISON_MESSAGE_HANDLING (STATUS = ON) 