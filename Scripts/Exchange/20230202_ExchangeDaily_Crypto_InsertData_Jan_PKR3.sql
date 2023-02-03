/*<info serverAlias="DBCUST-CustDB"></info>*/
/*
        Created: 20230202@Evan
        DB: DBCUST-CustDB
        Task : CandyA18 - Update USDT rate to prepare Jan 2023 invoice
        https://nexdev.net/issues/183358
*/
USE [CustDB]

GO

DECLARE @ExChangeCryto TABLE (ExchangeId int,Currency nvarchar(50), USDT float)
DECLARE @Exdate SMALLDATETIME = '20230101'

INSERT INTO @ExChangeCryto(Currency,USDT)
VALUES          
        ('PKR3', 0.00551721861149272)

UPDATE a
SET a.ExchangeId = b.ExchangeId, a.USDT = a.USDT * b.MultipliedBy
FROM @ExChangeCryto a 
        INNER JOIN exchange b WITH(NOLOCK)  ON a.Currency = b.currency

DELETE FROM @ExChangeCryto WHERE ExchangeId IS NULL

UPDATE a 
SET a.USDT = b.USDT
FROM ExchangeDaily_Crypto a WITH (ROWLOCK)
        INNER JOIN @ExChangeCryto b ON a.ExchangeId = b.ExchangeId
WHERE a.ExchangeDate >= @Exdate

