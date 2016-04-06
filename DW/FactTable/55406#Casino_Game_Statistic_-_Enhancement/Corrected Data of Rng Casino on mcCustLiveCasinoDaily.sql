USE [bodb_staging]

DECLARE @datestart DATETIME = '2016-02-01'
	,@dateend DATETIME = '2016-03-01'

BEGIN
	SET NOCOUNT ON

	CREATE TABLE #tblBettype (BETTYPE SMALLINT)

	INSERT INTO #tblBettype (BETTYPE)
	SELECT Bettype
	FROM bodb_Account.dbo.CasinoSetting CS(NOLOCK)
	WHERE SourceTable = 'bettransRNG'

	SELECT b.*
	INTO #bettransRnG_bk
	FROM DB06.bodb_Archive.dbo.bettransRnG_bk b WITH (NOLOCK)
		INNER JOIN #tblBettype sb ON b.gameID = sb.BetType
	WHERE b.winlostdate >= @datestart
		AND b.winlostdate <= @dateend
		AND EXISTS (
			SELECT TOP 1 1
			FROM #tblBettype sb
			WHERE b.gameID = sb.BetType
			)
		AND b.Currency NOT IN (20, 27, 28)

	CREATE TABLE #mcCustLiveCasinoDaily (
		rptDate DATETIME
		,CustID INT
		,recommend INT
		,mrecommend INT
		,srecommend INT
		,SiteID SMALLINT
		,currency TINYINT
		,bettype SMALLINT
		,leagueid INT
		,matchid INT
		,Stake MONEY
		,StakeRefund MONEY
		,WinlossIBC MONEY
		,WinlossS MONEY
		,WinlossM MONEY
		,WinlossA MONEY
		,WinlossP MONEY
		,TurnoverIBC MONEY
		,TurnoverS MONEY
		,TurnoverM MONEY
		,TurnoverA MONEY
		,CommissionS MONEY
		,CommissionM MONEY
		,CommissionA MONEY
		,CommissionP MONEY
		,BetCount INT
		,Actual_Stake MONEY
		,Actual_StakeRefund  MONEY
		)

	INSERT INTO #mcCustLiveCasinoDaily (
		[rptDate]
		,custid
		,recommend
		,mrecommend
		,srecommend
		,siteid
		,Currency
		,bettype
		,leagueid
		,matchid
		,Stake
		,Actual_Stake
		,StakeRefund
		,Actual_StakeRefund
		,WinlossIBC
		,WinlossS
		,WinlossM
		,WinlossA
		,WinlossP
		,TurnoverIBC
		,TurnoverS
		,TurnoverM
		,TurnoverA
		,CommissionS
		,CommissionM
		,CommissionA
		,CommissionP
		,BetCount
		)
	SELECT b.winlostdate [rptDate]
		,b.custid
		,b.recommend
		,b.mrecommend
		,b.srecommend
		,CASE WHEN b.[recommend] = 52466 THEN - 2 WHEN b.[recommend] = 5707545 THEN - 4 ELSE isnull(site.siteid, - 1) END siteid
		,b.Currency
		,b.gameID bettype
		,- 1 leagueid
		,b.Productid matchid
		,sum(CASE WHEN st.statusid IN (9, 10, 14) THEN 0 ELSE b.Stake END) Stake
		,sum(CASE WHEN st.statusid IN (9, 10, 14) THEN 0 ELSE abs(b.actual_stake) END) Actual_Stake
		,sum(CASE WHEN st.statusid IN (9, 10, 14) THEN b.Stake ELSE 0 END) StakeRefund
		,sum(CASE WHEN st.statusid IN (9, 10, 14) THEN abs(b.actual_stake) ELSE 0 END) Actual_StakeRefund
		,sum(CASE WHEN st.statusid IN (9, 10, 14) THEN 0 ELSE b.awinlost + b.mwinlost + b.swinlost + (b.winlost - (b.actual_stake)) END) WinlossIBC
		,sum(CASE WHEN st.statusid IN (9, 10, 14) THEN 0 ELSE b.swinlost END) WinlossS
		,sum(CASE WHEN st.statusid IN (9, 10, 14) THEN 0 ELSE b.mwinlost END) WinlossM
		,sum(CASE WHEN st.statusid IN (9, 10, 14) THEN 0 ELSE b.awinlost END) WinlossA
		,sum(CASE WHEN st.statusid IN (9, 10, 14) THEN 0 ELSE b.winlost - b.actual_stake END) WinlossP
		,sum(CASE WHEN st.statusid IN (9, 10, 14) THEN 0 ELSE ABS(b.stake) * (1 - b.tpositiontaking) END) TurnoverIBC
		,sum(CASE WHEN st.statusid IN (9, 10, 14) THEN 0 ELSE ABS(b.stake) * b.spositiontaking END) TurnoverS
		,sum(CASE WHEN st.statusid IN (9, 10, 14) THEN 0 ELSE ABS(b.stake) * b.mpositiontaking END) TurnoverM
		,sum(CASE WHEN st.statusid IN (9, 10, 14) THEN 0 ELSE ABS(b.stake) * b.apositiontaking END) TurnoverA
		,sum(CASE WHEN st.statusid IN (9, 10, 14) THEN 0 ELSE b.scomm END) CommissionS
		,sum(CASE WHEN st.statusid IN (9, 10, 14) THEN 0 ELSE b.acomm END) CommissionM
		,sum(CASE WHEN st.statusid IN (9, 10, 14) THEN 0 ELSE b.comm END) CommissionA
		,sum(CASE WHEN st.statusid IN (9, 10, 14) THEN 0 ELSE b.playercomm END) CommissionP
		,sum(CASE WHEN st.statusid IN (9, 10, 14) THEN 0 ELSE 1 END) BetCount
	FROM #bettransRnG_bk b
		LEFT JOIN bodb_Account.dbo.tbl_Status st WITH (NOLOCK) ON b.STATUS = st.STATUS
		LEFT JOIN bodb_Account.dbo.customer ag WITH (NOLOCK) ON b.recommend = ag.custid
		AND ag.roleid = 2
		LEFT JOIN bodb_Account.dbo.tbl_site site WITH (NOLOCK) ON ag.site = site.site
	GROUP BY b.winlostdate
		,b.custid
		,b.recommend
		,b.mrecommend
		,b.srecommend
		,CASE WHEN b.[recommend] = 52466 THEN - 2 WHEN b.[recommend] = 5707545 THEN - 4 ELSE isnull(site.siteid, - 1) END
		,b.Currency
		,b.gameID
		,b.Productid

	IF EXISTS(
			SELECT TOP 1 1
			FROM #mcCustLiveCasinoDaily
			)
	BEGIN
		DELETE b
		FROM bodb_Account.dbo.mcCustLiveCasinoDaily b
		WHERE b.rptDate >= @datestart
			AND b.rptDate <= @dateend
			AND EXISTS (
				SELECT TOP 1 1
				FROM #tblBettype sb
				WHERE b.BetType = sb.BetType
				)
			AND b.Currency NOT IN (20, 27, 28)

		INSERT INTO bodb_Account.dbo.mcCustLiveCasinoDaily (
			[rptDate]
			,custid
			,recommend
			,mrecommend
			,srecommend
			,siteid
			,Currency
			,bettype
			,leagueid
			,matchid
			,Stake
			,Actual_Stake
			,StakeRefund
			,Actual_StakeRefund
			,WinlossIBC
			,WinlossS
			,WinlossM
			,WinlossA
			,WinlossP
			,TurnoverIBC
			,TurnoverS
			,TurnoverM
			,TurnoverA
			,CommissionS
			,CommissionM
			,CommissionA
			,CommissionP
			,BetCount
			)
		SELECT [rptDate]
			,custid
			,recommend
			,mrecommend
			,srecommend
			,siteid
			,Currency
			,bettype
			,leagueid
			,matchid
			,Stake
			,Actual_Stake
			,StakeRefund
			,Actual_StakeRefund
			,WinlossIBC
			,WinlossS
			,WinlossM
			,WinlossA
			,WinlossP
			,TurnoverIBC
			,TurnoverS
			,TurnoverM
			,TurnoverA
			,CommissionS
			,CommissionM
			,CommissionA
			,CommissionP
			,BetCount
		FROM #mcCustLiveCasinoDaily
	END

	DROP TABLE #mcCustLiveCasinoDaily

	DROP TABLE #bettransRnG_bk

	DROP TABLE #tblBettype
END
