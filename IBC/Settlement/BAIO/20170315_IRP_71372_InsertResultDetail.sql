/*
	Created: 20170315@Kathy
	DB: DBPRO/bodb02
	Task: migrate data for BAIO [Redmine:#71372]
*/
SET NOCOUNT ON

CREATE TABLE #tmpMatch (matchid int, fth int, fta int, hth int, hta int, betstatus nvarchar(50), eventstatus nvarchar(50), strQuarter varchar(50), IsHTCal BIT)
CREATE TABLE #tmpResultDetail (matchid int, resourceId varchar(50), homevalue varchar(50), awayvalue varchar(50), resultstatusid tinyint, settlementstatusid tinyint) 
CREATE TABLE #tmpResultQuarter (matchid int, resourceId varchar(50), homevalue varchar(50), awayvalue varchar(50), resultstatusid tinyint, settlementstatusid tinyint) 

INSERT INTO #tmpMatch (matchid, fth, fta, hth, hta, betstatus, eventstatus, strQuarter, IsHTCal)
SELECT m.matchid
	,m.finalhomescore
	,m.finalawayscore
	,m.hthomescore
	,m.htawayscore
	,ISNULL(m.betstatus,'') as betstatus
	,m.eventstatus
	,CASE 
		WHEN m.betstatus = 'Refund;' THEN ''
		WHEN m.betstatus LIKE 'Refund FT%' THEN REPLACE(m.betstatus,'Refund FT;','')
		WHEN m.betstatus LIKE 'Refund HT%' THEN REPLACE(m.betstatus,'Refund HT;','')
		ELSE ISNULL(m.betstatus,'')
	END AS strQuarter
	,ISNULL(mr.IsHTCal,0)
FROM dbo.match m WITH(NOLOCK)
	LEFT JOIN dbo.match_remark mr WITH(NOLOCK)
		ON m.matchid = mr.matchid
WHERE sporttype = 2

INSERT INTO #tmpResultDetail (matchid, resourceId, homevalue, awayvalue, resultstatusid, settlementstatusid)
SELECT matchid
	,s.ResourceId
	,s.homevalue
	,s.awayvalue
	,CASE WHEN m.betstatus = 'Refund;' THEN 5 ELSE s.resultstatusid END AS resultstatusid
	,CASE WHEN m.betstatus = 'Refund;' THEN 1 ELSE s.settlementstatusid END AS settlementstatusid
FROM #tmpMatch m
CROSS APPLY (
	SELECT '00' AS resourceId
		,CASE WHEN m.betstatus = 'Refund;' OR m.betstatus LIKE 'Refund FT%' THEN NULL ELSE m.fth END AS homevalue
		,CASE WHEN m.betstatus = 'Refund;' OR m.betstatus LIKE 'Refund FT%' THEN NULL ELSE m.fta END AS awayvalue
		,CASE 
			WHEN m.eventstatus = 'Completed' THEN 5
			WHEN m.fth IS NOT NULL AND m.fta IS NOT NULL THEN 3
			ELSE 0
		END as resultstatusid
		,CASE
			WHEN m.eventstatus = 'Completed' 
				THEN CASE
						WHEN m.betstatus = 'Refund;' OR m.betstatus LIKE 'Refund FT%' THEN 1
						ELSE 4
					END
			ELSE 0
		END AS settlementstatusid
	UNION ALL	
	SELECT '01' AS resourceid
		,CASE WHEN m.betstatus = 'Refund;' OR m.betstatus LIKE 'Refund HT%' THEN NULL ELSE m.hth END homevalue
		,CASE WHEN m.betstatus = 'Refund;' OR m.betstatus LIKE 'Refund HT%' THEN NULL ELSE m.hta END awayvalue
		,CASE 
			WHEN m.IsHTCal = 1 OR m.betstatus LIKE 'Refund HT%' OR m.eventstatus = 'Completed' THEN 5
			WHEN m.hth IS NOT NULL AND m.hta IS NOT NULL THEN 3
			ELSE 0
		END as resultstatusid
		,CASE
			WHEN m.betstatus LIKE 'Refund HT%' OR m.betstatus = 'Refund;' THEN 1
			WHEN m.isHTCal = 1 OR m.eventstatus = 'Completed' THEN 4
			ELSE 0
		END AS settlementstatusid
	UNION ALL
	SELECT 'Q1' AS resourceid
		,NULL AS homevalue
		,NULL AS awayvalue
		,0 AS resultstatusid
		,0 AS settlementstatusid 
	UNION ALL
	SELECT 'Q2' AS resourceid
		,NULL AS homevalue
		,NULL AS awayvalue
		,0 AS resultstatusid
		,0 AS settlementstatusid 
	UNION ALL
	SELECT 'Q3' AS resourceid
		,NULL AS homevalue
		,NULL AS awayvalue
		,0 AS resultstatusid
		,0 AS settlementstatusid 
	UNION ALL
	SELECT 'Q4' AS resourceid
		,NULL AS homevalue
		,NULL AS awayvalue
		,0 AS resultstatusid
		,0 AS settlementstatusid 
	UNION ALL
	SELECT 'OT' AS resourceid
		,NULL AS homevalue
		,NULL AS awayvalue
		,0 AS resultstatusid
		,0 AS settlementstatusid 
	WHERE m.betstatus NOT LIKE 'Refund FT%' AND m.betstatus <> 'Refund;'
	) s


INSERT INTO #tmpResultQuarter (matchid, resourceId, homevalue, awayvalue, resultstatusid, settlementstatusid)
SELECT matchid
	,s.ResourceId
	,CASE 
		WHEN m.IsHTCal = 1 AND s.ResourceId IN ('Q1', 'Q2') THEN s.homevalue
		WHEN m.eventstatus = 'Completed' AND s.ResourceId IN ('OT', 'Q3', 'Q4') THEN s.homevalue
		WHEN s.homevalue + s.awayvalue = 0 THEN NULL 
		ELSE s.homevalue END
	,CASE 
		WHEN m.IsHTCal = 1 AND s.ResourceId IN ('Q1', 'Q2') THEN s.awayvalue
		WHEN m.eventstatus = 'Completed' AND s.ResourceId IN ('OT', 'Q3', 'Q4') THEN s.awayvalue
		WHEN s.homevalue + s.awayvalue = 0 THEN NULL 
		ELSE s.awayvalue END
	,CASE 
		WHEN m.IsHTCal = 1 AND s.ResourceId IN ('Q1', 'Q2') THEN 5
		WHEN m.eventstatus = 'Completed' AND s.ResourceId IN ('OT', 'Q3', 'Q4') THEN 5
		WHEN s.homevalue + s.awayvalue > 0 THEN 3
		ELSE 0
	END		
	,CASE
		WHEN m.IsHTCal = 1 AND s.ResourceId LIKE 'Q[1-2]' THEN 4
		WHEN m.eventstatus = 'Completed' THEN 4		
		ELSE 0
	END		
FROM #tmpMatch m
CROSS APPLY (
	SELECT SUBSTRING(s.val, 0, charindex('-', s.val)) AS homevalue
		,substring(s.val, charindex('-', s.val) + 1, len(s.val)) AS awayvalue
		,CASE 
			WHEN s.rank BETWEEN 1
					AND 4
				THEN 'Q' + CAST(s.rank AS VARCHAR)
			WHEN s.rank = 5
				THEN 'OT'
			ELSE ''
			END AS ResourceId
	FROM dbo.strSplit(m.strquarter, ',') s
	
	) s
WHERE m.strquarter <> ''

UPDATE r 
	SET homevalue = q.homevalue
		,awayvalue = q.awayvalue
		,resultstatusid = q.resultstatusid
		,settlementstatusid = q.settlementstatusid
FROM #tmpResultDetail r
	INNER JOIN #tmpResultQuarter q
		ON q.matchid = r.matchid
			AND q.resourceId = r.resourceId
			
/*
-------------
INSERT ResultDetail
-------------
*/
MERGE dbo.ResultDetail TARGET
USING (
	SELECT matchid, resourceId, homevalue, awayvalue, resultstatusid, settlementstatusid
	FROM #tmpResultDetail 
) AS SOURCE
	ON TARGET.MatchId = SOURCE.matchid
		AND TARGET.ResourceId = SOURCE.resourceId
WHEN NOT MATCHED BY TARGET THEN
	INSERT (MatchId, ResourceId, HomeValue, AwayValue
				,ResultStatusID, SettlementStatusID, CreateDate, LastModifyDate, CreateBy, LastModifyBy)
	VALUES (SOURCE.matchid, SOURCE.ResourceId, SOURCE.HomeValue, SOURCE.AwayValue
				,SOURCE.ResultStatusID,SOURCE.SettlementStatusID,GETDATE(),GETDATE(),111, 111);
				
SELECT @@rowcount AS 'NumberOfRow'
DROP TABLE #tmpMatch
DROP TABLE #tmpResultDetail 
DROP TABLE #tmpResultQuarter

SET NOCOUNT OFF