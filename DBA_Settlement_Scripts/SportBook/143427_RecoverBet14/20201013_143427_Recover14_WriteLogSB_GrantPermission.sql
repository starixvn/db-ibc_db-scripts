/*
	Created: 20201013@Helen
	Task: Script for recover single ticket[Redmine:#143427]
	DB: DBTRANS/bodb02
*/
USE bodb_CustomerLog
GO
GRANT SEND ON SERVICE::[Service_TicketVoiding_DBTXN] TO [vnLukas] 
GRANT RECEIVE ON [dbo].[Queue_TicketVoiding] TO [vnLukas]



