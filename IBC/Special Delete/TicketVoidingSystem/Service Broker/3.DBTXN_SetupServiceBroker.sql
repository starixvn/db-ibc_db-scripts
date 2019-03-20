/*
	Created:20190128@Kathy
	DB: DBTXN/bodb_CustomerLog
	Task: Ticket Voiding System - Setup service broker on DBTXN [Redmine:#90155]
*/

USE bodb_CustomerLog
GO

ALTER DATABASE bodb_CustomerLog SET ENABLE_BROKER WITH ROLLBACK IMMEDIATE
GO

CREATE MESSAGE TYPE MessageType_TicketVoiding_Log
GO

CREATE CONTRACT Contract_TicketVoiding_Log (MessageType_TicketVoiding_Log SENT BY ANY)
GO

CREATE QUEUE Queue_TicketVoiding WITH RETENTION = OFF ON ServiceBroker
GO

CREATE SERVICE Service_TicketVoiding_DBTXN ON QUEUE Queue_TicketVoiding (Contract_TicketVoiding_Log)
GO

/*
	SELECT service_broker_guid  
	FROM sys.databases  
	WHERE database_id = DB_ID()

*/
CREATE ROUTE Route_TicketVoiding_DBLOG AUTHORIZATION dbo
WITH SERVICE_NAME = 'Service_TicketVoiding_DBLOG'
--,BROKER_INSTANCE  = N'C502B761-9DB4-4C51-8498-A13B3716AEFC' -- local dev
--,ADDRESS = 'TCP://DB231:4741'
--,BROKER_INSTANCE  = N'01548fa9-b494-4353-99d6-f07ca31f1087' -- local test
--,ADDRESS = 'TCP://DB215:4741' -- local test
,BROKER_INSTANCE  = N'XXX' -- PROD
,ADDRESS = 'TCP://DBXXX:4741' -- PROD

-- 
GRANT SEND ON SERVICE::Service_TicketVoiding_DBTXN  TO bodbAdminNet
GRANT RECEIVE ON Queue_TicketVoiding TO bodbAdminNet

