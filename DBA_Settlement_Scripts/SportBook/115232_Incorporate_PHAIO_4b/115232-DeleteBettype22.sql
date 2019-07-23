/*	
	Created: 20190723@Kathy
	Task: delete bettype 22 after release PH AIO phase 4b [Redmine:#115232]
	DB: DBTXN/bodb02
*/
USE bodb02
GO
-- 99 rows affected
DELETE 
FROM	dbo.SettlementSpecialBettypeProfile WITH(ROWLOCK, UPDLOCK)
WHERE	sporttype = 1
		AND BetType = 22

GO
