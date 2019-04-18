/*
	Created: 20190418@Sol
	DB: Archived Dbs
	Task: Add new column SettlementTime into bettrans table
*/

USE bodb_Archive;

GO 

ALTER TABLE dbo.bettrans_bk
ADD SettlementTime DATETIME NULL;