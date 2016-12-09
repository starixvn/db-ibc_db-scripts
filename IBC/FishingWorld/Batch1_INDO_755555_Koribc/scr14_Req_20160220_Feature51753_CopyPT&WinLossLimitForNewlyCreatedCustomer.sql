/*
	Created: Helen
	Task: Copy PT & Comm & WinLossLimit for newly created customer
	DB: DBCUST/CustDB
	Date: 20150626
*/ 
		
DECLARE @maxcustid INT, @exchangeid INT
	
SELECT @maxcustid = xxx
	
CREATE TABLE #supers (custid int,exchangeid INT)
	
INSERT INTO #supers(custid,exchangeid)
SELECT ci.custid,ci.currency
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
)

CREATE TABLE #SMATemp
(
	CustID INT PRIMARY KEY CLUSTERED,	
	roleid TINYINT
)
	
INSERT INTO #MemberTemp (CustID)
SELECT custid
FROM Custinfo WITH (NOLOCK)
WHERE srecommend IN (SELECT custid FROM #supers) AND roleid = 1  AND Enabled = 1 AND custid > @maxcustid
	
INSERT INTO #SMATemp (CustID, roleid)
SELECT custid, roleid
FROM Custinfo WITH (NOLOCK)
WHERE srecommend IN (SELECT custid FROM #supers) AND roleid IN (2,3,4) AND Enabled = 1 AND custid > @maxcustid 

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
INSERT INTO #SMATemp (CustID,roleid)
-- NO NEED TO ADD SUPER, it's added already
SELECT CI.CustID,CI.roleid -- Direct Master 
FROM custInfo CI WITH (NOLOCK)
	INNER JOIN #DirectMaster D ON CI.custid = D.CustID 
WHERE ci.custid > @maxcustid 

UNION ALL
SELECT DISTINCT CI.CustID,CI.roleid -- Master of direct agent
FROM custInfo CI WITH (NOLOCK)
	INNER JOIN #DirectAgent D ON CI.custid = D.mrecommend 
WHERE ci.custid > @maxcustid 
	
UNION ALL

SELECT CI.CustID,CI.roleid -- Agent of direct master
FROM custInfo CI WITH (NOLOCK)
	INNER JOIN #DirectMaster D ON CI.mrecommend = D.CustID 
WHERE CI.roleid = 2
	AND ci.custid > @maxcustid 
UNION ALL
SELECT CI.CustID,CI.roleid -- Direct Agent
FROM custInfo CI WITH (NOLOCK)
	INNER JOIN #DirectAgent D ON CI.custid = D.CustID 
WHERE ci.custid > @maxcustid 
---------- For members ---------
INSERT INTO #MemberTemp (CustID)
SELECT CI.custid
FROM Custinfo CI WITH (NOLOCK)
	INNER JOIN #DirectMaster M ON CI.mrecommend = M.CustID
WHERE CI.roleid = 1	AND ci.custid > @maxcustid 
	
UNION ALL
SELECT CI.custid
FROM Custinfo CI WITH (NOLOCK)
	INNER JOIN #DirectAgent M ON CI.recommend = M.CustID
WHERE CI.roleid = 1 AND ci.custid > @maxcustid 

---- REMOVE SMA OR member if existing Allbet Setting
DELETE M
FROM #SMATemp M 
	INNER JOIN CustWinLossLimit_Agent ps WITH (NOLOCK) ON M.CustID = PS.CustID AND PS.SportType = 219
	
DELETE M
FROM #MemberTemp M 
	INNER JOIN CustWinLossLimit_Member ps WITH (NOLOCK) ON M.CustID = PS.CustID AND PS.SportType = 219
-------------END of Dummny Processing----------------------------

DECLARE @ProductID INT 
SET @ProductID = 24
	
DECLARE @MaxPT TINYINT
SELECT @MaxPT = MaxPT FROM dbo.ProductSettingDetail WITH (NOLOCK) WHERE ProductID = @ProductID AND SettingType = 1

--------------------------------------WinLossLimit-------------------------------------------------
--SMA Level
INSERT INTO CustWinLossLimit_Agent(CustId, SportType, BetType, MaxWinLimit, MaxLossLimit, IsAutoReset)
SELECT ci.custid, dest.tSportType, dest.tBetType	
	,0 AS MaxWinLimit
	,ISNULL(gbs.DefaultLossLimit,0) AS MaxLossLimit 
	,1 AS IsAutoReset
FROM dbo.custInfo ci WITH(NOLOCK)
	INNER JOIN #SMATemp tmpci WITH (NOLOCK) ON ci.custid = tmpci.custid
	INNER JOIN #supers S ON CI.srecommend = S.custid
	INNER JOIN LossLimit_GlobalSetting gbs WITH (NOLOCK) ON gbs.ProductId = @ProductID AND gbs.ExchangeId = s.exchangeid
	CROSS JOIN #DestinationSportBetType dest WITH(NOLOCK) 
WHERE ci.roleid IN (2,3,4) AND dest.SettingType = 6 
--Member Level
INSERT INTO CustWinLossLimit_Member(CustId, SportType, BetType, MaxWinLimit, MaxLossLimit, IsAutoReset)
SELECT ci.custid, dest.tSportType, dest.tBetType	
	,0 AS MaxWinLimit
	,ISNULL(gbs.DefaultLossLimit,0) AS MaxLossLimit 
	,1 AS IsAutoReset
FROM dbo.custInfo ci WITH(NOLOCK)
	INNER JOIN #SMATemp tmpci WITH (NOLOCK) ON ci.custid = tmpci.custid
	INNER JOIN #supers S ON CI.srecommend = S.custid
	INNER JOIN LossLimit_GlobalSetting gbs WITH (NOLOCK) ON gbs.ProductId = @ProductID AND gbs.ExchangeId = s.exchangeid
	CROSS JOIN #DestinationSportBetType dest WITH(NOLOCK) 
WHERE ci.roleid = 1 AND dest.SettingType = 6 
	
--------------------------------------PT Setting-------------------------------------------------	
--Super LEVEL
INSERT INTO dbo.CustPTSetting3rd_Agent
	(	[CustID]
		,[SportType]
		,[BetType]
		,[IsLive]
		,[SuperPT]
		,[MasterPT]
		,[AgentPT]
		,[IsAutoMasterPT]
		,[AutoMasterPT]
		,[IsAutoSuperPT]
		,[AutoSuperPT]
		,[MinPT]
		,[MaxPT])
SELECT 
	cs.custid, dest.tsporttype, dest.tbettype, dest.IsLive
	
		, CASE WHEN c.custid IN (2,4,13,15) THEN 90
				WHEN c.site = '755555' THEN 80
				WHEN c.site = 'Indo' THEN 80
				WHEN c.site = 'Koribc' THEN 90
				ELSE 90
				END
		
		, CASE WHEN c.custid IN (2,4,13,15) THEN 90
				WHEN c.site = '755555' THEN 80
				WHEN c.site = 'Indo' THEN 80
				WHEN c.site = 'Koribc' THEN 90
				ELSE 90
				END
		
		, CASE WHEN c.custid IN (2,4,13,15) THEN 90
				WHEN c.site = '755555' THEN 80
				WHEN c.site = 'Indo' THEN 80
				WHEN c.site = 'Koribc' THEN 90
				ELSE 90
				END
	
	,cs.isautompositiontaking
	,cs.autompositiontaking *100
	,cs.isautopositiontaking 
	,cs.autopositiontaking  *100
	,co.minpositiontaking  *100
	
	,CASE WHEN c.custid IN (2,4,13,15) THEN 90
				WHEN c.site = '755555' THEN 80
				WHEN c.site = 'Indo' THEN 80
				WHEN c.site = 'Koribc' THEN 90
				ELSE 90
				END
FROM dbo.CustSetting3rd cs WITH(NOLOCK) 
	INNER JOIN dbo.custOverride3rd co WITH(NOLOCK) ON cs.custid = co.custid and cs.sporttype = co.sporttype and cs.bettype = co.bettype
	INNER JOIN #SMATemp ci WITH(NOLOCK) ON ci.custid = cs.custid
	INNER JOIN #DestinationSportBetType dest WITH(NOLOCK) ON dest.SettingType = 1 AND cs.bettype = dest.fBetType AND cs.sporttype = dest.fSportType
	INNER JOIN Customer c (NOLOCK) ON c.custid = ci.CustID
WHERE c.roleid = 4

--Master/Agent Level
INSERT INTO dbo.CustPTSetting3rd_Agent
	(	[CustID]
		,[SportType]
		,[BetType]
		,[IsLive]
		,[SuperPT]
		,[MasterPT]
		,[AgentPT]
		,[IsAutoMasterPT]
		,[AutoMasterPT]
		,[IsAutoSuperPT]
		,[AutoSuperPT]
		,[MinPT]
		,[MaxPT])
SELECT 
	cs.custid, dest.tsporttype, dest.tbettype, dest.IsLive
	
	,cs.spositiontaking  *100
	,cs.mpositiontaking  *100
	,cs.apositiontaking  *100
	
	,cs.isautompositiontaking
	,cs.autompositiontaking *100
	,cs.isautopositiontaking 
	,cs.autopositiontaking  *100
	,co.minpositiontaking  *100
	,90
FROM dbo.CustSetting3rd cs WITH(NOLOCK) 
	INNER JOIN dbo.custOverride3rd co WITH(NOLOCK) ON cs.custid = co.custid and cs.sporttype = co.sporttype and cs.bettype = co.bettype
	INNER JOIN #SMATemp ci WITH(NOLOCK) ON ci.custid = cs.custid
	INNER JOIN #DestinationSportBetType dest WITH(NOLOCK) ON dest.SettingType = 1 AND cs.bettype = dest.fBetType AND cs.sporttype = dest.fSportType
WHERE ci.roleid IN (2,3)
			
--MEMBER LEVEL
INSERT INTO dbo.CustPTSetting3rd_Member
	(	[custid]
		,	[sporttype]
		,	[bettype]
		,	[islive]
		,	[superPT]
		,	[masterPT]
		,	[agentPT]
		,	[IsAutoMasterPT]
		,	[AutoMasterPT]
		,	[IsAutoSuperPT]
		,	[AutoSuperPT])
SELECT 
	cs.custid, dest.tsporttype, dest.tbettype, dest.IsLive
	,cs.spositiontaking  *100
	,cs.mpositiontaking  *100
	,cs.apositiontaking  *100
	,cs.isautompositiontaking
	,cs.autompositiontaking *100
	,cs.isautopositiontaking 
	,cs.autopositiontaking  *100
FROM dbo.CustSetting3rd cs WITH(NOLOCK)
	INNER JOIN #MemberTemp ci WITH(NOLOCK) ON cs.CustID = ci.custid
	INNER JOIN #DestinationSportBetType dest WITH(NOLOCK) ON dest.SettingType = 1 AND cs.bettype = dest.fBetType AND cs.sporttype = dest.fSportType
	
DECLARE @apos SMALLMONEY,
		@mpos SMALLMONEY
	
UPDATE cs
SET cs.MinPT = @MaxPT
FROM dbo.CustPTSetting3rd_Agent cs WITH(UPDLOCK,ROWLOCK) 
	INNER JOIN #SMATemp ci WITH(NOLOCK) ON ci.custid = cs.custid
	INNER JOIN #DestinationSportBetType dest WITH(NOLOCK) ON dest.SettingType = 1 AND cs.bettype = dest.tBetType AND cs.sporttype = dest.tSportType
WHERE MinPT > @MaxPT		
	
UPDATE cs
SET @apos = CASE WHEN cs.AgentPT > @MaxPT THEN @MaxPT ELSE cs.AgentPT END,
	cs.AgentPT = @apos,
	@mpos = CASE WHEN @apos + cs.MasterPT > @MaxPT THEN @MaxPT- @apos ELSE cs.MasterPT END,
	cs.MasterPT = @mpos,
	cs.SuperPT = CASE WHEN @apos + @mpos + cs.SuperPT > @MaxPT THEN @MaxPT - @mpos -@apos ELSE cs.SuperPT END
FROM  CustPTSetting3rd_Member cs WITH(UPDLOCK,ROWLOCK) 
	INNER JOIN #MemberTemp ci WITH(NOLOCK) ON ci.custid = cs.custid
	INNER JOIN #DestinationSportBetType dest WITH(NOLOCK) ON dest.SettingType = 1 AND cs.bettype = dest.tBetType AND cs.sporttype = dest.tSportType
WHERE cs.SuperPT + cs.MasterPT + cs.AgentPT > @MaxPT
		
UPDATE cs
SET @apos = CASE WHEN cs.AgentPT > @MaxPT THEN @MaxPT ELSE cs.AgentPT END,
	cs.AgentPT = @apos,
	cs.MasterPT = CASE WHEN @apos + cs.MasterPT > @MaxPT THEN @MaxPT- @apos ELSE cs.MasterPT END		
FROM  CustPTSetting3rd_Agent cs WITH(UPDLOCK,ROWLOCK) 
	INNER JOIN #SMATemp ci WITH(NOLOCK) ON ci.custid = cs.custid
	INNER JOIN #DestinationSportBetType dest WITH(NOLOCK) ON dest.SettingType = 1 AND cs.bettype = dest.tBetType AND cs.sporttype = dest.tSportType
WHERE cs.MasterPT + cs.AgentPT > @MaxPT	AND roleid = 2
	
UPDATE cs
SET @mpos = CASE WHEN cs.MasterPT > @MaxPT THEN @MaxPT ELSE cs.MasterPT END,
	cs.MasterPT = @mpos,
	cs.SuperPT = CASE WHEN cs.SuperPT + @mpos > @MaxPT THEN @MaxPT - @mpos ELSE cs.SuperPT END 		
FROM  CustPTSetting3rd_Agent cs WITH(UPDLOCK,ROWLOCK) 
	INNER JOIN #SMATemp ci WITH(NOLOCK) ON ci.custid = cs.custid
	INNER JOIN #DestinationSportBetType dest WITH(NOLOCK) ON dest.SettingType = 1 AND cs.bettype = dest.tBetType AND cs.sporttype = dest.tSportType
WHERE cs.MasterPT + cs.SuperPT > @MaxPT	AND roleid = 3
		
UPDATE cs
SET cs.SuperPT = CASE WHEN cs.SuperPT > @MaxPT THEN @MaxPT ELSE cs.SuperPT END 		
FROM  CustPTSetting3rd_Agent cs WITH(UPDLOCK,ROWLOCK) 
	INNER JOIN #supers ci WITH(NOLOCK) ON ci.custid = cs.custid
	INNER JOIN #DestinationSportBetType dest WITH(NOLOCK) ON dest.SettingType = 1 AND cs.bettype = dest.tBetType AND cs.sporttype = dest.tSportType
WHERE cs.SuperPT > @MaxPT	

--- Correct member
DECLARE @srecommend INT
CREATE TABLE #Super_Only (custid int,isfinished bit default(0))
INSERT INTO #Super_Only (custid)
SELECT CustID
FROM #SMATemp
WHERE roleid = 4


DECLARE @SportBettypeXML VARCHAR(MAX)
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
	
DROP TABLE #SMATemp
DROP TABLE #MemberTemp
DROP TABLE #DestinationSportBetType	
DROP TABLE #supers
DROP TABLE #DirectAgent
DROP TABLE #DirectMaster
DROP TABLE #Super_Only