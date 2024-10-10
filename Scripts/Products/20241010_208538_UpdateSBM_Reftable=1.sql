/*<info serverAlias="DBPRO-bodb02"></info>*/
/*
	Created: 20241010@Lewis
	Task: Update RefTable = 1 - bettransRNG [#RedmineId: 208538]
	DB: DBPRO-bodb02

*/
USE bodb02
 
UPDATE A WITH (ROWLOCK,UPDLOCK) SET A.RefTable = 1
FROM SportBettypeMatrix A
WHERE ProductID = 48