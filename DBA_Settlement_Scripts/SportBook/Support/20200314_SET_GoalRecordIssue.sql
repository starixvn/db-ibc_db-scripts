/*
	Created: 20200314@Helen
	Task: Correct GoalRecord - [Redmine:#0000] 
	DB: DBPRO/bodb02
*/

USE bodb02

GO

UPDATE dbo.Match WITH(ROWLOCK)
	SET GoalRecord = 'AA;'
WHERE matchid = 35111513

go

UPDATE dbo.ResultDetail WITH (ROWLOCK)
	SET HomeValue = 'AA;'
WHERE ResourceId = '08' AND MatchId = 35111513 

GO

UPDATE dbo.ResultDetail WITH (ROWLOCK)
	SET HomeValue = 'AA'
WHERE ResourceId = '09' AND MatchId = 35111513 

GO

