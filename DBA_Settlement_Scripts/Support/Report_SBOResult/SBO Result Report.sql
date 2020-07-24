 /*
	Created: 20200724@Max
	Task : SBO result Report [Redmine:#122713]
	DB: DBPRO/bodb02
*/

CREATE TABLE #match_tmp (matchid INT)

INSERT INTO #match_tmp (matchid)
SELECT m.matchid
FROM dbo.match m WITH (NOLOCK)
	INNER JOIN dbo.league l WITH (NOLOCK) ON m.leagueid = l.leagueid
WHERE m.sporttype = 1 AND l.isTest = 0

CREATE TABLE #data_temp (matchid INT, SourceId TINYINT, HTHomeScore VARCHAR(10), HTAwayScore VARCHAR(10), FTHomeScore VARCHAR(10), FTAwayScore VARCHAR(10))

INSERT INTO #data_temp (matchid, SourceId, HTHomeScore, HTAwayScore, FTHomeScore, FTAwayScore)
SELECT 
	matchid, SourceId
	, MAX(CASE WHEN TypeId = 1 THEN HomeValue END) AS HTHomeScore
	, MAX(CASE WHEN TypeId = 1 THEN AwayValue END) AS HTAwayScore
	, MAX(CASE WHEN TypeId = 2 THEN HomeValue END) AS FTHomeScore
	, MAX(CASE WHEN TypeId = 2 THEN AwayValue END) AS FTAwayScore
FROM 
(
	SELECT 
		m.matchid, SourceId, TypeId, HomeValue, AwayValue, CreatedDate
		, RANK()OVER(PARTITION BY rd.matchid, SourceId, TypeId ORDER BY createddate DESC) maxDate
	FROM #match_tmp m
		LEFT JOIN bodb02.dbo.ProviderResultDetail rd WITH(NOLOCK)  ON m.matchid = rd.MatchId
	WHERE TypeId IN (1,2) AND SourceId = 1
) t
WHERE maxDate = 1
GROUP BY t.MatchId, SourceId

SELECT t.matchid, t.SourceId, t.HTHomeScore, t.HTAwayScore, t.FTHomeScore, t.FTAwayScore
FROM #data_temp t
WHERE t.HTHomeScore IS NOT NULL AND t.HTAwayScore IS NOT NULL
	AND t.FTHomeScore IS NULL AND t.FTAwayScore IS NULL

SELECT COUNT(1) AS TotalMatchSBOResult
FROM #data_temp

DROP TABLE #match_tmp
DROP TABLE #data_temp