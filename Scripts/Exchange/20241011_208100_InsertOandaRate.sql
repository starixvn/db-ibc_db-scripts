/*<info serverAlias="DBCUST-CustDB"></info>*/
/*
	Created: 20241011@Danny
	DB: DBCUST-CustDB
	Task: Insert OandaRate [RedmineID: #208100]		
*/

USE CustDB

INSERT INTO ExchangeDailyOanda(
ExchangeDate,	ExchangeId,	Code,	MYR,	USD,	EUR,	CNY,
IDR,	AUD,	CHF,	GBP,	SGD,	THB,	VND,	ActualRate,	KRW,	JPY,	HKD,
TWD,	PHP,	BDT,	INR,	TRY,	NPR,	MXN,	NGN,	RepUpdateTime)

SELECT 
'2024-10-12' ExchangeDate,	ExchangeId,	Code,	MYR,	USD,	EUR,	CNY,
IDR,	AUD,	CHF,	GBP,	SGD,	THB,	VND,	ActualRate,	KRW,	JPY,	HKD,
TWD,	PHP,	BDT,	INR,	TRY,	NPR,	MXN,	NGN,	SYSDATETIME()
FROM ExchangeDailyOanda WITH(NOLOCK)
WHERE ExchangeDate = '2024-10-11' AND ExchangeId < 136

