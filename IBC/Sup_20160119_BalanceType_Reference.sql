/*
	Created: 20151230@Elodie
	Task: Update BalanceType in Product table to refer information
*/
USE bodb02
GO
ALTER TABLE Products ADD BalanceType TINYINT
GO
ALTER TABLE Products ADD SubProductBalanceType VARCHAR(MAX)