/*<info serverAlias="DBPLO-bodb_ploutos"></info>*/
/*
	Create: 20200731@Sol
	DB : DBPLO-bodb_ploutos
	Task: Delete duplicated email/username2 [redmine: #138658]
*/

USE bodb_ploutos;

GO 

CREATE TABLE #__tempPlayerNo(PlayerNo INT)

;WITH rs AS
(
	SELECT p.EmailAddress
	FROM PlayerProfile p WITH(NOLOCK)
	WHERE p.BrandCode = '12BET'
	GROUP BY p.EmailAddress
	HAVING COUNT(p.EmailAddress) > 1
), 
rss AS
(
	SELECT
		ROW_NUMBER() OVER (PARTITION BY p.EmailAddress ORDER BY p.PlayerNo) AS Number
	   ,CreatedDate
	   ,PlayerNo
	   ,Username2
	   ,BrandCode
	   ,Username
	   ,EmailAddress
	FROM PlayerProfile p WITH (NOLOCK)
	WHERE 
		p.BrandCode = '12BET'
		AND EXISTS (
					SELECT TOP 1 1
					FROM rs
					WHERE p.EmailAddress = rs.EmailAddress
				)
)
INSERT INTO #__tempPlayerNo (PlayerNo)
SELECT rss.PlayerNo
FROM rss 
WHERE rss.number > 1

---- delete data
DELETE FROM PlayerProfile
OUTPUT DELETED.*
WHERE 
	PlayerNo IN 
			(
				SELECT pn.PlayerNo FROM #__tempPlayerNo pn
			)
	AND BrandCode = '12BET'

DROP TABLE #__tempPlayerNo

GO