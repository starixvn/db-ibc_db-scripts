/*<info serverAlias="DBPRO-bodb02"></info>*/
/*
	Created: 20240705@Lewis
	DB: DBPRO-bodb02
	Task: InHouse Replication - Add new column RepUpdateTime for Products
*/
USE bodb02
GO

ALTER TABLE Products
ADD [RepUpdateTime] [datetime2](7) NULL CONSTRAINT [DF_Products_RepUpdateTime]  DEFAULT (sysdatetime())
GO