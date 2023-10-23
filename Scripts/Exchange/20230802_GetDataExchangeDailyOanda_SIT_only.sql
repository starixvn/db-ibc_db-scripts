/*<info serverAlias="DBCUST-CustDB"></info>*/
/*
       Created: 20231023@Evan
       DB: DBCUST-CustDB
       Task: Gen data ExchangeDailyOanda for testing
       
*/
SET NOCOUNT ON

DROP TABLE IF EXISTS #ExchangeDailyOanda 
CREATE TABLE #ExchangeDailyOanda(
       [ExchangeDate] [smalldatetime] ,
       [ExchangeId] [int] ,
       [Code] [varchar](12) ,
       [MYR] [float] ,
       [USD] [float] ,
       [EUR] [float] ,
       [CNY] [float] ,
       [IDR] [float] ,
       [AUD] [float] ,
       [CHF] [float] ,
       [GBP] [float] ,
       [SGD] [float] ,
       [THB] [float] ,
       [VND] [float] ,
       [ActualRate] [float] ,
       [KRW] [float] ,
       [JPY] [float] ,
       [HKD] [float] ,
       [TWD] [float] ,
       [PHP] [float] ,
       [BDT] [float] ,
       [INR] [float] )


INSERT INTO #ExchangeDailyOanda ([ExchangeDate], [ExchangeId], [Code], [MYR], [USD], [EUR], [CNY], [ActualRate], [IDR], [AUD], [CHF], [GBP], [SGD], [THB], [VND], [KRW], [JPY], [HKD], [TWD], [PHP], [BDT], [INR])
VALUES ('2023-10-01 00:00:00', '209', 'PHP', '0.08303', '0.01767', '0.01671', '0.12889', '0.0824', '274.01404', '0.02749', '0.01617', '0.01448', '0.02414', '0.64776', '429.91653', '23.9213', '2.6393', '0.13836', '0.56976', '1', '1.97085', '1.46956');
DECLARE @FromDate SMALLDATETIME = '20231001'
DECLARE @ToDate SMALLDATETIME = '20231101'

WHILE (@FromDate < @ToDate)
BEGIN
       
       INSERT INTO ExchangeDailyOanda ([ExchangeDate], [ExchangeId], [Code], [MYR], [USD], [EUR], [CNY], [ActualRate], [IDR], [AUD], [CHF], [GBP], [SGD], [THB], [VND], [KRW], [JPY], [HKD], [TWD], [PHP], [BDT], [INR])
       SELECT @FromDate
               , a.[ExchangeId]
               , a.[Code]
               , a.[MYR]
               , a.[USD]
               , a.[EUR]
               , a.[CNY]
               , a.[ActualRate]
               , a.[IDR]
               , a.[AUD]
               , a.[CHF]
               , a.[GBP]
               , a.[SGD]
               , a.[THB]
               , a.[VND]
               , a.[KRW]
               , a.[JPY]
               , a.[HKD]
               , a.[TWD]
               , a.[PHP]
               , a.[BDT]
               , a.[INR]
       FROM #ExchangeDailyOanda a
              LEFT JOIN ExchangeDailyOanda b WITH (NOLOCK) ON @FromDate = b.ExchangeDate
                     AND a.ExchangeId = b.ExchangeId
       WHERE b.ExchangeDate IS NULL
       
       SET @FromDate = DATEADD(DAY, 1, @FromDate)

END
GO
