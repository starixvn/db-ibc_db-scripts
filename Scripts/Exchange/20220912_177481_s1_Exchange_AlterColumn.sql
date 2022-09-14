/*<info serverAlias="DBCUST-CustDB"></info>*/
/*
	Created: 20220912@Evan
	DB: DBCUST-CustDB
	Task : Deposit - AG Group - CandyA18 - Support crypto
	https://nexdev.net/issues/177481
*/
USE [CustDB]

GO

ALTER TABLE Exchange 
ALTER COLUMN MultipliedBy DECIMAL (19,8) 

ALTER TABLE Exchange 
ADD CurrencyType TINYINT NOT NULL CONSTRAINT [DF_Exchange_CurrencyType]  DEFAULT (0) 
 
 


