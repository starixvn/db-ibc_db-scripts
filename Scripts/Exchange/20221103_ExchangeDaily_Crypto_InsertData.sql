/*<info serverAlias="DBCUST-CustDB"></info>*/
/*
        Created: 20220912@Evan
        DB: DBCUST-CustDB
        Task : CandyA18 - Update USDT rate to prepare Oct invoice
        https://nexdev.net/issues/180118
*/
USE [CustDB]

GO

DECLARE @ExChangeCryto TABLE (ExchangeId int,Currency nvarchar(50), USDT float)
DECLARE @Exdate SMALLDATETIME = '20221001'

INSERT INTO @ExChangeCryto(Currency,USDT)
VALUES  ('ADA', 0.50418288)
        ,('AMP',        0.00606544)
        ,('APE',        5.72347748)
        ,('AQT',        1.080645806)
        ,('ASTA',       0.004773131)
        ,('ATA',        0.154758604)
        ,('AVAX',       21.72547041)
        ,('BANANA',     0.089944826)
        ,('BAND',       1.190277228)
        ,('BF', 0.002404234)
        ,('BITE',       0.000591390)
        ,('BNB',        286.53451012)
        ,('BTC',        20254.50453345)
        ,('CAKE',       4.44073262)
        ,('CHZ',        0.20319508)
        ,('CRO',        0.11188745)
        ,('DOGE',       0.06365403)
        ,('ELON',       0.00000027)
        ,('ENS',        14.78130938)
        ,('EPIC',       0.683721676)
        ,('ERN',        2.811397056)
        ,('ETH',        1615.08544052)
        ,('GENE',       2.123980672)
        ,('GGM',        0.008215088)
        ,('GMT',        0.093420104)
        ,('GS', 0.014390027)
        ,('HERO',       0.003772265)
        ,('HOT',        0.00246688)
        ,('IQ', 0.004798686)
        ,('KSW',        0.032721317)
        ,('LOOKS',      0.29411467)
        ,('MIX',        0.003840750)
        ,('MXC',        0.061100534)
        ,('NEST',       0.019345402)
        ,('OMG',        1.685604944)
        ,('PEOPLE',     0.02302745)
        ,('PKR',        0.006497603)
        ,('RISE',       0.000294984)
        ,('RSR',        0.00638475)
        ,('SAND',       0.88980622)
        ,('SHIB',       0.00001285)
        ,('SMI',        0.000001713)
        ,('SNAP',       0.001535467)
        ,('SOD',        0.000805779)
        ,('STARL',      0.000003044)
        ,('STRX',       0.033301168)
        ,('SWFTC',      0.001443609)
        ,('TABOO',      0.000983908)
        ,('TRX',        0.06370867)
        ,('UBT',        0.190243101)
        ,('UNB',        0.001318597)
        ,('UNI',        6.69809592)
        ,('UPP',        0.075948707)
        ,('USDC',       1.01844843)
        ,('USDT',       1.00514349)
        ,('VET',        0.02551564)
        ,('WFLOW',      1.85494747)
        ,('WLBO',       0.006480664)
        ,('WSIGNA',     0.003366822)
        ,('XMON',       24142.821370808)
        ,('XRP',        0.35871158)
        ,('YETIC',      0)
        ,('ZEON',       0.03040690)
        ,('ZIL',        0.03830816)


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

