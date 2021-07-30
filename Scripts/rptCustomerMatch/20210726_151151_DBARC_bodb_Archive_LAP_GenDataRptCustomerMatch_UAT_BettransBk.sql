/*<info serverAlias="DBARC-bodb_Archive"></info>*/
/*
	Created: 20210726@Kos
	DB: DBARC-bodb_Archive
	Task: Generate data for temp table rptCustomerMatch_UAT for testing - range bk [Redmine: #151151]
*/

USE bodb_Archive
GO

DECLARE
	@FromDate	SMALLDATETIME = '2021-06-01 00:00:00',
	@ToDate		SMALLDATETIME = '2021-07-15 00:00:00'

DECLARE @SportBettype TABLE(ProductId TINYINT, BetType SMALLINT, EventType TINYINT)

INSERT INTO @SportBettype
SELECT ProductID, BetType, EventType
FROM bodb02.dbo.f_SportBettypeMatrix_Sel (0, 0, 0, 2, '', '', 1)
WHERE ProductID IN (1, 3, 5, 25, 27)

DECLARE @Date SMALLDATETIME

SET @Date = @FromDate

WHILE @Date <= @ToDate
BEGIN
	PRINT 'Generate data for ' + CONVERT(VARCHAR(20), @Date, 100)

	DELETE FROM bodb_Report.dbo.rptCustomerMatch_UAT WITH (ROWLOCK)
	WHERE winlostdate = @Date

	DECLARE @HWHLCutDate SMALLDATETIME = '2019-10-01'	-- half won/ half lose cut date

	;WITH cte_bettrans AS (
		SELECT a.custid
			,a.recommend
			,a.matchid
			,a.oddsid
			,a.bettype
			,SUM(ABS(a.stake)) AS stake
			,SUM(a.winlost- a.actual_stake) AS winlost
			,a.odds
			,a.oddstype
			,CASE
				WHEN a.winlostdate >= @HWHLCutDate
					AND a.statusID IN (112, 113)
					AND a.modds IN (-0.25, 0.25)
					-- Sportsbook
					AND (a.bettype < 999
						OR a.bettype BETWEEN 1301 AND 1399
						OR a.bettype BETWEEN 9001 AND 9399
						OR a.bettype BETWEEN 9400 AND 9699)
					AND a.bettype NOT IN (29, 38, 911, 912, 913, 914)	-- Parlay, betbuilder, Cashout
					AND a.bettype NOT BETWEEN 81 AND 120
					THEN CASE WHEN a.statusID = 112 THEN 114 ELSE 115 END
				WHEN a.winlostdate < @HWHLCutDate
					AND a.statusID IN (112,113)
					AND a.bettype IN (1, 3, 7, 8, 17, 18, 124, 125, 482, 483, 484, 485)
					AND ABS(a.modds) = 0.25
					THEN CASE WHEN a.statusID = 112 THEN 114 ELSE 115 END
				ELSE a.statusID
			END AS statusID
			,a.winlostdate
			,COUNT(a.custid) AS betcount
			,CASE
				WHEN BA.transid IS NULL THEN 0
				WHEN BA.transid IS NOT NULL THEN 1
			END AS isBA
			,SUM(a.awinlost) AS awinlost
			,SUM(a.comm) AS comm
			,SUM(a.playercomm) AS playercomm
			,a.currency
			,a.liveindicator
		FROM dbo.bettrans_bk AS a WITH (NOLOCK, INDEX = CIX_winlostdate)
			INNER JOIN bodb_licensee.dbo.f_SelLicenseeCust(0) AS LC ON a.recommend = lc.custid AND a.currency = lc.currency
			INNER JOIN @SportBettype AS s ON s.BetType = a.bettype
			LEFT JOIN bodb_licensee.dbo.LicenseeBATransaction_bk AS BA WITH (NOLOCK) ON a.transid = ba.transid
		WHERE a.winlostdate = @Date
			AND a.statusID IN (111, 112, 113)
			AND a.bettype < 19999
			AND a.matchid >= 0
		GROUP BY a.custid
			,a.recommend
			,a.matchid
			,a.oddsid
			,a.bettype
			,a.odds
			,a.oddstype
			,CASE
				WHEN a.winlostdate >= @HWHLCutDate
					AND a.statusID IN (112, 113)
					AND a.modds IN (-0.25, 0.25)
					---- Sportsbook
					AND (a.bettype < 999
						OR a.bettype BETWEEN 1301 AND 1399
						OR a.bettype BETWEEN 9001 AND 9399
						OR a.bettype BETWEEN 9400 AND 9699)
					AND a.bettype NOT IN (29, 38, 911, 912, 913, 914)  --- Parlay, betbuilder, Cashout
					AND a.bettype NOT BETWEEN 81 AND 120
					THEN CASE WHEN a.statusID = 112 THEN 114 ELSE 115 END
				WHEN a.winlostdate < @HWHLCutDate
					AND a.statusID IN (112,113)
					AND a.bettype IN (1, 3, 7, 8, 17, 18, 124, 125, 482, 483, 484, 485)
					AND ABS(a.modds) = 0.25
					THEN CASE WHEN a.statusID = 112 THEN 114 ELSE 115 END
				ELSE a.statusID
			END
			,a.winlostdate
			,CASE
				WHEN BA.transid IS NULL THEN 0
				WHEN BA.transid IS NOT NULL THEN 1
			END
			,a.currency
			,a.liveindicator
		)
		,cte_raceinfo AS (
			SELECT o.Orid
				,r.LeagueID
			FROM dbo.VSOutright_bk AS o WITH (NOLOCK)
				INNER JOIN dbo.VSRaceInfo_bk AS r WITH (NOLOCK) ON r.EventID = o.EventID
			WHERE o.EventDate = @Date
		)
	INSERT INTO bodb_Report.dbo.rptCustomerMatch_UAT (
		custid
		,matchid
		,oddsid
		,LeagueID
		,bettype
		,Odds
		,oddstype
		,statusID
		,stake
		,winlost
		,winlostdate
		,awinlost
		,Comm
		,playercomm
		,recommend
		,isba
		,betcount
		,currency
		,LiveIndicator)
	SELECT a.custid
		,a.matchid
		,a.oddsid
		,CASE 
			WHEN a.bettype IN (9, 29) THEN -9
			WHEN a.bettype = 2799 THEN -2799
			WHEN a.bettype = 10 THEN ISNULL(ob.leagueid, -1)
			WHEN a.bettype IN (1231, 1232, 1233, 1237, 1238) THEN ISNULL(r.LeagueID,-1)
			ELSE ISNULL(b.LeagueID, -1)
			END LeagueID
		,a.bettype
		,a.odds
		,a.oddstype
		,a.statusID
		,SUM(a.stake) AS stake
		,SUM(a.winlost) AS winlost
		,a.winlostdate
		,SUM(a.awinlost) AS awinlost
		,SUM(a.comm) AS Comm
		,SUM(a.playercomm) AS playercomm
		,a.recommend
		,a.isba
		,SUM(a.betcount) AS betcount
		,a.currency
		,a.liveindicator
	FROM cte_bettrans AS a
		LEFT JOIN dbo.match_bk AS b WITH (NOLOCK) ON a.matchid = b.matchid
		LEFT JOIN cte_raceinfo AS r ON a.oddsid = r.Orid
		LEFT JOIN dbo.outright_bk AS ob WITH (NOLOCK) ON a.matchid = ob.orid
	GROUP BY a.custid
		,a.matchid
		,a.oddsid
		,a.bettype
		,a.odds
		,a.oddstype
		,a.statusID
		,a.winlostdate
		,a.recommend
		,a.isba
		,CASE 
			WHEN a.bettype IN (9, 29) THEN -9
			WHEN a.bettype = 2799 THEN -2799
			WHEN a.bettype = 10 THEN ISNULL(ob.leagueid, -1)
			WHEN a.bettype IN (1231, 1232, 1233, 1237, 1238) THEN ISNULL(r.LeagueID,-1)
			ELSE ISNULL(b.LeagueID, -1)
		END
		,a.currency
		,a.liveindicator

	SET @Date = DATEADD(DAY, 1, @Date)

	PRINT 'Done'

	WAITFOR DELAY '00:00:00.280'
END
GO