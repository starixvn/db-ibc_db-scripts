/*	
	Created: 20200330@Sol
	Task: Delete data from SettlementSpecialBettypeProfile table with sporttype 2 - Tennis bettype - [Redmine:#129316]
	DB: DBTXN/bodb02
*/

USE bodb02

GO

-- Affected rows = 20
DELETE FROM SettlementSpecialBettypeProfile WHERE SportType = 5

GO