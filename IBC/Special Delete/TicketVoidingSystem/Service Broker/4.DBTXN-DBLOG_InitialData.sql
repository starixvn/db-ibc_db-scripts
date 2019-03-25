/*
	Create By: Kathy
	Created Date: 20181212
	Task: Apply Service Broker for Writing Log - [Redmine: 90155]
	DB: DBLOG,DBTXN/bodb_CustomerLog
	
*/
USE bodb_CustomerLog
GO
INSERT INTO [sb].[ConfigurationReference]([FunctionName],[MaxReceiveMsg],[MaxReceiveTimeOut])
VALUES('TicketVoiding',100,200)
GO
--[sb].[ConfigurationReferenceDetail]

INSERT INTO [sb].[ConfigurationReferenceDetail]([FunctionName],[ContractName],[MessageType],[MinConversation],[MaxConversation])
VALUES ('TicketVoiding','Contract_TicketVoiding_Log','MessageType_TicketVoiding_Log',5,20)
GO

