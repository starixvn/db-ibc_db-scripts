/*<info serverAlias="DBCUST-CustDB"></info>*/
/*
        Created: 20221202@Evan
        DB: DBCUST-CustDB
        Task : CandyA18 - Update USDT rate to prepare Nov invoice
        https://nexdev.net/issues/180991
*/
USE [CustDB]

GO

DECLARE @ExChangeCryto TABLE (ExchangeId int,Currency nvarchar(50), USDT float)
DECLARE @Exdate SMALLDATETIME = '20221101'

INSERT INTO @ExChangeCryto(Currency,USDT)
VALUES  ('USDC',        1 )
        ,('USDT',       1 )
        ,('XMON',       23055.62595874 )
        ,('WBTC',       21002.512412741 )
        ,('BTC',        19905.197155594 )
        ,('ETH',        1537.588753906 )
        ,('BNB',        341.46582197 )
        ,('QNT',        158.101022795 )
        ,('BCH',        117.354678314 )
        ,('AAVE',       77.456456344 )
        ,('LTC',        70.322237076 )
        ,('EGLD',       54.03946316 )
        ,('ETC',        25.16088445 )
        ,('FTT',        22.09453065 )
        ,('AVAX',       20.60077737 )
        ,('SOL',        17.20460717 )
        ,('OKT',        16.12587286 )
        ,('ENS',        14.62584745 )
        ,('ATOM',       14.15232987 )
        ,('LINK',       8.187430971 )
        ,('DOT',        6.698300157 )
        ,('UNI',        6.11096197 )
        ,('FIL',        5.724667940 )
        ,('HT', 5.160364175 )
        ,('CAKE',       4.391910895 )
        ,('APE',        4.304548664 )
        ,('LEO',        3.928904838 )
        ,('NEAR',       3.05108642 )
        ,('ERN',        2.380244873 )
        ,('GENE',       1.764567714 )
        ,('TON',        1.59489018 )
        ,('OMG',        1.475841814 )
        ,('XTZ',        1.381331587 )
        ,('MATIC',      1.184411028 )
        ,('BAND',       1.172806251 )
        ,('EOS',        1.12235188 )
        ,('FLOW',       1.117087685 )
        ,('AQT',        1.098955568 )
        ,('DAI',        1.00330081 )
        ,('BUSD',       1.00146771 )
        ,('SAND',       0.74418563 )
        ,('EPIC',       0.671940306 )
        ,('MANA',       0.594781237 )
        ,('ADA',        0.483620028 )
        ,('XRP',        0.382121800 )
        ,('LOOKS',      0.264517453 )
        ,('CHZ',        0.203195075 )
        ,('UBT',        0.171079133 )
        ,('ATA',        0.14567110 )
        ,('CRO',        0.107414430 )
        ,('XLM',        0.094607612 )
        ,('GMT',        0.09351157 )
        ,('BANANA',     0.088523183 )
        ,('DOGE',       0.07597358 )
        ,('UPP',        0.07134152 )
        ,('MXC',        0.05978980 )
        ,('TRX',        0.05855328 )
        ,('ENX',        0.054954202 )
        ,('XCN',        0.050901639 )
        ,('KSW',        0.039288791 )
        ,('ZIL',        0.03564302 )
        ,('STRX',       0.033169576 )
        ,('VET',        0.02492607 )
        ,('PEOPLE',     0.02283647 )
        ,('NEST',       0.019818690 )
        ,('ZEON',       0.019390204693533)
        ,('GS', 0.014599420802362)
        ,('GGM',        0.008214176778777)
        ,('WLBO',       0.006588081567301)
        ,('RSR',        0.006382915367825)
        ,('AMP',        0.005740487261995)
        ,('PKR',        0.005517218611493)
        ,('ASTA',       0.004102532545012)
        ,('IQ', 0.003994311330737)
        ,('MIX',        0.003671879828658)
        ,('GLMS',       0.003589007818941)
        ,('WSIGNA',     0.003257939321281)
        ,('BF', 0.002339257524554)
        ,('SNAP',       0.001526325333953)
        ,('SWFTC',      0.001462056945258)
        ,('UNB',        0.001319212255928)
        ,('TABOO',      0.00099029691809)
        ,('SOD',        0.000814249631401)
        ,('TECH',       0.000794189216725)
        ,('BITE',       0.000591231035914)
        ,('RISE',       0.000282008428837)
        ,('LUNC',       0.000184468821983)
        ,('SHIB',       1.21674581814463E-05)
        ,('STARL',      3.04366829549676E-06)
        ,('SMI',        1.71431523907887E-06)
        ,('ELON',       2.7289271725751E-07)
        ,('YETIC',      3.87581254220176E-10)
        ,('HERO',       0.003751737711354)
        ,('HOT',        0.002115452571829)


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

