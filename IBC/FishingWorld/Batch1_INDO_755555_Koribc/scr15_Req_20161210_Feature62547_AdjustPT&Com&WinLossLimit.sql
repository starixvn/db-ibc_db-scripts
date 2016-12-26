/*
	Created: Helen
	Task: Adjust PT 
	DB: DBCUST/CustDB
	Date: 20161210
*/ 

CREATE TABLE #supers (custid int)
	
INSERT INTO #supers(custid)
SELECT ci.custid
FROM dbo.Customer ci WITH(NOLOCK)
WHERE (ci.roleid = 4 	
	AND ci.custid NOT IN (SELECT custid FROM Dep_CustSuper WITH(NOLOCK))
	-- Production
	AND ci.site in ('INDO','755555','Koribc')
	AND ci.custid <> 72 )
	
	OR ci.custid IN (2,4,13,15) -- DUMMY
	
CREATE TABLE #DestinationSportBetType(fSportType SMALLINT, fBetType SMALLINT,tSportType SMALLINT, tBetType SMALLINT, IsLive BIT,  SettingType INT)
INSERT INTO #DestinationSportBetType
VALUES
(161, 85, 219	, 1011, 0, 1) --PT

DECLARE @MaxPT TINYINT
SELECT @MaxPT = MaxPT FROM dbo.ProductSettingDetail WITH (NOLOCK) WHERE ProductID = 24 AND SettingType = 1
--------------------------------------WinLossLimit-------------------------------------------------
/*
	DONE NOTHING	
*/
--------------------------------------PT Setting-------------------------------------------------	
--Update PT for different settings (not adjust for line super who take pt LCS more than 93%)
--AGENT LEVEL
CREATE TABLE #MemberTemp_adjusted (custid INT)

UPDATE cs1
SET cs1.SuperPT = cs2.slivepositiontaking * 100,
	cs1.MasterPT = cs2.mlivepositiontaking * 100,
	cs1.AgentPT = cs2.alivepositiontaking * 100,
	cs1.IsAutoMasterPT = cs2.isautolivempositiontaking,
	cs1.AutoMasterPT = cs2.autolivempositiontaking * 100,
	cs1.IsAutoSuperPT = cs2.isautolivepositiontaking,
	cs1.AutoSuperPT = cs2.autolivepositiontaking * 100,
	cs1.MinPT = co.minlivepositiontaking * 100

OUTPUT inserted.CustId
INTO #MemberTemp_adjusted(CustId) 

FROM dbo.custInfo ci WITH (NOLOCK) 
	INNER JOIN dbo.CustPTSetting3rd_Agent cs1 WITH(ROWLOCK,UPDLOCK) ON ci.custid = cs1.CustID
	INNER JOIN CustSetting3rd cs2 ON cs2.CustID = cs1.CustID
	INNER JOIN dbo.custOverride3rd co WITH (NOLOCK) ON cs1.CustID = co.CustID AND co.Sporttype = cs2.Sporttype AND co.Bettype = cs2.Bettype
	INNER JOIN #DestinationSportBetType dest WITH(NOLOCK) ON dest.SettingType = 1 AND cs2.bettype = dest.fBetType AND cs2.sporttype = dest.fSportType AND cs1.SportType = dest.tSportType AND cs1.BetType = dest.tBetType
WHERE ci.roleid IN (2,3,4) AND ci.Enabled = 1
	AND ci.srecommend IN (SELECT s.custid 
						FROM #supers s 
							INNER JOIN CustSetting3rd cs WITH(NOLOCK) ON s.custid = cs.custid AND cs.sporttype = 161 AND cs.bettype = 85
						--WHERE slivepositiontaking <= @MaxPT
						) 
	AND (cs1.SuperPT <> (cs2.slivepositiontaking * 100) OR
			cs1.MasterPT <> (cs2.mlivepositiontaking * 100) OR
			cs1.AgentPT <> (cs2.alivepositiontaking * 100) OR
			cs1.IsAutoMasterPT <> cs2.isautolivempositiontaking OR
			cs1.AutoMasterPT <> (cs2.autolivempositiontaking * 100) OR
			cs1.IsAutoSuperPT <> cs2.isautolivepositiontaking OR
			cs1.AutoSuperPT <> (cs2.autolivepositiontaking * 100) OR
			cs1.MinPT <> co.minlivepositiontaking * 100)

--MEMBER LEVEL

UPDATE cs1
SET cs1.SuperPT = cs2.slivepositiontaking * 100,
	cs1.MasterPT = cs2.mlivepositiontaking * 100,
	cs1.AgentPT = cs2.alivepositiontaking * 100,
	cs1.IsAutoMasterPT = cs2.isautolivempositiontaking,
	cs1.AutoMasterPT = cs2.autolivempositiontaking * 100,
	cs1.IsAutoSuperPT = cs2.isautolivepositiontaking,
	cs1.AutoSuperPT = cs2.autolivepositiontaking * 100

OUTPUT inserted.CustId
	INTO #MemberTemp_adjusted(CustId) 
						
FROM dbo.custInfo ci WITH (NOLOCK) 
	INNER JOIN dbo.CustPTSetting3rd_Member cs1 WITH(ROWLOCK,UPDLOCK) ON ci.custid = cs1.CustID
	INNER JOIN CustSetting3rd cs2 ON cs2.CustID = cs1.CustID
	INNER JOIN #DestinationSportBetType dest WITH(NOLOCK) ON dest.SettingType = 1 AND cs2.bettype = dest.fBetType AND cs2.sporttype = dest.fSportType AND cs1.SportType = dest.tSportType AND cs1.BetType = dest.tBetType
WHERE ci.roleid = 1 AND ci.Enabled = 1
	AND ci.srecommend IN (SELECT s.custid 
						FROM #supers s 
							INNER JOIN CustSetting3rd cs WITH(NOLOCK) ON s.custid = cs.custid AND cs.sporttype = 161 AND cs.bettype = 85
						--WHERE slivepositiontaking <= @MaxPT
						) 
	AND (cs1.SuperPT <> (cs2.slivepositiontaking * 100) OR
			cs1.MasterPT <> (cs2.mlivepositiontaking * 100) OR
			cs1.AgentPT <> (cs2.alivepositiontaking * 100) OR
			cs1.IsAutoMasterPT <> cs2.isautolivempositiontaking OR
			cs1.AutoMasterPT <> (cs2.autolivempositiontaking * 100) OR
			cs1.IsAutoSuperPT <> cs2.isautolivepositiontaking OR
			cs1.AutoSuperPT <> (cs2.autolivepositiontaking * 100))	

DECLARE @srecommend INT
DECLARE @SportBettypeXML VARCHAR(MAX)
CREATE TABLE #Super_Only (custid int,isfinished bit default(0))

IF EXISTS (SELECT 1 FROM #MemberTemp_adjusted)
BEGIN

	INSERT INTO #Super_Only (custid)
	SELECT DISTINCT ci.srecommend
	FROM #MemberTemp_adjusted M
		INNER JOIN custInfo CI WITH (NOLOCK) ON M.custid = ci.custid
	
	SET @SportBettypeXML = '<ROOT><PT SportType="219" BetType="1011" IsLive="0" /></ROOT>'
	
	WHILE (1 = 1)
	BEGIN
		UPDATE TOP (1) #Super_Only
		SET isfinished = 1
			,@srecommend = custid	
		WHERE isfinished = 0
		
		IF @@ROWCOUNT = 0 BREAK
				
		EXEC Acc_DynamicCustSetting3rd_07 @SuperID = @srecommend,@SportBettypeXML = @SportBettypeXML, @Roleid = 4
		
	END
	
END

DROP TABLE #DestinationSportBetType	
DROP TABLE #MemberTemp_adjusted
DROP TABLE #Super_Only
DROP TABLE #supers
