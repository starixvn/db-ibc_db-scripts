
/*
	Created: 20181121@Kathy
	DB: DBPRO/bodb02
	Task: Initial data for column match.SettlementStatus [Redmine:#102028]
*/
SET NOCOUNT ON

DECLARE @BatchCount INT

DECLARE @tmpMatchId TABLE (MatchId INT, SettlementStatus TINYINT)
CREATE TABLE #tmpMatch_Remark (MatchId INT, SettlementStatus TINYINT)

SET @BatchCount = 2000

INSERT INTO #tmpMatch_Remark (matchid, SettlementStatus)
SELECT	mr.matchid
		,ISNULL(mr.isPending, 0) + CASE WHEN ISNULL(mr.isUndecided, 0) = 1 THEN 2 ELSE 0 END AS SettlementStatus
FROM	dbo.match_remark mr WITH(NOLOCK)
	INNER JOIN dbo.match m WITH(NOLOCK)
		ON mr.matchid = m.matchid
WHERE	(mr.isPending = 1 OR mr.isUndecided = 1)

IF @@ROWCOUNT > 0
BEGIN
	WHILE (1 = 1)
	BEGIN
		DELETE FROM @tmpMatchId

		DELETE TOP (@BatchCount) #tmpMatch_Remark
		OUTPUT  DELETED.MatchId, DELETED.SettlementStatus INTO @tmpMatchId (MatchId, SettlementStatus)	
	
		UPDATE	TOP (@BatchCount) m
			SET SettlementStatus = t.SettlementStatus
		FROM	dbo.match m 
			INNER JOIN @tmpMatchId t 
				ON m.matchid = t.matchid

		IF @@ROWCOUNT < @BatchCount
			BREAK
	END
END

DROP TABLE #tmpMatch_Remark
