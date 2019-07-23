/*	
	Created: 20190723@Kathy
	Task: update setting for old bettype & insert new bettype [Redmine:#115232]
	DB: DBTXN/bodb02
*/
USE bodb02
GO
INSERT INTO dbo.SettlementSpecialBettypeProfile (pfID, SportType, BetType, BetID, ResourceID, SettleType, GroupType, OrdNo, OddsType)
VALUES (479, 1, 479, 0, 479, 'EAR', 'FT', 3, NULL)
,(479, 1, 481, 0, 481, 'EAR', 'FT', 4, NULL)

UPDATE dbo.SettlementSpecialBettypeProfile WITH(ROWLOCK, UPDLOCK)
	SET SettleType = 'MNL'
WHERE	SportType = 1
		AND BetType = 22

UPDATE dbo.SettlementSpecialBettypeProfile WITH(ROWLOCK, UPDLOCK)
	SET pfID = 424
		,OrdNo = 1
WHERE bettype = 424

UPDATE dbo.SettlementSpecialBettypeProfile WITH(ROWLOCK, UPDLOCK)
	SET pfID = 424
		,OrdNo = 2
WHERE bettype = 455
