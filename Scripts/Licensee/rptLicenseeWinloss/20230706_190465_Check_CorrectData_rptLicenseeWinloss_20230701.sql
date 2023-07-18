/*<info serverAlias="DBLIC-bodb_LicenseeReport"></info>*/
/*
	Created: 20230718@Evan
	DB: DBLIC-bodb_LicenseeReport
	Task: Gen data table rptLicenseeWinloss on 2023-07-01 
	https://nexdev.net/issues/190465
	Run on DB053, DB052
*/
SET NOCOUNT ON;

DECLARE
	@winlostdate SMALLDATETIME = '2023-07-01'

	DECLARE @NASportType SMALLINT = 0;
		
	DROP TABLE IF EXISTS #tmpRptData;
	CREATE TABLE #tmpRptData (
		[Recommend] 		INT
		,[WinlostDate]		SMALLDATETIME
		,[Product3rdId]		TINYINT
		,[Sporttype]		SMALLINT
		,[Bettype]			SMALLINT
		,[CustId]			INT
		,[StatusId]			SMALLINT
		,[LiveIndicator]	TINYINT
		,[LeagueGroupId]	SMALLINT
		,[TicketType]		TINYINT
		,[Betfrom]			VARCHAR(4)
		,[APositiontaking]	SMALLMONEY
		,[BetCount]			INT
		,[Turnover]			MONEY
		,[NetTurnover]		MONEY
		,[Winlost]			MONEY
		,[AWinlost]			MONEY
		,[PComm]			MONEY
		,[AComm]			MONEY
	);
	CREATE CLUSTERED INDEX CIX_tmpRptData ON #tmpRptData(
		[CustId] 		
	   ,[Product3rdId]		
	   ,[Sporttype]			
	   ,[Bettype]
	);
	
	DROP TABLE IF EXISTS #tmpAgency 
	CREATE TABLE #tmpAgency(recommend INT PRIMARY KEY);
	
	INSERT INTO #tmpAgency (recommend)
	SELECT b.recommend
	FROM DBARC.[bodb_Archive].[dbo].[bettrans_bk]  b WITH(NOLOCK)
	INNER JOIN bodb02.dbo.Dep_CustSuper cs WITH(NOLOCK) on cs.custid = b.srecommend
	WHERE  b.winlostdate = @winlostdate
		AND b.statusID IN (111,112,113)
		AND recommend IN (932187,4359308,4833644,7508193,10580769,10580778,21475590,28680705,37973034,41173124,43558464,47778984,48508240,48984449,49368715,55217326,56506782,59874983,60347416,60717590,68033522,82034008)
	GROUP BY b.recommend;
  
	DROP TABLE IF EXISTS #tmpBettype;
	CREATE TABLE #tmpBettype(ProductId TINYINT, Bettype SMALLINT PRIMARY KEY, RefTable TINYINT, EventType TINYINT, Product3rdId TINYINT);

	WITH CTE_Product AS (
			SELECT 0 AS ProductID, p.ProductName, p.ProductPrefix AS ProductCode
			FROM bodb02.dbo.Products p WITH(NOLOCK) 
			WHERE p.ProductID = 1
			UNION ALL
			SELECT DISTINCT p3.ProductID, p3.ProductName, p3.ProductPrefix AS ProductCode
			FROM bodb_licensee.dbo.Product3rd p3 WITH(NOLOCK)
			WHERE p3.Enabled = 1
	)
	INSERT INTO #tmpBettype
	SELECT tbl.ProductId, tbl.Bettype, tbl.RefTable, tbl.EventType, tbl.Product3rdId
	FROM (
		SELECT DISTINCT p.ProductID, 
			p3.ProductID AS Product3rdID,
			m.BetType, 
			m.RefTable,
			m.EventType
		FROM CTE_Product p3 WITH(NOLOCK)
		INNER JOIN bodb02.dbo.Products p WITH(NOLOCK) ON p.ProductPrefix = p3.ProductCode
		INNER JOIN bodb02.dbo.SportBettypeMatrix m WITH(NOLOCK) ON m.ProductID = p.ProductID
	) AS tbl;
	
	
--	PRINT 'GEN >> bettransbk';

	WITH CTE_SabaSportRef AS (
	    SELECT t.SportType, t.LeagueGroupID
	    FROM bodb02.[dbo].[LAP_f_WinlossAnalysis_SabaSportSel] () AS saba
			OUTER APPLY
			(
			  SELECT Sporttype, LeagueGroupID
			  FROM OPENJSON(saba.SporttypeRef)
			  WITH (Sporttype INT '$.Sporttype', 
				LeagueGroupIDs NVARCHAR(MAX) '$.LeagueGroupID' AS JSON
			  )
			  OUTER APPLY OPENJSON(LeagueGroupIDs) WITH (LeagueGroupID INT '$')
			) AS t
		  )
	INSERT INTO #tmpRptData
	SELECT 
		b.Recommend,
		b.WinlostDate,
		CASE 
			WHEN s.ProductID = 1 AND ba.IsBA = 0 THEN 0
			WHEN s.ProductID = 1 AND ba.IsBA = 1 THEN 3 
			ELSE s.Product3rdID 
		END AS Product3rdId,
		ck.Sporttype,
		s.Bettype,
		b.CustId,
		b.StatusId,
		ck.LiveIndicator,
		ck.LeagueGroupId,
		ck.TicketType,
		b.Betfrom,
		b.APositiontaking
		----------------------
		,SUM(1) AS BetCount
		,SUM(ABS(ck.Turnover)) AS Turnover
		,SUM(ck.NetTurnover) AS NetTurnover
		,SUM(winlost-actual_stake) AS Winlost
		,SUM(b.awinlost) AS AWinlost
		,SUM(b.playercomm) AS [PComm]
		,SUM(b.comm) AS [AComm]
	FROM DBARC.[bodb_Archive].[dbo].[bettrans_bk] b WITH(NOLOCK)
		INNER JOIN #tmpAgency pl WITH(NOLOCK) on pl.recommend = b.recommend
		INNER JOIN #tmpBettype s ON s.BetType = b.bettype AND s.RefTable NOT IN (1,2)
		LEFT JOIN DBARC.[bodb_Archive].dbo.match_bk m WITH(NOLOCK) ON b.matchid = m.matchid
		LEFT JOIN DBARC.[bodb_Archive].[dbo].[Match3rd_bk] m3rd WITH(NOLOCK) ON m3rd.Match3rdId = b.matchid
		LEFT JOIN [bodb02].dbo.League l WITH(NOLOCK) ON m.leagueid = l.leagueid AND l.LeagueGroupID IN (42,74,108,113,122,151)
		LEFT JOIN DBARC.[bodb_Archive].dbo.outright_bk o WITH(NOLOCK) ON b.matchid = o.orid
		LEFT JOIN CTE_SabaSportRef sbf ON sbf.SportType = l.sporttype AND sbf.LeagueGroupID = l.LeagueGroupID
		LEFT JOIN DBARC.[bodb_Archive].dbo.VSRaceInfo_bk vs WITH(NOLOCK) ON b.matchid = vs.EventID
		LEFT JOIN [bodb_licensee].dbo.LicenseeBATransaction_bk AS lba WITH (NOLOCK) ON b.transid = lba.transid
		OUTER APPLY (
			SELECT 
				IIF(lba.TransID IS NOT NULL, 1, 0) AS IsBA
		) AS ba
		OUTER APPLY (
			SELECT 
				ABS(b.[stake]) AS Turnover,
				CASE
					WHEN s.RefTable IN (1,2) THEN 0 -- Gaming IN bettransRnG/bettransLC
					WHEN s.ProductID = 1 AND b.statusID IN (111) THEN 0
					WHEN s.ProductID = 1 AND b.statusID IN (112, 113) AND ABS(b.modds) = 0.25 THEN ABS(stake) / 2
					ELSE ABS(b.stake)
				END AS NetTurnover,
				CASE 
					WHEN s.EventType = 0 THEN
						CASE 
							WHEN b.matchid = 29 THEN -1		--Parlay Sport
							WHEN b.matchid = 2799 THEN ISNULL(b.oddsid, @NASportType)
							WHEN b.matchid = 999 THEN @NASportType	-- Odds Spread Adjustment
							WHEN b.matchid = 0 AND b.bettype = 1800 THEN 250	-- AG Casino 
							WHEN b.matchid = 0 AND b.bettype = 8000 THEN 221	-- Exchange
							ELSE ISNULL(b.matchid, @NASportType)
						END
					WHEN s.EventType = 1 THEN ISNULL(m.sporttype, @NASportType)
					WHEN s.EventType = 2 THEN ISNULL(l.sporttype, @NASportType)
					WHEN s.EventType = 3 THEN ISNULL(vs.SportType, @NASportType)
					WHEN s.EventType = 5 THEN ISNULL(m3rd.Sporttype, @NASportType)
					ELSE @NASportType
				END AS SportType,
				IIF(b.betdaqid <> -2, ISNULL(sbf.LeagueGroupID, 0), 0) AS LeagueGroupID, -- Saba Sports
				CASE
					WHEN s.ProductId = 1 AND s.EventType = 1 AND b.betdaqid = -2 THEN 1 -- Castout
					ELSE 0
				END AS TicketType,
				CASE
					WHEN 
						b.statusID IN (112, 113)
						AND ABS(b.modds) =0.25
						AND (b.bettype < 999
							OR b.bettype BETWEEN 1301 AND 1399
							OR b.bettype BETWEEN 9001 AND 9399
							OR b.bettype BETWEEN 9400 AND 9998
							OR b.bettype BETWEEN 3900 AND 3999)	-- Sportsbook
						AND b.bettype NOT IN (29, 38, 911, 912, 913, 914)  --- Parlay, betbuilder, Cashout
						AND b.bettype NOT BETWEEN 81 AND 120
						THEN CASE WHEN b.statusID = 112 THEN 114 ELSE 115 END
					WHEN 
						b.statusID IN (112, 113)
						AND b.bettype IN (1, 3, 7, 8, 17, 18, 124, 125, 482, 483, 484, 485)
						AND ABS(b.modds) = 0.25
						THEN CASE WHEN b.statusID = 112 THEN 114 ELSE 115 END
					ELSE b.statusID
				END AS statusID,
				ISNULL(CASE WHEN b.bettype IN(9,29) THEN b.livehomescore ELSE b.liveindicator END, 0) AS liveindicator
		) AS ck
		
	WHERE b.winlostdate = @winlostdate
		AND b.statusID IN (111,112,113)
		AND ck.Sporttype = 5	-- Tennis Sport
		--AND ck.LeagueGroupId = 42
	GROUP BY 
		b.Recommend,
		b.WinlostDate,
		CASE 
			WHEN s.ProductID = 1 AND ba.IsBA = 0 THEN 0
			WHEN s.ProductID = 1 AND ba.IsBA = 1 THEN 3 
			ELSE s.Product3rdID 
		END,
		ck.Sporttype,
		s.Bettype,
		b.CustId,
		b.StatusId,
		ck.LiveIndicator,
		ck.LeagueGroupId,
		ck.TicketType,
		b.Betfrom,
		b.APositiontaking

	IF EXISTS (SELECT TOP 1 1 FROM #tmpRptData)
	BEGIN
		
		-- TODO: DELETE the OLD rows
		DELETE rpt
		FROM [dbo].[rptLicenseeWinloss] rpt
			INNER JOIN #tmpAgency a ON a.Recommend = rpt.Recommend 
		WHERE rpt.WinlostDate = @winlostdate AND Sporttype = 5

		---- TODO: INSERT the NEW rows
		INSERT INTO [dbo].[rptLicenseeWinloss]
		          ([Recommend]
		          ,[WinlostDate]
		          ,[Product3rdId]
		          ,[Sporttype]
		          ,[Bettype]
		          ,[CustId]
		          ,[StatusId]
		          ,[LiveIndicator]
		          ,[LeagueGroupId]
		          ,[TicketType]
		          ,[Betfrom]
		          ,[APositiontaking]
		          ,[BetCount]
		          ,[Turnover]
		          ,[NetTurnover]
		          ,[Winlost]
		          ,[AWinlost]
		          ,[PComm]
		          ,[AComm]
			  )
		SELECT rpt.[Recommend]
				,[WinlostDate]
				,[Product3rdId]
				,[Sporttype]
				,[Bettype]
				,rpt.[CustId]
				,[StatusId]
				,[LiveIndicator]
				,[LeagueGroupId]
				,[TicketType]
				,[Betfrom]
				,[APositiontaking]
				,[BetCount]
				,[Turnover]
				,[NetTurnover]
				,[Winlost]
				,[AWinlost]
				,[PComm]
				,[AComm]
		FROM #tmpRptData rpt
		INNER JOIN #tmpAgency a ON a.Recommend = rpt.Recommend
	END

GO
