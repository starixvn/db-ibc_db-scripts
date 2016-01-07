/*
	Created: Dominic
	Date: 2015-11-25 
	Task: Update Bet Setting / Position Taking / Discount of CockFighting for credit customer if there are any changes
	DB: DBCust.CustDB
*/  
	CREATE TABLE #SMABetLimitCust(CustID INT ,fSportType SMALLINT, fBetType SMALLINT,tSportType SMALLINT, tBetType SMALLINT, maxpermatch99 MONEY)
	CREATE TABLE #MemberBetLimitCust(CustID INT ,fSportType SMALLINT, fBetType SMALLINT,tSportType SMALLINT, tBetType SMALLINT, maxpermatch99 MONEY)
	CREATE TABLE #MemberDiscountCust(CustID INT ,fSportType SMALLINT, fBetType SMALLINT,tSportType SMALLINT, tBetType SMALLINT)
	CREATE TABLE #SMADiscountCust(CustID INT ,fSportType SMALLINT, fBetType SMALLINT,tSportType SMALLINT, tBetType SMALLINT)
	
	CREATE TABLE #supers (custid int)
	
	INSERT INTO #supers(custid)
	SELECT ci.custid
	FROM dbo.Customer ci WITH(NOLOCK)
	WHERE ci.roleid = 4 	
		AND ci.custid NOT IN (SELECT custid FROM Dep_CustSuper WITH(NOLOCK))
		AND ci.site <> '789y'
		AND ci.Currency = 20
		
	CREATE TABLE #DestinationSportBetType(fSportType SMALLINT, fBetType SMALLINT,tSportType SMALLINT, tBetType SMALLINT, IsLive BIT,  SettingType INT)
	INSERT INTO #DestinationSportBetType
	VALUES
	(99, 1, 206	,1003, 0, 1), --PT
	(99, 1, 206	,1003, 0, 2), --Bet Limit
	(99, 1, 206	,1003, 0, 3) --Discount

	
	/*****************************STEP 1 : Get Affected Customers**************************/
	--SMA Bet Limit
	INSERT INTO #SMABetLimitCust(CustID,fSportType,fBetType,tSportType,tBetType,maxpermatch99)
	SELECT ci.custid,map.fSportType,map.fBetType,map.tSportType,map.tBetType,ci.maxpermatch99
	FROM dbo.custinfo ci WITH(NOLOCK)
		CROSS JOIN #DestinationSportBetType map WITH(NOLOCK)
		INNER JOIN dbo.CustBetSetting3rd_Agent csa WITH(UPDLOCK,ROWLOCK)
			ON csa.CustID = ci.custid 
					AND csa.SportType = map.tSportType 
					AND csa.BetType = map.tBetType 
		INNER JOIN dbo.CustSetting cs WITH(NOLOCK) 
				ON cs.custid = ci.custid 
					AND cs.sporttype = map.fSportType 
					AND cs.bettype = map.fBetType
	WHERE map.SettingType = 2 AND ci.roleid IN (2,3,4) AND ci.srecommend IN (SELECT CustID FROM #supers)
			AND (
				cs.minbet <> csa.MinBet
				OR
				cs.maxbet <> csa.MaxBet
				OR
				ci.maxpermatch99 <> csa.MaxPerMatch
			)	
			
	--Member Bet Limit		
	INSERT INTO #MemberBetLimitCust(CustID,fSportType,fBetType,tSportType,tBetType,maxpermatch99)
	SELECT ci.custid,map.fSportType,map.fBetType,map.tSportType,map.tBetType,ci.maxpermatch99
	FROM custinfo ci WITH(NOLOCK)
		CROSS JOIN #DestinationSportBetType map WITH(NOLOCK)
		INNER JOIN dbo.CustBetSetting3rd_Member csm WITH(UPDLOCK,ROWLOCK)
			ON csm.CustID = ci.custid 
					AND csm.SportType = map.tSportType 
					AND csm.BetType = map.tBetType 
		INNER JOIN dbo.CustSetting cs WITH(NOLOCK) 
				ON cs.custid = ci.custid 
					AND cs.sporttype = map.fSportType 
					AND cs.bettype = map.fBetType
	WHERE map.SettingType = 2 AND ci.roleid = 1 AND ci.srecommend IN (SELECT CustID FROM #supers)
			AND (
				cs.minbet <> csm.MinBet
				OR
				cs.maxbet <> csm.MaxBet
				OR
				ci.maxpermatch99 <> csm.MaxPerMatch
			)
			
	--SMA Discount
	INSERT INTO #SMADiscountCust(CustID,fSportType,fBetType,tSportType,tBetType)
	SELECT ci.custid,map.fSportType,map.fBetType,map.tSportType,map.tBetType
	FROM dbo.custinfo ci WITH(NOLOCK)
		CROSS JOIN #DestinationSportBetType map WITH(NOLOCK)
		INNER JOIN dbo.CustDiscount3rd_Agent csa WITH(UPDLOCK,ROWLOCK)
			ON csa.CustID = ci.custid 
					AND csa.SportType = map.tSportType 
					AND csa.BetType = map.tBetType 
		INNER JOIN dbo.CustSetting cs WITH(NOLOCK) 
				ON cs.custid = ci.custid 
					AND cs.sporttype = map.fSportType 
					AND cs.bettype = map.fBetType
	WHERE map.SettingType = 3 AND ci.roleid IN (2,3,4) AND ci.srecommend IN (SELECT CustID FROM #supers)
			AND (
				cs.groupa <> csa.Discount
			)
			
	--SMA Discount
	INSERT INTO #MemberDiscountCust(CustID,fSportType,fBetType,tSportType,tBetType)
	SELECT ci.custid,map.fSportType,map.fBetType,map.tSportType,map.tBetType
	FROM dbo.custinfo ci WITH(NOLOCK)
		CROSS JOIN #DestinationSportBetType map WITH(NOLOCK)
		INNER JOIN dbo.CustDiscount3rd_Member csm WITH(UPDLOCK,ROWLOCK)
			ON csm.CustID = ci.custid 
					AND csm.SportType = map.tSportType 
					AND csm.BetType = map.tBetType 
		INNER JOIN dbo.CustSetting cs WITH(NOLOCK) 
				ON cs.custid = ci.custid 
					AND cs.sporttype = map.fSportType 
					AND cs.bettype = map.fBetType
	WHERE map.SettingType = 3 AND ci.roleid = 1 AND ci.srecommend IN (SELECT CustID FROM #supers)
			AND (
				cs.playerdiscount <> csm.PlayerDiscount
				OR cs.discount <> csm.AgentDiscount
				OR cs.adiscount <> csm.MasterDiscount
				OR cs.sdiscount <> csm.SuperDiscount
			)
	/*****************************STEP 2: Update affected customers**************************/
	--BET LIMIT of SMA 
	UPDATE csa
	SET
		csa.MinBet = cs.minbet,
		csa.MaxBet = cs.maxbet,
		csa.MaxPerMatch = ci.maxpermatch99
	FROM #SMABetLimitCust ci WITH(NOLOCK)
		INNER JOIN dbo.CustBetSetting3rd_Agent csa WITH(UPDLOCK,ROWLOCK)
			ON csa.CustID = ci.custid 
					AND csa.SportType = ci.tSportType 
					AND csa.BetType = ci.tBetType 
		INNER JOIN dbo.CustSetting cs WITH(NOLOCK) 
				ON cs.custid = ci.custid 
					AND cs.sporttype = ci.fSportType 
					AND cs.bettype = ci.fBetType
			

	 
	--BET LIMIT of Member 
	UPDATE csm
	SET
		csm.MinBet = cs.minbet,
		csm.MaxBet = cs.maxbet,
		csm.MaxPerMatch = ci.maxpermatch99
	FROM #MemberBetLimitCust ci WITH(NOLOCK)
		INNER JOIN dbo.CustBetSetting3rd_Member csm WITH(UPDLOCK,ROWLOCK)
			ON csm.CustID = ci.custid 
					AND csm.SportType = ci.tSportType 
					AND csm.BetType = ci.tBetType 
		INNER JOIN dbo.CustSetting cs WITH(NOLOCK) 
				ON cs.custid = ci.custid 
					AND cs.sporttype = ci.fSportType 
					AND cs.bettype = ci.fBetType

	--Discount of SMA 
	UPDATE csa
	SET
		csa.Discount = cs.groupa
	FROM #SMADiscountCust ci WITH(NOLOCK)
		INNER JOIN dbo.CustDiscount3rd_Agent csa WITH(UPDLOCK,ROWLOCK)
			ON csa.CustID = ci.custid 
					AND csa.SportType = ci.tSportType 
					AND csa.BetType = ci.tBetType 
		INNER JOIN dbo.CustSetting cs WITH(NOLOCK) 
				ON cs.custid = ci.custid 
					AND cs.sporttype = ci.fSportType 
					AND cs.bettype = ci.fBetType
					
	--Discount of Member 
	UPDATE csm
	SET
		csm.PlayerDiscount = cs.playerdiscount,
		csm.AgentDiscount = cs.discount,
		csm.MasterDiscount = cs.adiscount,
		csm.SuperDiscount = cs.sdiscount
	FROM #MemberDiscountCust ci WITH(NOLOCK)
		INNER JOIN dbo.CustDiscount3rd_Member csm WITH(UPDLOCK,ROWLOCK)
			ON csm.CustID = ci.custid 
					AND csm.SportType = ci.tSportType 
					AND csm.BetType = ci.tBetType 
		INNER JOIN dbo.CustSetting cs WITH(NOLOCK) 
				ON cs.custid = ci.custid 
					AND cs.sporttype = ci.fSportType 
					AND cs.bettype = ci.fBetType