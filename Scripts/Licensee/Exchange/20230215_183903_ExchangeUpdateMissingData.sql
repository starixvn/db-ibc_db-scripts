/*<info serverAlias="DBLIC-bodb_3rdProduct"></info>*/
/*
	Created: 20230215@Evan
	DB: DBLIC-bodb_3rdProduct
	Task : Database - Exchange - Update missing data on some tickets
	https://nexdev.net/issues/183903
*/
USE bodb_3rdProduct
GO
UPDATE a 
SET a.extension1 = '4200100'
FROM Bettrans_Exchange a WITH(ROWLOCK) 
WHERE a.betID IN (769737878, 802909770, 890263274, 941828507, 947042175, 957978559, 970237439, 982070328, 1016677418, 1043807477, 1067712331, 1080405403)

