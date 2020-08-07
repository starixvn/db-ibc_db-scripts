/*<info serverAlias="DBPLO-bodb_Ploutos"></info>*/
/*
	Create: 20200807@Sol
	DB : DBPLO-bodb_Ploutos
	Task: update gamecode of rptDep_AuditTickets table from 196 to 186 [redmine: #139154]
*/

USE bodb_Ploutos;

GO 

-- 1 row affected
UPDATE GameDetail WITH(ROWLOCK)
	SET GameName = 'Virtual Soccer World Cup'
WHERE 
	GameCode = '0192'
	AND GameName = 'Virtual Soccer Euro'

GO

-- 1 row affected
UPDATE GameDetail WITH(ROWLOCK)
	SET GameName = 'Virtual Soccer Asian Cup'
WHERE 
	GameCode = '0194'
	AND GameName = 'Virtual Horse'

GO

-- 1 row affected
INSERT INTO GameDetail(GameCode, GameName, GameType, ProductId)
VALUES ('0196', 'Virtual Soccer Champions Cup', 'RNG', 27)

GO