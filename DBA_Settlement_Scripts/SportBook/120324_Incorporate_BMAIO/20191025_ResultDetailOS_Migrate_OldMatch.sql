/*
	Created: 20191025@Sol
	DB: DBPRO/bodb02
	Task: migrate data for ResultDetailOS [Redmine:#120324]
*/

USE bodb02;

GO 

SET NOCOUNT ON

DECLARE @id_control INT
DECLARE @batchSize INT
DECLARE @results INT

SET @results = 1 --stores the row count after each successful batch
SET @batchSize = 1000 --rows to operate on each batch
SET @id_control = 0 --current batch 

-- Insert data to temp table 
SELECT eventstatus, finalhomescore, finalawayscore, ISNULL(betstatus,'') AS betstatus, matchid
	INTO #tmp_match
FROM match m WITH(NOLOCK)
WHERE sporttype = 9 

--Insert final data to table temp
SELECT ROW_NUMBER() OVER(ORDER BY m.matchid, s.ResourceId) AS RowNumber, m.matchid
		,s.ResourceId
		,s.homevalue
		,s.awayvalue
		,resultstatusid
		,settlementstatusid
	INTO #tmp_FinalResult
FROM #tmp_match m
		OUTER APPLY (
						SELECT TOP 3  ROW_NUMBER()OVER(ORDER BY m.matchid) AS ID,  m.matchid, f.val AS Score
						FROM f_SplitString(m.betstatus, ',') f
						WHERE m.betstatus not in ('', 'Refund;') 
						UNION 
						SELECT 0 , m.matchid, ''
					) bs

		CROSS APPLY (
			SELECT '00' AS resourceId
				,CASE WHEN m.finalhomescore IS NOT NULL OR m.finalawayscore IS NOT NULL THEN finalhomescore ELSE NULL END AS homevalue
				,CASE WHEN m.finalhomescore IS NOT NULL OR m.finalawayscore IS NOT NULL THEN finalawayscore ELSE NULL END AS awayvalue
				,CASE 
					WHEN m.eventstatus = 'Completed' THEN 5
					WHEN m.finalhomescore IS NOT NULL OR m.finalawayscore IS NOT NULL THEN 3
					ELSE 0
				END as resultstatusid
				,CASE
					WHEN m.eventstatus = 'Completed' 
						THEN CASE
								WHEN m.betstatus = 'Refund;' THEN 1
								ELSE 4
							END
					ELSE 0
				END AS settlementstatusid
			WHERE bs.ID = 0
			UNION ALL	
			SELECT TOP 1 '0101' AS resourceid
				, LEFT(Score, CHARINDEX('-',Score)-1) AS homevalue
				, RIGHT(Score, LEN(Score) - CHARINDEX('-',Score)) AS awayvalue
				,CASE 
					WHEN m.eventstatus = 'Completed' THEN 5
					WHEN m.finalhomescore IS NOT NULL OR m.finalawayscore IS NOT NULL THEN 3
					ELSE 0
				END AS resultstatusid
				,CASE
					WHEN m.eventstatus = 'Completed' 
						THEN CASE
								WHEN m.betstatus = 'Refund;' THEN 1
								ELSE 4
							END
					ELSE 0
				END AS settlementstatusid
			WHERE  bs.ID = 1
			UNION ALL
			SELECT TOP 1 '0102' AS resourceid
				, LEFT(Score, CHARINDEX('-',Score)-1) AS homevalue
				, RIGHT(Score, LEN(Score) - CHARINDEX('-',Score)) AS awayvalue
				,CASE 
					WHEN m.eventstatus = 'Completed' THEN 5
					WHEN m.finalhomescore IS NOT NULL OR m.finalawayscore IS NOT NULL THEN 3
					ELSE 0
				END AS resultstatusid
				,CASE
					WHEN m.eventstatus = 'Completed' 
						THEN CASE
								WHEN m.betstatus = 'Refund;' THEN 1
								ELSE 4
							END
					ELSE 0
				END AS settlementstatusid
			WHERE bs.ID = 2
			UNION ALL
			SELECT TOP 1 '0103' AS resourceid
				, LEFT(Score, CHARINDEX('-',Score)-1)
				 as homevalue
				, RIGHT(Score, LEN(Score) - CHARINDEX('-',Score))
				 AS awayvalue
				,CASE 
					WHEN m.eventstatus = 'Completed' THEN 5
					WHEN m.finalhomescore IS NOT NULL OR m.finalawayscore IS NOT NULL THEN 3
					ELSE 0
				END AS resultstatusid
				,CASE
					WHEN m.eventstatus = 'Completed' 
						THEN CASE
								WHEN m.betstatus = 'Refund;' THEN 1
								ELSE 4
							END
					ELSE 0
				END AS settlementstatusid
			WHERE  bs.ID = 3
			) s

--Insert data to ResultDetailOS
--when 0 rows returned, exit the loop
WHILE (@results > 0) 
BEGIN
	
	MERGE dbo.ResultDetailOS TARGET
	USING (
		SELECT matchid, resourceId, homevalue, awayvalue, resultstatusid, settlementstatusid
		FROM #tmp_FinalResult 
		WHERE RowNumber > @id_control
			AND RowNumber <= @id_control + @batchSize
	) AS SOURCE
		ON TARGET.MatchId = SOURCE.matchid
			AND TARGET.ResourceId = SOURCE.resourceId
	WHEN NOT MATCHED BY TARGET THEN
		INSERT (MatchId, ResourceId, HomeValue, AwayValue
					,ResultStatusID, SettlementStatusID, CreateDate, LastModifyDate, CreateBy, LastModifyBy)
		VALUES (SOURCE.matchid, SOURCE.ResourceId, SOURCE.HomeValue, SOURCE.AwayValue
					,SOURCE.ResultStatusID,SOURCE.SettlementStatusID,GETDATE(),GETDATE(),111, 111);
 
   -- obtain the latest rowcount to avoid infinite loops
   SET @results = @@ROWCOUNT

   -- next batch
   SET @id_control = @id_control + @batchSize

   -- rows affected
   SELECT @results AS 'RowAffected'
END

DROP TABLE #tmp_match
DROP TABLE #tmp_FinalResult

SET NOCOUNT OFF

GO

