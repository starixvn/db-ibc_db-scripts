-- run on DBACC
/*
	Created: 20210202@Percy
	DB: DBACC.bodb02
*/

CREATE TABLE #_CornerMatch (matchid INT, homeid INT)
CREATE TABLE #_bettrans (transid BIGINT, winlostdate SMALLDATETIME, refno BIGINT)
CREATE TABLE #_bettransm (refno BIGINT, matchid INT)

-- Get corner match
INSERT INTO #_CornerMatch (matchid, homeid)
SELECT matchid, homeid
FROM bodb_Archive.dbo.match_bk WITH (NOLOCK)
WHERE eventdate BETWEEN '2020-12-01' AND '2021-01-21'
	AND sporttype = 1

INSERT INTO #_CornerMatch (matchid, homeid)
SELECT matchid, homeid
FROM bodb02.dbo.match14 WITH (NOLOCK)
WHERE eventdate BETWEEN '2020-01-22' AND '2021-01-29'
	AND sporttype = 1

INSERT INTO #_CornerMatch (matchid, homeid)
SELECT matchid, homeid
FROM bodb02.dbo.match WITH (NOLOCK)
WHERE eventdate >= '2020-01-30'
	AND sporttype = 1

DELETE m
FROM #_CornerMatch m
	INNER JOIN bodb02.dbo.team t WITH (NOLOCK) ON m.homeid = t.teamid
WHERE t.teamname NOT LIKE '%No.of Corners%'
-- End Get corner match

-- Get ticket on bettrans
INSERT INTO #_bettrans (transid, winlostdate, refno)
SELECT b.transid, b.winlostdate, b.refno
FROM bodb_Archive.dbo.bettrans_bk b WITH (NOLOCK)
WHERE b.winlostdate BETWEEN '2021-01-01' AND '2021-01-21'
	AND b.bettype = 29
	AND b.statusID IN (111, 112, 113)

INSERT INTO #_bettrans (transid, winlostdate, refno)
SELECT b.transid, b.winlostdate, b.refno
FROM bodb02.dbo.bettrans14 b WITH (NOLOCK)
WHERE b.winlostdate BETWEEN '2021-01-22' AND '2021-01-29'
	AND b.bettype = 29
	AND b.statusID IN (111, 112, 113)

INSERT INTO #_bettrans (transid, winlostdate, refno)
SELECT b.transid, b.winlostdate, b.refno
FROM bodb02.dbo.bettrans b WITH (NOLOCK)
WHERE b.winlostdate BETWEEN '2021-01-30' AND '2021-01-31'
	AND b.bettype = 29
	AND b.statusID IN (111, 112, 113)
-- End Get ticket on bettrans

-- Get ticket on bettransm
INSERT INTO #_bettransm (refno, matchid)
SELECT bm.refno, bm.matchid
FROM bodb_Archive.dbo.bettransm bm WITH (NOLOCK)
WHERE winlostdate BETWEEN '2020-12-15' AND '2021-01-21'

INSERT INTO #_bettransm (refno, matchid)
SELECT bm.refno, bm.matchid
FROM bodb02.dbo.bettransm14 bm WITH (NOLOCK)
WHERE winlostdate BETWEEN '2021-01-22' AND '2021-01-29'

INSERT INTO #_bettransm (refno, matchid)
SELECT bm.refno, bm.matchid
FROM bodb02.dbo.bettransm bm WITH (NOLOCK)
WHERE winlostdate BETWEEN '2020-01-30' AND '2021-01-31'
-- End Get ticket on bettransm

CREATE CLUSTERED INDEX CIX_refno ON #_bettransm (refno)
CREATE INDEX IX_match ON #_bettransm (matchid)
CREATE INDEX IX_match ON #_CornerMatch (matchid)
CREATE INDEX IX_refno ON #_bettrans (refno)

-- remove data on bettransm
DELETE bm
FROM #_bettransm bm
	LEFT JOIN #_CornerMatch m ON bm.matchid = m.matchid
WHERE m.matchid IS NULL

-- remove duplicate refno (just keep 1 refno to query on bettrans)
DELETE bm
FROM (
	SELECT ROW_NUMBER() OVER(PARTITION BY refno ORDER BY refno) AS RN
	FROM #_bettransm
) bm
WHERE bm.RN > 1

-- remove data on bettransm
DELETE b
FROM #_bettrans b
	LEFT JOIN #_bettransm bm ON b.refno = bm.refno
WHERE bm.refno IS NULL

-- Get full data on bettransm: sporttype
CREATE TABLE #_bettransm_data (refno BIGINT, sporttype SMALLINT)
INSERT INTO #_bettransm_data (refno, sporttype)
SELECT t.refno, m.sporttype
FROM #_bettransm t
	INNER JOIN bodb02.dbo.bettransm bm WITH (NOLOCK) ON t.refno = bm.refno
	INNER JOIN bodb02.dbo.match m WITH (NOLOCK) ON bm.matchid = m.matchid

INSERT INTO #_bettransm_data (refno, sporttype)
SELECT t.refno, m.sporttype
FROM #_bettransm t
	INNER JOIN bodb02.dbo.bettransm14 bm WITH (NOLOCK) ON t.refno = bm.refno
	INNER JOIN bodb02.dbo.match14 m WITH (NOLOCK) ON bm.matchid = m.matchid

DECLARE @n INT = 100
INSERT INTO #_bettransm_data (refno, sporttype)
SELECT t.refno, m.sporttype
FROM #_bettransm t
	CROSS APPLY (
		SELECT TOP (@n) m.sporttype
		FROM bodb_Archive.dbo.bettransm bm WITH (NOLOCK, INDEX = IX_bettransm, FORCESEEK)
			INNER JOIN bodb_Archive.dbo.match_bk m WITH (NOLOCK) ON bm.matchid = m.matchid
		WHERE t.refno = bm.refno
	) m
OPTION (OPTIMIZE FOR (@n=1))
-- End Get full data on bettransm: sporttype
	
CREATE CLUSTERED INDEX CIX_refno ON #_bettransm_data (refno)

-- Get winloss data on bettrans
CREATE TABLE #Result (winlostdate SMALLDATETIME, hdp2 SMALLMONEY, sporttype SMALLINT
	, Tickets_Won INT, Tickets_Lose INT, Stake_Won MONEY, Stake_Lose MONEY, Member_Won MONEY, Member_Lose MONEY, OurPT_Won MONEY, OurPT_Lose MONEY)
   
INSERT INTO #Result
SELECT
	b.winlostdate, b.hdp2, bm.sporttype
	,SUM(CASE WHEN statusID = 112 THEN 1 ELSE 0 END) AS tickets_won
	,SUM(CASE WHEN statusID = 113 THEN 1 ELSE 0 END) AS tickets_lose
	,SUM(CASE WHEN statusID = 112 THEN stake * actualrate * (1 - tpositiontaking - CAST(ISNULL(epositiontaking, 0) AS DECIMAL(9,8))) ELSE 0 END) AS stake_won
	,SUM(CASE WHEN statusID = 113 THEN stake * actualrate * (1 - tpositiontaking - CAST(ISNULL(epositiontaking, 0) AS DECIMAL(9,8))) ELSE 0 END) AS stake_lose
	,SUM(CASE WHEN statusID = 112 THEN -(winlost - actual_stake) * actualrate ELSE 0 END) AS member_won
	,SUM(CASE WHEN statusID = 113 THEN -(winlost - actual_stake) * actualrate ELSE 0 END) AS member_lose
	,SUM(CASE WHEN statusID = 112 THEN (-(winlost - actual_stake) * (1 - tpositiontaking - CAST(ISNULL(epositiontaking, 0) AS DECIMAL(9,8))) - scomm  + scomm * CAST(ISNULL(epositiontaking, 0) AS DECIMAL(9,8)) / (1 - tpositiontaking)) * actualrate ELSE 0 END) AS ourPT_won
	,SUM(CASE WHEN statusID = 113 THEN (-(winlost - actual_stake) * (1 - tpositiontaking - CAST(ISNULL(epositiontaking, 0) AS DECIMAL(9,8))) - scomm  + scomm * CAST(ISNULL(epositiontaking, 0) AS DECIMAL(9,8)) / (1 - tpositiontaking)) * actualrate ELSE 0 END) AS ourPT_lose
FROM #_bettrans t
	INNER JOIN bodb02.dbo.bettrans b WITH (NOLOCK) ON t.transid = b.transid
	CROSS APPLY (SELECT CASE
							WHEN COUNT(DISTINCT sporttype) = 1 THEN MIN(sporttype)
							WHEN MIN(sporttype) = 1 THEN -3
							ELSE -1 END AS sporttype
				 FROM #_bettransm_data bm WHERE b.refno = bm.refno) bm
WHERE b.currency <> 20
	AND b.statusID <> 111
GROUP BY b.winlostdate, b.hdp2, bm.sporttype

INSERT INTO #Result
SELECT
	b.winlostdate, b.hdp2, bm.sporttype
	,SUM(CASE WHEN statusID = 112 THEN 1 ELSE 0 END) AS tickets_won
	,SUM(CASE WHEN statusID = 113 THEN 1 ELSE 0 END) AS tickets_lose
	,SUM(CASE WHEN statusID = 112 THEN stake * actualrate * (1 - tpositiontaking - CAST(ISNULL(epositiontaking, 0) AS DECIMAL(9,8))) ELSE 0 END) AS stake_won
	,SUM(CASE WHEN statusID = 113 THEN stake * actualrate * (1 - tpositiontaking - CAST(ISNULL(epositiontaking, 0) AS DECIMAL(9,8))) ELSE 0 END) AS stake_lose
	,SUM(CASE WHEN statusID = 112 THEN -(winlost - actual_stake) * actualrate ELSE 0 END) AS member_won
	,SUM(CASE WHEN statusID = 113 THEN -(winlost - actual_stake) * actualrate ELSE 0 END) AS member_lose
	,SUM(CASE WHEN statusID = 112 THEN (-(winlost - actual_stake) * (1 - tpositiontaking - CAST(ISNULL(epositiontaking, 0) AS DECIMAL(9,8))) - scomm  + scomm * CAST(ISNULL(epositiontaking, 0) AS DECIMAL(9,8)) / (1 - tpositiontaking)) * actualrate ELSE 0 END) AS ourPT_won
	,SUM(CASE WHEN statusID = 113 THEN (-(winlost - actual_stake) * (1 - tpositiontaking - CAST(ISNULL(epositiontaking, 0) AS DECIMAL(9,8))) - scomm  + scomm * CAST(ISNULL(epositiontaking, 0) AS DECIMAL(9,8)) / (1 - tpositiontaking)) * actualrate ELSE 0 END) AS ourPT_lose
FROM #_bettrans t
	INNER JOIN bodb02.dbo.bettrans14 b WITH (NOLOCK) ON t.transid = b.transid
	CROSS APPLY (SELECT CASE
							WHEN COUNT(DISTINCT sporttype) = 1 THEN MIN(sporttype)
							WHEN MIN(sporttype) = 1 THEN -3
							ELSE -1 END AS sporttype
				 FROM #_bettransm_data bm WHERE b.refno = bm.refno) bm
WHERE b.currency <> 20
	AND b.statusID <> 111
GROUP BY b.winlostdate, b.hdp2, bm.sporttype

INSERT INTO #Result
SELECT
	b.winlostdate, b.hdp2, bm.sporttype
	,SUM(CASE WHEN statusID = 112 THEN 1 ELSE 0 END) AS tickets_won
	,SUM(CASE WHEN statusID = 113 THEN 1 ELSE 0 END) AS tickets_lose
	,SUM(CASE WHEN statusID = 112 THEN stake * actualrate * (1 - tpositiontaking - CAST(ISNULL(epositiontaking, 0) AS DECIMAL(9,8))) ELSE 0 END) AS stake_won
	,SUM(CASE WHEN statusID = 113 THEN stake * actualrate * (1 - tpositiontaking - CAST(ISNULL(epositiontaking, 0) AS DECIMAL(9,8))) ELSE 0 END) AS stake_lose
	,SUM(CASE WHEN statusID = 112 THEN -(winlost - actual_stake) * actualrate ELSE 0 END) AS member_won
	,SUM(CASE WHEN statusID = 113 THEN -(winlost - actual_stake) * actualrate ELSE 0 END) AS member_lose
	,SUM(CASE WHEN statusID = 112 THEN (-(winlost - actual_stake) * (1 - tpositiontaking - CAST(ISNULL(epositiontaking, 0) AS DECIMAL(9,8))) - scomm  + scomm * CAST(ISNULL(epositiontaking, 0) AS DECIMAL(9,8)) / (1 - tpositiontaking)) * actualrate ELSE 0 END) AS ourPT_won
	,SUM(CASE WHEN statusID = 113 THEN (-(winlost - actual_stake) * (1 - tpositiontaking - CAST(ISNULL(epositiontaking, 0) AS DECIMAL(9,8))) - scomm  + scomm * CAST(ISNULL(epositiontaking, 0) AS DECIMAL(9,8)) / (1 - tpositiontaking)) * actualrate ELSE 0 END) AS ourPT_lose
FROM #_bettrans t
	CROSS APPLY (
		SELECT TOP 1 b.winlostdate, b.statusID, b.refno, b.stake, b.actual_stake, b.winlost, b.tpositiontaking, b.epositiontaking, b.scomm, b.actualrate, b.hdp2, b.currency
		FROM bodb_Archive.dbo.bettrans_bk b WITH (NOLOCK, INDEX = IX_transid, FORCESEEK)
		WHERE t.transid = b.transid
	) b
	CROSS APPLY (SELECT CASE
							WHEN COUNT(DISTINCT sporttype) = 1 THEN MIN(sporttype)
							WHEN MIN(sporttype) = 1 THEN -3
							ELSE -1 END AS sporttype
				 FROM #_bettransm_data bm WHERE b.refno = bm.refno) bm
WHERE b.currency <> 20
	AND b.statusID <> 111
GROUP BY b.winlostdate, b.hdp2, bm.sporttype
-- Get winloss data on bettrans

-- Return data
SELECT winlostdate, CONVERT(INT, hdp2) AS Combo
	,CASE t.sporttype WHEN -3 THEN 'Combined Sports' WHEN -1 THEN 'Mix Sports' ELSE s.SportName END AS [Sport]
	,Tickets_Won AS [Ticket Won]
	,Tickets_Lose AS [Ticket Lose]
	,Stake_Won AS [Stake Won]
	,Stake_Lose AS [Stake Lose]
	,Member_Won AS [Member Won]
	,Member_Lose AS [Member Lose]
	,OurPT_Won AS [House Won]
	,OurPT_Lose AS [House Lose]
FROM #Result t
	LEFT JOIN bodb02.dbo.Sports s WITH (NOLOCK) ON t.sporttype = s.SportType
ORDER BY 1, 2, 3

DROP TABLE #_bettrans
DROP TABLE #_bettransm
DROP TABLE #_bettransm_data
DROP TABLE #_CornerMatch
DROP TABLE #Result