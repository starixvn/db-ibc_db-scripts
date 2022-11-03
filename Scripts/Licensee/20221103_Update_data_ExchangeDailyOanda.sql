/*<info serverAlias="DBCUST-CUSTDB"></info>*/
/*
	Created: 20221103@Evan
	DB: DBCUST-CUSTDB
	Task: Regen data
*/
USE CUSTDB

DELETE FROM ExchangeDailyOanda WITH(ROWLOCK)where ExchangeDate = '20221031'
INSERT INTO ExchangeDailyOanda(ExchangeDate,ExchangeId,Code,MYR,USD,EUR,CNY,IDR,AUD,CHF,GBP,SGD,THB,VND,ActualRate,KRW,JPY,HKD,TWD,PHP,BDT,INR)
SELECT '20221031',ExchangeId,Code,MYR,USD,EUR,CNY,IDR,AUD,CHF,GBP,SGD,THB,VND,ActualRate,KRW,JPY,HKD,TWD,PHP,BDT,INR
FROM ExchangeDailyOanda WITH (NOLOCK) where ExchangeDate = '20221102'