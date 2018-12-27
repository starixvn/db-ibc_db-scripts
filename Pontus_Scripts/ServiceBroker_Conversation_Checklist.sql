/*

----- CHECKING DATA ------------------
SELECT * FROM [sb].[ConfigurationReference] WITH (NOLOCK)	  

SELECT * FROM [sb].[ConfigurationReferenceDetail] WITH (NOLOCK)	 

SELECT * FROM [sb].[ConversationCount] WITH (NOLOCK)	 

SELECT * FROM [Sb].[ConversationManagement] WITH (NOLOCK)	 

SELECT s.name, e.far_service, e.is_initiator
			 , e.conversation_handle, e.conversation_id
			 , e.conversation_group_id, e.state, e.state_desc
			 , e.send_sequence
			 , e.system_sequence
FROM sys.conversation_endpoints e WITH(NOLOCK)
	INNER JOIN sys.services s WITH(NOLOCK) on e.service_id = s.service_id	 
	 
*/
------------ #1: Open more conversation, for example: current = 3, and want more 4 Conversations  -------------------------------------------------
EXEC [Sb].[DBA_ConversationManagement] 
		@functionName = 'Login'
	  , @contractName = 'Contract_CustomerLog_UserLog_Login'		  
	  , @fromService = 'Service_CustomerLog_DBCUST'
	  , @toService = 'Service_CustomerLog_DBLOG'
	  , @Coversation_number = 4
	  , @Mode VARCHAR ='AddNew'
	  
------------ #2: clear all and then renew conversation: 10
--#2.1 - Check Message has been completed or not ?
--#2.1 - Check enable service broker
--#2.3 - set minConversation = 0, [sb].[ConfigurationReferenceDetail]	 

EXEC [Sb].[DBA_ConversationManagement] 
		@functionName = 'Login'
	  , @contractName = 'Contract_CustomerLog_UserLog_Login'		  
	  , @fromService = 'Service_CustomerLog_DBCUST'
	  , @toService = 'Service_CustomerLog_DBLOG'
	  , @Coversation_number = 10
	  , @Mode VARCHAR ='Reset'
