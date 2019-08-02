/*
	Created: 20190802@Sol
	Task: Correct GoalRecord - [Redmine:#118079] 
	DB: DBPRO/bodb02
*/

USE bodb02

GO

UPDATE dbo.Match WITH(ROWLOCK)
	SET GoalRecord = 'A;H'
WHERE matchid = 31541371

go

UPDATE dbo.ResultDetail WITH (ROWLOCK)
	SET HomeValue = 'A;H'
WHERE ResourceId = '08' AND MatchId = 31541371 

GO

UPDATE dbo.ProviderResultDetail WITH (ROWLOCK)
	SET HomeValue = 'A;H'
WHERE ProviderResultDetailId = 1180275 AND MatchId = 31541371

GO