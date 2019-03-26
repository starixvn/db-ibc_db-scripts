/*
	Creator: Kathy
    Date: 20190326
    Task: Correct result detail [Redmine:#110793]
    DB: DBPRO/bodb02
   
		
*/

UPDATE TOP (1) dbo.ResultDetail WITH(ROWLOCK, UPDLOCK)
	SET ResultStatusID = 1
		,SettlementStatusID = 0
WHERE	MatchId = 29558076
		AND ResourceId = '16002'