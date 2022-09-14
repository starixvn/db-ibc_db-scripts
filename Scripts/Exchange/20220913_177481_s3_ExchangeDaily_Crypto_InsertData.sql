/*<info serverAlias="DBCUST-CustDB"></info>*/
/*
        Created: 20220912@Evan
        DB: DBCUST-CustDB
        Task : Deposit - AG Group - CandyA18 - Support crypto
        https://nexdev.net/issues/177481
*/
USE [CustDB]

GO

DECLARE @ExChangeCryto TABLE (ExchangeId int,Code VARCHAR(5), USDT float, IsUpdate BIT DEFAULT(0))
INSERT INTO @ExChangeCryto(Code,USDT)
VALUES  ('TRX', 0.282713790669546)
        ,('DOG',        0.286499385898534)
        ,('ELO',        1.33917645562999E-06)
        ,('SHI',        5.63409315987603E-05)
        ,('BTC',        9.14788993491593)
        ,('ETH',        7.07818213203836)
        ,('UST',        4.48271051367376)
        ,('USC',        4.48226621058303)

UPDATE a
SET a.ExchangeId = b.ExchangeId
FROM @ExChangeCryto a INNER JOIN exchange b WITH(NOLOCK)  ON a.Code = b.Code
WHERE CurrencyType = 1

DECLARE @ExchangeDate DATE = '20220901'
DECLARE @tmpExchangeDate TABLE (ExchangeDate SMALLDATETIME);
DECLARE @firstDate SMALLDATETIME, @ExchangeId INT;
SELECT @firstDate = DATEADD(dd,-(DAY(@ExchangeDate)-1),@ExchangeDate);

WITH tmpExchangeDate AS
(
SELECT @firstDate AS ExchangeDate
UNION ALL
SELECT DATEADD(dd,1,ExchangeDate) AS ExchangeDate
FROM tmpExchangeDate WHERE ExchangeDate < GETDATE()
)
INSERT INTO @tmpExchangeDate
SELECT ExchangeDate FROM tmpExchangeDate

WHILE EXISTS (SELECT 1 FROM @ExChangeCryto WHERE IsUpdate = 0)
BEGIN
        SELECT TOP 1 @ExchangeId = ExchangeId FROM @ExChangeCryto WHERE IsUpdate = 0
        --INSERT INTO ExchangeDaily_Crypto(ExchangeDate,ExchangeId,USDT)
        SELECT ExchangeDate,ExchangeId,USDT 
        FROM @ExChangeCryto CROSS JOIN @tmpExchangeDate  
        WHERE ExchangeId = @ExchangeId

        UPDATE @ExChangeCryto SET IsUpdate = 1 WHERE ExchangeId = @ExchangeId
END


