/*<info serverAlias="DBCUST-CUSTDB"></info>*/
/*
	Created: 20221103@Evan
	DB: DBCUST-CUSTDB
	Task: Regen data 
	https://nexdev.net/issues/180115
*/
USE CUSTDB

DECLARE @ReplaceValue FLOAT = 1e-40;

DECLARE @MinDate SMALLDATETIME;

SELECT @MinDate = MIN(ExchangeDate) 
FROM ExchangeDailyOanda a WITH (ROWLOCK)
	INNER JOIN Exchange b WITH (NOLOCK) ON a.exchangeid = b.exchangeid
WHERE 
	CurrencyType = 1

UPDATE a 
SET
	a.USD=@ReplaceValue,
	a.EUR=@ReplaceValue,
	a.IDR=@ReplaceValue,
	a.AUD=@ReplaceValue,
	a.CHF=@ReplaceValue,
	a.GBP=@ReplaceValue,
	a.SGD=@ReplaceValue,
	a.THB=@ReplaceValue,
	a.VND=@ReplaceValue,
	a.KRW=@ReplaceValue,
	a.JPY=@ReplaceValue,
	a.HKD=@ReplaceValue,
	a.TWD=@ReplaceValue,
	a.PHP=@ReplaceValue,
	a.BDT=@ReplaceValue,
	a.INR=@ReplaceValue
FROM ExchangeDailyOanda a WITH (ROWLOCK)
	INNER JOIN Exchange b WITH (NOLOCK) ON a.exchangeid = b.exchangeid
WHERE 
	CurrencyType = 1
	AND ExchangeDate >= @MinDate