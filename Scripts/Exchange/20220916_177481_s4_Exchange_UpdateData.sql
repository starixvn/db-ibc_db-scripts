/*<info serverAlias="DBCUST-CustDB"></info>*/
/*
        Created: 20220921@Evan
        DB: DBCUST-CustDB
        Task : Update currency type + Adjust multiplier of BTC & ETH
        https://nexdev.net/issues/177481
*/
USE [CustDB]

GO

UPDATE exchange WITH(ROWLOCK) 
SET CurrencyType = 1 
WHERE currency IN('TRX','DOGE','ELON','SHIB','BTC','ETH','USDT3','USDC','HOT','AMP','ZEON','RSR','VET','ZIL','PEOPLE','ADA','XRP','LOOKS','XPRT','CRO','FLOW','SAND','AVAX','APE','CAKE','ENS','UNI')

UPDATE exchange WITH(ROWLOCK) SET MultipliedBy = 0.0001 WHERE currency = 'BTC';
UPDATE exchange WITH(ROWLOCK) SET MultipliedBy = 0.001 WHERE currency = 'ETH'; 

