USE bodb_Report
GO

DECLARE @winlostdate SMALLDATETIME = '2020-04-16' 

/*
	Created: 20200427@Percy
	DB: DBRPT.bodb_Report
	Task: rptWinlost - Correct data on bettrans_bk range
*/

BEGIN	
	DECLARE @BalanceUpDay SMALLDATETIME
	SELECT  @BalanceUpDay = winlostdate FROM bodb02.dbo.bettrans WITH (NOLOCK) WHERE bettype = 20000 AND matchid = 0 AND custid = 3 
	
	IF @winlostdate >= @BalanceUpDay
	BEGIN
		PRINT 'Invalid winlostdate!'
		RETURN
	END

	-- Data source
	BEGIN
		CREATE TABLE #tmpRptWinlost
		(
			matchid				INT
			,bettype			SMALLINT
			,liveindicator		BIT
			,Status				NVARCHAR(10)
			,IBC				TINYINT
			,RealTurnover		MONEY
			,RealWinLost		MONEY
			,RealPosition		MONEY
			,RealCommission		MONEY
			,RealLineTotal		MONEY
			,VirtualTurnover	MONEY
			,VirtualLineTotal	MONEY
			,SportType			SMALLINT
			,exrisk				SMALLMONEY
		)
	END

	-- SportBettypeMatrix
	BEGIN
		CREATE TABLE #SportBettype (ProductID INT, Bettype SMALLINT, EventType INT, SubProduct VARCHAR(500), RefTable TINYINT, SportType INT) -- Sporttype is used for products which have not matchid
		INSERT INTO #SportBettype (ProductID, Bettype, EventType, SubProduct, RefTable, SportType)
		SELECT ProductID, Bettype, EventType, SubProduct, RefTable, 0 AS SportType
		FROM bodb02.dbo.f_SportBettypeMatrix_Sel(0, 0, 0, 2, '', '', 0)		
	END
	
	-- 1. bettrans
	BEGIN
		-- For VS Parlay (bettype = 2799)
		CREATE TABLE #tmpRefno (refno BIGINT, matchid INT)
		INSERT INTO #tmpRefno (refno, matchid)
		SELECT b.refno, MIN (bm.matchid) AS matchid
		FROM bodb_Archive.dbo.bettrans_bk b WITH (NOLOCK)
			INNER JOIN bodb_Archive.dbo.bettransm bm WITH (NOLOCK) ON b.refno = bm.refno
		WHERE b.bettype = 2799
			AND b.winlostdate = @winlostdate
			AND b.statusID IN (111, 112, 113)
		GROUP BY b.refno

		INSERT INTO #tmpRptWinlost
		(
			matchid
			,bettype
			,liveindicator
			,Status
			,IBC
			,RealTurnover
			,RealWinLost
			,RealPosition
			,RealCommission
			,RealLineTotal
			,VirtualTurnover
			,VirtualLineTotal
			,SportType
			,exrisk
		)
		SELECT
			CASE WHEN b.bettype = 2799 THEN r.matchid ELSE b.matchid END
			,b.bettype
			,b.liveindicator
			,CASE
				WHEN StatusID = 111 THEN 'DRAW'
				WHEN StatusID = 112 THEN 'WON'
				WHEN StatusID = 113 THEN 'LOSE'
				END AS Status
			,CASE
				WHEN sb.ProductID <> 1 THEN 0
				WHEN recommend = 52466 THEN 1
				WHEN recommend = 5707545 THEN 2
				ELSE 0
				END AS IBC
			,SUM((1-tpositiontaking) * actualrate
				*
				CASE
					WHEN sb.ProductID = 33 THEN 0 -- Poker Games
					WHEN sb.ProductID = 1 THEN ABS(stake)
					ELSE stake
					END
				) AS realturnover
			,SUM((winlost-actual_stake) * actualrate)				AS realWinlost
			,SUM((awinlost+mwinlost+swinlost) * actualrate)			AS realPos
			,SUM(scomm * actualrate)								AS realComm
			,SUM((winlost-actual_stake+awinlost+mwinlost+swinlost+scomm) * actualrate)	AS realLineTotal
			,SUM((1-tpositiontaking) * virtualrate
				*
				CASE
					WHEN sb.ProductID = 33 THEN 0 -- Poker Games
					WHEN sb.ProductID = 1 THEN ABS(stake)
					ELSE stake
					END
				) AS virtualTurnover
			,SUM((winlost-actual_stake+awinlost+mwinlost+swinlost+scomm) * virtualrate) AS virtualLineTotal
			,0 AS SportType
			,CASE
				WHEN b.bettype = 18000 AND b.currency2 = 1 THEN 1
				WHEN b.bettype = 29 AND betteam = N'1' THEN 1
				ELSE 0
				END AS exrisk
		FROM bodb_Archive.dbo.bettrans_bk b WITH (NOLOCK)
			INNER JOIN #SportBettype sb on b.bettype = sb.Bettype AND sb.RefTable IN (0, 3)
			LEFT JOIN #tmpRefno r ON b.refno = r.refno AND b.bettype = 2799
		WHERE b.winlostdate = @winlostdate
			AND b.statusID IN (111,112,113) --(/Won/lose/Draw)
			AND b.currency <> 20
		GROUP BY
			CASE WHEN b.bettype = 2799 THEN r.matchid ELSE b.matchid END
			,b.bettype
			,b.liveindicator
			,CASE
				WHEN StatusID = 111 THEN 'DRAW'
				WHEN StatusID = 112 THEN 'WON'
				WHEN StatusID = 113 THEN 'LOSE'
				END
			,CASE
				WHEN sb.ProductID <> 1 THEN 0
				WHEN recommend = 52466 THEN 1
				WHEN recommend = 5707545 THEN 2
				ELSE 0
				END
			,CASE
				WHEN b.bettype = 18000 AND b.currency2 = 1 THEN 1
				WHEN b.bettype = 29 AND betteam = N'1' THEN 1
				ELSE 0
				END
	END

	-- 2. bettransRnG
	BEGIN
		CREATE TABLE #PrizeBettypeGroup (Bettype SMALLINT)
		INSERT INTO #PrizeBettypeGroup (Bettype)
		SELECT Bettype FROM DBWH.bodb_Account.dbo.BettypeGroup WITH (NOLOCK) WHERE BettypeGroupID = 6

		INSERT INTO #tmpRptWinlost
		(
			matchid
			,bettype
			,liveindicator
			,Status
			,IBC
			,RealTurnover
			,RealWinLost
			,RealPosition
			,RealCommission
			,RealLineTotal
			,VirtualTurnover
			,VirtualLineTotal
			,SportType
			,exrisk
		)
		SELECT
			0 AS matchid
			,b.gameID
			,0 AS liveindicator
			,CASE
				WHEN StatusID = 111 THEN 'DRAW'
				WHEN StatusID = 112 THEN 'WON'
				WHEN StatusID = 113 THEN 'LOSE'
				END AS Status
			,0 AS IBC
			,SUM((1-tpositiontaking) * stake *actualrate) AS realturnover
			,SUM((winlost-actual_stake) * actualrate)				AS realWinlost
			,SUM((awinlost+mwinlost+swinlost) * actualrate)			AS realPos
			,SUM(scomm * actualrate)								AS realComm
			,SUM((CASE
					WHEN bg.Bettype IS NOT NULL THEN 0
					WHEN sb.Bettype IN (2198, 2398, 2998) THEN (b.ContributionRate * b.BetStake) + awinlost + mwinlost + swinlost + scomm
				    ELSE winlost - actual_stake + awinlost + mwinlost + swinlost + scomm
					END) * actualrate) AS realLineTotal
			,SUM((1-tpositiontaking) * stake * virtualrate) AS virtualTurnover
			,SUM((CASE
					WHEN bg.Bettype IS NOT NULL THEN 0
					WHEN sb.Bettype IN (2198, 2398, 2998) THEN (b.ContributionRate * b.BetStake) + awinlost + mwinlost + swinlost + scomm
				    ELSE winlost - actual_stake + awinlost + mwinlost + swinlost + scomm
					END) * virtualrate) AS virtualLineTotal
			,0 AS SportType
			,0 AS exrisk
		FROM bodb_Archive.dbo.bettransRnG_bk b WITH (NOLOCK)
			INNER JOIN #SportBettype sb ON b.gameID = sb.Bettype AND sb.RefTable = 1
			LEFT JOIN #PrizeBettypeGroup bg ON b.gameID = bg.Bettype
		WHERE winlostdate = @winlostdate
			AND b.statusID IN (111, 112, 113)
			AND b.currency <> 20
		GROUP BY
			b.gameID
			,CASE
				WHEN StatusID = 111 THEN 'DRAW'
				WHEN StatusID = 112 THEN 'WON'
				WHEN StatusID = 113 THEN 'LOSE'
				END
	END

	-- 3. bettransLC
	BEGIN
		INSERT INTO #tmpRptWinlost
		(
			matchid
			,bettype
			,liveindicator
			,Status
			,IBC
			,RealTurnover
			,RealWinLost
			,RealPosition
			,RealCommission
			,RealLineTotal
			,VirtualTurnover
			,VirtualLineTotal
			,SportType
			,exrisk
		)
		SELECT
			b.productID
			,b.gameID
			,0 AS liveindicator
			,CASE
				WHEN StatusID = 111 THEN 'DRAW'
				WHEN StatusID = 112 THEN 'WON'
				WHEN StatusID = 113 THEN 'LOSE'
				END AS Status
			,0 AS IBC
			,SUM((1-tpositiontaking) * stake * actualrate)	AS realturnover
			,SUM((winlost-actual_stake) * actualrate)		AS realWinlost
			,SUM((awinlost+mwinlost+swinlost) * actualrate) AS realPos
			,SUM((scomm) * actualrate)						AS realComm
			,SUM((winlost-actual_stake+awinlost+mwinlost+swinlost+scomm) * actualrate)	AS realLineTotal
			,SUM((1-tpositiontaking) * stake * virtualrate) AS virtualTurnover
			,SUM((winlost-actual_stake+awinlost+mwinlost+swinlost+scomm) * virtualrate) AS virtualLineTotal
			,211 AS SportType
			,0 AS exrisk
		FROM bodb_Archive.dbo.bettransLC_bk b WITH (NOLOCK)
			INNER JOIN #SportBettype sb ON b.gameID = sb.Bettype AND sb.RefTable = 2
		WHERE b.winlostdate = @winlostdate
			AND b.statusID IN (111, 112, 113)
			AND b.currency <> 20
		GROUP BY
			b.productID
			,b.gameID
			,CASE
				WHEN StatusID = 111 THEN 'DRAW'
				WHEN StatusID = 112 THEN 'WON'
				WHEN StatusID = 113 THEN 'LOSE'
				END
	END

	-- Update Sport
	BEGIN
		-- match
		UPDATE r
		SET r.SportType = CASE
							WHEN leaguename LIKE '%NFL%' AND l.sporttype = 2 THEN 3
							WHEN (leaguename LIKE '%NHL%' OR leaguename LIKE '%hockey%') AND l.sporttype = 2 THEN 4
							ELSE l.sporttype END
			,r.exrisk = m.exrisk
			,r.matchid = CASE WHEN r.bettype = 2799 THEN 0 ELSE r.matchid END
		FROM #tmpRptWinlost r
			INNER JOIN bodb_Archive.dbo.match_bk m WITH (NOLOCK) ON r.matchid = m.matchid
			INNER JOIN bodb02.dbo.league l WITH (NOLOCK) ON m.leagueid = l.leagueid
		WHERE bettype IN (SELECT bettype FROM bodb02.dbo.SportBettypeMatrix (NOLOCK) WHERE EventType <> 5)
			AND m.eventdate = @winlostdate

		-- outrigh
		UPDATE r
		SET r.SportType = CASE
							WHEN leaguename LIKE '%NFL%' AND l.sporttype = 2 THEN 3
							WHEN (leaguename LIKE '%NHL%' OR leaguename LIKE '%hockey%') AND l.sporttype = 2 THEN 4
							ELSE l.sporttype END
		FROM #tmpRptWinlost r
			INNER JOIN bodb_Archive.dbo.outright_bk o WITH (NOLOCK) ON r.matchid = o.orid
			INNER JOIN bodb02.dbo.league l WITH (NOLOCK) ON o.leagueid = l.leagueid
		WHERE bettype IN (SELECT bettype FROM bodb02.dbo.SportBettypeMatrix (NOLOCK) WHERE EventType = 2)

		-- VSOutright
		UPDATE r
		SET r.SportType = v.SportType
		FROM #tmpRptWinlost r
			INNER JOIN bodb02.dbo.VSRaceInfo v WITH (NOLOCK) ON r.matchid = v.EventID
		WHERE bettype IN (SELECT bettype FROM bodb02.dbo.SportBettypeMatrix (NOLOCK) WHERE EventType = 3)

		-- NG2, Exchange, Pragmatic, Poker Games
		UPDATE sb
		SET sb.SportType = s.SportType
		FROM #SportBettype sb
			 INNER JOIN bodb02.dbo.SportBettypeMatrix s WITH (NOLOCK)
				ON sb.BetType = s.BetType
					AND s.ProductID IN (23, 31, 32, 33, 34, 37, 36, 38, 39, 42, 43, 45, 40, 47)
		
		UPDATE r
		SET r.SportType = sb.SportType
		FROM #tmpRptWinlost r
			INNER JOIN #SportBettype sb ON r.bettype = sb.Bettype
		WHERE sb.SportType > 0
	END

	-- Compare data
	BEGIN
		CREATE TABLE #tmpResult
		(
			ModifiedType		INT
			,matchid			INT
			,bettype			SMALLINT
			,liveindicator		BIT
			,Status				NVARCHAR
			,IBC				TINYINT
			,RealTurnover		MONEY
			,RealWinLost		MONEY
			,RealPosition		MONEY
			,RealCommission		MONEY
			,RealLineTotal		MONEY
			,VirtualTurnover	MONEY
			,VirtualLineTotal	MONEY
			,SportType			SMALLINT
			,exrisk				SMALLMONEY
		)

		;WITH CTE_Target AS
		(
			SELECT
				matchid,bettype,liveindicator,Status,IBC,SportType,exrisk
				,SUM(RealTurnover) RealTurnover
				,SUM(RealWinLost) RealWinLost
				,SUM(RealPosition) RealPosition
				,SUM(RealCommission) RealCommission
				,SUM(RealLineTotal) RealLineTotal
				,SUM(VirtualTurnover) VirtualTurnover
				,SUM(VirtualLineTotal) VirtualLineTotal
			FROM dbo.rptWinLost WITH (NOLOCK)
			WHERE winlostdate = @winlostdate
			GROUP BY matchid,bettype,liveindicator,Status,IBC,SportType,exrisk
		)
		, CTE_Source AS
		(
			SELECT
				matchid,bettype,liveindicator,Status,IBC,SportType,exrisk
				,SUM(RealTurnover) RealTurnover
				,SUM(RealWinLost) RealWinLost
				,SUM(RealPosition) RealPosition
				,SUM(RealCommission) RealCommission
				,SUM(RealLineTotal) RealLineTotal
				,SUM(VirtualTurnover) VirtualTurnover
				,SUM(VirtualLineTotal) VirtualLineTotal
			FROM #tmpRptWinlost
		GROUP BY matchid,bettype,liveindicator,Status,IBC,SportType,exrisk
		)
		INSERT INTO #tmpResult
		(
			ModifiedType
			,matchid
			,bettype
			,liveindicator
			,Status
			,IBC
			,RealTurnover
			,RealWinLost
			,RealPosition
			,RealCommission
			,RealLineTotal
			,VirtualTurnover
			,VirtualLineTotal
			,SportType
			,exrisk
		)
		SELECT
			CASE
				WHEN s.SportType IS NULL THEN -1 -- delete
				WHEN t.SportType IS NULL THEN 1 -- insert
				ELSE 0 -- update
				END AS ModifiedType
			,ISNULL(s.matchid, t.matchid)
			,ISNULL(s.bettype, t.bettype)
			,ISNULL(s.liveindicator, t.liveindicator)
			,ISNULL(s.Status, t.Status)
			,ISNULL(s.IBC, t.IBC)
			,ISNULL(s.RealTurnover, 0)
			,ISNULL(s.RealWinLost, 0)
			,ISNULL(s.RealPosition, 0)
			,ISNULL(s.RealCommission, 0)
			,ISNULL(s.RealLineTotal, 0)
			,ISNULL(s.VirtualTurnover, 0)
			,ISNULL(s.VirtualLineTotal, 0)
			,ISNULL(s.SportType, t.SportType)
			,ISNULL(s.exrisk, t.exrisk)
		FROM CTE_Target t
			FULL OUTER JOIN CTE_Source s
				ON s.SportType = t.SportType
					AND s.bettype = t.bettype
					AND s.liveindicator = t.liveindicator
					AND s.Status = t.Status
					AND s.exrisk = t.exrisk
					AND s.matchid = t.matchid
					AND s.IBC = t.IBC
		WHERE (s.SportType IS NULL
			OR t.SportType IS NULL
			OR ROUND(ABS(ISNULL(s.RealTurnover, 0) - ISNULL(t.RealTurnover, 0)),2) > 0.0
			OR ROUND(ABS(ISNULL(s.RealWinLost, 0) - ISNULL(t.RealWinLost, 0)),2) > 0.0
			OR ROUND(ABS(ISNULL(s.RealPosition, 0) - ISNULL(t.RealPosition, 0)),2) > 0.0
			OR ROUND(ABS(ISNULL(s.RealCommission, 0) - ISNULL(t.RealCommission, 0)),2) > 0.0
			OR ROUND(ABS(ISNULL(s.RealLineTotal, 0) - ISNULL(t.RealLineTotal, 0)),2) > 0.0
			OR ROUND(ABS(ISNULL(s.VirtualTurnover, 0) - ISNULL(t.VirtualTurnover, 0)),2) > 0.0
			OR ROUND(ABS(ISNULL(s.VirtualLineTotal, 0) - ISNULL(t.VirtualLineTotal, 0)),2) > 0.0
			)
	END

	-- Regen data
	BEGIN
		IF EXISTS (SELECT 1 FROM #tmpResult WHERE ModifiedType = -1)
			DELETE r WITH (NOLOCK, UPDLOCK)
			FROM dbo.rptWinLost r
				INNER JOIN #tmpResult t
					ON r.winlostdate = @WinlostDate
						AND r.SportType = t.SportType
						AND r.bettype = t.bettype
						AND r.liveindicator = t.liveindicator
						AND r.Status = t.Status
						AND r.exrisk = t.exrisk
						AND r.matchid = t.matchid
						AND r.IBC = t.IBC
			WHERE t.ModifiedType = -1

		IF EXISTS (SELECT 1 FROM #tmpResult WHERE ModifiedType = 0)
			UPDATE r WITH (ROWLOCK)
			SET r.RealTurnover = t.RealTurnover
				,r.RealWinLost = t.RealWinLost
				,r.RealPosition = t.RealPosition
				,r.RealCommission = t.RealCommission
				,r.RealLineTotal = t.RealLineTotal
				,r.VirtualTurnover = t.VirtualTurnover
				,r.VirtualLineTotal = t.VirtualLineTotal
			FROM dbo.rptWinLost r
				INNER JOIN #tmpResult t
					ON r.winlostdate = @WinlostDate
						AND r.SportType = t.SportType
						AND r.bettype = t.bettype
						AND r.liveindicator = t.liveindicator
						AND r.Status = t.Status
						AND r.exrisk = t.exrisk
						AND r.matchid = t.matchid
						AND r.IBC = t.IBC
			WHERE t.ModifiedType = 0

		IF EXISTS (SELECT 1 FROM #tmpResult WHERE ModifiedType = 1)
			INSERT INTO dbo.rptWinLost
			(
				winlostdate,matchid,bettype,liveindicator,Status,IBC,RealTurnover,RealWinLost,RealPosition
				,RealCommission,RealLineTotal,VirtualTurnover,VirtualLineTotal,SportType,exrisk
			)
			SELECT
				@winlostdate,matchid,bettype,liveindicator,Status,IBC,RealTurnover,RealWinLost,RealPosition
				,RealCommission,RealLineTotal,VirtualTurnover,VirtualLineTotal,SportType,exrisk
			FROM #tmpResult
			WHERE ModifiedType = 1
	END

	DROP TABLE #PrizeBettypeGroup
	DROP TABLE #SportBettype
	DROP TABLE #tmpRefno
	DROP TABLE #tmpResult
	DROP TABLE #tmpRptWinlost
END