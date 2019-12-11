/*
	Created: 20191211@Sol
	DB: DBPRO/bodb02
	Task: migrate data for ResultDetailOS [Redmine:#120324]
*/

USE bodb02;

GO 

SET NOCOUNT ON

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


-- verify data
SELECT tempTbl.*
FROM #tmp_FinalResult tempTbl WITH(NOLOCK)
	LEFT JOIN ResultDetailOS main WITH(NOLOCK)
		ON main.MatchID = tempTbl.matchid 
			AND main.ResourceID = tempTbl.resourceId 
			AND main.HomeValue = tempTbl.homevalue 
			AND main.AwayValue = tempTbl.awayvalue
			AND main.ResultStatusID = tempTbl.resultstatusid
			AND main.SettlementStatusID = tempTbl.settlementstatusid 
WHERE main.MatchID IS NULL 

SET NOCOUNT OFF

GO

