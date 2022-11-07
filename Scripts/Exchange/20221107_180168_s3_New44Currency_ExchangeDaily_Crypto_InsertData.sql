/*<info serverAlias="DBCUST-CustDB"></info>*/
/*
        Created: 20221107@Evan
        DB: DBCUST-CustDB
        Task : Deposit - AG Group - CandyA18 - Support crypto - Offer 44 new crypto
        https://nexdev.net/issues/180168
*/
USE [CustDB]

GO
DECLARE @ExChangeCryto TABLE (ExchangeId int,Currency nvarchar(50), USDT float)

DECLARE @MinDate SMALLDATETIME;
DECLARE @Today DATE =  GETDATE();
SELECT @MinDate = DATEADD(DAY, -1, @Today)

INSERT INTO @ExChangeCryto(Currency,USDT)
VALUES  ('GMT',	0.09725),
		('BAND',	1.22),
		('EPIC',	0.4322),
		('MXC',	0.06289),
		('RISE',	3.243),
		('UNB',	0.001278),
		('MIX',	0.00372),
		('STARL',	2.87),
		('AQT',	1.14),
		('STRX',	0.03671),
		('TABOO',	0.001025),
		('BANANA',	0.0866),
		('SWFTC',	0.001517),
		('BF',	0.002482),
		('UBT',	0.1534),
		('PKR3',	0.007334),
		('NEST',	0.02357),
		('XMON',	2.010447),
		('SIGNA',	0.002488),
		('ASTA',	0.003283),
		('SMI',	1.39),
		('YETIC',	3.4 ),
		('OMG',	1.71),
		('IQ',	0.004924),
		('ERN',	3.11),
		('HARD',	0.206),
		('ATA',	0.1508),
		('UPP',	0.06235),
		('SNAP',	0.001532),
		('GENE',	2.47),
		('HERO',	0.004721),
		('BITE',	4.132),
		('NSDX',	0.02004),
		('XT',	3.32),
		('KSW',	0.04035),
		('OKT',	14.4),
		('GS',	0.01246),
		('JEWEL',	0.1537),
		('WLBO',	0.005761),
		('SOD',	7.12),
		('GGM',	0.009527),
		('CHZ',	0.1813),
		('TON',	1.48),
		('BNB',	3.2865)

UPDATE a
SET a.ExchangeId = b.ExchangeId
FROM @ExChangeCryto a INNER JOIN exchange b WITH(NOLOCK)  ON a.Currency = b.currency

INSERT INTO ExchangeDaily_Crypto(ExchangeDate,ExchangeId,USDT)
SELECT @MinDate ExchangeDate,a.ExchangeId,a.USDT 
FROM	@ExChangeCryto a


