/*<info serverAlias="DBCUST-CustDB"></info>*/
/*
        Created: 20220912@Evan
        DB: DBCUST-CustDB
        Task : Deposit - AG Group - CandyA18 - Support crypto
        https://nexdev.net/issues/177481
*/
USE [CustDB]

GO

DECLARE @ExChangeCryto TABLE (ExchangeId int,Currency nvarchar(50), USDT float)

INSERT INTO @ExChangeCryto(Currency,USDT)
VALUES  ('TRX',         0.061)
        ,('DOGE',       0.06)
        ,('ELON',       3)
        ,('SHIB',       1.2)
        ,('BTC',        2.01)
        ,('ETH',        1.61)
        ,('USDT3',      1)
        ,('USDC',       1)

UPDATE a
SET a.ExchangeId = b.ExchangeId
FROM @ExChangeCryto a INNER JOIN exchange b WITH(NOLOCK)  ON a.Currency = b.currency

INSERT INTO ExchangeDaily_Crypto(ExchangeDate,ExchangeId,USDT)
SELECT a.ExchangeDate,a.ExchangeId,b.USDT 
FROM ExchangeDailyOanda a WITH (NOLOCK) 
        INNER JOIN @ExChangeCryto b ON a.ExchangeId = b.ExchangeId
        LEFT JOIN ExchangeDaily_Crypto c WITH (NOLOCK) ON a.ExchangeId = c.ExchangeId AND a.ExchangeDate = c.ExchangeDate
WHERE c.ExchangeId IS NULL

