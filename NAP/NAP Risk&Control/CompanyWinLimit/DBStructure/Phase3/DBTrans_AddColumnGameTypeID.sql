/*
	Created By: Helen
	Created date: 20161212
	Task: https://nexdev.net/issues/61220
	
	DB:DBTRANS/bodb02
	
*/
USE bodb02
GO
ALTER TABLE dbo.BalancePendingDebitGame ADD GameTypeID smallint
GO
ALTER TABLE dbo.BalancePendingCreditGame ADD GameTypeID smallint