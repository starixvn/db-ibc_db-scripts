/*
	Created: Elodie
	Date: 20160301
	Task: copy stake level for newly created customers
	DB: DBCUST/CustDB
*/
--step 0: backup & copy stake level setting from LCS DB to DBTP for newly customers

CREATE TABLE #supers (custid int, currency INT)

INSERT INTO #supers(custid,currency)
SELECT custid, currency
FROM Customer WITH(NOLOCK)
WHERE roleid = 4 	
	AND custid NOT IN (SELECT custid FROM Dep_CustSuper WITH(NOLOCK))
	AND ci.currency IN (34,45,43) --IDR,WON,'THB'

--step 1: copy settings for newly created customers
CREATE TABLE #tmpCust (custid INT, roleid INT, syncLiveCasino BIT, uplineID INT, srecommend INT, currency INT)

DECLARE @StakeLevelList_2401 VARCHAR(100)= ''
		,@StakeLevelList_2402 VARCHAR(100)= ''
		,@StakeLevelList_2401_new VARCHAR(100)= ''
		,@currency INT
		,@custid INT
		,@uplineID INT
		,@roleid INT
		,@syncLiveCasino BIT
		,@max_custid INT
		,@max_custid2 INT
		,@srecommend INT

SELECT @max_custid = xx
		,@max_custid2 = yy	

INSERT INTO #tmpCust(custid, roleid, syncLiveCasino, uplineID, srecommend, currency)
SELECT DISTINCT ci.custid, roleid, syncLiveCasino,
		CASE WHEN roleid = 3 THEN srecommend
			WHEN roleid = 2 THEN mrecommend
			WHEN roleid = 1 THEN recommend  ELSE 0 END, srecommend, s.currency
FROM custinfo ci WITH(NOLOCK) 
	INNER JOIN #Supers s ON ci.srecommend = s.custid
WHERE ci.custid > @max_custid
	AND ci.custid <= @max_custid2


WHILE (1=1)
BEGIN
	SELECT TOP (1) @custid = custid
				,@roleid = roleid
				,@syncLiveCasino = syncLiveCasino
				,@UplineID = uplineID
				,@srecommend = srecommend
				,@currency = currency
	FROM #tmpCust		
	ORDER BY roleid DESC
			
	IF @@ROWCOUNT = 0
		BREAK;

	SELECT @StakeLevelList_2401_new = ''
		,@StakeLevelList_2401 = ''
		,@StakeLevelList_2402 = ''

	--Bettype 2402: Lowest VIP Bet limit
	SELECT TOP 1 @StakeLevelList_2402 = StakeLevelID 
	FROM dbo.StakeLevel WITH(NOLOCK) 
	WHERE ExchangeId = @currency AND GameTypeID = 2402 
	ORDER BY MaxStake, MinStake

	IF @syncLiveCasino = 1
	BEGIN
		--Bettype 2401: get stakelevel from LiveCasino
		SELECT @StakeLevelList_2401 = StakeLevelList
		FROM DBBingoAdmin.LiveCasinoAdmin.dbo.CustGameType s with(Nolock) 
		WHERE custid = @custid AND s.GameTypeID = 108
			
		SELECT @StakeLevelList_2401_new = @StakeLevelList_2401_new + CONVERT(VARCHAR(10),StakeLevelID2) + ','
		FROM (
		SELECT StakeLevelID2
		FROM dbo.tmpStakeLevel WITH(NOLOCK) 
		WHERE stakeLevelID IN (SELECT val FROM strSplit(@StakeLevelList_2401,','))
		)t 
					
		IF @StakeLevelList_2401_new <> ''
		BEGIN
			SELECT @StakeLevelList_2401_new = left(@StakeLevelList_2401_new,len(@StakeLevelList_2401_new) - 1)
		END
		
		IF @roleid = 1
			--Member Level
			INSERT INTO dbo.CustStakeLevel_Member(CustID, SportType, BetType, StakeLevelList)		
			SELECT @custid, 211, 2401, @StakeLevelList_2401_new 
			WHERE NOT EXISTS ( SELECT 1 FROM CustStakeLevel_Member WITH (NOLOCK) WHERE CustID = @custid AND SportType = 211 AND BetType = 2401)
			UNION ALL 
			SELECT @custid, 211, 2402, @StakeLevelList_2402
			WHERE NOT EXISTS ( SELECT 1 FROM CustStakeLevel_Member WITH (NOLOCK) WHERE CustID = @custid AND SportType = 211 AND BetType = 2402)
		ELSE
			--SMA Level
			INSERT INTO dbo.CustStakeLevel_Agent(CustID, SportType, BetType, StakeLevelList)		
			SELECT @custid, 211, 2401, @StakeLevelList_2401_new
			WHERE NOT EXISTS ( SELECT 1 FROM CustStakeLevel_Agent WITH (NOLOCK) WHERE CustID = @custid AND SportType = 211 AND BetType = 2401)
			UNION ALL 
			SELECT @custid, 211, 2402, @StakeLevelList_2402
			WHERE NOT EXISTS ( SELECT 1 FROM CustStakeLevel_Agent WITH (NOLOCK) WHERE CustID = @custid AND SportType = 211 AND BetType = 2402)
	END	
	ELSE--Un-sync LCS
	BEGIN
		IF EXISTS (SELECT 1 FROM CustInfo WITH (NOLOCK) WHERE custid = @srecommend AND syncLiveCasino = 0)
		BEGIN
			SELECT TOP 1 @StakeLevelList_2401 =  StakeLevelID 
			FROM dbo.StakeLevel WITH(NOLOCK) 
			WHERE ExchangeId = @currency AND GameTypeID = 2401
			ORDER BY MaxStake, MinStake

			IF @roleid = 1
			INSERT INTO dbo.CustStakeLevel_Member(CustID, SportType, BetType, StakeLevelList)
			SELECT @custid, 211, 2401, @StakeLevelList_2401
			WHERE NOT EXISTS ( SELECT 1 FROM CustStakeLevel_Member WITH (NOLOCK) WHERE CustID = @custid AND SportType = 211 AND BetType = 2401)
			UNION ALL
			SELECT @custid, 211, 2402, @StakeLevelList_2402
			WHERE NOT EXISTS ( SELECT 1 FROM CustStakeLevel_Member WITH (NOLOCK) WHERE CustID = @custid AND SportType = 211 AND BetType = 2402)
		ELSE
			INSERT INTO dbo.CustStakeLevel_Agent(CustID, SportType, BetType, StakeLevelList)
			SELECT @custid, 211, 2401, @StakeLevelList_2401
			WHERE NOT EXISTS ( SELECT 1 FROM CustStakeLevel_Agent WITH (NOLOCK) WHERE CustID = @custid AND SportType = 211 AND BetType = 2401)
			UNION ALL
			SELECT @custid, 211, 2402, @StakeLevelList_2402
			WHERE NOT EXISTS ( SELECT 1 FROM CustStakeLevel_Agent WITH (NOLOCK) WHERE CustID = @custid AND SportType = 211 AND BetType = 2402)
		END
		ELSE
		BEGIN
			IF @roleid = 1
				INSERT INTO dbo.CustStakeLevel_Member(CustID, SportType, BetType, StakeLevelList)
				SELECT @custid, 211, 2401, '' AS stakeLevelList
				WHERE NOT EXISTS ( SELECT 1 FROM CustStakeLevel_Member WITH (NOLOCK) WHERE CustID = @custid AND SportType = 211 AND BetType = 2401)
				UNION ALL
				SELECT @custid, 211, 2402, @StakeLevelList_2402
				WHERE NOT EXISTS ( SELECT 1 FROM CustStakeLevel_Member WITH (NOLOCK) WHERE CustID = @custid AND SportType = 211 AND BetType = 2402)
			ELSE
				INSERT INTO dbo.CustStakeLevel_Agent(CustID, SportType, BetType, StakeLevelList)
				SELECT @custid, 211, 2401, '' AS stakeLevelList
				WHERE NOT EXISTS ( SELECT 1 FROM CustStakeLevel_Agent WITH (NOLOCK) WHERE CustID = @custid AND SportType = 211 AND BetType = 2401)
				UNION ALL
				SELECT @custid, 211, 2402, @StakeLevelList_2402
				WHERE NOT EXISTS ( SELECT 1 FROM CustStakeLevel_Agent WITH (NOLOCK) WHERE CustID = @custid AND SportType = 211 AND BetType = 2402)
		END
	END	
	
	DELETE #tmpCust WHERE custid = @custid
END	

