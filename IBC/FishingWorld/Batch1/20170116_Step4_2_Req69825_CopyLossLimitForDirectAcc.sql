

/*
	Created: Winnie
	Task: Copy Losslimit & PT for direct accounts
	DB: DBCUST/CustDB
	Date: 20170117
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
	SELECT custid, roleid
	FROM Customer with(nolock)
	WHERE  site in ('733333','222223', '222225', '222227', '222229')
		and custid NOT IN (SELECT custid from Acc_CustDirect WITH(NOLOCK))
		and srecommend IN (SELECT custid from Acc_CustDirect WITH(NOLOCK))
		and roleid=3 AND srecommend = @srecommend AND custid <= @maxcustid 
		
	--- get direct agent
	INSERT INTO #DirectAgent (CustID,mrecommend,roleid)
	SELECT custid, mrecommend,roleid
	FROM Customer WITH(NOLOCK)
	WHERE site in ('733333','222223', '222225', '222227', '222229')
		and custid NOT IN (SELECT custid from Acc_CustDirect WITH(NOLOCK))
		and mrecommend IN (SELECT custid from Acc_CustDirect WITH(NOLOCK))
		and roleid=2 AND srecommend = @srecommend AND custid <= @maxcustid

	INSERT INTO #DirectMember(CustID,recommend,mrecommend,roleid)
	SELECT c.custid, c.recommend,c.mrecommend,c.roleid
	FROM Customer c WITH(NOLOCK)
	INNER JOIN Customer ca (nolock) on c.recommend=ca.custid 
	WHERE c.custid NOT IN (SELECT custid from Acc_CustDirect WITH(NOLOCK))
		AND c.recommend IN (SELECT custid from Acc_CustDirect WITH(NOLOCK))
		AND c.roleid=1 AND c.srecommend = @srecommend AND C.custid <= @maxcustid 
		AND  ca.site in ('733333','222223', '222225', '222227', '222229')
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
	WHERE CI.custid <= @maxcustid 	
	UNION 
	SELECT DISTINCT CI.srecommend,4 -- super of direct agent
	FROM custInfo CI WITH (NOLOCK)
		INNER JOIN #DirectAgent D ON CI.custid = d.CustID
	WHERE CI.custid <= @maxcustid 	
	
	UNION 

	SELECT CI.CustID,2 -- Agent of direct master
	FROM custInfo CI WITH (NOLOCK)
		INNER JOIN #DirectMaster D ON CI.mrecommend = D.CustID 
	WHERE CI.roleid = 2 AND CI.custid <= @maxcustid 
				
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
	SELECT CI.custid
	FROM Custinfo CI WITH (NOLOCK)
		INNER JOIN #DirectMaster M ON CI.mrecommend = M.CustID
	WHERE CI.roleid = 1	AND CI.custid <= @maxcustid 			

	UNION 
	SELECT CI.custid
	FROM Custinfo CI WITH (NOLOCK)
		INNER JOIN #DirectAgent M ON CI.recommend = M.CustID
	WHERE CI.roleid = 1 AND CI.custid <= @maxcustid 			

	-- Direct member
		
	UNION 
	SELECT CI.custid
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
	
	--Member Level
	INSERT INTO CustWinLossLimit_Member(CustId, SportType, BetType, MaxWinLimit, MaxLossLimit, IsAutoReset)
	SELECT si.custid, @Sporttype, @Bettype
		, 0 AS MaxWinLimit	
		, @DefaultLossLimit AS MaxLossLimit 
		, 1 IsAutoReset
	FROM #MemberTemp si WITH (NOLOCK) 
	
	--------------------------------------PT Setting-------------------------------------------------	
	DECLARE @SuperPT TINYINT
	
	--Super LEVEL
	SELECT @SuperPT=CASE	WHEN @ExchangeID IN (5,13,67) THEN 70
				WHEN @ExchangeID IN (1,2) AND slivepositiontaking IN (0.7,0.8)THEN slivepositiontaking*100
				WHEN @ExchangeID IN (1,2) AND slivepositiontaking = 0.85 THEN 90
				WHEN @ExchangeID NOT IN (5,13,67,1,2) AND slivepositiontaking = 0.85 THEN 90
				ELSE slivepositiontaking*100 
				END
	FROM dbo.CustSetting3rd cs WITH(NOLOCK)			
	WHERE Custid=@srecommend AND cs.sporttype=@SporttypeRef AND	 cs.bettype=@BettypeRef 
	
	
	
	IF EXISTS(SELECT TOP 1 1 FROM #SMATemp WHERE CustID=@srecommend)	
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
		,@SuperPT
		,@SuperPT
		,@SuperPT
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
		,@SuperPT
		,0
		,0
		,0
		,0
		,0
		,0
		,@MaxPT
	FROM #SMATemp ci WITH(NOLOCK) 	
	WHERE RoleID=3
	
	--Agent LEVEL
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
		,@SuperPT
		,0
		,0
		,0
		,0
		,0
		,@MaxPT
	FROM #DirectAgent ci WITH(NOLOCK) 	
	WHERE RoleID=2	
	
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
	FROM #SMATemp ci WITH(NOLOCK) 
	WHERE RoleID=2 AND ci.CustID NOT IN(SELECT CustID FROM #DirectAgent)	

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
WHERE ci.custid IN (
			-- dummy account
			2,3,4,5,12,13,15
		)

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
WHERE ci.custid IN (
			-- dummy account
			2,3,4,5,12,13,15
		)


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
