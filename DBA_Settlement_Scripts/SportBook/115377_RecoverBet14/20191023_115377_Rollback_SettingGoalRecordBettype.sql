/*
	Created: 20191002@Helen
	Task: Recover Bet14 - rollback plan if any
	DB: DBTRANS/bodb02
*/
USE bodb02
GO

DELETE pf
FROM SettlementSpecialBettypeProfile pf WITH (ROWLOCK)
	INNER JOIN dbo.f_Set_GetGroupBettypes () f ON pf.BetType = f.BetType 
WHERE pf.pfID = 0 AND f.IsUsedGoalRecordValue = 1 	
