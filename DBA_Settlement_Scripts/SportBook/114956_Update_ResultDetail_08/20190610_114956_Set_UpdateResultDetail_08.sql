/*
	Created: 20190610@Helen
	Task: Update resoure 08 in ResultDetail - [Redmine:114956] 
	DB: DBPRO/bodb02
*/
USE bodb02
GO
UPDATE r
	SET HomeValue = m.GoalRecord
FROM dbo.ResultDetail r WITH (ROWLOCK)
	INNER JOIN dbo.match m WITH (NOLOCK) ON m.matchid = r.MatchId 
WHERE m.betstatus = 'Abandoned 2H;' AND r.ResourceId = '08' 
	AND m.MatchId IN (30757991,30775436) 
GO	
