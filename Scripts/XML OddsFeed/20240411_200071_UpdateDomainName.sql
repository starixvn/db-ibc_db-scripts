/*<info serverAlias="DBODDSFEED-bodb_OddsFeed" executers="" viewers="" isFunction="0"></info>*/

/*
	Created: 20240411@Lewis
	Task: change domain name http => https [Redmine:#200071]
	DB: DBODDSFEED-bodb_OddsFeed

*/

DECLARE @IdFrom SMALLINT = 1
		,@IdTo SMALLINT = 16

--SELECT REPLACE(D.DomainName,'http://','https://') ,* 
UPDATE D SET D.DomainName = REPLACE(D.DomainName,'http://','https://') 
FROM Domain  D WITH (ROWLOCK, UPDLOCK)
WHERE DomainID between @IdFrom and @IdTo