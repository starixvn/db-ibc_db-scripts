/*<info serverAlias="DBCUST-CustDB"></info>*/
/*
	Created: 20250314@Kelvin
	DB: DBCUST-CustDB
	Task : LAP - Support based PKR (RedmineID: #219424)
*/

USE [CustDB]

GO

ALTER TABLE ExchangeDailyOanda
ADD [PKR] FLOAT NULL; 


