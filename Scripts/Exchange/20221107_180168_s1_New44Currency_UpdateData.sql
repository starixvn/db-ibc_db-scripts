/*<info serverAlias="DBCUST-CustDB"></info>*/
/*
        Created: 20221107@Evan
        DB: DBCUST-CustDB
        Task : Update currency type + Adjust multiplier 
        https://nexdev.net/issues/180168
*/
USE [CustDB]

GO

UPDATE exchange WITH(ROWLOCK) 
SET CurrencyType = 1 
WHERE currency IN
('GMT','BAND','EPIC','MXC','RISE','UNB','MIX','STARL','AQT','STRX','TABOO','BANANA','SWFTC','BF','UBT','PKR3','NEST','XMON','SIGNA','ASTA','SMI','YETIC','OMG','IQ','ERN','HARD','ATA','UPP','SNAP','GENE','HERO','BITE','NSDX','XT','KSW','OKT','GS','JEWEL','WLBO','SOD','GGM','CHZ','TON','BNB')

UPDATE exchange WITH(ROWLOCK) SET MultipliedBy = 10000000000 WHERE currency = 'YETIC';
UPDATE exchange WITH(ROWLOCK) SET MultipliedBy = 0.0001 WHERE currency = 'XMON';
UPDATE exchange WITH(ROWLOCK) SET MultipliedBy = 0.01 WHERE currency = 'BNB';






