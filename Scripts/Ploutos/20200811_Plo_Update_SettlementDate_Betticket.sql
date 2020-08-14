/*<info serverAlias="DBPLO-bodb_Ploutos"></info>*/
/*
	Create: 20200811@Sol
	DB : DBPLO-bodb_Ploutos
	Task: update settlementdate to initial value for re-sync [redmine: #139383]
*/

USE bodb_Ploutos;

GO

---- 12bet
---- update BetTicket table
UPDATE b 
	SET b.SettlementDate = DATEADD(HOUR, 12, bs.ActionDate)	--> GMT+8
FROM BetTicket b WITH(ROWLOCK)
	INNER JOIN BetTicket_Staging bs WITH(NOLOCK)
		on b.TransactionId = bs.TransID
WHERE 
	b.TransactionId IN 
	(
		109580719411,
		109580790480,
		109586433686,
		109608690414,
		109613508128,
		109622371460
	)

GO