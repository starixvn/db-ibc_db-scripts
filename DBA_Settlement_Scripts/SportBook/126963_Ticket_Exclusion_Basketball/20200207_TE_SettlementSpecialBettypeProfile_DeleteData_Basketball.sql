/*	
	Created: 20200207@Sol
	Task: Delete data from SettlementSpecialBettypeProfile table with sporttype 2 - Basketball bettype - [Redmine:#126963]
	DB: DBTXN/bodb02
*/

USE bodb02

GO

-- Affected rows = 69
DELETE FROM SettlementSpecialBettypeProfile WHERE SportType = 2

GO