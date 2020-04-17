USE bodb_licensee
GO

/*
	Created: 20200417@Percy
	DB: DBCUST.bodb_Licensee
	Task: Table Game - Temporary update FromDate setting for 12BET
*/

UPDATE dbo.OAS_ChargeInfo WITH (ROWLOCK)
SET FromDate = '2020-03-30'
WHERE ProductID = 40
	AND FromParty = 14
	AND FromDate = '2020-04-16'