/*
	Created: Helen
	Task: Adjust PT &  WinLossLimit 
	DB: DBCUST/CustDB
	Date: 20161210
*/ 

CREATE TABLE #supers (custid int)
	
INSERT INTO #supers(custid)
SELECT ci.custid
FROM dbo.Customer ci WITH(NOLOCK)
WHERE ci.roleid = 4 	
	AND ci.custid NOT IN (SELECT custid FROM Dep_CustSuper WITH(NOLOCK))
	-- Production
	AND ci.site in ('INDO','755555','Koribc')
	AND ci.custid <> 72
	AND ci.custid NOT IN (2,4,13,15)
	
CREATE TABLE #DestinationSportBetType(fSportType SMALLINT, fBetType SMALLINT,tSportType SMALLINT, tBetType SMALLINT, IsLive BIT,  SettingType INT)
INSERT INTO #DestinationSportBetType
VALUES
(161, 85, 219	, 1011, 0, 1), --PT
(219, 1011, 219	, 1011, 0, 6) --WinLossLimit

CREATE TABLE #MemberTemp
(
	CustID INT PRIMARY KEY CLUSTERED,
	SyncLiveCasino BIT,
	MaxWinLiveCasino SMALLMONEY,
	isAutoResetLiveCasino BIT
)

CREATE TABLE #SMATemp
(
	CustID INT PRIMARY KEY CLUSTERED,
	roleid TINYINT,
	SyncLiveCasino BIT,
	MaxWinLiveCasino SMALLMONEY,
	isAutoResetLiveCasino BIT
)

INSERT INTO #MemberTemp (CustID, SyncLiveCasino, MaxWinLiveCasino, isAutoResetLiveCasino)
SELECT custid, SyncLiveCasino, MaxWinLiveCasino, isAutoResetLiveCasino
FROM Custinfo WITH (NOLOCK)
WHERE srecommend IN (SELECT custid FROM #supers) AND roleid = 1  AND Enabled = 1
	
	
INSERT INTO #SMATemp (CustID, roleid, SyncLiveCasino, MaxWinLiveCasino, isAutoResetLiveCasino)
SELECT custid, roleid, SyncLiveCasino, MaxWinLiveCasino, isAutoResetLiveCasino
FROM Custinfo WITH (NOLOCK)
WHERE srecommend IN (SELECT custid FROM #supers) AND roleid IN (2,3,4) AND Enabled = 1

------------STARTING Dummy Processing
CREATE TABLE #DirectMaster (CustID INT PRIMARY KEY,roleid INT)
CREATE TABLE #DirectAgent (CustID INT PRIMARY KEY,mrecommend INT,roleid INT)

--- get direct master
INSERT INTO #DirectMaster (CustID,roleid)
SELECT custid, roleid
FROM Customer with(nolock)
WHERE SITE in ('INDO','755555','Koribc')
	and custid NOT IN (SELECT custid from Acc_CustDirect WITH(NOLOCK))
	and srecommend IN (SELECT custid from Acc_CustDirect WITH(NOLOCK))
	and roleid=3 AND srecommend IN (2,4,13,15)

--- get direct agent
INSERT INTO #DirectAgent (CustID,mrecommend,roleid)
SELECT custid, mrecommend,roleid
FROM Customer WITH(NOLOCK)
WHERE site in ('INDO','755555','Koribc')
	and custid NOT IN (SELECT custid from Acc_CustDirect WITH(NOLOCK))
	and mrecommend IN (SELECT custid from Acc_CustDirect WITH(NOLOCK))
	and roleid=2 AND srecommend IN (2,4,13,15)

----------- For SMA  -----------
INSERT INTO #SMATemp (CustID, roleid, SyncLiveCasino, MaxWinLiveCasino, isAutoResetLiveCasino)
-- NO NEED TO ADD SUPER, it's added already
SELECT ci.custid, ci.roleid, ci.SyncLiveCasino, ci.MaxWinLiveCasino, ci.isAutoResetLiveCasino -- Direct Master 
FROM custInfo CI WITH (NOLOCK)
	INNER JOIN #DirectMaster D ON CI.custid = D.CustID 


UNION ALL
SELECT DISTINCT ci.custid, ci.roleid, ci.SyncLiveCasino, ci.MaxWinLiveCasino, ci.isAutoResetLiveCasino -- Master of direct agent
FROM custInfo CI WITH (NOLOCK)
	INNER JOIN #DirectAgent D ON CI.custid = D.mrecommend 

	
UNION ALL

SELECT ci.custid, ci.roleid, ci.SyncLiveCasino, ci.MaxWinLiveCasino, ci.isAutoResetLiveCasino -- Agent of direct master
FROM custInfo CI WITH (NOLOCK)
	INNER JOIN #DirectMaster D ON CI.mrecommend = D.CustID 
WHERE CI.roleid = 2
	
UNION ALL
SELECT ci.custid, ci.roleid, ci.SyncLiveCasino, ci.MaxWinLiveCasino, ci.isAutoResetLiveCasino -- Direct Agent
FROM custInfo CI WITH (NOLOCK)
	INNER JOIN #DirectAgent D ON CI.custid = D.CustID 

---------- For members ---------
INSERT INTO #MemberTemp (CustID, SyncLiveCasino, MaxWinLiveCasino, isAutoResetLiveCasino)
SELECT ci.CustID, ci.SyncLiveCasino, ci.MaxWinLiveCasino, ci.isAutoResetLiveCasino
FROM Custinfo CI WITH (NOLOCK)
	INNER JOIN #DirectMaster M ON CI.mrecommend = M.CustID
WHERE CI.roleid = 1	
	
UNION ALL
SELECT ci.CustID, ci.SyncLiveCasino, ci.MaxWinLiveCasino, ci.isAutoResetLiveCasino
FROM Custinfo CI WITH (NOLOCK)
	INNER JOIN #DirectAgent M ON CI.recommend = M.CustID
WHERE CI.roleid = 1 

-------------END of Dummny Processing----------------------------
DECLARE @MaxPT TINYINT
SELECT @MaxPT = MaxPT FROM dbo.ProductSettingDetail WITH (NOLOCK) WHERE ProductID = 24 AND SettingType = 1
--------------------------------------WinLossLimit-------------------------------------------------
/*
	DONE NOTHING	
*/
--------------------------------------PT Setting-------------------------------------------------	
--Update PT for different settings (not adjust for line super who take pt LCS more than 93%)
--AGENT LEVEL
UPDATE cs1
SET cs1.SuperPT = cs2.spositiontaking * 100,
	cs1.MasterPT = cs2.mpositiontaking * 100,
	cs1.AgentPT = cs2.apositiontaking * 100,
	cs1.IsAutoMasterPT = cs2.isautompositiontaking,
	cs1.AutoMasterPT = cs2.autompositiontaking * 100,
	cs1.IsAutoSuperPT = cs2.isautopositiontaking,
	cs1.AutoSuperPT = cs2.autopositiontaking * 100,
	cs1.MinPT = co.minpositiontaking * 100
FROM dbo.custInfo ci WITH (NOLOCK) 
	INNER JOIN dbo.CustPTSetting3rd_Agent cs1 WITH(ROWLOCK,UPDLOCK) ON ci.custid = cs1.CustID
	INNER JOIN CustSetting3rd cs2 ON cs2.CustID = cs1.CustID
	INNER JOIN dbo.custOverride3rd co WITH (NOLOCK) ON cs1.CustID = co.CustID AND co.Sporttype = cs2.Sporttype AND co.Bettype = cs2.Bettype
	INNER JOIN #DestinationSportBetType dest WITH(NOLOCK) ON dest.SettingType = 1 AND cs2.bettype = dest.fBetType AND cs2.sporttype = dest.fSportType AND cs1.SportType = dest.tSportType AND cs1.BetType = dest.tBetType
WHERE ci.roleid IN (2,3,4) AND ci.Enabled = 1
	AND ci.srecommend IN (SELECT s.custid 
						FROM #supers s 
							INNER JOIN CustSetting3rd cs WITH(NOLOCK) ON s.custid = cs.custid AND cs.sporttype = 161 AND cs.bettype = 85
						WHERE spositiontaking <= @MaxPT) 
	AND (cs1.SuperPT <> (cs2.spositiontaking * 100) OR
			cs1.MasterPT <> (cs2.mpositiontaking * 100) OR
			cs1.AgentPT <> (cs2.apositiontaking * 100) OR
			cs1.IsAutoMasterPT <> cs2.isautompositiontaking OR
			cs1.AutoMasterPT <> (cs2.autompositiontaking * 100) OR
			cs1.IsAutoSuperPT <> cs2.isautopositiontaking OR
			cs1.AutoSuperPT <> (cs2.autopositiontaking * 100) OR
			cs1.MinPT <> co.minpositiontaking * 100)

--MEMBER LEVEL
UPDATE cs1
SET cs1.SuperPT = cs2.spositiontaking * 100,
	cs1.MasterPT = cs2.mpositiontaking * 100,
	cs1.AgentPT = cs2.apositiontaking * 100,
	cs1.IsAutoMasterPT = cs2.isautompositiontaking,
	cs1.AutoMasterPT = cs2.autompositiontaking * 100,
	cs1.IsAutoSuperPT = cs2.isautopositiontaking,
	cs1.AutoSuperPT = cs2.autopositiontaking * 100
FROM dbo.custInfo ci WITH (NOLOCK) 
	INNER JOIN dbo.CustPTSetting3rd_Member cs1 WITH(ROWLOCK,UPDLOCK) ON ci.custid = cs1.CustID
	INNER JOIN CustSetting3rd cs2 ON cs2.CustID = cs1.CustID
	INNER JOIN dbo.custOverride3rd co WITH (NOLOCK) ON cs1.CustID = co.CustID AND co.Sporttype = cs2.Sporttype AND co.Bettype = cs2.Bettype
	INNER JOIN #DestinationSportBetType dest WITH(NOLOCK) ON dest.SettingType = 1 AND cs2.bettype = dest.fBetType AND cs2.sporttype = dest.fSportType AND cs1.SportType = dest.tSportType AND cs1.BetType = dest.tBetType
WHERE ci.roleid = 1 AND ci.Enabled = 1
	AND ci.srecommend IN (SELECT s.custid 
						FROM #supers s 
							INNER JOIN CustSetting3rd cs WITH(NOLOCK) ON s.custid = cs.custid AND cs.sporttype = 161 AND cs.bettype = 85
						WHERE spositiontaking <= @MaxPT) 
	AND (cs1.SuperPT <> (cs2.spositiontaking * 100) OR
			cs1.MasterPT <> (cs2.mpositiontaking * 100) OR
			cs1.AgentPT <> (cs2.apositiontaking * 100) OR
			cs1.IsAutoMasterPT <> cs2.isautompositiontaking OR
			cs1.AutoMasterPT <> (cs2.autompositiontaking * 100) OR
			cs1.IsAutoSuperPT <> cs2.isautopositiontaking OR
			cs1.AutoSuperPT <> (cs2.autopositiontaking * 100))	

DROP TABLE #SMATemp
DROP TABLE #MemberTemp
DROP TABLE #DestinationSportBetType	