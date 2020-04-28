USE bodb_Report
GO

DECLARE @winlostdate SMALLDATETIME = '2020-04-16' 

/*
	Created: 20200427@Percy
	DB: DBRPT.bodb_Report
	Task: rptWinlost - Correct data on bettrans_bk range
*/

BEGIN	
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

	-- bettrans_bk
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
			b.matchid
			,b.bettype
			,b.liveindicator
			,CASE
				WHEN StatusID = 111 THEN 'DRAW'
				WHEN StatusID = 112 THEN 'WON'
				WHEN StatusID = 113 THEN 'LOSE'
				END AS Status
			,0 AS IBC
			,SUM((1-tpositiontaking) * stake * actualrate)			AS realturnover
			,SUM((winlost-actual_stake) * actualrate)				AS realWinlost
			,SUM((awinlost+mwinlost+swinlost) * actualrate)			AS realPos
			,SUM(scomm * actualrate)								AS realComm
			,SUM((winlost-actual_stake+awinlost+mwinlost+swinlost+scomm) * actualrate)	AS realLineTotal
			,SUM((1-tpositiontaking) * stake * virtualrate)			AS virtualTurnover
			,SUM((winlost-actual_stake+awinlost+mwinlost+swinlost+scomm) * virtualrate) AS virtualLineTotal
			,222 AS SportType
			,0 AS exrisk
		FROM bodb_Archive.dbo.bettrans_bk b WITH (NOLOCK)
		WHERE b.winlostdate = @winlostdate
			AND b.statusID IN (111, 112, 113)
			AND b.currency <> 20
			AND b.bettype BETWEEN 4901 AND 4999 -- Table Game
		GROUP BY
			b.matchid
			,b.bettype
			,b.liveindicator
			,CASE
				WHEN StatusID = 111 THEN 'DRAW'
				WHEN StatusID = 112 THEN 'WON'
				WHEN StatusID = 113 THEN 'LOSE'
				END
	END

	-- Compare data
	BEGIN
		CREATE TABLE #tmpResult
		(
			ModifiedType		INT
			,matchid			INT
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
				AND SportType = 222 -- Table Game
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

	DROP TABLE #tmpResult
	DROP TABLE #tmpRptWinlost
END