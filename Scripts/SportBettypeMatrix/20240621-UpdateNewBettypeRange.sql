/*<info serverAlias="DBPRO-bodb02"></info>*/
/*
	Created: 20240621@Lewis
	DB: DBPRO-bodb02
	Task: Update new bettype range : [11100 - 11299] => table bettype & sportbettypematrix
*/



DELETE
FROM bettype WITH (ROWLOCK) 
WHERE typeid between 11057 and 11099



DELETE
FROM SportBettypeMatrix WITH (ROWLOCK)
WHERE ProductID = 87


