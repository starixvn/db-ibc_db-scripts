/*<info serverAlias="DBCUST-CustDB"></info>*/
/*
        Created: 20230201@Evan
        DB: DBCUST-CustDB
        Task : Insert missing data table ExchangeDaily_Crypto on SIT
        https://nexdev.net/issues/177844
*/
USE [CustDB]

GO

DECLARE @ExChangeCryto TABLE (ExchangeId int, USDT float,ExchangeDate smalldatetime)
DECLARE @Exdate SMALLDATETIME='2022-12-09 00:00:00', @Todate SMALLDATETIME = GETDATE();
 
DECLARE @tbDate TABLE (ExchangeDate SMALLDATETIME);
WITH cte_date AS (
        SELECT @Exdate AS ExchangeDate
        UNION ALL
        SELECT DATEADD(dd,1,ExchangeDate) FROM cte_date WHERE ExchangeDate < DATEADD(dd,-1,@Todate)
)
INSERT INTO @tbDate
SELECT ExchangeDate FROM cte_date WHERE ExchangeDate > @Exdate

INSERT INTO @ExChangeCryto (ExchangeId, USDT, ExchangeDate)
SELECT ExchangeId, USDT, b.ExchangeDate 
FROM ExchangeDaily_Crypto a WITH(NOLOCK) CROSS JOIN @tbDate b
WHERE a.ExchangeDate = @Exdate

INSERT INTO ExchangeDaily_Crypto(ExchangeDate,ExchangeId,USDT)
SELECT a.ExchangeDate,a.ExchangeId,a.USDT 
FROM @ExChangeCryto a LEFT JOIN ExchangeDaily_Crypto b WITH(NOLOCK) ON a.ExchangeDate = b.ExchangeDate AND a.ExchangeId = b.ExchangeId
WHERE b.ExchangeId IS NULL
