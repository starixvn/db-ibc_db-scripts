/*
	Created:20190128@Kathy
	DB: DBLOG/bodb_CustomerLog
	Task: Ticket Voiding System - Setup service broker on DBLOG [Redmine:#90155]
*/

USE bodb_CustomerLog
GO

CREATE MESSAGE TYPE MessageType_TicketVoiding_Log
GO

CREATE CONTRACT Contract_TicketVoiding_Log
(MessageType_TicketVoiding_Log SENT BY ANY)
GO

CREATE QUEUE Queue_TicketVoiding WITH RETENTION = OFF ON servicebroker
GO

CREATE SERVICE Service_TicketVoiding_DBLOG
ON QUEUE Queue_TicketVoiding (Contract_TicketVoiding_Log)
GO

CREATE ROUTE Route_TicketVoiding_DBTXN -- point back to source
WITH SERVICE_NAME='Service_TicketVoiding_DBTXN',
--ADDRESS='TCP://DB230:4741' -- local dev
--,BROKER_INSTANCE  = N'9F768743-57EA-4C4B-96DA-6CA1AEA4BC7C' -- local dev
--ADDRESS='TCP://DB206:4741' --local test
--,BROKER_INSTANCE  = N'9f768743-57ea-4c4b-96da-6ca1aea4bc7c' -- local test
ADDRESS='TCP://DBXXX:4741' -- PROD
,BROKER_INSTANCE  = N'XXX' -- PROD

GO

GRANT SEND ON SERVICE::Service_TicketVoiding_DBLOG TO PUBLIC -- Grant send permission, only need to run against target side
GO

GRANT SEND ON SERVICE::Service_TicketVoiding_DBLOG TO bodbAdminNet
GO

GRANT RECEIVE ON Queue_TicketVoiding TO bodbAdminNet

USE master
GO

CREATE CERTIFICATE [SSBS_DBTXN_Cert] 
   AUTHORIZATION dba_cert_User
   FROM FILE = N'D:\SSBSQLCertificates\SSBS_DBTXN_Cert.cer'
GO


