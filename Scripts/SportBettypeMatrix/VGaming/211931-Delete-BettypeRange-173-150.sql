/*<info serverAlias="DBPRO-bodb02"></info>*/
/*
	Created: 20241010@Lewis
	Task: delete for sport not offered anymore (173 , 150) [#RedmineId: 211931]
	DB: DBPRO-bodb02

*/

--select * 
DELETE A WITH (ROWLOCK)
FROM SportBettypeMatrix A
WHERE ProductID = 66 
	AND sporttype = 173 
	AND BetType BETWEEN 13500 AND 13799

--select * 
DELETE A WITH (ROWLOCK)
FROM SportBettypeMatrix A
WHERE ProductID = 42 
	AND sporttype = 150 
	AND BetType BETWEEN 13200 AND 13499