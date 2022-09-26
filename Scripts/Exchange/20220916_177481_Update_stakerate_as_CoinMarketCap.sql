/*<info serverAlias="DBCUST-CustDB"></info>*/
/*
        Created: 20220912@Evan
        DB: DBCUST-CustDB
        Task : Update stakerate as CoinMarketCap ID for Crypto Currency only
        https://nexdev.net/issues/177481
*/
USE [CustDB]

GO

UPDATE exchange WITH(ROWLOCK) SET stakerate = 1958 WHERE currency = 'TRX';
UPDATE exchange WITH(ROWLOCK) SET stakerate = 74 WHERE currency = 'DOGE';
UPDATE exchange WITH(ROWLOCK) SET stakerate = 9436 WHERE currency = 'ELON';
UPDATE exchange WITH(ROWLOCK) SET stakerate = 5994 WHERE currency = 'SHIB';
UPDATE exchange WITH(ROWLOCK) SET stakerate = 1 WHERE currency = 'BTC';
UPDATE exchange WITH(ROWLOCK) SET stakerate = 1027 WHERE currency = 'ETH';
UPDATE exchange WITH(ROWLOCK) SET stakerate = 825 WHERE currency = 'USDT3';
UPDATE exchange WITH(ROWLOCK) SET stakerate = 3408 WHERE currency = 'USDC';
UPDATE exchange WITH(ROWLOCK) SET stakerate = 2682 WHERE currency = 'HOT';
UPDATE exchange WITH(ROWLOCK) SET stakerate = 6945 WHERE currency = 'AMP';
UPDATE exchange WITH(ROWLOCK) SET stakerate = 3795 WHERE currency = 'ZEON';
UPDATE exchange WITH(ROWLOCK) SET stakerate = 3964 WHERE currency = 'RSR';
UPDATE exchange WITH(ROWLOCK) SET stakerate = 3077 WHERE currency = 'VET';
UPDATE exchange WITH(ROWLOCK) SET stakerate = 2469 WHERE currency = 'ZIL';
UPDATE exchange WITH(ROWLOCK) SET stakerate = 14806 WHERE currency = 'PEOPLE';
UPDATE exchange WITH(ROWLOCK) SET stakerate = 2010 WHERE currency = 'ADA';
UPDATE exchange WITH(ROWLOCK) SET stakerate = 52 WHERE currency = 'XRP';
UPDATE exchange WITH(ROWLOCK) SET stakerate = 17081 WHERE currency = 'LOOKS';
UPDATE exchange WITH(ROWLOCK) SET stakerate = 7281 WHERE currency = 'XPRT';
UPDATE exchange WITH(ROWLOCK) SET stakerate = 3635 WHERE currency = 'CRO';
UPDATE exchange WITH(ROWLOCK) SET stakerate = 4558 WHERE currency = 'FLOW';
UPDATE exchange WITH(ROWLOCK) SET stakerate = 6210 WHERE currency = 'SAND';
UPDATE exchange WITH(ROWLOCK) SET stakerate = 5805 WHERE currency = 'AVAX';
UPDATE exchange WITH(ROWLOCK) SET stakerate = 18876 WHERE currency = 'APE';
UPDATE exchange WITH(ROWLOCK) SET stakerate = 7186 WHERE currency = 'CAKE';
UPDATE exchange WITH(ROWLOCK) SET stakerate = 13855 WHERE currency = 'ENS';
UPDATE exchange WITH(ROWLOCK) SET stakerate = 7083 WHERE currency = 'UNI';


