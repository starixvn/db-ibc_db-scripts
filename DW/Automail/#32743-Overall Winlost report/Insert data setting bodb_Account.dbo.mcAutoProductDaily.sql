USE bodb_Account
GO

SET NOCOUNT ON

DECLARE @datestart DATETIME = '2015-01-01'
	,@dateend DATETIME
	,@BalanceUpDay DATETIME
	,@MoveBetDay DATETIME

SELECT @MoveBetDay  = max(eventdate)
FROM DBACC.bodb02.dbo.match14 WITH (NOLOCK)

SELECT TOP 1 @BalanceUpDay = winlostdate
FROM DBACC.bodb02.dbo.Bettrans WITH (NOLOCK)
WHERE bettype = 20000 AND matchid = 0 AND custid = 3

SELECT @dateend = @MoveBetDay
SELECT @datestart datestart,@dateend  dateend,@MoveBetDay MoveBetDay,@BalanceUpDay BalanceUpDay

TRUNCATE TABLE bodb_Account.dbo.mcAutoProductDaily

INSERT INTO  bodb_Account.dbo.mcAutoProductDaily(rptDate,ProductID,livestat,WinlossIBC,TurnoverIBC,BetCount,PartnerAmtDue)
SELECT b.[rptDate] [rptDate]
	,pbt.Productid
	,b.IsLive [livestat]
	,SUM(CASE 
			WHEN pbt.excluded_WL = 1 THEN 0
			ELSE b.[WinlossIBC] * edo.Rate
			END) [WinlossIBC]
	,SUM(CASE 
			WHEN pbt.excluded_TO = 1 THEN 0
			ELSE b.TurnoverIBC * edo.Rate
			END) [TurnoverIBC]
	,SUM(CASE 
			WHEN pbt.excluded_BetCount = 1 THEN 0
			ELSE b.[BetCount]
			END) [BetCount]
	,0 PartnerAmtDue
FROM bodb_Account.dbo.MasterCube b WITH (NOLOCK)
	INNER JOIN bodb_Account.dbo.ProductBettypeSetting pbt WITH (NOLOCK) ON b.Bettype = pbt.Bettype AND pbt.ProductID NOT IN (
		- 1000 --Mix Parlay
		, 2 --racing
		, 6 --RNG Casino
		)
	INNER JOIN bodb_Account.dbo.tbl_Currency_Daily edo WITH (NOLOCK) ON edo.ExchangeDate = b.[rptDate] AND edo.Currency = b.currency
	LEFT JOIN [bodb_dwrs].[dbo].[DWH_view_TestCurrency] vwExcludeCurr WITH (NOLOCK) ON b.currency = vwExcludeCurr.currencyid
WHERE b.rptdate >= @BalanceUpDay AND b.rptdate <= @MoveBetDay AND b.[status] NOT IN (- 1, 18, 9, 10, 14, 3) AND vwExcludeCurr.currencyid IS NULL AND pbt.excluded = 0 AND Productid > 11
GROUP BY b.[rptDate]
	,pbt.Productid
	,b.IsLive

INSERT INTO  bodb_Account.dbo.mcAutoProductDaily(rptDate,ProductID,livestat,WinlossIBC,TurnoverIBC,BetCount,PartnerAmtDue)
SELECT b.[rptDate] [rptDate]
	,pbt.Productid
	,b.IsLive [livestat]
	,SUM(CASE 
			WHEN pbt.excluded_WL = 1 THEN 0
			ELSE b.[WinlossIBC] * edo.Rate
			END) [WinlossIBC]
	,SUM(CASE 
			WHEN pbt.excluded_TO = 1 THEN 0
			ELSE b.TurnoverIBC * edo.Rate
			END) [TurnoverIBC]
	,SUM(CASE 
			WHEN pbt.excluded_BetCount = 1 THEN 0
			ELSE b.[BetCount]
			END) [BetCount]
	,0 PartnerAmtDue
FROM bodb_Archive.dbo.MasterCube b WITH (NOLOCK)
	INNER JOIN bodb_Account.dbo.ProductBettypeSetting pbt WITH (NOLOCK) ON b.Bettype = pbt.Bettype AND pbt.ProductID NOT IN (
		- 1000 --Mix Parlay
		, 2 --racing
		, 6 --RNG Casino
		)
	INNER JOIN bodb_Account.dbo.tbl_Currency_Daily edo WITH (NOLOCK) ON edo.ExchangeDate = b.[rptDate] AND edo.Currency = b.currency
	LEFT JOIN [bodb_dwrs].[dbo].[DWH_view_TestCurrency] vwExcludeCurr WITH (NOLOCK) ON b.currency = vwExcludeCurr.currencyid
WHERE b.rptdate >= @datestart AND b.rptdate <= @BalanceUpDay AND b.[status] NOT IN (- 1, 18, 9, 10, 14, 3) AND vwExcludeCurr.currencyid IS NULL AND pbt.excluded = 0 AND Productid > 11
GROUP BY b.[rptDate]
	,pbt.Productid
	,b.IsLive

INSERT INTO  bodb_Account.dbo.mcAutoProductDaily(rptDate,ProductID,livestat,WinlossIBC,TurnoverIBC,BetCount,PartnerAmtDue)
SELECT mc.[rptDate]
	,ISNULL(pbt.Productid, 0) ProductID
	,mc.isLive livestat
	,- SUM(CASE 
			WHEN pbt.excluded_WL = 1 THEN 0
			ELSE (
					ISNULL(- mc.WinlossIBC, 0) - ISNULL(CASE 
							WHEN racing.partnerID IN (2, 3, 4) THEN 0
							ELSE mc.StakeA
							END, 0) + ISNULL(mc.CommissionSVirtual, 0) - ISNULL(mc.CommissionS, 0)
					) * c.Rate
			END) WinlossIBC
	,SUM(CASE 
			WHEN pbt.excluded_TO = 1 THEN 0
			ELSE ISNULL(mc.TurnoverIBC * c.Rate, 0)
			END) TurnoverIBC
	,SUM(CASE 
			WHEN pbt.excluded_BetCount = 1 THEN 0
			ELSE mc.[BetCount]
			END) [BetCount]
	,- SUM((
			(
				ISNULL(- mc.WinlossIBC, 0) - ISNULL(CASE 
						WHEN racing.partnerID IN (2, 3, 4) THEN 0
						ELSE mc.StakeA
						END, 0) + ISNULL(mc.CommissionSVirtual, 0) - ISNULL(mc.CommissionS, 0)
				) + (mc.WinlossP + mc.WinlossS + mc.WinlossM + mc.WinlossA + mc.CommissionS)
			) * c.Rate) PartnerAmtDue
FROM bodb_Account.dbo.MasterCube mc WITH (NOLOCK)
	INNER JOIN bodb_Account.dbo.ProductBettypeSetting pbt WITH (NOLOCK) ON mc.Bettype = pbt.Bettype AND pbt.excluded = 0 AND pbt.Productid = 2
	INNER JOIN bodb02.dbo.RacingMeeting racing WITH (NOLOCK) ON racing.meetingID = mc.leagueid
	INNER JOIN bodb_Account.dbo.tbl_Currency_Daily c WITH (NOLOCK) ON mc.rptDate = c.ExchangeDate AND mc.currency = c.Currency
	LEFT JOIN [bodb_dwrs].[dbo].[DWH_view_TestCurrency] vwExcludeCurr WITH (NOLOCK) ON mc.currency = vwExcludeCurr.currencyid
WHERE mc.rptdate >= @BalanceUpDay AND mc.rptdate <= @dateend AND mc.[status] NOT IN (- 1, 18, 9, 10, 14, 3) AND vwExcludeCurr.currencyid IS NULL
GROUP BY mc.[rptDate]
	,ISNULL(pbt.Productid, 0)
	,mc.isLive

INSERT INTO  bodb_Account.dbo.mcAutoProductDaily(rptDate,ProductID,livestat,WinlossIBC,TurnoverIBC,BetCount,PartnerAmtDue)
SELECT mc.[rptDate]
	,ISNULL(pbt.Productid, 0) ProductID
	,mc.isLive livestat
	,- SUM(CASE 
			WHEN pbt.excluded_WL = 1 THEN 0
			ELSE (
					ISNULL(- mc.WinlossIBC, 0) - ISNULL(CASE 
							WHEN racing.partnerID IN (2, 3, 4) THEN 0
							ELSE mc.StakeA
							END, 0) + ISNULL(mc.CommissionSVirtual, 0) - ISNULL(mc.CommissionS, 0)
					) * c.Rate
			END) WinlossIBC
	,SUM(CASE 
			WHEN pbt.excluded_TO = 1 THEN 0
			ELSE ISNULL(mc.TurnoverIBC * c.Rate, 0)
			END) TurnoverIBC
	,SUM(CASE 
			WHEN pbt.excluded_BetCount = 1 THEN 0
			ELSE mc.[BetCount]
			END) [BetCount]
	,- SUM((
			(
				ISNULL(- mc.WinlossIBC, 0) - ISNULL(CASE 
						WHEN racing.partnerID IN (2, 3, 4) THEN 0
						ELSE mc.StakeA
						END, 0) + ISNULL(mc.CommissionSVirtual, 0) - ISNULL(mc.CommissionS, 0)
				) + (mc.WinlossP + mc.WinlossS + mc.WinlossM + mc.WinlossA + mc.CommissionS)
			) * c.Rate) PartnerAmtDue
FROM bodb_Archive.dbo.MasterCube mc WITH (NOLOCK)
	INNER JOIN bodb_Account.dbo.ProductBettypeSetting pbt WITH (NOLOCK) ON mc.Bettype = pbt.Bettype AND pbt.excluded = 0 AND pbt.Productid = 2
	INNER JOIN bodb02.dbo.RacingMeeting racing WITH (NOLOCK) ON racing.meetingID = mc.leagueid
	INNER JOIN bodb_Account.dbo.tbl_Currency_Daily c WITH (NOLOCK) ON mc.rptDate = c.ExchangeDate AND mc.currency = c.Currency
	LEFT JOIN [bodb_dwrs].[dbo].[DWH_view_TestCurrency] vwExcludeCurr WITH (NOLOCK) ON mc.currency = vwExcludeCurr.currencyid
WHERE mc.rptdate >= @datestart AND mc.rptdate <= @BalanceUpDay AND mc.[status] NOT IN (- 1, 18, 9, 10, 14, 3) AND vwExcludeCurr.currencyid IS NULL
GROUP BY mc.[rptDate]
	,ISNULL(pbt.Productid, 0)
	,mc.isLive

INSERT INTO  bodb_Account.dbo.mcAutoProductDaily(rptDate,ProductID,livestat,WinlossIBC,TurnoverIBC,BetCount,PartnerAmtDue)
SELECT b.[rptDate] [rptDate]
	,ISNULL(pbt.Productid, 0) Productid
	,b.livestat [livestat]
	,SUM(CASE 
			WHEN pbt.excluded_WL = 1 THEN 0
			ELSE b.[WinlossIBC] * edo.Rate
			END) [WinlossIBC]
	,SUM(CASE 
			WHEN pbt.excluded_TO = 1 THEN 0
			ELSE b.TurnoverIBC * edo.Rate
			END) [TurnoverIBC]
	,SUM(CASE 
			WHEN pbt.excluded_BetCount = 1 THEN 0
			ELSE b.[BetCount]
			END) [BetCount]
	,0 PartnerAmtDue
FROM bodb_Account.dbo.rptCustParlayDaily b WITH (NOLOCK)
	INNER JOIN bodb_Account.dbo.ProductBettypeSetting pbt WITH (NOLOCK) ON pbt.excluded = 0 AND pbt.Productid = - 1000
	LEFT JOIN bodb_Account.dbo.tbl_Currency_Daily edo WITH (NOLOCK) ON edo.ExchangeDate = b.[rptDate] AND edo.Currency = b.currency
	LEFT JOIN [bodb_dwrs].[dbo].[DWH_view_TestCurrency] vwExcludeCurr WITH (NOLOCK) ON b.currency = vwExcludeCurr.currencyid
WHERE b.rptdate >= @dateend AND b.rptdate <= @BalanceUpDay AND b.[status] NOT IN (- 1, 18, 9, 10, 14, 3) AND vwExcludeCurr.currencyid IS NULL
GROUP BY b.[rptDate]
	,ISNULL(pbt.Productid, 0)
	,b.livestat

INSERT INTO  bodb_Account.dbo.mcAutoProductDaily(rptDate,ProductID,livestat,WinlossIBC,TurnoverIBC,BetCount,PartnerAmtDue)
SELECT b.[rptDate] [rptDate]
	,ISNULL(pbt.Productid, 0) Productid
	,0 [livestat]
	,SUM(CASE 
			WHEN pbt.excluded_WL = 1 THEN 0
			ELSE b.[WinlossIBC_RM]
			END) [WinlossIBC]
	,SUM(CASE 
			WHEN pbt.excluded_TO = 1 THEN 0
			ELSE b.[TurnoverIBC_RM]
			END) [TurnoverIBC]
	,SUM(CASE 
			WHEN pbt.excluded_BetCount = 1 THEN 0
			ELSE b.[BetCount]
			END) [BetCount]
	,0 PartnerAmtDue
FROM bodb_Account.[dbo].rptCustCasinoDaily b WITH (NOLOCK)
	INNER JOIN bodb_Account.dbo.ProductBettypeSetting pbt WITH (NOLOCK) ON b.Bettype = pbt.Bettype AND pbt.excluded = 0 AND pbt.Productid = 6
	LEFT JOIN [bodb_dwrs].[dbo].[DWH_view_TestCurrency] vwExcludeCurr WITH (NOLOCK) ON b.currency = vwExcludeCurr.currencyid
WHERE b.rptdate >= @datestart AND b.rptdate <= @dateend AND b.[statusid] NOT IN (- 1, 18, 9, 10, 14, 3) AND vwExcludeCurr.currencyid IS NULL
GROUP BY b.[rptDate]
	,ISNULL(pbt.Productid, 0)
