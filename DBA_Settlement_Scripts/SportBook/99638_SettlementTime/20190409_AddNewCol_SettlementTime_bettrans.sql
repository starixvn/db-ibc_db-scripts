/*
	Created: 20190409@Sol
	DB: DBTXN.bodb02; 
	Task: Add new column SettlementTime into bettrans table
*/

USE [bodb02];

GO 

ALTER TABLE dbo.bettrans
ADD SettlementTime DATETIME NULL;

GO 

ALTER TABLE dbo.bettrans14
ADD SettlementTime DATETIME NULL;