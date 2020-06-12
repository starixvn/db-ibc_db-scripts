/*<info serverAlias="DBN88-bodb_N88" isFunction="0" isNested=""></info>*/
/*
Created: 20200612@Sol
Task: Correct data for currency id = 51 [Redmine: #135372]
DB: DBN88-bodb_N88
*/

USE bodb_N88

GO 

UPDATE dbo.N88_RptWinloss
	SET TurnOver = TurnOver/1000,
		Winloss = Winloss/1000
WHERE Currency = 51

GO