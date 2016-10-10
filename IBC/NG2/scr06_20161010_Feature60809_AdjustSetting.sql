/*
	Created: Elodie
	Task: Adjust PT 
	DB: DBCUST/CustDB
	Date: 20161010
*/ 
CREATE TABLE #supers (custid INT PRIMARY KEY CLUSTERED)

INSERT INTO #supers(custid)
SELECT ci.custid
FROM customer ci WITH (NOLOCK) 
	INNER JOIN site s WITH (NOLOCK) ON ci.site = s.site
	LEFT JOIN custsuper cs WITH (NOLOCK) ON ci.custid = cs.custid
WHERE ci.roleid = 4  
			AND ci.username NOT LIKE '3rdSuper%'
			AND cs.isinternal = 0
			AND ci.custid NOT IN (SELECT custid FROM Dep_CustSuper WITH(NOLOCK))
			AND s.islicensee = 0
			AND ci.site IN ('789y')

CREATE TABLE #DestinationSportBetType(fSportType SMALLINT, fBetType SMALLINT,tSportType SMALLINT, tBetType SMALLINT, IsLive BIT,  SettingType INT)
INSERT INTO #DestinationSportBetType
SELECT 1, 1, SportType, BetType, 0, SettingType
FROM dbo.ProductSettingDetail WITH (NOLOCK)
WHERE ProductID = 23 AND SettingType IN (1)

--------------------------------------PT Setting-------------------------------------------------	
--Update PT for different settings (not adjust for line super who take pt RNG more than 93%)
--AGENT LEVEL
UPDATE csa
SET
	csa.SuperPT = cs.SPositionTaking  * 100,
	csa.MasterPT = cs.MPositionTaking *100,
	csa.AgentPT = cs.APositionTaking *100, 
	csa.IsAutoMasterPT = cs.IsAutoMPositionTaking,
	csa.AutoMasterPT = cs.AutoMPositionTaking *100, 
	csa.IsAutoSuperPT = cs.IsAutoPositionTaking, 
	csa.AutoSuperPT = cs.AutoPositionTaking, 
	csa.MinPT = CASE WHEN ci.roleid <> 4 THEN co.MinPositionTaking  * 100 ELSE 0 END
FROM dbo.custinfo ci WITH(NOLOCK)	
	INNER JOIN dbo.CustPTSetting3rd_Agent csa WITH(UPDLOCK,ROWLOCK) ON csa.custid = ci.custid
	INNER JOIN dbo.custSetting cs WITH (NOLOCK) ON cs.custid = ci.CustID
	INNER JOIN dbo.custOverride co WITH (NOLOCK) ON co.bettype = cs.bettype AND co.bettype = cs.BetType AND co.custid = cs.custid
	INNER JOIN #DestinationSportBetType dest ON dest.fSportType = cs.sporttype AND dest.fBetType = cs.bettype 
												AND dest.tSportType = csa.SportType AND dest.tBetType = csa.BetType AND dest.IsLive = csa.IsLive
WHERE ci.srecommend IN (SELECT custid FROM #supers) 
		AND ci.roleid IN (2,3,4) AND Enabled = 1
		AND (
			cs.SPositionTaking * 100 <> csa.SuperPT
			OR cs.MPositionTaking *100 <> csa.MasterPT
			OR cs.APositionTaking *100 <> csa.AgentPT
			OR cs.IsAutoMPositionTaking <> csa.IsAutoMasterPT
			OR cs.AutoMPositionTaking *100 <> csa.AutoMasterPT
			OR cs.IsAutoPositionTaking <> csa.IsAutoSuperPT
			OR cs.AutoPositionTaking *100 <> csa.AutoSuperPT
			OR co.MinPositionTaking  *100 <> csa.MinPT
		)

--MEMBER LEVEL
UPDATE csm
SET
	csm.SuperPT = cs.SPositionTaking  *100,
	csm.MasterPT = cs.MPositionTaking  *100,
	csm.AgentPT = cs.APositionTaking  *100, 
	csm.IsAutoMasterPT = cs.IsAutoMPositionTaking,
	csm.AutoMasterPT = cs.AutoMPositionTaking *100, 
	csm.IsAutoSuperPT = cs.IsAutoPositionTaking, 
	csm.AutoSuperPT = cs.AutoPositionTaking *100
FROM dbo.custinfo ci WITH(NOLOCK)
	INNER JOIN dbo.CustPTSetting3rd_Member csm WITH(UPDLOCK,ROWLOCK) ON csm.custid = ci.custid
	INNER JOIN dbo.custSetting cs WITH (NOLOCK) ON cs.custid = ci.CustID
	INNER JOIN dbo.custOverride co WITH (NOLOCK) ON co.bettype = cs.bettype AND co.bettype = cs.BetType AND co.custid = cs.custid
	INNER JOIN #DestinationSportBetType dest ON dest.fSportType = cs.sporttype AND dest.fBetType = cs.bettype 
												AND dest.tSportType = csm.SportType AND dest.tBetType = csm.BetType AND dest.IsLive = csm.IsLive
WHERE ci.srecommend IN (SELECT custid FROM #supers)  
		AND ci.roleid = 1 AND Enabled = 1
		AND (
			cs.SPositionTaking  *100 <> csm.SuperPT
			OR cs.MPositionTaking  *100 <> csm.MasterPT
			OR cs.APositionTaking  *100 <> csm.AgentPT
			OR cs.IsAutoMPositionTaking <> csm.IsAutoMasterPT
			OR cs.AutoMPositionTaking *100 <> csm.AutoMasterPT
			OR cs.IsAutoPositionTaking <> csm.IsAutoSuperPT
			OR cs.AutoPositionTaking  *100 <> csm.AutoSuperPT
			)

DROP TABLE #supers