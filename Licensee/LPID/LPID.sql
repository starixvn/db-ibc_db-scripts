/*<info serverAlias="DBEXT-bodb02" executers="bodbAdminNet" isFunction="0" isNested="0"></info>*/
USE [bodb02]
GO

/*
	-- Get PartyId
	SELECT * FROM bodb_Licensee.dbo.OAS_Party WITH (NOLOCK)
	WHERE PartyName IN ('')

	SELECT * FROM bodb_Licensee.dbo.OAS_PartyDetail WITH (NOLOCK)
	WHERE BrandName IN ('')

	-- Get Base Currency
	SELECT * FROM bodb_Licensee.dbo.OAS_PartyBaseCurrency WITH (NOLOCK)
	WHERE PartyId = 1
*/

DECLARE @FromMonth DATETIME = '2018-01-01', @ToMonth DATETIME = '2022-01-01', @ProductCodes VARCHAR(100) = 'SB'
		,@PartyIds VARCHAR(MAX) = '484,490,584,585,594,605,647', @BaseCurrencyName VARCHAR(10) = 'EUR'

---------
SELECT @FromMonth = DATEADD(MONTH, DATEDIFF(MONTH, 0, @FromMonth), 0)
SELECT @ToMonth = DATEADD(DAY, -1, DATEADD(MONTH, DATEDIFF(MONTH, 0, @ToMonth) + 1, 0))

DECLARE @FromDate DATETIME, @ToDate DATETIME, @Msg VARCHAR(1000)
SELECT  @FromDate = @FromMonth
SELECT  @ToDate = DATEADD(DAY, -1, DATEADD(MONTH, 1, @FromDate))

BEGIN

	DECLARE @Exchange TABLE (ExchangeDate DATE, ExchangeId INT, Rate FLOAT)
	DECLARE @Products TABLE (GroupProductId INT, ProductId INT, FromDate DATE, ToDate DATE)

	CREATE TABLE #_tmp_PartyChargeInfo (PartyId INT, LicenseeId INT, ProductId INT, FromDate DATETIME, ToDate DATETIME)
	CREATE TABLE #PerformanceData
	(
		rptDate DATE, LicenseeId INT, PartyId INT, ProductId INT, CurrencyId INT
		,BetCount INT, Turnover MONEY, MemberWL MONEY, BACommission MONEY
	)
	
	DECLARE @Result TABLE
	(
		PartyId INT, ProductId INT, LicensingFeeTypeId SMALLINT, GrossLicensingFee MONEY, LicensingFee MONEY, ExtraAmount MONEY, IsChargedByGroupMinFee BIT, IsChargedByMinFee BIT
		,Rebate MONEY, RebateRate MONEY, RebateRemark NVARCHAR(4000), Discount MONEY, DiscountRate MONEY, DiscountRemark NVARCHAR(4000)
		,BetCount INT, Turnover MONEY, MemberWL MONEY, BACommission MONEY, IsUpdated BIT DEFAULT (0)
		,MonthDate DATETIME
	)

	WHILE @ToDate <= @ToMonth
	BEGIN
		SET @Msg = 'Start month: ' + CONVERT(VARCHAR(10), @FromDate, 120)
		RAISERROR (@Msg, 1, 0) WITH NOWAIT

		TRUNCATE TABLE #PerformanceData
		TRUNCATE TABLE #_tmp_PartyChargeInfo
		DELETE @Exchange
		DELETE @Products

		INSERT INTO @Exchange (ExchangeDate, ExchangeId, Rate)
		SELECT ExchangeDate, ExchangeId, BaseCurrencyRate
		FROM dbo.LA_f_ExchangeDailySel(@FromDate, @ToDate, @BaseCurrencyName)

		INSERT INTO #_tmp_PartyChargeInfo (PartyId, LicenseeId, ProductId, FromDate, ToDate)
		SELECT DISTINCT PartyId, LicenseeId, ProductId, FromDate, ToDate
		FROM bodb_Licensee.dbo.LA_f_ChargeInfoWithCredit(@PartyIds, @FromDate, @ToDate, @ProductCodes)
		
		INSERT INTO @Products (GroupProductId, ProductId, FromDate, ToDate)
		SELECT GroupProductId, ProductId, FromDate, ToDate FROM bodb_licensee.dbo.LA_f_GroupProduct(@ProductCodes, @FromDate, @ToDate) 

		;WITH CTE_PerformanceData AS (
			SELECT r.rptDate, r.SiteId, gp.GroupProductId AS ProductId, r.CurrencyId
				,SUM(CASE WHEN gb.Bettype IS NOT NULL THEN 0 ELSE r.BetCount END) AS BetCount
				,SUM(CASE WHEN gb.Bettype IS NOT NULL THEN 0 ELSE r.Turnover END) AS Turnover
				,SUM(CASE WHEN gb.Bettype IS NOT NULL THEN 0 ELSE r.MemberWL + r.CommissionP END) AS MemberWL
				,SUM(CommissionA) AS BACommission
			FROM (
				SELECT rptDate, SiteId, ProductId, CurrencyId, Bettype
					,SUM(BetCount * CASE
										WHEN ISNULL(TicketType, 0) = 2 THEN 0
										ELSE 1 END) AS BetCount
					,SUM(Turnover * CASE
										WHEN ISNULL(TicketType, 0) = 2 THEN 0
										ELSE 1 END) AS Turnover
					,SUM(CASE WHEN ISNULL(TicketType, 0) = 2 THEN 0 ELSE MemberWL END) AS MemberWL
					,SUM(CASE WHEN ProductId = 31 THEN CommissionP ELSE 0 END) AS CommissionP
					,SUM(CASE WHEN ProductId = 3 THEN CommissionA ELSE 0 END) AS CommissionA
				FROM bodb_LicenseeReport.dbo.rpt_BettingByProduct WITH (NOLOCK)
				WHERE rptDate BETWEEN @FromDate AND @ToDate
					AND CurrencyId <> 20
					AND CustomerCategory NOT IN (27, 28)
					AND StatusId IN (111, 112, 113, 114, 115)
				GROUP BY rptDate, SiteId, ProductId, CurrencyId, Bettype
				UNION SELECT NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL -- sum data first
			) r
				INNER JOIN @Products gp ON r.ProductId = gp.ProductId AND r.rptDate BETWEEN gp.FromDate AND gp.ToDate
				LEFT JOIN bodb_Licensee.dbo.LA_f_GroupBettype() gb ON r.Bettype = gb.Bettype
			GROUP BY r.rptDate, r.SiteId, gp.GroupProductId, r.CurrencyId
		)
		INSERT INTO #PerformanceData (rptDate, LicenseeId, PartyId, ProductId, CurrencyId, BetCount, Turnover, MemberWL, BACommission)
		SELECT d.rptDate, d.SiteId, p.PartyId, d.ProductId, d.CurrencyId, SUM(d.BetCount), SUM(d.Turnover), SUM(d.MemberWL), SUM(d.BACommission)
		FROM CTE_PerformanceData d
			INNER JOIN #_tmp_PartyChargeInfo p ON d.SiteId = p.LicenseeId AND d.ProductId = p.ProductId AND d.rptDate BETWEEN p.FromDate AND p.ToDate
		GROUP BY d.rptDate, d.SiteId, p.PartyId, d.ProductId, d.CurrencyId

		INSERT INTO @Result
		(
			PartyId, ProductId, LicensingFeeTypeId, GrossLicensingFee, LicensingFee, ExtraAmount, IsChargedByGroupMinFee, IsChargedByMinFee
			,Discount, DiscountRate, DiscountRemark, Rebate, RebateRate, RebateRemark
		)
		EXEC bodb_Licensee.dbo.LA_AmountToCompanyByProduct
			@PartyIds = @PartyIds
			,@ProductCodes = @ProductCodes
			,@FromDate = @FromDate
			,@ToDate = @ToDate
			,@BaseCurrencyName = @BaseCurrencyName

		UPDATE r
		SET r.MonthDate = @FromDate, r.IsUpdated = 1
			,r.LicensingFee = r.LicensingFee + r.ExtraAmount
			,r.BetCount = d.BetCount, r.Turnover = d.Turnover, r.MemberWL = d.MemberWL
			,r.BACommission = d.BACommission
		FROM @Result r
			LEFT JOIN (
				SELECT p.PartyId, p.ProductId
					,SUM(p.BetCount) AS BetCount
					,SUM(p.Turnover * e.Rate) AS Turnover
					,SUM(p.MemberWL * e.Rate) AS MemberWL
					,SUM(p.BACommission * e.Rate) AS BACommission
				FROM #PerformanceData p
					INNER JOIN @Exchange e ON p.CurrencyId = e.ExchangeId AND p.rptDate = e.ExchangeDate
				GROUP BY p.PartyId, p.ProductId
			) d ON r.PartyId = d.PartyId AND r.ProductId = d.ProductId
		WHERE r.IsUpdated = 0

		SELECT @FromDate = DATEADD(DAY, 1, @ToDate)
		SELECT @ToDate = DATEADD(DAY, -1, DATEADD(MONTH, 1, @FromDate))

		WAITFOR DELAY '00:00:00.280'
	END

	-- Return data
	SELECT r.MonthDate, r.Turnover, r.GrossWinLoss
		,CONVERT(MONEY, CASE WHEN r.Turnover = 0 THEN 0 ELSE -r.GrossWinLoss/r.Turnover END) AS Margin
		,r.SportsbookFee, r.DiscountSportsbook, r.RebateSportsbook, r.PromotionSportsbook
	FROM (
		SELECT MonthDate
			,CONVERT(MONEY, SUM(Turnover)) AS Turnover
			,CONVERT(MONEY, SUM(MemberWL)) AS GrossWinLoss
			,CONVERT(MONEY, SUM(CASE WHEN ProductId = 0 THEN LicensingFee ELSE 0 END)) AS SportsbookFee
			,CONVERT(MONEY, SUM(CASE WHEN ProductId = 0 THEN Discount ELSE 0 END)) AS DiscountSportsbook
			,CONVERT(MONEY, SUM(CASE WHEN ProductId = 0 THEN Rebate ELSE 0 END)) AS RebateSportsbook
			,CONVERT(MONEY, SUM(CASE WHEN ProductId = 37 THEN LicensingFee ELSE 0 END)) AS PromotionSportsbook
		FROM @Result
		GROUP BY MonthDate
	) r

	DROP TABLE #_tmp_PartyChargeInfo
	DROP TABLE #PerformanceData
END
GO