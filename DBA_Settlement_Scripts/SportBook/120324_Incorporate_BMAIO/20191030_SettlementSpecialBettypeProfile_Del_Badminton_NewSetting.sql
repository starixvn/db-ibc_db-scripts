/*	
	Created: 20191030@Sol
	Task: Delete data from SettlementSpecialBettypeProfile table with sporttype 9 - Badminton - [Redmine:#120324]
	DB: DBTXN/bodb02
*/

USE bodb02

GO

DELETE FROM SettlementSpecialBettypeProfile WHERE SportType = 9

GO