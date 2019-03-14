/*
	Created:20190128@Kathy
	DB: DBTXN/bodb_CustomerLog
	Task: Ticket Voiding System - Initial conversation [Redmine:#90155]
*/

EXEC [Sb].[ConversationManagement_Upd] 
		@functionName = 'TicketVoiding'
	  , @contractName = 'Contract_TicketVoiding_Log'		  
	  , @fromService = 'Service_TicketVoiding_DBTXN'
	  , @toService = 'Service_TicketVoiding_DBLOG'
	  , @newCnt = 5
go	