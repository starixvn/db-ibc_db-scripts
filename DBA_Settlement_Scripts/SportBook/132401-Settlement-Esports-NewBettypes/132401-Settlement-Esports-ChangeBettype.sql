/*
	Created by: Kathy
	Date: 20200515
	Task: change bettype correct score (4) to 9088 [#132401]
	DB: SIT - DBTXN/bodb02
*/


/*
SELECT *
FROM SettlementSpecialBettypeProfile
WHERE SportType = 43 and BetType = 4
*/


INSERT INTO SettlementSpecialBettypeProfile (pfID, BetType, SportType, BetID, ResourceID, SettleType, GroupType, OrdNo, RoundID, OddsType)
SELECT 9088, 9088, SportType, BetID, ResourceID, SettleType, GroupType, OrdNo, RoundID, OddsType
FROM SettlementSpecialBettypeProfile
WHERE SportType = 43 AND BetType = 4

DELETE 
FROM SettlementSpecialBettypeProfile WITH(ROWLOCK, UPDLOCK)
WHERE SportType = 43 AND BetType = 4

GO