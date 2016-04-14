/*
	Created: Elodie
	Task: Copy PT & Comm for newly created customer
	DB: DBCUST/CustDB
	Date: 20150626
*/ 

DECLARE @maxcustID2 INT
	
SELECT @maxcustID2 = xxx
	
CREATE TABLE #supers (custid int)
	
INSERT INTO #supers(custid)
SELECT ci.custid
FROM dbo.Customer ci WITH(NOLOCK)
WHERE ci.roleid = 4 	
	AND ci.custid NOT IN (SELECT custid FROM Dep_CustSuper WITH(NOLOCK))
	AND ci.currency IN (34,45,43) --IDR,WON,'THB'

DECLARE @SportType SMALLINT, @BetType SMALLINT, @IsLive BIT
	SELECT @SportType = 212, @BetType = 4001, @IsLive = 0

CREATE TABLE #MemberTemp
(
	CustID INT PRIMARY KEY CLUSTERED,
	SyncCasino BIT
)

CREATE TABLE #SMATemp
(
	CustID INT PRIMARY KEY CLUSTERED,
	roleid TINYINT,
	SyncCasino BIT
)
	
INSERT INTO #MemberTemp (CustID, SyncCasino)
SELECT custid, SyncCasino
FROM Custinfo WITH (NOLOCK)
WHERE srecommend IN (SELECT custid FROM #supers) AND roleid = 1  AND Enabled = 1 AND custid > @maxcustID2	
	
INSERT INTO #SMATemp (CustID, roleid, SyncCasino)
SELECT custid, roleid, SyncCasino
FROM Custinfo WITH (NOLOCK)
WHERE srecommend IN (SELECT custid FROM #supers) AND roleid IN (2,3,4) AND Enabled = 1 AND custid > @maxcustID2 

DECLARE @MaxPT TINYINT, @MaxComm DECIMAL(9,8)
SELECT @MaxPT = MaxPT FROM dbo.ProductSettingDetail WITH (NOLOCK) WHERE ProductID = 22 AND SettingType = 1
SELECT @MaxComm = MaxDiscount FROM dbo.ProductSettingDetail WITH (NOLOCK) WHERE ProductID = 22 AND SettingType = 3
	
--------------------------------------PT Setting-------------------------------------------------	
--AGENT LEVEL
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
	c.IBCCustID, @SportType, @BetType, @IsLive
	,cs.spositiontaking  *100
	,cs.mpositiontaking  *100
	,cs.apositiontaking  *100
	,cs.isautompositiontaking
	,cs.autompositiontaking *100
	,cs.isautopositiontaking 
	,cs.autopositiontaking  *100
	,cs.minpositiontaking  *100
	,90
FROM DBBingoAdmin.CasinoAdmin.dbo.CustGameKind cs WITH(NOLOCK) 
	INNER JOIN DBBingoAdmin.CasinoAdmin.dbo.Customer c WITH (NOLOCK) ON c.CustID = cs.CustID
	INNER JOIN #SMATemp ci WITH(NOLOCK) ON ci.custid = c.IBCCustID
WHERE cs.GameKind = 9
	
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
	c.IBCCustID, @SportType, @BetType, @IsLive
	,cs.spositiontaking  *100
	,cs.mpositiontaking  *100
	,cs.apositiontaking  *100
	,cs.isautompositiontaking
	,cs.autompositiontaking *100
	,cs.isautopositiontaking 
	,cs.autopositiontaking  *100
FROM DBBingoAdmin.CasinoAdmin.dbo.CustGameKind cs WITH(NOLOCK) 
	INNER JOIN DBBingoAdmin.CasinoAdmin.dbo.Customer c WITH (NOLOCK) ON c.CustID = cs.CustID
	INNER JOIN #MemberTemp ci WITH(NOLOCK) ON ci.CustID = c.IBCCustID
WHERE cs.GameKind = 9
	
DECLARE @apos SMALLMONEY,
		@mpos SMALLMONEY	

UPDATE cs
SET cs.MinPT = @MaxPT
FROM dbo.CustPTSetting3rd_Agent cs WITH(UPDLOCK,ROWLOCK) 
	INNER JOIN #SMATemp ci WITH(NOLOCK) ON ci.custid = cs.custid
WHERE MinPT > @MaxPT AND cs.SportType = @SportType AND cs.BetType = @BetType
		
UPDATE cs
SET @apos = CASE WHEN cs.AgentPT > @MaxPT THEN @MaxPT ELSE cs.AgentPT END,
	cs.AgentPT = @apos,
	@mpos = CASE WHEN @apos + cs.MasterPT > @MaxPT THEN @MaxPT- @apos ELSE cs.MasterPT END,
	cs.MasterPT = @mpos,
	cs.SuperPT = CASE WHEN @apos + @mpos + cs.SuperPT > @MaxPT THEN @MaxPT - @mpos -@apos ELSE cs.SuperPT END
FROM  CustPTSetting3rd_Member cs WITH(UPDLOCK,ROWLOCK) 
	INNER JOIN #MemberTemp ci WITH(NOLOCK) ON ci.custid = cs.custid
WHERE cs.SuperPT + cs.MasterPT + cs.AgentPT > @MaxPT AND cs.SportType = @SportType AND cs.BetType = @BetType
		
UPDATE cs
SET @apos = CASE WHEN cs.AgentPT > @MaxPT THEN @MaxPT ELSE cs.AgentPT END,
	cs.AgentPT = @apos,
	cs.MasterPT = CASE WHEN @apos + cs.MasterPT > @MaxPT THEN @MaxPT- @apos ELSE cs.MasterPT END		
FROM  CustPTSetting3rd_Agent cs WITH(UPDLOCK,ROWLOCK) 
	INNER JOIN #SMATemp ci WITH(NOLOCK) ON ci.custid = cs.custid
WHERE cs.MasterPT + cs.AgentPT > @MaxPT	AND roleid = 2 AND cs.SportType = @SportType AND cs.BetType = @BetType
	
UPDATE cs
SET @mpos = CASE WHEN cs.MasterPT > @MaxPT THEN @MaxPT ELSE cs.MasterPT END,
	cs.MasterPT = @mpos,
	cs.SuperPT = CASE WHEN cs.SuperPT + @mpos > @MaxPT THEN @MaxPT - @mpos ELSE cs.SuperPT END 		
FROM  CustPTSetting3rd_Agent cs WITH(UPDLOCK,ROWLOCK) 
	INNER JOIN #SMATemp ci WITH(NOLOCK) ON ci.custid = cs.custid
WHERE cs.MasterPT + cs.SuperPT > @MaxPT	AND roleid = 3 AND cs.SportType = @SportType AND cs.BetType = @BetType
		
UPDATE cs
SET cs.SuperPT = CASE WHEN cs.SuperPT > @MaxPT THEN @MaxPT ELSE cs.SuperPT END 		
FROM  CustPTSetting3rd_Agent cs WITH(UPDLOCK,ROWLOCK) 
	INNER JOIN #supers ci WITH(NOLOCK) ON ci.custid = cs.custid
WHERE cs.SuperPT > @MaxPT AND cs.SportType = @SportType AND cs.BetType = @BetType

--------------------------------------Commission Setting-------------------------------------------------		
--Agent Level
INSERT INTO dbo.CustDiscount3rd_Agent(CustID, SportType, BetType, Discount)
SELECT cs.custid, @SportType, @BetType, 
		CASE	WHEN roleid = 4 THEN cs.SMAgentRollingRate
				WHEN roleid = 3 THEN cs.MAgentRollingRate
				WHEN roleid = 2 THEN cs.AgentRollingRate END
FROM DBBingoAdmin.CasinoAdmin.dbo.CustGameKind cs WITH(NOLOCK) 
	INNER JOIN DBBingoAdmin.CasinoAdmin.dbo.Customer c WITH (NOLOCK) ON c.CustID = cs.CustID
	INNER JOIN #SMATemp ci WITH(NOLOCK) ON ci.custid = c.IBCCustID
WHERE cs.GameKind = 9

--Member Level
INSERT INTO dbo.CustDiscount3rd_Member(CustID, SportType, BetType, PlayerDiscount, AgentDiscount, MasterDiscount, SuperDiscount)
SELECT cs.custid, @SportType, @BetType, cs.MemberRollingRate, cs.AgentRollingRate, cs.MAgentRollingRate, cs.SMAgentRollingRate
FROM DBBingoAdmin.CasinoAdmin.dbo.CustGameKind cs WITH(NOLOCK) 
	INNER JOIN DBBingoAdmin.CasinoAdmin.dbo.Customer c WITH (NOLOCK) ON c.CustID = cs.CustID
	INNER JOIN #MemberTemp ci WITH(NOLOCK) ON ci.custid = c.IBCCustID
WHERE cs.GameKind = 9

--adjust commission Super = [0; 0.1]	
--correct for super level

UPDATE cs
SET cs.Discount = @MaxComm
FROM  CustDiscount3rd_Agent cs WITH(UPDLOCK,ROWLOCK) 
	INNER JOIN #SMATemp ci ON cs.CustID = ci.CustID
WHERE cs.Discount > @MaxComm AND cs.SportType = @SportType AND cs.BetType = @BetType
		
UPDATE cs
SET cs.SuperDiscount = CASE WHEN cs.SuperDiscount > @MaxComm THEN @MaxComm ELSE cs.SuperDiscount END,
	cs.MasterDiscount = CASE WHEN cs.MasterDiscount > cs.SuperDiscount THEN cs.SuperDiscount ELSE cs.MasterDiscount END,
	cs.AgentDiscount = CASE WHEN cs.AgentDiscount > cs.MasterDiscount THEN cs.MasterDiscount ELSE cs.AgentDiscount END,
	cs.PlayerDiscount = CASE WHEN cs.PlayerDiscount > cs.AgentDiscount THEN cs.AgentDiscount ELSE cs.PlayerDiscount END
FROM dbo.CustDiscount3rd_Member cs WITH(UPDLOCK, ROWLOCK)
	INNER JOIN #MemberTemp ci ON cs.CustID = ci.CustID
WHERE cs.SportType = @SportType AND cs.BetType = @BetType 
	AND (cs.SuperDiscount > @MaxComm 
		OR cs.MasterDiscount > cs.SuperDiscount 
		OR cs.AgentDiscount > cs.MasterDiscount 
		OR cs.PlayerDiscount > cs.AgentDiscount)
		  
DROP TABLE #SMATemp
DROP TABLE #MemberTemp
