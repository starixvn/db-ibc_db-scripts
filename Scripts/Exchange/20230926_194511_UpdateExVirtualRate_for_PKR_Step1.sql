/*<info serverAlias="DBCUST-CustDB"></info>*/
/*
	Created: 20230926@Evan
	DB: DBCUST-CustDB
	Task: Update ExVirtualRate for PKR [Redmine: #194511]
*/

USE CustDB
GO

UPDATE Exchange WITH (ROWLOCK)
SET ExVirtualRate = 1
WHERE ExchangeId = 121
