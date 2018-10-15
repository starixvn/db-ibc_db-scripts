USE bodb02
GO

/*
	Created: 20181015@Kathy
	DB: DBPRO/bodb02
	Task: Initial data for column match_remark.SettlementStatus [Redmine:#102028]
*/
SET NOCOUNT ON

DECLARE @BatchCount INT
		,@AffectedRow INT

DECLARE @tmpMatchId TABLE (MatchId INT, SettlementStatus TINYINT)
CREATE TABLE #tmpMatch_Remark (MatchId INT, SettlementStatus TINYINT)

SET @BatchCount = 2000
SET @AffectedRow = 0

INSERT INTO #tmpMatch_Remark(matchid, SettlementStatus)
SELECT	matchid
		,ISNULL(isPending, 0) + CASE WHEN ISNULL(isUndecided, 0) = 1 THEN 2 ELSE 0 END AS SettlementStatus
FROM	dbo.match_remark
WHERE	isPending = 1 
		OR isUndecided = 1 

MERGE #tmpMatch_Remark AS TARGET
USING (SELECT	m.matchid
		FROM	dbo.match m WITH(NOLOCK)
		WHERE	m.eventstatus = N'completed'
	) AS SOURCE
	ON TARGET.MatchId = SOURCE.matchid
WHEN MATCHED THEN UPDATE 
					SET	TARGET.SettlementStatus = TARGET.SettlementStatus + 4
WHEN NOT MATCHED BY TARGET THEN 
	INSERT (matchid, SettlementStatus)
	VALUES (SOURCE.matchid, 4);


SET @AffectedRow = @@rowcount

IF @AffectedRow > 0
BEGIN
	WHILE (1 = 1)
	BEGIN
		DELETE FROM @tmpMatchId

		DELETE TOP (@BatchCount) #tmpMatch_Remark
		OUTPUT  DELETED.MatchId, DELETED.SettlementStatus INTO @tmpMatchId (MatchId, SettlementStatus)	
	
		UPDATE	TOP (@BatchCount) m
			SET SettlementStatus = t.SettlementStatus
		FROM	dbo.match_remark m 
			INNER JOIN @tmpMatchId t 
				ON m.matchid = t.matchid

		IF @@rowcount < @BatchCount
			BREAK
	END
END

SELECT @AffectedRow 'Affected rows'

DROP TABLE #tmpMatch_Remark