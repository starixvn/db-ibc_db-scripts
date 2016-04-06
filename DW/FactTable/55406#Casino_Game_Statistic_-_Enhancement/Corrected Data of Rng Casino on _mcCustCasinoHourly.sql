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

	CREATE TABLE #mcCustCasinoHourly (
		rptDate DATE
		,CustId INT
		,recommend INT
		,srecommend INT
		,mrecommend INT
		,siteid SMALLINT
		,currency TINYINT
		,bettype SMALLINT
		,leagueid INT
		,[Hour] TINYINT
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
		,Actual_StakeRefund MONEY
		)

	INSERT INTO #mcCustCasinoHourly (
		rptDate
		,CustId
		,recommend
		,srecommend
		,mrecommend
		,siteid
		,currency
		,bettype
		,leagueid
		,[Hour]
		,Stake
		,StakeRefund
		,Actual_Stake
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
		,ISNULL(site.siteid, - 1) siteid
		,b.Currency
		,b.gameID bettype
		,- 1 leagueid
		,
		--DATEPART(HOUR, transdate) AS Hour,
		CASE WHEN DATEDIFF(dd, transdate, winlostdate) = 1
				AND DATEPART(HOUR, transdate) = 23 THEN 0 --bet at 23PM then convert to 0 AM 
			ELSE DATEPART(HOUR, transdate) END AS [Hour]
		,SUM(CASE WHEN st.statusid IN (9, 10, 14) THEN 0 ELSE b.Stake END) Stake
		,SUM(CASE WHEN st.statusid IN (9, 10, 14) THEN b.Stake ELSE 0 END) StakeRefund
		,SUM(CASE WHEN st.statusid IN (9, 10, 14) THEN 0 ELSE b.Actual_Stake END) Actual_Stake
		,SUM(CASE WHEN st.statusid IN (9, 10, 14) THEN b.Actual_Stake ELSE 0 END) Actual_StakeRefund
		,SUM(CASE WHEN st.statusid IN (9, 10, 14) THEN 0 ELSE (1 - tpositiontaking) * (b.winlost - b.actual_stake) END) AS WinlossIBC
		,SUM(CASE WHEN st.statusid IN (9, 10, 14) THEN 0 ELSE b.swinlost END) WinlossS
		,SUM(CASE WHEN st.statusid IN (9, 10, 14) THEN 0 ELSE b.mwinlost END) WinlossM
		,SUM(CASE WHEN st.statusid IN (9, 10, 14) THEN 0 ELSE b.awinlost END) WinlossA
		,SUM(CASE WHEN st.statusid IN (9, 10, 14) THEN 0 ELSE b.winlost - b.actual_stake END) WinlossP
		,SUM(CASE WHEN st.statusid IN (9, 10, 14) THEN 0 ELSE ABS(stake) * (1 - b.tpositiontaking) END) TurnoverIBC
		,SUM(CASE WHEN st.statusid IN (9, 10, 14) THEN 0 ELSE ABS(stake) * (b.spositiontaking) END) TurnoverS
		,SUM(CASE WHEN st.statusid IN (9, 10, 14) THEN 0 ELSE ABS(stake) * (b.mpositiontaking) END) TurnoverM
		,SUM(CASE WHEN st.statusid IN (9, 10, 14) THEN 0 ELSE ABS(stake) * (b.apositiontaking) END) TurnoverA
		,SUM(CASE WHEN st.statusid IN (9, 10, 14) THEN 0 ELSE b.scomm END) CommissionS
		,SUM(CASE WHEN st.statusid IN (9, 10, 14) THEN 0 ELSE b.acomm END) CommissionM
		,SUM(CASE WHEN st.statusid IN (9, 10, 14) THEN 0 ELSE b.comm END) CommissionA
		,SUM(CASE WHEN st.statusid IN (9, 10, 14) THEN 0 ELSE b.playercomm END) CommissionP
		,SUM(CASE WHEN st.statusid IN (9, 10, 14) THEN 0 ELSE 1 END) BetCount
	FROM #bettransRnG_bk b WITH (NOLOCK)
		LEFT JOIN bodb_Account.dbo.tbl_Status st WITH (NOLOCK) ON b.STATUS = st.STATUS
		LEFT JOIN bodb02.dbo.customer ag WITH (NOLOCK) ON b.recommend = ag.custid
		AND ag.roleid = 2
		LEFT JOIN bodb_Account.dbo.tbl_site site WITH (NOLOCK) ON site.site = ag.site
	GROUP BY b.winlostdate
		,b.custid
		,b.recommend
		,b.mrecommend
		,b.srecommend
		,site.siteid
		,b.Currency
		,b.gameID
		,CASE WHEN DATEDIFF(dd, transdate, winlostdate) = 1
				AND DATEPART(HOUR, transdate) = 23 THEN 0 --bet at 23PM then convert to 0 AM 
			ELSE DATEPART(HOUR, transdate) END

	IF EXISTS (
			SELECT TOP 1 1
			FROM #mcCustCasinoHourly
			)
	BEGIN
		DELETE b
		FROM bodb_Account.dbo.mcCustCasinoHourly b
		WHERE b.rptDate >= @datestart
			AND b.rptDate <= @dateend
			AND EXISTS (
				SELECT TOP 1 1
				FROM #tblBettype sb
				WHERE b.BetType = sb.BetType
				)
			AND b.Currency NOT IN (20, 27, 28)

		INSERT INTO bodb_Account.dbo.mcCustCasinoHourly (
			rptDate
			,CustId
			,recommend
			,srecommend
			,mrecommend
			,siteid
			,currency
			,bettype
			,leagueid
			,[Hour]
			,Stake
			,StakeRefund
			,Actual_Stake
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
		SELECT rptDate
			,CustId
			,recommend
			,srecommend
			,mrecommend
			,siteid
			,currency
			,bettype
			,leagueid
			,[Hour]
			,Stake
			,StakeRefund
			,Actual_Stake
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
		FROM #mcCustCasinoHourly
	END

	DROP TABLE #bettransRnG_bk

	DROP TABLE #mcCustCasinoHourly

	DROP TABLE #tblBettype
END
