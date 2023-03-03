/*<info serverAlias="DBLIC-bodb_3rdProduct"></info>*/
/*
	Created: 20230303@Evan
	DB: DBLIC-bodb_3rdProduct
	Task : Database - Exchange - Update missing data on some tickets
	https://nexdev.net/issues/184678
*/
USE bodb_3rdProduct
GO
UPDATE a 
SET a.extension1 = '4200100'
FROM Bettrans_Exchange a WITH(ROWLOCK) 
WHERE a.betID IN (1015746215,1021188034)

