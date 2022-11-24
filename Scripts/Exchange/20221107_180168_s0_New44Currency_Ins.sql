/*<info serverAlias="DBCUST-CustDB"></info>*/
/*
        Created: 20221107@Evan
        DB: DBCUST-CustDB
        Task : Sync data from PROD
        https://nexdev.net/issues/180168
*/
USE [CustDB]

GO

DELETE a
FROM ExchangeDailyOanda a WITH(ROWLOCK) INNER JOIN Exchange b WITH(NOLOCK) ON a.ExchangeId = b.ExchangeId
WHERE b.currency IN
('GMT','BAND','EPIC','MXC','RISE','UNB','MIX','STARL','AQT','STRX','TABOO','BANANA','SWFTC','BF','UBT','PKR3','NEST','XMON','SIGNA','ASTA','SMI','YETIC','OMG','IQ','ERN','HARD','ATA','UPP','SNAP','GENE','HERO','BITE','NSDX','XT','KSW','OKT','GS','JEWEL','WLBO','SOD','GGM','CHZ','TON','BNB')

DELETE a
FROM ExchangeDaily_Crypto a WITH(ROWLOCK) INNER JOIN Exchange b WITH(NOLOCK) ON a.ExchangeId = b.ExchangeId
WHERE b.currency IN
('GMT','BAND','EPIC','MXC','RISE','UNB','MIX','STARL','AQT','STRX','TABOO','BANANA','SWFTC','BF','UBT','PKR3','NEST','XMON','SIGNA','ASTA','SMI','YETIC','OMG','IQ','ERN','HARD','ATA','UPP','SNAP','GENE','HERO','BITE','NSDX','XT','KSW','OKT','GS','JEWEL','WLBO','SOD','GGM','CHZ','TON','BNB')

DELETE Exchange WITH(ROWLOCK)
WHERE currency IN
('GMT','BAND','EPIC','MXC','RISE','UNB','MIX','STARL','AQT','STRX','TABOO','BANANA','SWFTC','BF','UBT','PKR3','NEST','XMON','SIGNA','ASTA','SMI','YETIC','OMG','IQ','ERN','HARD','ATA','UPP','SNAP','GENE','HERO','BITE','NSDX','XT','KSW','OKT','GS','JEWEL','WLBO','SOD','GGM','CHZ','TON','BNB')


INSERT INTO Exchange ([currency], [stakerate], [actualrate], [commaxpayout], [creator], [minbet], [minbetlive], [AUDRate], [ZARRate], [GBPRate], [EURORate], [US$Rate], [Code], [Description], [MultipliedBy], [ExVirtualRate], [PJUnitPrice], [IsActive], [OfferSite], [ExchangeId],  [CurrencyType])
VALUES ('GMT', NULL, 0.461, NULL, 22040272, '20', '20', NULL, NULL, NULL, NULL, NULL, 'GMT', 'GoMining', 1.00000000, NULL, NULL, 1, 2, 163, 0),
       ('BAND', NULL, 5.7828, NULL, 22040272, '2', '2', NULL, NULL, NULL, NULL, NULL, 'BAN', 'Band Protocal', 1.00000000, NULL, NULL, 1, 2, 164, 0),
       ('EPIC', NULL, 2.0486, NULL, 22040272, '5', '5', NULL, NULL, NULL, NULL, NULL, 'EPI', 'Epic Cash', 1.00000000, NULL, NULL, 1, 2, 165, 0),
       ('MXC', NULL, 0.2981, NULL, 22040272, '30', '30', NULL, NULL, NULL, NULL, NULL, 'MXC', 'MXC', 1.00000000, NULL, NULL, 1, 2, 166, 0),
       ('RISE', NULL, 15.3718, NULL, 22040272, '1', '1', NULL, NULL, NULL, NULL, NULL, 'RIS', 'EverRise', 10000.00000000, NULL, NULL, 1, 2, 167, 0),
       ('UNB', NULL, 0.0061, NULL, 22040272, '1250', '1250', NULL, NULL, NULL, NULL, NULL, 'UNB', 'Unbound', 1.00000000, NULL, NULL, 1, 2, 168, 0),
       ('MIX', NULL, 0.0176, NULL, 22040272, '500', '500', NULL, NULL, NULL, NULL, NULL, 'MIX', 'MixMarvel', 1.00000000, NULL, NULL, 1, 2, 169, 0),
       ('STARL', NULL, 13.6038, NULL, 22040272, '1', '1', NULL, NULL, NULL, NULL, NULL, 'STA', 'Star Link', 1000000.00000000, NULL, NULL, 1, 2, 170, 0),
       ('AQT', NULL, 5.4036, NULL, 22040272, '2', '2', NULL, NULL, NULL, NULL, NULL, 'AQT', 'Alpha Quark Token', 1.00000000, NULL, NULL, 1, 2, 171, 0),
       ('STRX', NULL, 0.174, NULL, 22040272, '50', '50', NULL, NULL, NULL, NULL, NULL, 'STR', 'Strike Coin', 1.00000000, NULL, NULL, 1, 2, 172, 0),
       ('TABOO', NULL, 0.0049, NULL, 22040272, '1600', '1600', NULL, NULL, NULL, NULL, NULL, 'TAB', 'Taboo Token', 1.00000000, NULL, NULL, 1, 2, 173, 0),
       ('BANANA', NULL, 0.4105, NULL, 22040272, '20', '20', NULL, NULL, NULL, NULL, NULL, 'BAA', 'ApeSwap', 1.00000000, NULL, NULL, 1, 2, 174, 0),
       ('SWFTC', NULL, 0.0072, NULL, 22040272, '1100', '1100', NULL, NULL, NULL, NULL, NULL, 'SWF', 'SWFT Coin', 1.00000000, NULL, NULL, 1, 2, 175, 0),
       ('BF', NULL, 0.0118, NULL, 22040272, '700', '700', NULL, NULL, NULL, NULL, NULL, 'BF', 'BitForex Token', 1.00000000, NULL, NULL, 1, 2, 176, 0),
       ('UBT', NULL, 0.7271, NULL, 22040272, '10', '10', NULL, NULL, NULL, NULL, NULL, 'UBT', 'Uni Bright', 1.00000000, NULL, NULL, 1, 2, 177, 0),
       ('PKR3', NULL, 0.0348, NULL, 22040272, '220', '220', NULL, NULL, NULL, NULL, NULL, 'PK3', 'Polker', 1.00000000, NULL, NULL, 1, 2, 178, 0),
       ('NEST', NULL, 0.1117, NULL, 22040272, '70', '70', NULL, NULL, NULL, NULL, NULL, 'NES', 'Nest Protocol', 1.00000000, NULL, NULL, 1, 2, 179, 0),
       ('XMON', NULL, 9.5295, NULL, 22040272, '1', '1', NULL, NULL, NULL, NULL, NULL, 'XMO', 'Xmon', 1.00000000, NULL, NULL, 1, 2, 180, 0),
       ('SIGNA', NULL, 0.0118, NULL, 22040272, '700', '700', NULL, NULL, NULL, NULL, NULL, 'SIG', 'Signum', 1.00000000, NULL, NULL, 1, 2, 181, 0),
       ('ASTA', NULL, 0.0156, NULL, 22040272, '500', '500', NULL, NULL, NULL, NULL, NULL, 'AST', 'Asta', 1.00000000, NULL, NULL, 1, 2, 182, 0),
       ('SMI', NULL, 6.5886, NULL, 22040272, '1', '1', NULL, NULL, NULL, NULL, NULL, 'SMI', 'Safemoon Inu', 1000000.00000000, NULL, NULL, 1, 2, 183, 0),
       ('YETIC', NULL, 16.116, NULL, 22040272, '1', '1', NULL, NULL, NULL, NULL, NULL, 'YET', 'Yetic Coin', 1.00000000, NULL, NULL, 1, 2, 184, 0),
       ('OMG', NULL, 8.1054, NULL, 22040272, '1', '1', NULL, NULL, NULL, NULL, NULL, 'OMG', 'OMG', 1.00000000, NULL, NULL, 1, 2, 185, 0),
       ('IQ', NULL, 0.0233, NULL, 22040272, '350', '350', NULL, NULL, NULL, NULL, NULL, 'IQ', 'EveriPedia', 1.00000000, NULL, NULL, 1, 2, 186, 0),
       ('ERN', NULL, 14.7414, NULL, 22040272, '1', '1', NULL, NULL, NULL, NULL, NULL, 'ERN', 'Ethernity Chain', 1.00000000, NULL, NULL, 1, 2, 187, 0),
       ('HARD', NULL, 0.9764, NULL, 22040272, '10', '10', NULL, NULL, NULL, NULL, NULL, 'HAR', 'Hard Protocol', 1.00000000, NULL, NULL, 1, 2, 188, 0),
       ('ATA', NULL, 0.7148, NULL, 22040272, '10', '10', NULL, NULL, NULL, NULL, NULL, 'ATA', 'Automata Network', 1.00000000, NULL, NULL, 1, 2, 189, 0),
       ('UPP', NULL, 0.2955, NULL, 22040272, '30', '30', NULL, NULL, NULL, NULL, NULL, 'UPP', 'Sentinel Protocol', 1.00000000, NULL, NULL, 1, 2, 190, 0),
       ('SNAP', NULL, 0.0073, NULL, 22040272, '1100', '1100', NULL, NULL, NULL, NULL, NULL, 'SNA', 'Snapex', 1.00000000, NULL, NULL, 1, 2, 191, 0),
       ('GENE', NULL, 11.7078, NULL, 22040272, '1', '1', NULL, NULL, NULL, NULL, NULL, 'GEN', 'GenoPets', 1.00000000, NULL, NULL, 1, 2, 192, 0),
       ('HERO', NULL, 0.0224, NULL, 22040272, '350', '350', NULL, NULL, NULL, NULL, NULL, 'HER', 'MetaHero', 1.00000000, NULL, NULL, 1, 2, 193, 0),
       ('XT', NULL, 15.7368, NULL, 22040272, '1', '1', NULL, NULL, NULL, NULL, NULL, 'XT', 'XtCom Token', 1.00000000, NULL, NULL, 1, 2, 194, 0),
       ('OKT', NULL, 68.256, NULL, 22040272, '1', '1', NULL, NULL, NULL, NULL, NULL, 'OKT', 'OKT', 1.00000000, NULL, NULL, 1, 2, 195, 0),
       ('GS', NULL, 0.0591, NULL, 22040272, '150', '150', NULL, NULL, NULL, NULL, NULL, 'GS', 'Genesis Shard', 1.00000000, NULL, NULL, 1, 2, 196, 0),
       ('JEWEL', NULL, 0.7285, NULL, 22040272, '15', '15', NULL, NULL, NULL, NULL, NULL, 'JEW', 'Defi Kingdoms', 1.00000000, NULL, NULL, 1, 2, 197, 0),
       ('GGM', NULL, 0.0452, NULL, 22040272, '200', '200', NULL, NULL, NULL, NULL, NULL, 'GGM', 'Monster Galaxy', 1.00000000, NULL, NULL, 1, 2, 198, 0),
       ('CHZ', NULL, 0.8594, NULL, 22040272, '10', '10', NULL, NULL, NULL, NULL, NULL, 'CHZ', 'Chiliz', 1.00000000, NULL, NULL, 1, 2, 199, 0),
       ('TON', NULL, 7.0152, NULL, 22040272, '1', '1', NULL, NULL, NULL, NULL, NULL, 'TON', 'Ton Coin', 1.00000000, NULL, NULL, 1, 2, 200, 0),
       ('BNB', NULL, 15.578, NULL, 22040272, '1', '1', NULL, NULL, NULL, NULL, NULL, 'BNB', 'Binance Coin', 1.00000000, NULL, NULL, 1, 2, 201, 0);