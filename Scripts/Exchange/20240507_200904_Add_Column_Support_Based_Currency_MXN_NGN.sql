/*<info serverAlias="DBCUST-CustDB"></info>*/
/*
	Created: 20240507@Kelvin
	DB: DBCUST-CustDB
	Task : LAP - Support based currency JPY, MXN, NGN (RedmineID: #200904)	
*/

USE [CustDB]

GO

ALTER TABLE ExchangeDailyOanda
ADD [MXN] FLOAT NULL; 

ALTER TABLE ExchangeDailyOanda
ADD [NGN] FLOAT NULL;

