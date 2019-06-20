
/*
	Created: 20190620@Sol
	Task : Insert 2 new bettype to SettlementSpecialBettypeProfile table
	DB: DBPRO/bodb02 [Redmine:#115232]
*/

USE bodb02

GO

INSERT INTO SettlementSpecialBettypeProfile(pfID,SportType,BetType,BetID,ResourceID,SettleType,GroupType,OrdNo,RoundID,OddsType)
VALUES  (0, 1, 479, 0, 479, 'EAR', 'FT', 4, NULL, NULL),
		(0, 1, 481, 0, 481, 'EAR', '2H', 5, NULL, NULL)