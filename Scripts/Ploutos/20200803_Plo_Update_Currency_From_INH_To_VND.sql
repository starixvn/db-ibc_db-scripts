/*<info serverAlias="DBPLO-bodb_ploutos"></info>*/
/*
	Create: 20200803@Sol
	DB : DBPLO-bodb_ploutos
	Task: update currency from INH to VND [redmine: #138757]
*/

USE bodb_ploutos;

GO 

UPDATE PlayerProfile
	SET CurrencyCode = 'VND'
WHERE 
	CurrencyCode = 'INH'
	AND BrandCode = '12BET'

GO