/*<info serverAlias="DBCUST-CustDB"></info>*/
/*
        Created: 20221107@Evan
        DB: DBCUST-CustDB
        Task : Update stakerate as CoinMarketCap ID for Crypto Currency only
        https://nexdev.net/issues/180168
*/
USE [CustDB]

GO

UPDATE exchange WITH(ROWLOCK) SET stakerate = 10180 WHERE currency = 'GMT';
UPDATE exchange WITH(ROWLOCK) SET stakerate = 4679 WHERE currency = 'BAND';
UPDATE exchange WITH(ROWLOCK) SET stakerate = 5435 WHERE currency = 'EPIC';
UPDATE exchange WITH(ROWLOCK) SET stakerate = 3628 WHERE currency = 'MXC';
UPDATE exchange WITH(ROWLOCK) SET stakerate = 15257 WHERE currency = 'RISE';
UPDATE exchange WITH(ROWLOCK) SET stakerate = 7846 WHERE currency = 'UNB';
UPDATE exchange WITH(ROWLOCK) SET stakerate = 4366 WHERE currency = 'MIX';
UPDATE exchange WITH(ROWLOCK) SET stakerate = 10821 WHERE currency = 'STARL';
UPDATE exchange WITH(ROWLOCK) SET stakerate = 7460 WHERE currency = 'AQT';
UPDATE exchange WITH(ROWLOCK) SET stakerate = 9220 WHERE currency = 'STRX';
UPDATE exchange WITH(ROWLOCK) SET stakerate = 10586 WHERE currency = 'TABOO';
UPDATE exchange WITH(ROWLOCK) SET stakerate = 8497 WHERE currency = 'BANANA';
UPDATE exchange WITH(ROWLOCK) SET stakerate = 2341 WHERE currency = 'SWFTC';
UPDATE exchange WITH(ROWLOCK) SET stakerate = 4283 WHERE currency = 'BF';
UPDATE exchange WITH(ROWLOCK) SET stakerate = 2758 WHERE currency = 'UBT';
UPDATE exchange WITH(ROWLOCK) SET stakerate = 10427 WHERE currency = 'PKR3';
UPDATE exchange WITH(ROWLOCK) SET stakerate = 5841 WHERE currency = 'NEST';
UPDATE exchange WITH(ROWLOCK) SET stakerate = 8509 WHERE currency = 'XMON';
UPDATE exchange WITH(ROWLOCK) SET stakerate = 10776 WHERE currency = 'SIGNA';
UPDATE exchange WITH(ROWLOCK) SET stakerate = 6375 WHERE currency = 'ASTA';
UPDATE exchange WITH(ROWLOCK) SET stakerate = 9958 WHERE currency = 'SMI';
UPDATE exchange WITH(ROWLOCK) SET stakerate = 14718 WHERE currency = 'YETIC';
UPDATE exchange WITH(ROWLOCK) SET stakerate = 1808 WHERE currency = 'OMG';
UPDATE exchange WITH(ROWLOCK) SET stakerate = 2930 WHERE currency = 'IQ';
UPDATE exchange WITH(ROWLOCK) SET stakerate = 8615 WHERE currency = 'ERN';
UPDATE exchange WITH(ROWLOCK) SET stakerate = 7576 WHERE currency = 'HARD';
UPDATE exchange WITH(ROWLOCK) SET stakerate = 10188 WHERE currency = 'ATA';
UPDATE exchange WITH(ROWLOCK) SET stakerate = 2866 WHERE currency = 'UPP';
UPDATE exchange WITH(ROWLOCK) SET stakerate = 15906 WHERE currency = 'SNAP';
UPDATE exchange WITH(ROWLOCK) SET stakerate = 13632 WHERE currency = 'GENE';
UPDATE exchange WITH(ROWLOCK) SET stakerate = 10778 WHERE currency = 'HERO';
UPDATE exchange WITH(ROWLOCK) SET stakerate = 10314 WHERE currency = 'BITE';
UPDATE exchange WITH(ROWLOCK) SET stakerate = 12312 WHERE currency = 'NSDX';
UPDATE exchange WITH(ROWLOCK) SET stakerate = 5999 WHERE currency = 'XT';
UPDATE exchange WITH(ROWLOCK) SET stakerate = 14361 WHERE currency = 'KSW';
UPDATE exchange WITH(ROWLOCK) SET stakerate = 8267 WHERE currency = 'OKT';
UPDATE exchange WITH(ROWLOCK) SET stakerate = 9196 WHERE currency = 'GS';
UPDATE exchange WITH(ROWLOCK) SET stakerate = 12319 WHERE currency = 'JEWEL';
UPDATE exchange WITH(ROWLOCK) SET stakerate = 9898 WHERE currency = 'WLBO';
UPDATE exchange WITH(ROWLOCK) SET stakerate = 20887 WHERE currency = 'SOD';
UPDATE exchange WITH(ROWLOCK) SET stakerate = 16742 WHERE currency = 'GGM';
UPDATE exchange WITH(ROWLOCK) SET stakerate = 4066 WHERE currency = 'CHZ';
UPDATE exchange WITH(ROWLOCK) SET stakerate = 11419 WHERE currency = 'TON';
UPDATE exchange WITH(ROWLOCK) SET stakerate = 1839 WHERE currency = 'BNB';



