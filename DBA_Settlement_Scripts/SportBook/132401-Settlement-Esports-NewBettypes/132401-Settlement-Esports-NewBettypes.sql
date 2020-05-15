/*
	Created by: Kathy
	Date: 20200428
	Task: Insert new bettype for esport [#132401]
	DB: DBTXN/bodb02
*/

IF NOT EXISTS (SELECT TOP 1 1 FROM SettlementSpecialBettypeProfile WITH(NOLOCK) WHERE sporttype = 43 AND BetType = 9087)
BEGIN
	UPDATE SettlementSpecialBettypeProfile WITH(ROWLOCK, UPDLOCK)
		SET OrdNo = OrdNo + (RoundID%100)*100 - 100
	WHERE SportType = 43
	AND RoundID > 801
	AND SettleType <> 'MNL'

	INSERT INTO SettlementSpecialBettypeProfile (pfID, BetType, SportType, BetID, ResourceID, SettleType, GroupType, RoundID, OrdNo, OddsType)
	VALUES (102, 9087,43,801,908701,'EAR','SP',801, 0, 0)
	,(102, 9087,43,802,908702,'EAR','SP',802,0, 0)
	,(102, 9087,43,803,908703,'EAR','SP',803,0, 0)
	,(102, 9087,43,804,908704,'EAR','SP',804,0, 0)
	,(102, 9087,43,805,908705,'EAR','SP',805,0, 0)

	UPDATE s WITH(ROWLOCK, UPDLOCK)
		SET OrdNo = tmp.max_ordno + 1
	FROM SettlementSpecialBettypeProfile s
		CROSS APPLY (
			select MAX(tmp.OrdNo) max_ordno
			from SettlementSpecialBettypeProfile tmp
			WHERE tmp.SportType = s.SportType 
				AND tmp.SettleType = s.SettleType 
				AND tmp.RoundID = s.RoundID
			GROUP BY tmp.RoundID
		) tmp
	WHERE s.SportType = 43
	AND s.SettleType = 'EAR'
	AND s.BetType = 9087
END

IF NOT EXISTS (SELECT TOP 1 1 FROM SettlementSpecialBettypeProfile WITH(NOLOCK) WHERE sporttype = 43 AND BetType = 9088)
BEGIN
	INSERT INTO SettlementSpecialBettypeProfile (pfID, BetType, SportType, BetID, ResourceID, SettleType, GroupType, RoundID, OrdNo, OddsType)
	VALUES (9088, 9088,43,0,'00','MNL','FT','00', 99, 1)
END