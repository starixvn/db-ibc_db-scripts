

/*
	Created: Winnie
	Task: Copy Losslimit & PT for direct accounts
	DB: DBCUST/CustDB
	Date: 20170313
*/ 
ALTER PROCEDURE [dbo].[Acc_DynamicCustSetting3rd_09]
	@srecommend INT	
	,@ExchangeID INT	
	,@maxcustid INT
	,@target VARCHAR(20)
AS
BEGIN
	SET NOCOUNT ON
	
	IF (@target = 'REPLICATED' AND @@SERVERNAME = 'DBCUST') RETURN	-- run at all replicated servers
	IF (@target = 'DBCUST' AND @@SERVERNAME <> 'DBCUST') RETURN -- run at dbtrans only
	
	IF dbo.f_CheckRepTable('CustInfo') = 0 RETURN
	IF dbo.f_CheckRepTable('Customer') = 0 RETURN
	IF dbo.f_CheckRepTable('CustWinLossLimit_Agent') = 0 RETURN
	IF dbo.f_CheckRepTable('CustWinLossLimit_Member') = 0 RETURN		
	IF dbo.f_CheckRepTable('CustPTSetting3rd_Agent') = 0 RETURN
	IF dbo.f_CheckRepTable('CustPTSetting3rd_Member') = 0 RETURN	
	

	CREATE TABLE #MemberTemp
	(
		CustID INT PRIMARY KEY CLUSTERED
	)

	CREATE TABLE #SMATemp
	(
		CustID INT PRIMARY KEY CLUSTERED,
		RoleID INT	
	)
	CREATE TABLE #DirectMaster (CustID INT PRIMARY KEY,roleid INT)
	CREATE TABLE #DirectAgent (CustID INT PRIMARY KEY,mrecommend INT,roleid INT)
	CREATE TABLE #DirectMember (CustID INT PRIMARY KEY,recommend INT,mrecommend INT,roleid INT)			
	--- get direct master
	INSERT INTO #DirectMaster (CustID,roleid)
	SELECT ci.custid, ci.roleid
	FROM Customer ci with(nolock)
	INNER JOIN custInfo c WITH(NOLOCK) ON ci.custid=c.custid
	WHERE  site in  ('611111','722222','766666','789y', '7aa666', 'XYZbet', 'Best-odds')	
		and ci.custid NOT IN (SELECT custid from Acc_CustDirect WITH(NOLOCK))
		and ci.srecommend IN (SELECT custid from Acc_CustDirect WITH(NOLOCK))
		and ci.roleid=3 AND ci.srecommend = @srecommend AND ci.custid <= @maxcustid 
		AND c.Enabled=1
		
	--- get direct agent
	INSERT INTO #DirectAgent (CustID,mrecommend,roleid)
	SELECT ci.custid, ci.mrecommend,ci.roleid
	FROM Customer ci WITH(NOLOCK)
	INNER JOIN custInfo c WITH(NOLOCK) ON ci.custid=c.custid
	WHERE site in  ('611111','722222','766666','789y', '7aa666', 'XYZbet', 'Best-odds')	
		and ci.custid NOT IN (SELECT custid from Acc_CustDirect WITH(NOLOCK))
		and ci.mrecommend IN (SELECT custid from Acc_CustDirect WITH(NOLOCK))
		and ci.roleid=2 AND ci.srecommend = @srecommend AND ci.custid <= @maxcustid
		AND c.Enabled=1

	INSERT INTO #DirectMember(CustID,recommend,mrecommend,roleid)
	SELECT c.custid, c.recommend,c.mrecommend,c.roleid
	FROM Customer c WITH(NOLOCK)
	INNER JOIN Customer ca (nolock) on c.recommend=ca.custid 
	INNER JOIN custInfo ci WITH(NOLOCK) ON ci.custid=c.custid
	WHERE c.custid NOT IN (SELECT custid from Acc_CustDirect WITH(NOLOCK))
		AND c.recommend IN (SELECT custid from Acc_CustDirect WITH(NOLOCK))
		AND c.roleid=1 AND c.srecommend = @srecommend AND C.custid <= @maxcustid 
		AND  ca.site in  ('611111','722222','766666','789y', '7aa666', 'XYZbet', 'Best-odds')	
		AND ci.Enabled=1
	----------- For SMA  -----------
	INSERT INTO #SMATemp (CustID,RoleID)
	--SELECT @srecommend,4 -- Super
	--UNION ALL
	SELECT CI.CustID,3 -- Direct Master 
	FROM custInfo CI WITH (NOLOCK)
		INNER JOIN #DirectMaster D ON CI.custid = D.CustID 		
	UNION 
	SELECT ci.srecommend,4 -- super of Direct Master 
	FROM custInfo CI WITH (NOLOCK)
		INNER JOIN #DirectMaster D ON CI.custid = D.CustID	
	UNION 
	SELECT DISTINCT CI.CustID,3 -- Master of direct agent
	FROM custInfo CI WITH (NOLOCK)
		INNER JOIN #DirectAgent D ON CI.custid = D.mrecommend 

	UNION 
	SELECT DISTINCT CI.srecommend,4 -- super of direct agent
	FROM custInfo CI WITH (NOLOCK)
		INNER JOIN #DirectAgent D ON CI.custid = d.CustID	
	
	UNION 

	SELECT CI.CustID,2 -- Agent of direct master
	FROM custInfo CI WITH (NOLOCK)
		INNER JOIN #DirectMaster D ON CI.mrecommend = D.CustID 
	WHERE CI.roleid = 2 AND ci.Enabled=1
				
	UNION 
	SELECT CI.CustID,CI.roleid -- Direct Agent
	FROM custInfo CI WITH (NOLOCK)
		INNER JOIN #DirectAgent D ON CI.custid = D.CustID 
	UNION 

	SELECT DISTINCT CI.srecommend,4 -- super of direct member
	FROM custInfo CI WITH (NOLOCK)
		INNER JOIN #DirectMember D ON CI.custid = D.CustID 
	WHERE  ci.Enabled = 1
	UNION 

	SELECT DISTINCT CI.CustID,CI.roleid -- Master of direct member
	FROM custInfo CI WITH (NOLOCK)
		INNER JOIN #DirectMember D ON CI.custid = D.mrecommend 
	WHERE  ci.Enabled = 1

	UNION 
	SELECT DISTINCT CI.CustID,CI.roleid -- agent of direct member
	FROM custInfo CI WITH (NOLOCK)
		INNER JOIN #DirectMember D ON CI.custid = D.recommend 
	WHERE  ci.Enabled = 1 	
	---------- For members ---------
	INSERT INTO #MemberTemp (CustID)
	SELECT  CI.custid
	FROM Custinfo CI WITH (NOLOCK)
		INNER JOIN #DirectMaster M ON CI.mrecommend = M.CustID
	WHERE CI.roleid = 1	AND CI.custid <= @maxcustid AND ci.Enabled=1 			

	UNION 
	SELECT  CI.custid
	FROM Custinfo CI WITH (NOLOCK)
		INNER JOIN #DirectAgent M ON CI.recommend = M.CustID
	WHERE CI.roleid = 1 AND CI.custid <= @maxcustid AND ci.Enabled=1 			

	-- Direct member
		
	UNION 
	SELECT  CI.custid
	FROM Custinfo CI WITH (NOLOCK)
		INNER JOIN #DirectMember M ON CI.custid = M.CustID AND CI.custid <= @maxcustid 	
		
	DECLARE @DefaultLossLimit MONEY	,@Sporttype INT,@Bettype INT,@MaxPT TINYINT,@SporttypeRef INT,@BettypeRef INT
	SELECT @DefaultLossLimit = ISNULL(DefaultLossLimit,0)
	FROM LossLimit_GlobalSetting WITH (NOLOCK)
	WHERE ProductId = 24 AND ExchangeId = @ExchangeID
	SELECT @Sporttype=219
	SELECT @Bettype=1011
	SELECT @MaxPT= MaxPT from ProductSettingDetail WITH(NOLOCK) where SportType=@Sporttype and BetType=@Bettype and SettingType=1
	SELECT @SporttypeRef=161
	SELECT @BettypeRef=85
	--------------------------------------WinLossLimit-------------------------------------------------
	--SuperLevel
	INSERT INTO CustWinLossLimit_Agent(CustId, SportType, BetType,MaxWinLimit, MaxLossLimit, IsAutoReset)
	SELECT si.custid, @Sporttype, @Bettype
		, 0 AS MaxWinLimit	
		, @DefaultLossLimit AS MaxLossLimit 
		, 1 IsAutoReset
	FROM #SMATemp si WITH (NOLOCK) 		
	WHERE si.custid <= @maxcustid AND si.CustID NOT IN(2,5,13,4,15,4174,4177,4178,4300,8619)
	--Member Level
	INSERT INTO CustWinLossLimit_Member(CustId, SportType, BetType, MaxWinLimit, MaxLossLimit, IsAutoReset)
	SELECT si.custid, @Sporttype, @Bettype
		, 0 AS MaxWinLimit	
		, @DefaultLossLimit AS MaxLossLimit 
		, 1 IsAutoReset
	FROM #MemberTemp si WITH (NOLOCK) 
	
	--------------------------------------PT Setting-------------------------------------------------
	--Super LEVEL		
	IF EXISTS(SELECT TOP 1 1 FROM #SMATemp WHERE CustID=@srecommend AND CustID NOT IN(2,5,13,4,15))	
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
		@srecommend, @Sporttype, @Bettype, 0		
		,@MaxPT
		,@MaxPT
		,@MaxPT
		,0
		,0
		,0
		,0
		,0
		,@MaxPT
	
	--Master LEVEL
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
		ci.custid, @Sporttype, @Bettype, 0
		,0
		,CASE	WHEN c.site='611111' AND @ExchangeID =4 THEN 70
				WHEN c.site='611111' AND @ExchangeID <>4 THEN 90
				WHEN c.site='722222' AND @ExchangeID IN(5,67,13) THEN 70
				WHEN c.site='722222' AND @ExchangeID IN(2,1) THEN 90
				WHEN c.site='766666' AND @ExchangeID =70 THEN 90
				WHEN c.site='789y' AND @ExchangeID =35 AND mlivepositiontaking=0.85 THEN 90
				WHEN c.site='789y' AND @ExchangeID =35 AND mlivepositiontaking=0.5 THEN 50
				WHEN c.site='789y' AND @ExchangeID =3 AND mlivepositiontaking IN(0, 0.70, 0.80, 0.85) THEN 90
				WHEN c.site='789y' AND @ExchangeID IN (40,17,64) THEN 80
				WHEN c.site='789y' AND @ExchangeID =16 AND mlivepositiontaking<>0.85 THEN 80
				WHEN c.site='789y' AND @ExchangeID =16 AND mlivepositiontaking=0.85 THEN 85
				WHEN c.site='7aa666' AND @ExchangeID =69 THEN 90
				WHEN c.site='Best-odds' THEN mlivepositiontaking*100
				WHEN c.site='XYZbet' AND @ExchangeID =21 THEN 80
				WHEN c.site='XYZbet' AND @ExchangeID =6 THEN 90
				ELSE ISNULL(mlivepositiontaking*100,90)
				END
		,0
		,0
		,0
		,0 
		,0
		,0
		,@MaxPT
	FROM #DirectMaster ci WITH(NOLOCK) 
	LEFT JOIN dbo.CustSetting3rd cs WITH(NOLOCK) ON ci.CustID=cs.custid AND cs.sporttype=@SporttypeRef AND	 cs.bettype=@BettypeRef
	INNER JOIN Customer c WITH(NOLOCK) ON c.CustID=cs.custid
	WHERE ci.RoleID=3
	
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
		ci.custid, @Sporttype, @Bettype, 0
		,0
		,@MaxPT
		,0
		,0
		,0
		,0
		,0
		,0
		,@MaxPT
	FROM #SMATemp ci WITH(NOLOCK) 	
	WHERE RoleID=3 AND ci.CustID NOT IN(SELECT CustID FROM #DirectMaster) AND CI.custid <= @maxcustid
	AND ci.CustID NOT IN(4174,4177,4178,4300,8619)
	
	--Agent LEVEL
	--direct agent
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
		ci.custid, @Sporttype, @Bettype, 0
		,0
		,0
		,CASE	WHEN c.site='611111' AND @ExchangeID =4 THEN 70
				WHEN c.site='611111' AND @ExchangeID <>4 THEN 90
				WHEN c.site='722222' AND @ExchangeID IN(5,67,13) THEN 70
				WHEN c.site='722222' AND @ExchangeID IN(2,1) THEN 90
				WHEN c.site='766666' AND @ExchangeID =70 THEN 90
				WHEN c.site='789y' AND @ExchangeID =35 AND alivepositiontaking=0.85 THEN 90
				WHEN c.site='789y' AND @ExchangeID =35 AND alivepositiontaking=0.5 THEN 50
				WHEN c.site='789y' AND @ExchangeID =3 AND alivepositiontaking IN(0, 0.70, 0.80, 0.85) THEN 90
				WHEN c.site='789y' AND @ExchangeID IN (40,17,64) THEN 80
				WHEN c.site='789y' AND @ExchangeID =16 AND alivepositiontaking<>0.85 THEN 80
				WHEN c.site='789y' AND @ExchangeID =16 AND alivepositiontaking=0.85 THEN 85
				WHEN c.site='7aa666' AND @ExchangeID =69 THEN 90
				WHEN c.site='Best-odds' THEN alivepositiontaking*100
				WHEN c.site='XYZbet' AND @ExchangeID =21 THEN 80
				WHEN c.site='XYZbet' AND @ExchangeID =6 THEN 90
				ELSE ISNULL(alivepositiontaking*100,90)
				END
		,0
		,0
		,0
		,0
		,0
		,@MaxPT
	FROM #DirectAgent ci WITH(NOLOCK) 
	LEFT JOIN 	 dbo.CustSetting3rd cs WITH(NOLOCK)	 ON ci.CustID=cs.custid AND cs.sporttype=@SporttypeRef AND	 cs.bettype=@BettypeRef
	INNER JOIN Customer c WITH(NOLOCK) ON c.CustID=cs.custid
	WHERE ci.RoleID=2	
	-- agent of direct master
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
		ci.custid,  @Sporttype, @Bettype, 0
		,0
		,0
		,0
		,0
		,0
		,0
		,0
		,0
		,@MaxPT	
	FROM custInfo CI WITH (NOLOCK)
		INNER JOIN #DirectMaster D ON CI.mrecommend = D.CustID 
	WHERE CI.roleid = 2 AND CI.custid <= @maxcustid AND ci.Enabled=1
	-- dummy agent of member
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
		ci.custid,  @Sporttype, @Bettype, 0
		,0
		,0
		,@MaxPT
		,0
		,0
		,0
		,0
		,0
		,@MaxPT		
	FROM #SMATemp ci WITH(NOLOCK) 
	WHERE RoleID=2 AND ci.CustID NOT IN(SELECT CustID FROM #DirectAgent)
	AND ci.CustID NOT IN (SELECT cii.CustID FROM custInfo cii WITH (NOLOCK)
							INNER JOIN #DirectMaster D ON Cii.mrecommend = D.CustID 
							WHERE Cii.roleid = 2 AND Cii.custid <= @maxcustid AND cii.Enabled=1)
	AND CI.custid <= @maxcustid	

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
		ci.custid, @Sporttype, @Bettype, 0
		,0
		,0
		,0
		,0
		,0
		,0
		,0
	FROM 	#MemberTemp ci WITH(NOLOCK) 	
	
	DROP TABLE #SMATemp
	DROP TABLE #MemberTemp		
END
GO

-- END STEP 1: DEPLOY THIS SP @DBCUST.CustDB --------
------------------------------------------------------	

-- BEGIN STEP 2: RUN THIS SCRIPT AT ALL REPLICATED SERVERS (06/DBTP) -----
--------------------------------------------------------------------------------------
CREATE TABLE #supers (custid int,exchangeid INT,isfinished bit default(0))

DECLARE @max_custid INT, @srecommend INT, @exchangeid INT

SELECT @max_custid = xxx

INSERT INTO #supers(custid,exchangeid)
SELECT ci.custid,ci.currency
FROM dbo.Customer ci WITH(NOLOCK)
WHERE ci.custid <=100-- dummy acc =<100
		OR ci.custid IN(1469577, 21278849, 21278858)
WHILE (1 = 1)
BEGIN
	UPDATE TOP (1) #Supers
	SET isfinished = 1
		,@srecommend = custid	
		,@exchangeid = exchangeid 
	WHERE isfinished = 0
	
	IF @@ROWCOUNT = 0 BREAK
			
	EXEC dbo.Acc_DynamicCustSetting3rd_09 @srecommend = @srecommend , @Exchangeid = @exchangeid
			,@maxcustid = @max_custid
			,@target = 'REPLICATED'
			
			
	waitfor delay '00:00:0.280'
END

-- BEGIN STEP 3: RUN THIS SCRIPT AT DBCUST -----
--------------------------------------------------------------------------------------
CREATE TABLE #supers (custid int,exchangeid INT,isfinished bit default(0))

DECLARE @max_custid INT, @srecommend INT, @exchangeid INT

SELECT @max_custid = xxx

INSERT INTO #supers(custid,exchangeid)
SELECT ci.custid,ci.currency
FROM dbo.Customer ci WITH(NOLOCK)
WHERE ci.custid <=100-- dummy acc =<100
		OR ci.custid IN(1469577, 21278849, 21278858)
WHILE (1 = 1)
BEGIN
	UPDATE TOP (1) #Supers
	SET isfinished = 1
		,@srecommend = custid	
		,@exchangeid = exchangeid 
	WHERE isfinished = 0
	
	IF @@ROWCOUNT = 0 BREAK

	EXEC dbo.Acc_DynamicCustSetting3rd_09 @srecommend = @srecommend, @Exchangeid = @exchangeid
			,@maxcustid = @max_custid
			,@target = 'DBCUST'
						
	waitfor delay '00:00:0.280'
END
