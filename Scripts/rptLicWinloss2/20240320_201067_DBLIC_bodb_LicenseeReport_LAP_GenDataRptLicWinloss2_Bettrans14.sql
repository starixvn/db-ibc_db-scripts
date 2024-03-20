/*<info serverAlias="DBLIC-bodb_LicenseeReport,DBBAL-bodb_LicenseeReport"></info>*/
/*
	Created: 20240320@Evan
	DB: DBLIC-bodb_LicenseeReport,DBBAL-bodb_LicenseeReport
	Task: Task: Regen data bettrans14 range
*/

SET NOCOUNT ON

DECLARE @MoveBetsDay SMALLDATETIME, @BalanceUpDay SMALLDATETIME
DECLARE @Fromdate SMALLDATETIME = '2024-03-01'
DECLARE @ToDate SMALLDATETIME = '2024-03-13'

EXEC bodb02.dbo.NAP_Admin_GetMovebetDate @MovebetDate = @MoveBetsDay OUTPUT
EXEC bodb02.dbo.NAP_Admin_GetBalanceUpDate @BalanceUpDate = @BalanceUpDay OUTPUT

IF @Fromdate < @BalanceUpDay
	SET  @Fromdate = @BalanceUpDay
IF @ToDate > @MoveBetsDay
	SET  @ToDate = @MoveBetsDay

--SELECT @MoveBetsDay MoveBetsDay,@BalanceUpDay BalanceUpDay,@Fromdate Fromdate,@ToDate ToDate

DELETE FROM dbo.rptLicWinloss2 WITH (ROWLOCK) WHERE winlostdate BETWEEN @Fromdate AND @ToDate AND sporttype = 250
PRINT 'Delete data table rptLicWinloss2 sporttype = 250 Winlostdate from ' + CONVERT(VARCHAR(20),@Fromdate,23) + ' to ' + CONVERT(VARCHAR(20),@ToDate,23) + ' : ' + CONVERT(VARCHAR(20),@@rowcount) + ' row(s) effected'

CREATE TABLE #SportBettype (ProductId TINYINT, BetType SMALLINT, EventType TINYINT)

CREATE CLUSTERED INDEX IX_BetType ON #SportBettype (BetType)

INSERT INTO #SportBettype
SELECT ProductID, BetType, EventType
FROM bodb02.dbo.f_SportBettypeMatrix_Sel (1, 0, 0, 2, '', '', 1)

DECLARE @HWHLCutDate SMALLDATETIME = '2019-10-01' -- half won/ half lose cut date

-- Member Level
INSERT INTO dbo.rptLicWinloss2 (
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
	,TicketType
	)
SELECT
	b.winlostdate
	,c.username
	,c.username2
	,c.custid
	,1
	,c.recommend
	,c.mrecommend
	,c.srecommend
	,SUM(ABS(b.stake)) AS TurnOver
	,SUM(b.winlost - b.actual_stake) AS WinLost
	,CASE
		WHEN b.statusID IN (112, 113) THEN SUM(CASE
													WHEN (b.bettype IN (4300, 4299, 4298, 4297, 3007, 1906, 1698, 1699, 3150, 3898, 3899, 4598, 4599, 4600, 2499, 8695, 7698)
														OR (b.bettype BETWEEN 1611 AND 1697 AND b.matchid = 150)
														OR (b.bettype BETWEEN 3801 AND 3899 AND b.matchid = 173)
														OR (b.bettype BETWEEN 8700 AND 8709 AND b.matchid = 157)) THEN 0
													ELSE ABS(b.winlost - b.actual_stake)
												END)  -- exclude PP Prize, SAG Tip ticket from BetEffective
		ELSE 0
	END AS BetEffective
	,SUM(b.awinlost) AS awinlost
	,SUM(b.mwinlost) AS mwinlost
	,SUM(ISNULL(b.swinlost, 0)) AS swinlost
	,SUM(b.playercomm) AS playercomm
	,SUM(b.comm) AS comm
	,SUM(b.acomm) AS acomm
	,SUM(ISNULL(b.scomm, 0)) AS scomm
    ,SUM((b.winlost - b.actual_stake) * b.virtualrate) AS WinlostVirtual
	,SUM(b.comm * b.virtualrate) AS CommVirtual
	,COUNT(b.transid) BetCount
	,b.currency
	,CASE
		WHEN b.bettype IN (71,72) THEN 251 --casino
		WHEN b.bettype = 1000 THEN 253 --games
		WHEN b.bettype BETWEEN 81 AND 120 THEN 161 --Number Game
		WHEN b.bettype BETWEEN 8101 AND 8120 THEN 164 --Number Game - Happy 5
		WHEN b.bettype BETWEEN 3601 AND 3610 THEN 168 --Happy 5 Linked Games
		WHEN (b.bettype BETWEEN 1201 AND 1299 ) THEN 180  --Virtual Sport
		WHEN b.bettype BETWEEN 51 AND 69 THEN 201
		WHEN b.bettype IN (31,32,33,41,42,43) THEN 151
		WHEN b.bettype BETWEEN 1501  AND 1599 THEN 202 -- Keno
		WHEN b.bettype BETWEEN 1800 AND 1899 THEN 250 -- AGC
		WHEN b.bettype = 1900 THEN 249 -- VG
		WHEN b.bettype BETWEEN 2101 AND 2199 THEN 208
		WHEN b.bettype BETWEEN 2201 AND 2299 THEN 209
		WHEN (b.bettype BETWEEN 2301 AND 2399 OR b.bettype BETWEEN 2901 AND 2999) THEN 210
		WHEN b.bettype BETWEEN 4001 AND 4100 OR b.bettype BETWEEN 5800 AND 5999 THEN 212 -- VB
		WHEN b.bettype BETWEEN 2401 AND 2499 THEN 211 -- AB
		WHEN b.bettype BETWEEN 2701 AND 2799 THEN 190 --Betradar Virtual Sport
		WHEN b.bettype BETWEEN 2800 AND 2829 THEN 193 --Virtual Basketball
		WHEN b.bettype BETWEEN 1021 AND 1099 THEN 220 -- Lottery
		WHEN b.bettype BETWEEN 8000 AND 8099 THEN 221 -- Exchange
		WHEN b.bettype BETWEEN 4101 AND 4300 OR b.bettype BETWEEN 6701 AND 7000 THEN 248 -- PP
		WHEN b.bettype BETWEEN 1901 AND 1999 THEN 165 -- CC
		WHEN b.bettype BETWEEN 4301 AND 4600 THEN 247 -- SG
		WHEN b.bettype BETWEEN 4601 AND 4900 THEN 245 -- VRG
		WHEN b.bettype BETWEEN 4901 AND 5000 THEN 222 -- TG
		WHEN b.bettype BETWEEN 5001 AND 5099 THEN 223 -- I4D
		WHEN b.bettype BETWEEN 3101 AND 3150 THEN 243 -- SXG
		WHEN (b.bettype BETWEEN 1611 AND 1699 AND b.matchid <> 150) THEN 200 -- SBC
		WHEN (b.bettype BETWEEN 1611 AND 1699 AND b.matchid = 150) THEN 150 -- SBC FreeBets
		WHEN b.bettype BETWEEN 6401 AND 6700 THEN 234 -- JK
		WHEN b.bettype BETWEEN 3001 AND 3099 THEN 244 -- SAG
		WHEN b.bettype BETWEEN 6001 AND 6300 THEN 232 -- PGS
		WHEN b.bettype BETWEEN 3611 AND 3620 THEN 169 -- SLT
		WHEN b.bettype BETWEEN 7001 AND 7300 THEN 238 -- HB
		WHEN b.bettype BETWEEN 3401 AND 3499 THEN 233 -- WM
		WHEN (b.bettype BETWEEN 3801 AND 3899 AND b.matchid <> 173) THEN 171 -- VGA
		WHEN (b.bettype BETWEEN 3801 AND 3899 AND b.matchid = 173) THEN 173 -- VGA FreeBets
		WHEN b.bettype BETWEEN 17000 AND 17030 THEN 246 -- Saba Promotion
		WHEN b.bettype BETWEEN 8700 AND 8709 THEN 157 -- Player Tips
		WHEN b.bettype BETWEEN 3501 AND 3599 THEN 239 -- BGG
		WHEN b.bettype BETWEEN 7301 AND 7600 THEN 167 -- CG
		WHEN b.bettype BETWEEN 7701 AND 7799 THEN 172 -- AP
		WHEN b.bettype BETWEEN 7801 AND 7899 THEN 174 -- APM
		WHEN b.bettype = 5301 THEN 231 -- VS3 (old)
		WHEN b.bettype BETWEEN 5302 AND 5399 THEN 178 -- LG (VS3)
		WHEN b.bettype BETWEEN 7901 AND 7999 THEN 175 -- BTC
		WHEN b.bettype BETWEEN 8201 AND 8299 THEN 176 -- FGG
		WHEN b.bettype BETWEEN 5401 AND 5499 THEN 237 -- MXG
		WHEN b.bettype BETWEEN 5100 AND 5299 THEN 158 -- Jili
		WHEN b.bettype BETWEEN 3151 AND 3200 THEN 159 -- YeeBet
		WHEN b.bettype BETWEEN 8400 AND 8699 THEN 155 -- MG-RNG
		WHEN b.bettype BETWEEN 8900 AND 8999 THEN 156 -- SEA
		WHEN b.bettype BETWEEN 10300 AND 10399 THEN 228 -- WE
		WHEN b.bettype BETWEEN 7601 AND 7700 THEN 227 -- L22
		ELSE 0
	END AS sporttype
	-- 1706: bidme tip, 4300 - PP Promotion Prize
	,CASE
		WHEN b.bettype IN (71, 72, 1000, 901, 902, 903, 904, 911, 912, 913, 914, 1706, 4300, 4299, 4298, 4297, 3007, 1906, 999, 1698, 1699, 3150, 3898, 3899, 4598, 4599, 4600, 2499, 8695, 7698)
			OR (b.bettype BETWEEN 1611 AND 1697 AND matchid = 150)
			OR (b.bettype BETWEEN 3801 AND 3899 AND matchid = 173)
			OR (b.bettype BETWEEN 17000 AND 17030)  
			OR (b.bettype BETWEEN 8700 AND 8709)
			OR (b.bettype BETWEEN 1801 AND 1803) THEN b.bettype
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
				OR b.bettype BETWEEN 9400 AND 9998
				OR b.bettype BETWEEN 3900 AND 3999)
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
		WHEN b.betfrom IN ('s','m','l','r','o','c','2','5','_','@','%','7','8','~','.','$',']','}','#') THEN 1
		ELSE 0
	END AS isMobile
	,b.betfrom
	,SUM(CASE
			WHEN (b.bettype IN (902, 912)
					OR (b.bettype = 29 AND b.oddsspread = 1))
				AND BA.transid IS NULL THEN b.actual_stake
			WHEN b.bettype IN (4297, 1698, 3898, 4599) THEN b.oddsspread
			ELSE 0
		END) AS BuyBackAmt
	,SUM(CASE
			WHEN (b.bettype IN (902, 912)
					OR (b.bettype = 29 AND b.oddsspread = 1))
				AND BA.transid IS NOT NULL THEN b.actual_stake
			ELSE 0
		END) AS BABuyBackAmt
	,b.apositiontaking
	,CASE
		WHEN s.ProductId = 1 AND s.EventType = 1 AND b.betdaqid = -2 THEN 1
		ELSE 0
	END AS TicketType
FROM
	bodb02.dbo.bettrans14 AS b WITH (NOLOCK)
	INNER JOIN bodb02.dbo.Customer AS c WITH (NOLOCK) ON b.custid = c.custid
	LEFT JOIN #SportBettype AS s ON s.BetType = b.bettype
	LEFT JOIN bodb_licensee.dbo.LicenseeBATransaction_bk AS ba WITH (NOLOCK) ON b.transid = ba.transid
WHERE
	b.winlostdate BETWEEN @Fromdate AND @ToDate
	AND c.srecommend IN (SELECT custid FROM bodb02.dbo.f_DepSuper_1('All'))
	AND b.statusID IN (101, 111, 112, 113) --REJECT, DRAW, WON, LOSE
	AND b.bettype BETWEEN 1800 AND 1803
GROUP BY
	b.winlostdate
	,c.custid
	,c.recommend
	,c.mrecommend
	,c.srecommend
	,c.username
	,c.username2
	,b.currency
	,b.statusID
	,CASE
		WHEN b.bettype IN (71,72) THEN 251 --casino
		WHEN b.bettype = 1000 THEN 253 --games
		WHEN b.bettype BETWEEN 81 AND 120 THEN 161 --Number Game
		WHEN b.bettype BETWEEN 8101 AND 8120 THEN 164 --Number Game - Happy 5
		WHEN b.bettype BETWEEN 3601 AND 3610 THEN 168 --Happy 5 Linked Games
		WHEN (b.bettype BETWEEN 1201 AND 1299 ) THEN 180  --Virtual Sport
		WHEN b.bettype BETWEEN 51 AND 69 THEN 201
		WHEN b.bettype IN (31,32,33,41,42,43) THEN 151
		WHEN b.bettype BETWEEN 1501  AND 1599 THEN 202
		WHEN b.bettype BETWEEN 1800 AND 1899 THEN 250 -- AGC
		WHEN b.bettype = 1900 THEN 249 -- VG
		WHEN b.bettype BETWEEN 2101 AND 2199 THEN 208
		WHEN b.bettype BETWEEN 2201 AND 2299 THEN 209
		WHEN (b.bettype BETWEEN 2301 AND 2399 OR b.bettype BETWEEN 2901 AND 2999) THEN 210
		WHEN b.bettype BETWEEN 4001 AND 4100 OR b.bettype BETWEEN 5800 AND 5999 THEN 212 -- VB
		WHEN b.bettype BETWEEN 2401 AND 2499 THEN 211 -- AB
		WHEN b.bettype BETWEEN 2701 AND 2799 THEN 190 --Betradar Virtual Sport
		WHEN b.bettype BETWEEN 2800 AND 2829 THEN 193 --Virtual Basketball
		WHEN b.bettype BETWEEN 1021 AND 1099 THEN 220 -- Lottery
		WHEN b.bettype BETWEEN 8000 AND 8099 THEN 221 -- Exchange
		WHEN b.bettype BETWEEN 4101 AND 4300 OR b.bettype BETWEEN 6701 AND 7000 THEN 248 -- PP
		WHEN b.bettype BETWEEN 1901 AND 1999 THEN 165 -- CC
		WHEN b.bettype BETWEEN 4301 AND 4600 THEN 247 -- SG
		WHEN b.bettype BETWEEN 4601 AND 4900 THEN 245 -- VRG
		WHEN b.bettype BETWEEN 4901 AND 5000 THEN 222 -- TG
		WHEN b.bettype BETWEEN 5001 AND 5099 THEN 223 -- I4D
		WHEN b.bettype BETWEEN 3101 AND 3150 THEN 243 -- SXG
		WHEN (b.bettype BETWEEN 1611 AND 1699 AND b.matchid <> 150) THEN 200 -- SBC
		WHEN (b.bettype BETWEEN 1611 AND 1699 AND b.matchid = 150) THEN 150 -- SBC FreeBets
		WHEN b.bettype BETWEEN 6401 AND 6700 THEN 234 -- JK
		WHEN b.bettype BETWEEN 3001 AND 3099 THEN 244 -- SAG
		WHEN b.bettype BETWEEN 6001 AND 6300 THEN 232 -- PGS
		WHEN b.bettype BETWEEN 3611 AND 3620 THEN 169 -- SLT
		WHEN b.bettype BETWEEN 7001 AND 7300 THEN 238 -- HB
		WHEN b.bettype BETWEEN 3401 AND 3499 THEN 233 -- WM
		WHEN (b.bettype BETWEEN 3801 AND 3899 AND b.matchid <> 173) THEN 171 -- VGA
		WHEN (b.bettype BETWEEN 3801 AND 3899 AND b.matchid = 173) THEN 173 -- VGA FreeBets
		WHEN b.bettype BETWEEN 17000 AND 17030 THEN 246 -- Saba Promotion
		WHEN b.bettype BETWEEN 8700 AND 8709 THEN 157 -- Player Tips
		WHEN b.bettype BETWEEN 3501 AND 3599 THEN 239 -- BGG
		WHEN b.bettype BETWEEN 7301 AND 7600 THEN 167 -- CG
		WHEN b.bettype BETWEEN 7701 AND 7799 THEN 172 -- AP
		WHEN b.bettype BETWEEN 7801 AND 7899 THEN 174 -- APM
		WHEN b.bettype = 5301 THEN 231 -- VS3 (old)
		WHEN b.bettype BETWEEN 5302 AND 5399 THEN 178 -- LG (VS3)
		WHEN b.bettype BETWEEN 7901 AND 7999 THEN 175 -- BTC
		WHEN b.bettype BETWEEN 8201 AND 8299 THEN 176 -- FGG
		WHEN b.bettype BETWEEN 5401 AND 5499 THEN 237 -- MXG
		WHEN b.bettype BETWEEN 5100 AND 5299 THEN 158 -- Jili
		WHEN b.bettype BETWEEN 3151 AND 3200 THEN 159 -- YeeBet
		WHEN b.bettype BETWEEN 8400 AND 8699 THEN 155 -- MG-RNG
		WHEN b.bettype BETWEEN 8900 AND 8999 THEN 156 -- SEA
		WHEN b.bettype BETWEEN 10300 AND 10399 THEN 228 -- WE
		WHEN b.bettype BETWEEN 7601 AND 7700 THEN 227 -- L22
		ELSE 0
	END
	,CASE
		WHEN b.bettype IN (71, 72, 1000, 901, 902, 903, 904, 911, 912, 913, 914, 1706, 4300, 4299, 4298, 4297, 3007, 1906, 999, 1698, 1699, 3150, 3898, 3899, 4598, 4599, 4600, 2499, 8695, 7698)
			OR (b.bettype BETWEEN 1611 AND 1697 AND matchid = 150)
			OR (b.bettype BETWEEN 3801 AND 3899 AND matchid = 173)
			OR (b.bettype BETWEEN 17000 AND 17030)  
			OR (b.bettype BETWEEN 8700 AND 8709) 
			OR (b.bettype BETWEEN 1801 AND 1803) THEN b.bettype
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
				OR b.bettype BETWEEN 9400 AND 9998
				OR b.bettype BETWEEN 3900 AND 3999)
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
		WHEN b.betfrom IN ('s','m','l','r','o','c','2','5','_','@','%','7','8','~','.','$',']','}','#') THEN 1
		ELSE 0
	END
	,b.betfrom
	,b.apositiontaking
	,CASE
		WHEN s.ProductId = 1 AND s.EventType = 1 AND b.betdaqid = -2 THEN 1
		ELSE 0
	END

DROP TABLE #SportBettype

-- Agent Level (sum on member)
INSERT INTO dbo.rptLicWinloss2 (
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
	,TicketType
	)
SELECT
	b.winlostdate
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
	,b.TicketType
FROM
	dbo.rptLicWinloss2 AS b WITH (NOLOCK)
	INNER JOIN bodb02.dbo.customer AS c WITH (NOLOCK) ON b.recommend = c.custid
WHERE
	b.winlostdate BETWEEN @Fromdate AND @ToDate
	AND b.sporttype = 250
	AND b.roleid = 1
	AND c.roleid = 2
GROUP BY
	b.winlostdate
	,c.username
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
	,b.TicketType

-- Master Level (sum on member)
INSERT INTO dbo.rptLicWinloss2
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
	,TicketType
	)
SELECT
	b.winlostdate
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
	,b.TicketType
FROM
	dbo.rptLicWinloss2 AS b WITH (NOLOCK)
	INNER JOIN bodb02.dbo.customer AS c WITH (NOLOCK) ON b.mrecommend = c.custid
WHERE
	b.winlostdate BETWEEN @Fromdate AND @ToDate
	AND b.sporttype = 250
	AND b.roleid = 1
	AND c.roleid = 3
GROUP BY
	b.winlostdate
	,c.username
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
	,b.TicketType

-- Super Level (Sum on member)
INSERT INTO dbo.rptLicWinloss2 (
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
	,TicketType
	)
SELECT
	b.winlostdate
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
	,b.TicketType
FROM
	dbo.rptLicWinloss2 AS b WITH (NOLOCK)
	INNER JOIN bodb02.dbo.customer AS c WITH (NOLOCK) ON b.srecommend = c.custid
WHERE
	b.winlostdate BETWEEN @Fromdate AND @ToDate
	AND b.sporttype = 250
	AND b.roleid = 1
	AND c.roleid = 4
GROUP BY
	b.winlostdate
	,c.username
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
	,b.TicketType

