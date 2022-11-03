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
VALUES  ('TRX',         0.061)
        ,('DOGE',       0.06)
        ,('ELON',       3)
        ,('SHIB',       1.2)
        ,('BTC',        2.01)
        ,('ETH',        1.61)
        ,('USDT3',      1)
        ,('USDC',       1)
        ,('HOT',        0.002)
        ,('AMP',        0.0055)
        ,('ZEON',       0.009)
        ,('RSR',        0.0061)
        ,('VET',        0.0254)
        ,('ZIL',        0.0341)
        ,('PEOPLE',     0.0194)
        ,('ADA',        0.4686)
        ,('XRP',        0.3418)
        ,('LOOKS',      0.286)
        ,('XPRT',       0.6424)
        ,('CRO',        0.1092)
        ,('FLOW',       1.8524)
        ,('SAND',       0.88)
        ,('AVAX',       18.535)
        ,('APE',        4.9918)
        ,('CAKE',       4.3758)
        ,('ENS',        14.8918)
        ,('UNI',        6.1776)

UPDATE a
SET a.ExchangeId = b.ExchangeId
FROM @ExChangeCryto a INNER JOIN exchange b WITH(NOLOCK)  ON a.Currency = b.currency

UPDATE a 
SET a.USDT = b.USDT
FROM ExchangeDaily_Crypto a WITH (ROWLOCK)
        INNER JOIN @ExChangeCryto b ON a.ExchangeId = b.ExchangeId
WHERE a.ExchangeDate >= @Exdate