/*	
	Created: 20191218@Sol
	Task: Delete data from SettlementSpecialBettypeProfile table with sporttype 1 - Penalty bettype - [Redmine:#121681]
	DB: DBTXN/bodb02
*/

USE bodb02

GO

-- Affected rows = 129
DELETE FROM SettlementSpecialBettypeProfile WHERE SportType = 1 AND Bettype IN (395,393,391,390,387,386,385,384,383,382,381) AND SettleType = 'EAR'

GO