/*<info serverAlias="DBCUST-CustDB"></info>*/
/*
	Created: 20241111@Kelvin
	DB: DBCUST-CustDB
	Task : LAP - Support BRL base currency (RedmineID: #208662)	
*/

USE [CustDB]

GO

ALTER TABLE ExchangeDailyOanda
ADD [BRL] FLOAT NULL; 


