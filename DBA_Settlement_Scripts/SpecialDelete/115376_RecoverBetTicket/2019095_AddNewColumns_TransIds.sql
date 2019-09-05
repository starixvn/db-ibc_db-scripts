/*	
	Created: 20190905@Sol
	Task: CN88 - Recover bet ticket within 7 days [Redmine:#115376]
	DB: DBTXN/bodb02
*/

USE [bodb02]

GO

ALTER TABLE TicketVoiding_RequestDetail ADD TransIds VARCHAR(MAX) NULL;

GO

ALTER TABLE TicketVoiding_VoidingHistory ADD TransIds VARCHAR(MAX) NULL; 

GO