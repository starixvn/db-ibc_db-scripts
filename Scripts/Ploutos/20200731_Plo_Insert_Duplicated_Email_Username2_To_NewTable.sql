/*<info serverAlias="DBPLO-bodb_ploutos"></info>*/
/*
	Create: 20200731@Sol
	DB : DBPLO-bodb_ploutos
	Task: Insert duplicated email/username2 to new table [redmine: #138658]
*/

USE bodb_ploutos;

GO 

SELECT * INTO PlayerProfile_Dup
FROM PlayerProfile p WITH (NOLOCK)
WHERE 
	p.BrandCode = '12BET' 
	AND p.EmailAddress IN (
							SELECT EmailAddress
							FROM PlayerProfile p WITH (NOLOCK)
							WHERE p.BrandCode = '12BET'
							GROUP BY EmailAddress
							HAVING COUNT(EmailAddress) > 1
						)

GO