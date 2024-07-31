/*<info serverAlias="DBPRO-bodb02"></info>*/
/*
	Created: 20240731@Lewis
	DB: DBPRO-bodb02
	Task: VS5 remove sporttype 148
*/
USE bodb02
GO


DELETE 
FROM SportBettypeMatrix  
WHERE SportType = 148

