DECLARE @winlostdate DATETIME

CREATE TABLE #__SuperExtraPT(productId INT, bettypePT INT, SuperId INT, ExtraPT MONEY)
CREATE CLUSTERED INDEX CIX_#__SuperExtraPT ON #__SuperExtraPT(SuperId, bettypePT)

;WITH rs AS 
(
	SELECT DISTINCT b.bettype , b.srecommend
	FROM bettrans14 b WITH(NOLOCK) 
	WHERE 
		b.winlostdate = @winlostdate
		AND b.statusID NOT IN (0, 1, 102, 101, 103)
		AND b.bettype <= 19000
)
INSERT INTO #__SuperExtraPT (productId, bettypePT, SuperId, ExtraPT)
SELECT tbl.ProductID, b.bettype , b.srecommend , T.ExtraPT
FROM rs b 
	CROSS APPLY 
	(
		SELECT DISTINCT
			tbl.ProductID
		FROM f_SportBettypeMatrix_Sel(0, 0, b.bettype, 2, '', '', 0) tbl
		WHERE b.bettype = tbl.bettype
	) tbl
	OUTER APPLY 
	(
		SELECT DISTINCT expt2.SuperId, expt2.ExtraPT
		FROM CustDB.dbo.Acc_GroupExtraPT2Setting expt2 WITH (NOLOCK)
		WHERE @winlostdate BETWEEN expt2.FromDate AND expt2.ToDate
				AND tbl.ProductID = expt2.ProductID
				AND b.srecommend = expt2.SuperId 
				AND ISNULL(expt2.SubProduct,'') = ''
				AND expt2.Sporttype = 0
	) t

---- Member
INSERT INTO sum_winloss_tmp
(
	winlostdate, roleid, custid, recommend, mrecommend, srecommend, turnover, winlost, awinlost, mwinlost, swinlost,
	playercomm, comm, acomm, scomm, betcount, grosscomm, Sporttype, bettype, netTurnover, TunroverNoDraw, ExtraWinloss, ExtraComm
)
SELECT
	@winlostdate
   ,1
   ,bettrans.custid
   ,bettrans.recommend
   ,bettrans.mrecommend
   ,bettrans.srecommend
   ,SUM(ABS(stake)) TurnOver
   ,SUM(winlost - actual_stake) winlost
   ,SUM(awinlost) awinlost
   ,SUM(mwinlost) mwinlost
   ,SUM(ISNULL(swinlost, 0)) swinlost
   ,SUM(playercomm) playercomm
   ,SUM(comm) comm
   ,SUM(acomm) acomm
   ,SUM(ISNULL(scomm, 0)) scomm
   ,COUNT(1) BetCount
   ,SUM(CASE
		WHEN apositiontaking = 1 THEN 0
		ELSE ISNULL(comm / (1 - apositiontaking), 0)
	END) grosscomm
   ,248 AS Sporttype
   ,CASE
		WHEN bettype IN (4297, 4298) THEN bettype
		ELSE 0
	END bettype
   ,0 AS netTurnover
   ,SUM(ABS(stake)) AS TurnoverNoDraw,
	-1 * SUM(
				CASE
					-- Jackpot
					WHEN bettrans.bettype IN (4297) THEN
						CASE WHEN bettrans.tpositiontaking = 1 THEN 0 ELSE ISNULL(bettrans.betid/CONVERT(DECIMAL(19,8), 100000000), 0) END
					WHEN bettrans.bettype IN (4298) THEN 0
					ELSE CASE WHEN bettrans.tpositiontaking = 1 THEN 0 ELSE bettrans.winlost - bettrans.actual_stake END
				END
				* CASE WHEN tbl.ExtraPT IS NOT NULL THEN tbl.ExtraPT
						ELSE ISNULL(bettrans.epositiontaking, 0)
					END
		) AS ExtraWinloss,
	-1 * SUM(CASE WHEN bettrans.tpositiontaking = 1 THEN 0 
			ELSE bettrans.scomm / (1 - bettrans.tpositiontaking)
			END * CASE WHEN tbl.ExtraPT IS NOT NULL THEN tbl.ExtraPT ELSE ISNULL(bettrans.epositiontaking, 0) END		
		) AS ExtraComm
FROM dbo.bettrans14 bettrans WITH (NOLOCK)
		INNER JOIN #__SuperExtraPT tbl 
			ON bettrans.srecommend = tbl.SuperId
				AND bettrans.bettype = tbl.bettypePT
WHERE 
	bettrans.winlostdate = @winlostdate
	AND bettrans.statusID  NOT IN (0, 1, 102, 101, 103)
	AND bettrans.bettype BETWEEN 4101 AND 4300 
GROUP BY bettrans.custid
		,bettrans.recommend
		,bettrans.mrecommend
		,bettrans.srecommend
		,CASE
			 WHEN bettype IN (4298, 4297) THEN bettype
			 ELSE 0
		 END

---- Agent
INSERT INTO sum_winloss_tmp
(
	winlostdate, roleid, custid, recommend, mrecommend, srecommend, turnover, winlost, awinlost, mwinlost, swinlost,
	playercomm, comm, acomm, scomm, BetCount, grosscomm, sporttype, bettype, netTurnover, TunroverNoDraw, ExtraWinloss, ExtraComm
)
SELECT
	@winlostdate
   ,2
   ,bettrans.recommend
   ,bettrans.recommend
   ,bettrans.mrecommend
   ,bettrans.srecommend
   ,SUM(ABS(stake)) TurnOver
   ,SUM(winlost - actual_stake) winlost
   ,SUM(awinlost) awinlost
   ,SUM(mwinlost) mwinlost
   ,SUM(ISNULL(swinlost, 0)) swinlost
   ,SUM(playercomm) playercomm
   ,SUM(comm) comm
   ,SUM(acomm) acomm
   ,SUM(ISNULL(scomm, 0)) scomm
   ,COUNT(1) BetCount
   ,SUM(CASE
		WHEN apositiontaking + mpositiontaking = 1 THEN 0
		ELSE ISNULL(acomm / (1 - apositiontaking - mpositiontaking), 0)
	END) grosscomm
   ,248 sporttype
   ,CASE
		WHEN bettype IN (4298, 4297) THEN bettype
		ELSE 0
	END bettype
   ,SUM(ABS(stake * apositiontaking)) AS netTurnover
   ,SUM(ABS(stake)) AS TurnoverNoDraw,
	-1 * SUM(
				CASE
					-- Jackpot
					WHEN bettrans.bettype IN (4297) THEN
						CASE WHEN bettrans.tpositiontaking = 1 THEN 0 ELSE ISNULL(bettrans.betid/CONVERT(DECIMAL(19,8), 100000000), 0) END
					WHEN bettrans.bettype IN (4298) THEN 0
					ELSE CASE WHEN bettrans.tpositiontaking = 1 THEN 0 ELSE bettrans.winlost - bettrans.actual_stake END
				END
				* CASE WHEN tbl.ExtraPT IS NOT NULL THEN tbl.ExtraPT
						ELSE ISNULL(bettrans.epositiontaking, 0)
					END
		) AS ExtraWinloss,
	-1 * SUM(CASE 
				WHEN bettrans.bettype IN (4297, 4298) THEN 0
				ELSE 
					CASE 
						WHEN bettrans.tpositiontaking = 1 THEN 0 
						ELSE bettrans.scomm / (1 - bettrans.tpositiontaking)
					END * CASE WHEN tbl.ExtraPT IS NOT NULL THEN tbl.ExtraPT ELSE ISNULL(bettrans.epositiontaking, 0) END
			END
		) AS ExtraComm
FROM dbo.bettrans14 bettrans WITH (NOLOCK)
		INNER JOIN #__SuperExtraPT tbl 
			ON bettrans.srecommend = tbl.SuperId
				AND bettrans.bettype = tbl.bettypePT
WHERE 
	bettrans.winlostdate = @winlostdate
	AND bettrans.statusID NOT IN (0, 1, 102, 101, 103)
	AND bettrans.bettype BETWEEN 4101 AND 4300
GROUP BY bettrans.recommend
		,bettrans.mrecommend
		,bettrans.srecommend
		,CASE
			 WHEN bettype IN (4298, 4297) THEN bettype
			 ELSE 0
		 END

---- Master
INSERT INTO sum_winloss_tmp
(
	winlostdate, roleid, custid, recommend, mrecommend, srecommend, turnover, winlost, awinlost, mwinlost, swinlost,
	playercomm, comm, acomm, scomm, BetCount, grosscomm, sporttype, bettype, netTurnover, TunroverNoDraw, ExtraWinloss, ExtraComm
)
SELECT
	@winlostdate
   ,3
   ,bettrans.mrecommend
   ,0 recommend
   ,bettrans.mrecommend
   ,bettrans.srecommend
   ,SUM(ABS(stake)) TurnOver
   ,SUM(winlost - actual_stake) winlost
   ,SUM(awinlost) awinlost
   ,SUM(mwinlost) mwinlost
   ,SUM(ISNULL(swinlost, 0)) swinlost
   ,SUM(playercomm) playercomm
   ,SUM(comm) comm
   ,SUM(acomm) acomm
   ,SUM(ISNULL(scomm, 0)) scomm
   ,COUNT(1) BetCount
   ,SUM(CASE
		WHEN tpositiontaking = 1 THEN 0
		ELSE scomm / (1 - tpositiontaking)
	END) grosscomm
   ,248 sporttype
   ,CASE
		WHEN bettype IN (4298, 4297) THEN bettype
		ELSE 0
	END bettype
   ,SUM(ABS(stake * mpositiontaking)) AS netTurnover
   ,SUM(ABS(stake)) AS TurnoverNoDraw,
	-1 * SUM(
				CASE
					-- Jackpot
					WHEN bettrans.bettype IN (4297) THEN
						CASE WHEN bettrans.tpositiontaking = 1 THEN 0 ELSE ISNULL(bettrans.betid/CONVERT(DECIMAL(19,8), 100000000), 0) END
					WHEN bettrans.bettype IN (4298) THEN 0
					ELSE CASE WHEN bettrans.tpositiontaking = 1 THEN 0 ELSE bettrans.winlost - bettrans.actual_stake END
				END
				* CASE WHEN tbl.ExtraPT IS NOT NULL THEN tbl.ExtraPT
						ELSE ISNULL(bettrans.epositiontaking, 0)
					END
		) AS ExtraWinloss,
	-1 * SUM(CASE 
				WHEN bettrans.bettype IN (4297, 4298) THEN 0
				ELSE 
					CASE 
						WHEN bettrans.tpositiontaking = 1 THEN 0 
						ELSE bettrans.scomm / (1 - bettrans.tpositiontaking)
					END * CASE WHEN tbl.ExtraPT IS NOT NULL THEN tbl.ExtraPT ELSE ISNULL(bettrans.epositiontaking, 0) END
			END
		) AS ExtraComm
FROM dbo.bettrans14 bettrans WITH (NOLOCK)
		INNER JOIN #__SuperExtraPT tbl 
			ON bettrans.srecommend = tbl.SuperId
				AND bettrans.bettype = tbl.bettypePT
WHERE 
	bettrans.winlostdate = @winlostdate
	AND bettrans.statusID NOT IN (0, 1, 102, 101, 103)
	AND bettrans.bettype BETWEEN 4101 AND 4300
GROUP BY bettrans.mrecommend
		,bettrans.srecommend
		,CASE
			 WHEN bettype IN (4298, 4297) THEN bettype
			 ELSE 0
		 END

---- Super
INSERT INTO sum_winloss_tmp
(
	winlostdate, roleid, custid, recommend, mrecommend, srecommend, turnover, winlost, awinlost, mwinlost, swinlost,
	playercomm, comm, acomm, scomm, BetCount, grosscomm, sporttype, bettype, netTurnover, TunroverNoDraw, ExtraWinloss, ExtraComm
)
SELECT
	@winlostdate
   ,4
   ,bettrans.srecommend
   ,0 recommend
   ,0 mrecommend
   ,bettrans.srecommend
   ,SUM(ABS(stake)) TurnOver
   ,SUM(winlost - actual_stake) winlost
   ,SUM(awinlost) awinlost
   ,SUM(mwinlost) mwinlost
   ,SUM(ISNULL(swinlost, 0)) swinlost
   ,SUM(playercomm) playercomm
   ,SUM(comm) comm
   ,SUM(acomm) acomm
   ,SUM(ISNULL(scomm, 0)) scomm
   ,COUNT(1) BetCount
   ,SUM(CASE
		WHEN tpositiontaking = 1 THEN 0
		ELSE scomm / (1 - tpositiontaking)
	END) grosscomm
   ,248 sporttype
   ,CASE
		WHEN bettype IN (4298, 4297) THEN bettype
		ELSE 0
	END bettype
   ,SUM(ABS(stake * spositiontaking)) AS netTurnover
   ,SUM(ABS(stake)) AS TurnoverNoDraw,
	-1 * SUM(
				CASE
					-- Jackpot
					WHEN bettrans.bettype IN (4297) THEN
						CASE WHEN bettrans.tpositiontaking = 1 THEN 0 ELSE ISNULL(bettrans.betid/CONVERT(DECIMAL(19,8), 100000000), 0) END
					WHEN bettrans.bettype IN (4298) THEN 0
					ELSE CASE WHEN bettrans.tpositiontaking = 1 THEN 0 ELSE bettrans.winlost - bettrans.actual_stake END
				END
				* CASE WHEN tbl.ExtraPT IS NOT NULL THEN tbl.ExtraPT
						ELSE ISNULL(bettrans.epositiontaking, 0)
					END
		) AS ExtraWinloss,
	-1 * SUM(CASE 
				WHEN bettrans.bettype IN (4297, 4298) THEN 0
				ELSE 
					CASE 
						WHEN bettrans.tpositiontaking = 1 THEN 0 
						ELSE bettrans.scomm / (1 - bettrans.tpositiontaking)
					END * CASE WHEN tbl.ExtraPT IS NOT NULL THEN tbl.ExtraPT ELSE ISNULL(bettrans.epositiontaking, 0) END
			END
		) AS ExtraComm
FROM dbo.bettrans14 bettrans WITH (NOLOCK)
		INNER JOIN #__SuperExtraPT tbl 
			ON bettrans.srecommend = tbl.SuperId
				AND bettrans.bettype = tbl.bettypePT
WHERE 
	bettrans.winlostdate = @winlostdate
	AND bettrans.statusID NOT IN (0, 1, 102, 101, 103)
	AND bettrans.bettype BETWEEN 4101 AND 4300

GROUP BY bettrans.srecommend
		,CASE
			 WHEN bettype IN (4298, 4297) THEN bettype
			 ELSE 0
		 END

-- update username for main table
-- temp table for only one day, no need to update by batch
UPDATE s
	SET s.username = c.username
FROM sum_winloss_tmp s WITH(ROWLOCK)
	INNER JOIN CustDB.dbo.Customer c WITH(NOLOCK)
		ON s.custid = c.custid
WHERE s.winlostdate = @winlostdate

DROP TABLE #__SuperExtraPT

