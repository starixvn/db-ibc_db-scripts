/*<info serverAlias="DBPRO-bodb02"></info>*/
/*
	Created by: Lewis@20250107
	Task: SABA Keno - 102 [Redmine:#215118] 
	DB:	DBPRO-bodb02
*/

--SELECT * 
UPDATE P WITH (ROWLOCK,UPDLOCK) 
SET P.ProductID = 102 , P.VendorID = 102, P.RepUpdateTime = sysdatetime()
FROM Products P 
WHERE ProductID = 82

--SELECT * 
UPDATE S WITH (ROWLOCK,UPDLOCK)
SET S.ProductID = 102
FROM SportBettypeMatrix S 
WHERE ProductID = 82

