/*<info serverAlias="DBRPT-bodb_Report"></info>*/
/*
	Created: 20210927@Percy
	DBRPT-bodb_Report
	Task: Gen data for apositiontaking column (rptLicWinloss2)
	Step 2: Clone SP import data
*/
use bodb_Report
go

ALTER PROCEDURE dbo.Task_DailyRptLicWinloss2_temp
	@WinLostDate SMALLDATETIME
AS

/*
	Copy from DBLIC.bodb_LicenseeReport.dbo.Task_DailyRptLicWinloss2
*/

BEGIN
	SET NOCOUNT ON

	DELETE FROM dbo.rptLicWinloss2_temp WITH (ROWLOCK) WHERE winlostdate = @WinLostDate

	DECLARE @HWHLCutDate SMALLDATETIME = '2019-10-01' -- half won/ half lose cut date

	CREATE TABLE #BATransIds (TransId BIGINT PRIMARY KEY)
	INSERT INTO #BATransIds (TransId)
	SELECT TransId FROM bodb_Licensee.dbo.LicenseeBATransaction_bk WITH (NOLOCK) WHERE winlostdate = @WinLostDate

	--Member Level
	INSERT INTO dbo.rptLicWinloss2_temp (
		[winlostdate]
		,[username]
		,[username2]
		,[custid]
		,[roleid]
		,[recommend]
		,[mrecommend]
		,[srecommend]
		,[turnover]
		,[winlost]
		,[BetEffective]
		,[awinlost]
		,[mwinlost]
		,[swinlost]
		,[playercomm]
		,[comm]
		,[acomm]
		,[scomm]
		,[winlostvirtual]
		,[commvirtual]
		,[BetCount]
		,[Currency]
		,[sporttype]
		,[bettype]
		,[statusID]
		,[isBA]
		,[isMobile]
		,[betfrom]
		,[BuyBackAmt]
		,[BABuyBackAmt]
		,[apositiontaking]
		)
	SELECT
		@WinLostDate
		,c.username
		,c.username2
		,c.custid
		,1
		,c.recommend
		,c.mrecommend
		,c.srecommend
		,SUM(CASE
				WHEN b.liveawayscore = 0 AND b.bettype IN (33, 43) THEN ABS(b.stake/2)
				ELSE ABS(b.stake)
			END) AS TurnOver
		,SUM(winlost - actual_stake) winlost
		,CASE
			WHEN b.statusID IN (112,113) THEN SUM(CASE
															WHEN (b.bettype IN (4300, 4299, 4298, 4297, 3007, 1906, 1698, 1699, 3150, 3898, 3899)
																OR (b.bettype BETWEEN 1611 AND 1697 AND b.matchid = 150)
																OR (b.bettype BETWEEN 3801 AND 3899 AND b.matchid = 173)) THEN 0
															ELSE ABS(winlost - actual_stake)
														END)  -- exclude PP Prize, SAG Tip ticket from BetEffective
			ELSE 0
		END AS BetEffective
		,SUM(awinlost) awinlost
		,SUM(mwinlost) mwinlost
		,SUM(ISNULL(swinlost,0)) swinlost
		,SUM(playercomm) playercomm
		,SUM(comm) comm
		,SUM(acomm) acomm
		,SUM(ISNULL(scomm,0)) scomm
		,SUM((winlost - actual_stake) * virtualrate) AS WinlostVirtual
		,SUM(comm * virtualrate) AS CommVirtual
		,COUNT(b.transid) BetCount
		,b.currency
		,CASE
			WHEN bettype IN (71,72) THEN 251 --casino
			WHEN bettype = 1000 THEN 253 --games
			WHEN bettype BETWEEN 81 AND 120 THEN 161 --Number Game
			WHEN bettype BETWEEN 8101 AND 8120 THEN 164 --Number Game - Happy 5
			WHEN bettype BETWEEN 3601 AND 3610 THEN 168 --Happy 5 Linked Games
			WHEN (bettype BETWEEN 1201 AND 1299 ) THEN 180  --Virtual Sport
			WHEN bettype BETWEEN 51 AND 69 THEN 201
			WHEN bettype IN (31,32,33,41,42,43) THEN 151
			WHEN bettype BETWEEN 1501  AND 1599 THEN 202 -- Keno
			WHEN bettype BETWEEN 1800 AND 1899 THEN 250 -- AGC
			WHEN bettype BETWEEN 1700 AND 1799 THEN 255 -- GD
			WHEN bettype = 1900 THEN 249 -- VG
			WHEN bettype BETWEEN 2101 AND 2199 THEN 208
			WHEN bettype BETWEEN 2201 AND 2299 THEN 209
			WHEN (bettype BETWEEN 2301 AND 2399 OR bettype BETWEEN 2901 AND 2999) THEN 210
			WHEN bettype BETWEEN 4001 AND 4100 THEN 212 -- VB
			WHEN bettype BETWEEN 2401 AND 2499 THEN 211 -- AB
			WHEN bettype BETWEEN 18000 AND 18006 THEN 204 --CB
			WHEN bettype BETWEEN 1011 AND 1020 THEN 219
			WHEN bettype BETWEEN 2701 AND 2799 THEN 190 --Betradar Virtual Sport
			WHEN bettype BETWEEN 2800 AND 2829 THEN 193 --Virtual Basketball
			WHEN bettype BETWEEN 1021 AND 1099 THEN 220 -- Lottery
			WHEN bettype BETWEEN 8000 AND 8099 THEN 221 -- Exchange
			WHEN bettype BETWEEN 4101 AND 4300 THEN 248 -- PP
			WHEN bettype BETWEEN 1901 AND 1999 THEN 165 -- CC
			WHEN bettype BETWEEN 4301 AND 4600 THEN 247 -- SG
			WHEN bettype BETWEEN 4601 AND 4900 THEN 245 -- VRG
			WHEN bettype BETWEEN 4901 AND 5000 THEN 222 -- TG
			WHEN bettype BETWEEN 5001 AND 5099 THEN 223 -- I4D
			WHEN bettype BETWEEN 3101 AND 3150 THEN 243 -- SXG
			WHEN (bettype BETWEEN 1611 AND 1699 AND matchid <> 150) THEN 200 -- SBC
			WHEN (bettype BETWEEN 1611 AND 1699 AND matchid = 150) THEN 150 -- SBC FreeBets
			WHEN bettype BETWEEN 6401 AND 6700 THEN 234 -- JK
			WHEN bettype BETWEEN 3001 AND 3099 THEN 244 -- SAG
			WHEN bettype BETWEEN 6001 AND 6300 THEN 232 -- PGS
			WHEN bettype BETWEEN 5701 AND 5799 THEN 236 -- GDG
			WHEN bettype BETWEEN 3611 AND 3620 THEN 169 -- SLT
			WHEN bettype BETWEEN 7001 AND 7300 THEN 238 -- HB
			WHEN bettype BETWEEN 3401 AND 3499 THEN 233 -- WM
			WHEN (bettype BETWEEN 3801 AND 3899 AND matchid <> 173) THEN 171 -- VGA
			WHEN (bettype BETWEEN 3801 AND 3899 AND matchid = 173) THEN 173 -- VGA FreeBets
			WHEN bettype BETWEEN 17000 AND 17030 THEN 246 -- Saba Promotion
			WHEN bettype BETWEEN 3501 AND 3599 THEN 239 -- BGG
			WHEN bettype BETWEEN 7301 AND 7600 THEN 167 -- CG
			ELSE 0
		END AS sporttype
		-- 1706: bidme tip, 4300 - PP Promotion Prize
		,CASE
			WHEN (bettype IN (71, 72, 1000, 901, 902, 903, 904, 911, 912, 913, 914, 1706, 4300, 4299, 4298, 4297, 3007, 1906, 999, 1698, 1699, 3150, 3898, 3899)
				OR (bettype BETWEEN 1611 AND 1697 AND matchid = 150)
				OR (bettype BETWEEN 3801 AND 3899 AND matchid = 173)
				OR (bettype BETWEEN 17000 AND 17030)
				) THEN bettype
			WHEN b.bettype = 29 AND b.oddsspread = 1 THEN -29		-- God Of Fortune
			ELSE 0
		END bettype
		--114: half win, 115: half lose
		,CASE
			WHEN b.winlostdate >= @HWHLCutDate
				AND b.statusID IN (112,113)
				AND b.modds IN (-0.25, 0.25)
				AND (b.bettype < 999							-- Sportsbook
					OR b.bettype BETWEEN 1301 AND 1399
					OR b.bettype BETWEEN 9001 AND 9399
					OR b.bettype BETWEEN 9400 AND 9699)
				AND b.bettype NOT IN (29,38,911,912,913,914)  --- Parlay, betbuilder, Cashout
				AND b.bettype NOT BETWEEN 81 AND 120
				THEN CASE WHEN b.statusID = 112 THEN 114 ELSE 115 END
			WHEN b.winlostdate < @HWHLCutDate
				AND b.statusID IN (112, 113)
				AND b.bettype IN(1,3,7,8,17,18,124,125,482,483,484,485)
				AND ABS(modds) = 0.25
				THEN CASE WHEN b.statusID = 112 THEN 114 ELSE 115 END
			ELSE b.statusID
		END AS statusID
		,CASE
			WHEN BA.transid IS NULL THEN 0
			WHEN BA.transid IS NOT NULL THEN 1
		END AS isBA
		,CASE
			WHEN b.betfrom IN ('s','m','l','r','o','c','2','5','_','@','%','7','8','~','#','$') THEN 1
			ELSE 0
		END AS isMobile
		,CASE
			WHEN b.betfrom IN ('a','d','e','u','s','m','l','g','r','x','y','z','o','c','t','v','0','1','2','3','4','5','6','7','_','@','%','8','9','>','~','^','#','$') THEN b.betfrom
			ELSE ''
		END AS betfrom
		,SUM(CASE
				WHEN (b.bettype IN (902, 912)
						OR (b.bettype = 29 AND b.oddsspread = 1))
					AND BA.transid IS NULL THEN b.actual_stake
				WHEN b.bettype IN (4297, 1698) THEN b.oddsspread
				ELSE 0
			END) AS BuyBackAmt
		,SUM(CASE
				WHEN (b.bettype IN (902, 912)
						OR (b.bettype = 29 AND b.oddsspread = 1))
					AND BA.transid IS NOT NULL THEN b.actual_stake
				ELSE 0
			END) AS BABuyBackAmt
		,b.apositiontaking
	FROM
		dbo.bettrans_temp AS b WITH (NOLOCK)
		INNER JOIN bodb02.dbo.customer AS c WITH (NOLOCK) ON b.custid = c.custid
		LEFT JOIN #BATransIds AS ba ON b.transid = ba.transid
	WHERE
		b.winlostdate = @WinLostDate
		--AND c.srecommend IN (SELECT custid FROM bodb02.dbo.f_DepSuper_1('All'))
		--AND b.statusID IN (101, 111, 112, 113) --REJECT, DRAW, WON, LOSE
		--AND b.bettype <= 19999
	GROUP BY
		c.custid
		,c.recommend
		,c.mrecommend
		,c.srecommend
		,c.username
		,c.username2
		,b.currency
		,b.statusID
		,CASE
			WHEN bettype IN (71,72) THEN 251 --casino
			WHEN bettype = 1000 THEN 253 --games
			WHEN bettype BETWEEN 81 AND 120 THEN 161 --Number Game
			WHEN bettype BETWEEN 8101 AND 8120 THEN 164 --Number Game - Happy 5
			WHEN bettype BETWEEN 3601 AND 3610 THEN 168 --Happy 5 Linked Games
			WHEN (bettype BETWEEN 1201 AND 1299 ) THEN 180  --Virtual Sport
			WHEN bettype BETWEEN 51 AND 69 THEN 201
			WHEN bettype IN (31,32,33,41,42,43) THEN 151
			WHEN bettype BETWEEN 1501  AND 1599 THEN 202
			WHEN bettype BETWEEN 1800 AND 1899 THEN 250 -- AGC
			WHEN bettype BETWEEN 1700 AND 1799 THEN 255 -- GD
			WHEN bettype = 1900 THEN 249 -- VG
			WHEN bettype BETWEEN 2101 AND 2199 THEN 208
			WHEN bettype BETWEEN 2201 AND 2299 THEN 209
			WHEN (bettype BETWEEN 2301 AND 2399 OR bettype BETWEEN 2901 AND 2999) THEN 210
			WHEN bettype BETWEEN 4001 AND 4100 THEN 212 -- VB
			WHEN bettype BETWEEN 2401 AND 2499 THEN 211 -- AB
			WHEN bettype BETWEEN 18000 AND 18006 THEN 204
			WHEN bettype BETWEEN 1011  AND 1020 THEN 219
			WHEN bettype BETWEEN 2701 AND 2799 THEN 190 --Betradar Virtual Sport
			WHEN bettype BETWEEN 2800 AND 2829 THEN 193 --Virtual Basketball
			WHEN bettype BETWEEN 1021 AND 1099 THEN 220 -- Lottery
			WHEN bettype BETWEEN 8000 AND 8099 THEN 221 -- Exchange
			WHEN bettype BETWEEN 4101 AND 4300 THEN 248 -- PP
			WHEN bettype BETWEEN 1901 AND 1999 THEN 165 -- CC
			WHEN bettype BETWEEN 4301 AND 4600 THEN 247 -- SG
			WHEN bettype BETWEEN 4601 AND 4900 THEN 245 -- VRG
			WHEN bettype BETWEEN 4901 AND 5000 THEN 222 -- TG
			WHEN bettype BETWEEN 5001 AND 5099 THEN 223 -- I4D
			WHEN bettype BETWEEN 3101 AND 3150 THEN 243 -- SXG
			WHEN (bettype BETWEEN 1611 AND 1699 AND matchid <> 150) THEN 200 -- SBC
			WHEN (bettype BETWEEN 1611 AND 1699 AND matchid = 150) THEN 150 -- SBC FreeBets
			WHEN bettype BETWEEN 6401 AND 6700 THEN 234 -- JK
			WHEN bettype BETWEEN 3001 AND 3099 THEN 244 -- SAG
			WHEN bettype BETWEEN 6001 AND 6300 THEN 232 -- PGS
			WHEN bettype BETWEEN 5701 AND 5799 THEN 236 -- GDG
			WHEN bettype BETWEEN 3611 AND 3620 THEN 169 -- SLT
			WHEN bettype BETWEEN 7001 AND 7300 THEN 238 -- HB
			WHEN bettype BETWEEN 3401 AND 3499 THEN 233 -- WM
			WHEN (bettype BETWEEN 3801 AND 3899 AND matchid <> 173) THEN 171 -- VGA
			WHEN (bettype BETWEEN 3801 AND 3899 AND matchid = 173) THEN 173 -- VGA FreeBets
			WHEN bettype BETWEEN 17000 AND 17030 THEN 246 -- Saba Promotion
			WHEN bettype BETWEEN 3501 AND 3599 THEN 239 -- BGG
			WHEN bettype BETWEEN 7301 AND 7600 THEN 167 -- CG
			ELSE 0
		END
		,CASE
			WHEN (bettype IN (71, 72, 1000, 901, 902, 903, 904, 911, 912, 913, 914, 1706, 4300, 4299, 4298, 4297, 3007, 1906, 999, 1698, 1699, 3150, 3898, 3899)
				OR (bettype BETWEEN 1611 AND 1697 AND matchid = 150)
				OR (bettype BETWEEN 3801 AND 3899 AND matchid = 173)
				OR (bettype BETWEEN 17000 AND 17030)
				) THEN bettype
			WHEN b.bettype = 29 AND b.oddsspread = 1 THEN -29		-- God Of Fortune
			ELSE 0
		END
		,CASE
			WHEN b.winlostdate >= @HWHLCutDate
				AND b.statusID IN (112, 113)
				AND b.modds IN (-0.25, 0.25)
				AND (b.bettype < 999						-- Sportsbook
					OR b.bettype BETWEEN 1301 AND 1399
					OR b.bettype BETWEEN 9001 AND 9399
					OR b.bettype BETWEEN 9400 AND 9699)
				AND b.bettype NOT IN (29,38,911,912,913,914)  --- Parlay, betbuilder, Cashout
				AND b.bettype NOT BETWEEN 81 AND 120
				THEN CASE WHEN b.statusID = 112 THEN 114 ELSE 115 END
			WHEN b.winlostdate < @HWHLCutDate
				AND b.statusID IN (112, 113)
				AND b.bettype IN (1,3,7,8,17,18,124,125,482,483,484,485)
				AND ABS(modds) = 0.25
				THEN CASE WHEN b.statusID = 112 THEN 114 ELSE 115 END
			ELSE b.statusID
		END
		,CASE
			WHEN BA.transid IS NULL THEN 0
			WHEN BA.transid IS NOT NULL THEN 1
		END
		,CASE
			WHEN b.betfrom IN ('s','m','l','r','o','c','2','5','_','@','%','7','8','~','#','$') THEN 1
			ELSE 0
		END
		,CASE
			WHEN b.betfrom IN ('a','d','e','u','s','m','l','g','r','x','y','z','o','c','t','v','0','1','2','3','4','5','6','7','_','@','%','8','9','>','~','^','#','$') THEN b.betfrom
			ELSE ''
		END
		,b.apositiontaking

	DROP TABLE #BATransIds

	-- Agent Level (sum on member)
	INSERT INTO dbo.rptLicWinloss2_temp (
		 [winlostdate]
		,[username]
		,[username2]
		,[custid]
		,[roleid]
		,[recommend]
		,[mrecommend]
		,[srecommend]
		,[turnover]
		,[winlost]
		,[BetEffective]
		,[awinlost]
		,[mwinlost]
		,[swinlost]
		,[playercomm]
		,[comm]
		,[acomm]
		,[scomm]
		,[winlostvirtual]
		,[commvirtual]
		,[BetCount]
		,[Currency]
		,[sporttype]
		,[bettype]
		,[statusID]
		,[isBA]
		,[isMobile]
		,[betfrom]
		,[BuyBackAmt]
		,[BABuyBackAmt]
		,[apositiontaking]
		)
	SELECT
		@WinLostDate
		,c.username
		,c.username2
		,c.custid
		,2 AS roleid
		,b.recommend
		,b.mrecommend
		,b.srecommend
		,SUM(turnover)
		,SUM(winlost)
		,SUM(BetEffective)
		,SUM(awinlost)
		,SUM(mwinlost)
		,SUM(swinlost)
		,SUM(playercomm)
		,SUM(comm)
		,SUM(acomm)
		,SUM(scomm)
		,SUM(winlostvirtual)
		,SUM(commvirtual)
		,SUM(BetCount)
		,b.currency
		,b.sporttype
		,b.bettype
		,b.statusID
		,b.isBA
		,b.isMobile
		,b.betfrom
		,SUM(BuyBackAmt)
		,SUM(BABuyBackAmt)
		,b.apositiontaking
	FROM
		dbo.rptLicWinloss2_temp AS b WITH (NOLOCK)
		INNER JOIN bodb02.dbo.customer AS c WITH (NOLOCK) ON b.recommend = c.custid
	WHERE
		b.winlostdate = @WinLostDate
		AND b.roleid = 1
		AND c.roleid = 2
	GROUP BY
		c.username
		,c.username2
		,c.custid
		,b.recommend
		,b.mrecommend
		,b.srecommend
		,b.currency
		,b.sporttype
		,b.bettype
		,b.statusID
		,b.isBA
		,b.isMobile
		,b.betfrom
		,b.apositiontaking

	-- Master Level (sum on member)
	INSERT INTO dbo.rptLicWinloss2_temp
		(
		[winlostdate]
		,[username]
		,[username2]
		,[custid]
		,[roleid]
		,[recommend]
		,[mrecommend]
		,[srecommend]
		,[turnover]
		,[winlost]
		,[BetEffective]
		,[awinlost]
		,[mwinlost]
		,[swinlost]
		,[playercomm]
		,[comm]
		,[acomm]
		,[scomm]
		,[winlostvirtual]
		,[commvirtual]
		,[BetCount]
		,[Currency]
		,[sporttype]
		,[bettype]
		,[statusID]
		,[isBA]
		,[isMobile]
		,[betfrom]
		,[BuyBackAmt]
		,[BABuyBackAmt]
		,[apositiontaking]
		)
	SELECT
		@winlostdate
		,c.username
		,c.username2
		,c.custid
		,3 AS roleid
		,0
		,b.mrecommend
		,b.srecommend
		,SUM(turnover)
		,SUM(winlost)
		,SUM(BetEffective)
		,SUM(awinlost)
		,SUM(mwinlost)
		,SUM(swinlost)
		,SUM(playercomm)
		,SUM(comm)
		,SUM(acomm)
		,SUM(scomm)
		,SUM(winlostvirtual)
		,SUM(commvirtual)
		,SUM(BetCount)
		,b.currency
		,b.sporttype
		,b.bettype
		,b.statusID
		,b.isBA
		,b.isMobile
		,b.betfrom
		,SUM(BuyBackAmt)
		,SUM(BABuyBackAmt)
		,b.apositiontaking
	FROM
		dbo.rptLicWinloss2_temp AS b WITH (NOLOCK)
		INNER JOIN bodb02.dbo.customer AS c WITH (NOLOCK) ON b.mrecommend = c.custid
	WHERE
		b.winlostdate = @WinLostDate
		AND b.roleid = 1
		AND c.roleid = 3
	GROUP BY
		c.username
		,c.username2
		,c.custid
		,b.mrecommend
		,b.srecommend
		,b.currency
		,b.sporttype
		,b.bettype
		,b.statusID
		,b.isBA
		,b.isMobile
		,b.betfrom
		,b.apositiontaking

	-- Super Level (Sum on member)
	INSERT INTO dbo.rptLicWinloss2_temp (
		[winlostdate]
		,[username]
		,[username2]
		,[custid]
		,[roleid]
		,[recommend]
		,[mrecommend]
		,[srecommend]
		,[turnover]
		,[winlost]
		,[BetEffective]
		,[awinlost]
		,[mwinlost]
		,[swinlost]
		,[playercomm]
		,[comm]
		,[acomm]
		,[scomm]
		,[winlostvirtual]
		,[commvirtual]
		,[BetCount]
		,[Currency]
		,[sporttype]
		,[bettype]
		,[statusID]
		,[isBA]
		,[isMobile]
		,[betfrom]
		,[BuyBackAmt]
		,[BABuyBackAmt]
		,[apositiontaking]
		)
	SELECT
		@winlostdate
		,c.username
		,c.username2
		,c.custid
		,4 AS roleid
		,0
		,0
		,b.srecommend
		,SUM(turnover)
		,SUM(winlost)
		,SUM(BetEffective)
		,SUM(awinlost)
		,SUM(mwinlost)
		,SUM(swinlost)
		,SUM(playercomm)
		,SUM(comm)
		,SUM(acomm)
		,SUM(scomm)
		,SUM(winlostvirtual)
		,SUM(commvirtual)
		,SUM(BetCount)
		,b.currency
		,b.sporttype
		,b.bettype
		,b.statusID
		,b.isBA
		,b.isMobile
		,b.betfrom
		,SUM(BuyBackAmt)
		,SUM(BABuyBackAmt)
		,b.apositiontaking
	FROM
		dbo.rptLicWinloss2_temp AS b WITH (NOLOCK)
		INNER JOIN bodb02.dbo.customer AS c WITH (NOLOCK) ON b.srecommend = c.custid
	WHERE
		b.winlostdate = @WinLostDate
		AND b.roleid = 1
		AND c.roleid = 4
	GROUP BY
		c.username
		,c.username2
		,c.custid
		,b.srecommend
		,b.currency
		,b.sporttype
		,b.bettype
		,b.statusID
		,b.isBA
		,b.isMobile
		,b.betfrom
		,b.apositiontaking
END
GO