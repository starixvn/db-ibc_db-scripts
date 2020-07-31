/*<info serverAlias="DBPLO-bodb_ploutos"></info>*/
/*
	Create: 20200731@Sol
	DB : DBPLO-bodb_ploutos
	Task: update statusid from 100 to 0 for 12bet [redmine: #138658]
*/

USE bodb_ploutos;

GO 

UPDATE PlayerProfile
	SET StatusID = 0
WHERE 
	StatusID = 100 
	AND BrandCode = '12BET'

GO