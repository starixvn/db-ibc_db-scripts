/*<info serverAlias="DBACC-bodb02"></info>*/

/*
Create: 20230725@Lewis
Task: ReGen Data of Sum_Winloss_Old - SabaTennis [RedmineID: #190459]
DB: DBACC-bodb02

Description:
	1. RUN Script 1 to get data bk --> INSERT into sum_winloss_old_tmp (DBACC-bodb02)
	2. RUN Script 2 to reGen for sum_winloss_old (DBSUM-bodb_Summary)
*/

DECLARE @wldate SMALLDATETIME = '20230628'  --'20230629'

-- ==========================
-- Get data from bettrans_bk
-- ==========================

CREATE TABLE #databettrans_bk (
	winlostdate SMALLDATETIME,
	custid INT
)
INSERT INTO #databettrans_bk (
	winlostdate,
	custid
)
SELECT DISTINCT
	b.winlostdate,
	b.custid
FROM bodb_Archive.dbo.bettrans_bk b WITH (NOLOCK)
INNER JOIN bodb_Archive.dbo.match_bk m WITH (NOLOCK)
	ON b.matchid = m.matchid
INNER JOIN (
			SELECT  leagueid,LeagueGroupID 
			FROM dbo.League WITH (NOLOCK) 
			WHERE LeagueGroupID = 42 AND sporttype = 5
		  ) l
	ON l.leagueid = m.leagueid
WHERE b.winlostdate = @wldate
	AND b.statusID IN (111,112,113)

-- ================================================================
-- Insert data into dbo.sum_winloss_old_tmp by Task_Sum_Winloss_Old
-- ================================================================

DECLARE @custids VARCHAR(MAX)

SELECT @custids = STRING_AGG(CAST(b.custid AS VARCHAR(MAX)),',')
FROM #databettrans_bk b
WHERE b.winlostdate = @wldate

EXEC dbo.Task_Sum_Winloss_Old 
		@WinlostDate = @wldate,
		@CustIds = @custids,
		@ProductIds = '1'

WAITFOR DELAY '00:00:02'

-- ==============================================================================
-- DELETE data bodb_Archive.dbo.sum_winloss_old_tmp not in list Custids & not SMA
-- ==============================================================================

IF NOT EXISTS (SELECT TOP 1 1 FROM bodb_Archive.dbo.sum_winloss_old_tmp WITH (NOLOCK) WHERE winlostdate = @wldate)
BEGIN
	RETURN
END

DELETE
FROM bodb_Archive.dbo.sum_winloss_old_tmp 
WHERE winlostdate = @wldate
	AND	roleid = 1 --not SMA
	AND custid NOT IN (SELECT custid FROM #databettrans_bk) --not in list Custids
	 	
DROP TABLE #databettrans_bk	