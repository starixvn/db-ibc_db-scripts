/*
	Created: 20191113@Helen
	Task: Recover bet ticket within 7 days - https://nexdev.net/issues/115376 
	DB: DBTXN.bodb_CustomerLog
*/
USE bodb_CustomerLog
GO
GRANT SEND ON SERVICE::[Service_TicketVoiding_DBTXN] TO [vnPatrick] 
GRANT RECEIVE ON [dbo].[Queue_TicketVoiding] TO [vnPatrick]
GO
GRANT SEND ON SERVICE::[Service_TicketVoiding_DBTXN] TO [vnDaniel] 
GRANT RECEIVE ON [dbo].[Queue_TicketVoiding] TO [vnDaniel]
GO

