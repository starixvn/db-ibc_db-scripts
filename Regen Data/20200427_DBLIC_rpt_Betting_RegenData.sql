USE bodb_LicenseeReport
GO

/*
	Created: 20200427@Percy
	DB: DBLIC.bodb_LicenseeReport
	Task: rpt_Betting - Correct data on bettrans_bk & bettrans14 range
		bettrans_bk:	2020-04-16
		bettrans14:		2020-04-17 --> 2020-04-19
*/

-- Data source
BEGIN
	CREATE TABLE #tmpBettrans
	(
		rptDate				DATETIME
		,recommend			INT
		,bettype			SMALLINT
		,CurrencyID			INT
		,Status				SMALLINT
		,IsLive				BIT
		,BetCount			INT
		,MemberCount		INT
		,Turnover			MONEY
		,WinLoss			MONEY
		,WinLossA			MONEY
		,WinLossM			MONEY
		,WinLossS			MONEY
		,CommissionP		MONEY
		,CommissionA		MONEY
		,CommissionM		MONEY
		,CommissionS		MONEY
		,WinLossVirtual		MONEY
		,CommissionSVirtual	MONEY
		,CustomerCategory	SMALLINT
		,oddsspread			MONEY
		,TicketType			TINYINT
	)
END

-- bettrans_bk
BEGIN
	INSERT INTO #tmpBettrans
	SELECT
		b.winlostdate				AS rptDate
		,b.recommend				AS recommend
		,b.bettype					AS bettype
		,b.currency					AS [CurrencyID]
		,b.statusid					AS [Status]
		,ISNULL(b.liveindicator, 0)	AS [IsLive]
		,COUNT(1)					AS Betcount
		,COUNT(DISTINCT b.custid)	AS MemberCount
		,SUM(ABS(b.stake))			AS Turnover
		,SUM(winlost-actual_stake)	AS winloss
		,SUM(awinlost)				AS winlossA
		,SUM(mwinlost)				AS winlossM
		,SUM(swinlost)				AS winlossS
		,SUM(playercomm)			AS commissionP
		,SUM(comm)					AS commissionA
		,SUM(acomm)					AS commissionM
		,SUM(scomm)					AS commissionS
		,SUM((winlost-actual_stake)*virtualrate) AS WinLossVirtual
		,SUM(scomm*virtualrate)		AS CommissionSVirtual
		,CASE	WHEN b.recommend = 52466 THEN 27 -- 8RM
				WHEN b.recommend = 5707545 THEN 28 -- BARM
				ELSE -1 END AS customercategory
		,SUM(ISNULL(oddsspread, 0))	AS oddsspread
		,ISNULL(b.currency2, 0)		AS TicketType
	FROM DBARC.bodb_Archive.dbo.bettrans_bk b WITH (NOLOCK)
	WHERE b.winlostdate = '2020-04-16'
		AND b.bettype BETWEEN 4901 AND 4999
	GROUP BY
		b.winlostdate
		,b.recommend
		,b.bettype
		,b.currency
		,b.statusid
		,ISNULL(b.liveindicator, 0)
		,CASE	WHEN b.recommend = 52466 THEN 27 -- 8RM
				WHEN b.recommend = 5707545 THEN 28 -- BARM
				ELSE -1 END
		,ISNULL(b.currency2, 0)
END

-- bettrans14
BEGIN
	INSERT INTO #tmpBettrans
	SELECT
		b.winlostdate				AS rptDate
		,b.recommend				AS recommend
		,b.bettype					AS bettype
		,b.currency					AS [CurrencyID]
		,b.statusid					AS [Status]
		,ISNULL(b.liveindicator, 0)	AS [IsLive]
		,COUNT(1)					AS Betcount
		,COUNT(DISTINCT b.custid)	AS MemberCount
		,SUM(ABS(b.stake))			AS Turnover
		,SUM(winlost-actual_stake)	AS winloss
		,SUM(awinlost)				AS winlossA
		,SUM(mwinlost)				AS winlossM
		,SUM(swinlost)				AS winlossS
		,SUM(playercomm)			AS commissionP
		,SUM(comm)					AS commissionA
		,SUM(acomm)					AS commissionM
		,SUM(scomm)					AS commissionS
		,SUM((winlost-actual_stake)*virtualrate) AS WinLossVirtual
		,SUM(scomm*virtualrate)		AS CommissionSVirtual
		,CASE	WHEN b.recommend = 52466 THEN 27 -- 8RM
				WHEN b.recommend = 5707545 THEN 28 -- BARM
				ELSE -1 END AS customercategory
		,SUM(ISNULL(oddsspread, 0))	AS oddsspread
		,ISNULL(b.currency2, 0)		AS TicketType
	FROM bodb02.dbo.bettrans14 b WITH (NOLOCK)
	WHERE b.winlostdate BETWEEN '2020-04-17' AND '2020-04-19'
		AND b.bettype BETWEEN 4901 AND 4999
	GROUP BY
		b.winlostdate
		,b.recommend
		,b.bettype
		,b.currency
		,b.statusid
		,ISNULL(b.liveindicator, 0)
		,CASE	WHEN b.recommend = 52466 THEN 27 -- 8RM
				WHEN b.recommend = 5707545 THEN 28 -- BARM
				ELSE -1 END
		,ISNULL(b.currency2, 0)
END

-- Insert into source
BEGIN
	CREATE TABLE #DataSource
	(
		rptDate				DATETIME
		,SiteID				INT
		,Bettype			SMALLINT
		,LeagueID			INT
		,CurrencyID			INT
		,Status				SMALLINT
		,IsLive				BIT
		,BetCount			INT
		,MemberCount		INT
		,Turnover			MONEY
		,WinLoss			MONEY
		,WinLossA			MONEY
		,WinLossM			MONEY
		,WinLossS			MONEY
		,CommissionP		MONEY
		,CommissionA		MONEY
		,CommissionM		MONEY
		,CommissionS		MONEY
		,WinLossVirtual		MONEY
		,CommissionSVirtual	MONEY
		,CustomerCategory	SMALLINT
		,BuyBackAmount		MONEY
		,WinPrizeAmount		MONEY
		,CashOutAmount		MONEY
		,oddsspread			MONEY
		,ExtraAmount		MONEY
		,TicketType			TINYINT
	)
	INSERT INTO #DataSource
	SELECT
		b.rptDate
		,ISNULL(s.SiteID, -1)
		,b.bettype
		,-1
		,b.CurrencyID
		,b.Status
		,b.IsLive
		,SUM(Betcount)
		,SUM(MemberCount)
		,SUM(Turnover)
		,SUM(winloss)
		,SUM(winlossA)
		,SUM(winlossM)
		,SUM(winlossS)
		,SUM(commissionP)
		,SUM(commissionA)
		,SUM(commissionM)
		,SUM(commissionS)
		,SUM(WinLossVirtual)
		,SUM(CommissionSVirtual)
		,b.customercategory
		,0
		,0
		,0
		,SUM(oddsspread)
		,b.TicketType
		,0
	FROM #tmpBettrans b
		LEFT JOIN bodb02.dbo.Customer ag WITH (NOLOCK) ON b.recommend = ag.custid AND ag.roleid = 2
		LEFT JOIN bodb_Licensee.dbo.view_site_list s WITH (NOLOCK) ON s.SiteName = ag.site
	GROUP BY
		b.rptDate
		,ISNULL(s.SiteID, -1)
		,b.bettype
		,b.CurrencyID
		,b.Status
		,b.IsLive
		,b.customercategory
		,b.TicketType

	DROP TABLE #tmpBettrans
END

-- Data target
BEGIN
	CREATE TABLE #DataTarget
	(
		rptDate				DATETIME
		,SiteID				INT
		,Bettype			SMALLINT
		,LeagueID			INT
		,CurrencyID			INT
		,Status				SMALLINT
		,IsLive				BIT
		,BetCount			INT
		,MemberCount		INT
		,Turnover			MONEY
		,WinLoss			MONEY
		,WinLossA			MONEY
		,WinLossM			MONEY
		,WinLossS			MONEY
		,CommissionP		MONEY
		,CommissionA		MONEY
		,CommissionM		MONEY
		,CommissionS		MONEY
		,WinLossVirtual		MONEY
		,CommissionSVirtual	MONEY
		,CustomerCategory	SMALLINT
		,BuyBackAmount		MONEY
		,WinPrizeAmount		MONEY
		,CashOutAmount		MONEY
		,oddsspread			MONEY
		,ExtraAmount		MONEY
		,TicketType			TINYINT
	)
	INSERT INTO #DataTarget
	SELECT
		rptDate
		,SiteID
		,Bettype
		,LeagueID
		,CurrencyID
		,Status
		,IsLive
		,BetCount
		,MemberCount
		,Turnover
		,WinLoss
		,WinLossA
		,WinLossM
		,WinLossS
		,CommissionP
		,CommissionA
		,CommissionM
		,CommissionS
		,WinLossVirtual
		,CommissionSVirtual
		,CustomerCategory
		,BuyBackAmount
		,WinPrizeAmount
		,CashOutAmount
		,oddsspread
		,ExtraAmount
		,TicketType
	FROM dbo.rpt_Betting WITH (NOLOCK)
	WHERE rptDate BETWEEN '2020-04-16' AND '2020-04-19'
		AND Bettype BETWEEN 4901 AND 4999
END

-- Compare data
BEGIN
	CREATE TABLE #Result
	(
		ModifiedType		SMALLINT
		,rptDate			DATETIME
		,SiteID				INT
		,Bettype			SMALLINT
		,LeagueID			INT
		,CurrencyID			INT
		,Status				SMALLINT
		,IsLive				BIT
		,BetCount			INT
		,MemberCount		INT
		,Turnover			MONEY
		,WinLoss			MONEY
		,WinLossA			MONEY
		,WinLossM			MONEY
		,WinLossS			MONEY
		,CommissionP		MONEY
		,CommissionA		MONEY
		,CommissionM		MONEY
		,CommissionS		MONEY
		,WinLossVirtual		MONEY
		,CommissionSVirtual	MONEY
		,CustomerCategory	SMALLINT
		,BuyBackAmount		MONEY
		,WinPrizeAmount		MONEY
		,CashOutAmount		MONEY
		,oddsspread			MONEY
		,ExtraAmount		MONEY
		,TicketType			TINYINT
	)

	INSERT INTO #Result
	SELECT
		CASE
			WHEN s.rptDate IS NULL THEN -1 -- delete
			WHEN t.rptDate IS NULL THEN 1 -- insert
			ELSE 0 -- update
			END
		,ISNULL(s.rptDate, t.rptDate)
		,ISNULL(s.SiteID, t.SiteID)
		,ISNULL(s.Bettype, t.Bettype)
		,ISNULL(s.LeagueID, t.LeagueID)
		,ISNULL(s.CurrencyID, t.CurrencyID)
		,ISNULL(s.Status, t.Status)
		,ISNULL(s.IsLive, t.IsLive)
		,ISNULL(s.BetCount, 0)
		,ISNULL(s.MemberCount, 0)
		,ISNULL(s.Turnover, 0)
		,ISNULL(s.WinLoss, 0)
		,ISNULL(s.WinLossA, 0)
		,ISNULL(s.WinLossM, 0)
		,ISNULL(s.WinLossS, 0)
		,ISNULL(s.CommissionP, 0)
		,ISNULL(s.CommissionA, 0)
		,ISNULL(s.CommissionM, 0)
		,ISNULL(s.CommissionS, 0)
		,ISNULL(s.WinLossVirtual, 0)
		,ISNULL(s.CommissionSVirtual, 0)
		,ISNULL(s.CustomerCategory, t.CustomerCategory)
		,ISNULL(s.BuyBackAmount, 0)
		,ISNULL(s.WinPrizeAmount, 0)
		,ISNULL(s.CashOutAmount, 0)
		,ISNULL(s.oddsspread, 0)
		,ISNULL(s.ExtraAmount, 0)
		,ISNULL(s.TicketType, t.TicketType)
	FROM #DataSource s
		FULL OUTER JOIN #DataTarget t
			ON s.rptDate = t.rptDate
				AND s.SiteID = t.SiteID
				AND s.Bettype = t.Bettype
				AND s.LeagueID = t.LeagueID
				AND s.CurrencyID = t.CurrencyID
				AND s.Status = t.Status
				AND s.IsLive = t.IsLive
				AND s.CustomerCategory = t.CustomerCategory
				AND s.TicketType = t.TicketType
	WHERE s.rptDate IS NULL
		OR t.rptDate IS NULL
		OR ISNULL(s.BetCount, 0) <> ISNULL(t.BetCount, 0)
		OR ISNULL(s.MemberCount, 0) <> ISNULL(t.MemberCount, 0)
		OR ISNULL(s.Turnover, 0) <> ISNULL(t.Turnover, 0)
		OR ISNULL(s.WinLoss, 0) <> ISNULL(t.WinLoss, 0)
		OR ISNULL(s.WinLossA, 0) <> ISNULL(t.WinLossA, 0)
		OR ISNULL(s.WinLossM, 0) <> ISNULL(t.WinLossM, 0)
		OR ISNULL(s.WinLossS, 0) <> ISNULL(t.WinLossS, 0)
		OR ISNULL(s.CommissionP, 0) <> ISNULL(t.CommissionP, 0)
		OR ISNULL(s.CommissionA, 0) <> ISNULL(t.CommissionA, 0)
		OR ISNULL(s.CommissionM, 0) <> ISNULL(t.CommissionM, 0)
		OR ISNULL(s.CommissionS, 0) <> ISNULL(t.CommissionS, 0)
		OR ISNULL(s.WinLossVirtual, 0) <> ISNULL(t.WinLossVirtual, 0)
		OR ISNULL(s.CommissionSVirtual, 0) <> ISNULL(t.CommissionSVirtual, 0)
		OR ISNULL(s.BuyBackAmount, 0) <> ISNULL(t.BuyBackAmount, 0)
		OR ISNULL(s.WinPrizeAmount, 0) <> ISNULL(t.WinPrizeAmount, 0)
		OR ISNULL(s.CashOutAmount, 0) <> ISNULL(t.CashOutAmount, 0)
		OR ISNULL(s.oddsspread, 0) <> ISNULL(t.oddsspread, 0)
		OR ISNULL(s.ExtraAmount, 0) <> ISNULL(t.ExtraAmount, 0)

	DROP TABLE #DataSource
	DROP TABLE #DataTarget

	IF EXISTS (SELECT 1 FROM #Result WHERE ModifiedType = -1)
		DELETE r WITH (ROWLOCK, UPDLOCK)
		FROM dbo.rpt_Betting r
			INNER JOIN #Result t
				ON r.rptDate = t.rptDate
					AND r.SiteID = t.SiteID
					AND r.Bettype = t.Bettype
					AND r.LeagueID = t.LeagueID
					AND r.CurrencyID = t.CurrencyID
					AND r.Status = t.Status
					AND r.IsLive = t.IsLive
					AND r.CustomerCategory = t.CustomerCategory
					AND r.TicketType = t.TicketType
		WHERE t.ModifiedType = -1

	IF EXISTS (SELECT 1 FROM #Result WHERE ModifiedType = 0)
		UPDATE r WITH (ROWLOCK)
		SET r.BetCount = t.BetCount
			,r.MemberCount = t.MemberCount
			,r.Turnover = t.Turnover
			,r.WinLoss = t.WinLoss
			,r.WinLossA = t.WinLossA
			,r.WinLossM = t.WinLossM
			,r.WinLossS = t.WinLossS
			,r.CommissionP = t.CommissionP
			,r.CommissionA = t.CommissionA
			,r.CommissionM = t.CommissionM
			,r.CommissionS = t.CommissionS
			,r.WinLossVirtual = t.WinLossVirtual
			,r.CommissionSVirtual = t.CommissionSVirtual
			,r.BuyBackAmount = t.BuyBackAmount
			,r.WinPrizeAmount = t.WinPrizeAmount
			,r.CashOutAmount = t.CashOutAmount
			,r.oddsspread = t.oddsspread
			,r.ExtraAmount = t.ExtraAmount
		FROM dbo.rpt_Betting r
			INNER JOIN #Result t
				ON r.rptDate = t.rptDate
					AND r.SiteID = t.SiteID
					AND r.Bettype = t.Bettype
					AND r.LeagueID = t.LeagueID
					AND r.CurrencyID = t.CurrencyID
					AND r.Status = t.Status
					AND r.IsLive = t.IsLive
					AND r.CustomerCategory = t.CustomerCategory
					AND r.TicketType = t.TicketType
		WHERE t.ModifiedType = 0

	IF EXISTS (SELECT 1 FROM #Result WHERE ModifiedType = 1)
		INSERT INTO dbo.rpt_Betting
		(
			rptDate,SiteID,Bettype,LeagueID,CurrencyID,Status,IsLive,BetCount,MemberCount
			,Turnover,WinLoss,WinLossA,WinLossM,WinLossS,CommissionP,CommissionA,CommissionM,CommissionS
			,WinLossVirtual,CommissionSVirtual,CustomerCategory,BuyBackAmount,WinPrizeAmount,CashOutAmount
			,oddsspread,ExtraAmount,TicketType
		)
		SELECT
			rptDate,SiteID,Bettype,LeagueID,CurrencyID,Status,IsLive,BetCount,MemberCount
			,Turnover,WinLoss,WinLossA,WinLossM,WinLossS,CommissionP,CommissionA,CommissionM,CommissionS
			,WinLossVirtual,CommissionSVirtual,CustomerCategory,BuyBackAmount,WinPrizeAmount,CashOutAmount
			,oddsspread,ExtraAmount,TicketType
		FROM #Result
		WHERE ModifiedType = 1

	DROP TABLE #Result
END