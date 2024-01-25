/*<info serverAlias="DBCUST-CustDB"></info>*/
/*
	Created: 20240112@Evan
	DB: DBCUST-CustDB
	Task : Support new currency LIR & NPR (Add 2 column TRY & NPR on table ExchangeDailyOanda)
	https://nexdev.net/issues/197693
*/
USE [CustDB]

GO

ALTER TABLE ExchangeDailyOanda
ADD [TRY] FLOAT NULL; 

ALTER TABLE ExchangeDailyOanda
ADD [NPR] FLOAT NULL;

