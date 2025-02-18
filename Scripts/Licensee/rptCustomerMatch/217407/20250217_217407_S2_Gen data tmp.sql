/*<info serverAlias="DBARC-bodb_Archive"></info>*/
/*
	Created: 20250217@Kelvin
	DB: DBARC-bodb_Archive
	Task: Task: Regen data on rptCustomerMatch [Redmine: #217407]
		S2: Regen data for staging table rptCustomerMatch_staging_217407
*/

DECLARE @BalanceUpDate	SMALLDATETIME,
		@WinLostDate	DATETIME = '2025-02-01'

DECLARE @MBBU TABLE (BalanceUpDay SMALLDATETIME, MoveBetsDay SMALLDATETIME)
INSERT INTO @MBBU (BalanceUpDay, MoveBetsDay)
EXEC bodb02.dbo.Age_SelBalanceUpDay

SELECT @BalanceUpDate = BalanceUpDay
FROM @MBBU

--SELECT * FROM @MBBU

WHILE @WinLostDate < @BalanceUpDate
BEGIN
	PRINT 'Generate data for ' + CONVERT(VARCHAR(20), @WinLostDate, 101)

	DELETE FROM bodb_Report.dbo.rptCustomerMatch_staging_217407
	WHERE winlostdate = @WinLostDate

	;WITH cte_SportBettype AS
		(
			SELECT ProductID, BetType, EventType
			FROM bodb02.dbo.f_SportBettypeMatrix_Sel (0, 0, 0, 2, '', '', 1)
			WHERE ProductID IN (5, 27, 77, 83, 88, 71 -- VS product
								)
		)
		,cte_bettrans AS (
		SELECT a.custid
			,a.recommend
			,a.matchid
			,a.oddsid
			,a.bettype
			,SUM(ABS(a.stake)) AS stake
			,SUM(a.winlost - a.actual_stake) AS winlost
			,a.odds
			,a.oddstype
			,a.statusID
			,a.winlostdate
			,COUNT(a.custid) AS betcount
			,0 AS isBA
			,SUM(a.awinlost) AS awinlost
			,SUM(a.comm) AS comm
			,SUM(a.playercomm) AS playercomm
			,a.currency
			,a.liveindicator
			,NULL AS TicketType
			,s.EventType
		FROM dbo.bettrans_bk AS a WITH (NOLOCK)
			INNER JOIN bodb_licensee.dbo.f_SelLicenseeCust(0) AS LC ON a.recommend = lc.custid AND a.currency = lc.currency
			INNER JOIN cte_SportBettype AS s ON s.BetType = a.bettype
		WHERE a.winlostdate = @WinLostDate
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
			,a.statusID
			,a.winlostdate
			,a.currency
			,a.liveindicator
			,s.EventType
		)
		,cte_raceinfo AS
		(
			SELECT o.Orid
				,r.LeagueID
			FROM dbo.VSOutright_bk AS o WITH (NOLOCK)
				INNER JOIN dbo.VSRaceInfo_bk AS r WITH (NOLOCK) ON r.EventID = o.EventID
			WHERE o.EventDate = @WinLostDate
		)		
		INSERT INTO bodb_Report.dbo.rptCustomerMatch_staging_217407 (
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
			,comm
			,playercomm
			,recommend
			,isba
			,betcount
			,currency
			,LiveIndicator
			,TicketType
			)
		SELECT a.CustID
			,a.matchid
			,a.oddsid
			,CASE WHEN a.EventType = 0 THEN
					CASE
						WHEN a.bettype IN (2799, 10449, 11099) THEN -(a.bettype)
						ELSE -1
					END
				WHEN a.EventType = 1 THEN ISNULL(b.LeagueID, -1)
				WHEN a.EventType = 3 THEN ISNULL(r.LeagueID, -1)
				WHEN a.EventType = 5 THEN ISNULL(b3rd.League3rdId, -1)
				ELSE -1
			 END LeagueID
			,a.bettype
			,a.odds
			,a.oddstype
			,a.statusID
			,SUM(a.stake) AS stake
			,SUM(winlost) AS winlost
			,a.winlostdate
			,SUM(a.awinlost) AS awinlost
			,SUM(a.comm) AS Comm
			,SUM(a.playercomm) AS playercomm
			,a.recommend
			,a.isba
			,SUM(a.betcount) AS betcount
			,a.currency
			,a.liveindicator
			,a.TicketType
		FROM cte_bettrans AS a
			LEFT JOIN dbo.match_bk AS b WITH (NOLOCK) ON a.matchid = b.matchid
			LEFT JOIN cte_raceinfo AS r ON a.oddsid = r.Orid
			LEFT JOIN dbo.Match3rd_bk AS b3rd WITH (NOLOCK) ON a.matchid = b3rd.match3rdId
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
			,CASE WHEN a.EventType = 0 THEN
					CASE
						WHEN a.bettype IN (2799, 10449, 11099) THEN -(a.bettype)
						ELSE -1
					END
				WHEN a.EventType = 1 THEN ISNULL(b.LeagueID, -1)
				WHEN a.EventType = 3 THEN ISNULL(r.LeagueID, -1)
				WHEN a.EventType = 5 THEN ISNULL(b3rd.League3rdId, -1)
				ELSE -1
			 END
			,a.currency
			,a.liveindicator
			,a.TicketType

	SET @WinLostDate = DATEADD(D,1,@WinLostDate)

	WAITFOR DELAY '00:00:00.280'
END


