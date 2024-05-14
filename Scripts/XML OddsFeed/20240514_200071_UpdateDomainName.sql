/*<info serverAlias="DBODDSFEED-bodb_OddsFeed" executers="" viewers="" isFunction="0"></info>*/

/*
	Created: 20240514@Lewis
	Task: feeds.12ying.com https => http [Redmine:#200071]
	DB: DBODDSFEED-bodb_OddsFeed

*/

DECLARE @Id SMALLINT = 7

UPDATE D SET D.DomainName = REPLACE(D.DomainName,'https://','http://') 
FROM Domain  D WITH (ROWLOCK, UPDLOCK)
WHERE DomainID = @Id
