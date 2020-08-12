/*<info serverAlias="DBPLO-bodb_Ploutos"></info>*/
/*
	Create: 20200811@Sol
	DB : DBPLO-bodb_Ploutos
	Task: update statusid to initial value for re-sync [redmine: #139383]
*/

USE bodb_Ploutos;

GO

---- 12bet
---- update BetTicket table
UPDATE BetTicket WITH(ROWLOCK)
	SET StatusID = 0,
		TryCount = 0
WHERE 
	StatusID = 3
	AND BrandCode = '12BET'

GO

---- Nova88
---- update BetTicket table
UPDATE BetTicket WITH(ROWLOCK)
	SET StatusID = 0,
		TryCount = 0
WHERE 
	StatusID = 3
	AND BrandCode = 'Nova88'

GO

---- ivorysport
---- update BetTicket table
UPDATE BetTicket WITH(ROWLOCK)
	SET StatusID = 0,
		TryCount = 0
WHERE 
	StatusID = 3
	AND BrandCode = 'ivorysport'

GO

---- opal88
---- update BetTicket table
UPDATE BetTicket WITH(ROWLOCK)
	SET StatusID = 0,
		TryCount = 0
WHERE 
	StatusID = 3
	AND BrandCode = 'opal88'

GO