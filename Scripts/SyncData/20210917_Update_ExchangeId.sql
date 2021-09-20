/*<info serverAlias="DBCUST-CustDB"></info>*/
/*
	Create: 20210917@Sol
	DB : DBCUST-CustDB
	Task: update exchangeID - [Redmine: #161795]
*/

USE CustDB;

GO 

UPDATE exchange WITH(ROWLOCK)
	SET 
		ExchangeId = 124
WHERE 
	ExchangeId = 122 AND currency = 'RMB2'

GO

UPDATE exchange WITH(ROWLOCK)
	SET 
		ExchangeId = 125
WHERE 
	ExchangeId = 123 AND currency = 'INH2'

GO