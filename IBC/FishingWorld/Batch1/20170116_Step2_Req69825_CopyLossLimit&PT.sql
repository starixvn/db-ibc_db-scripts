/*
	Created: Winnie
	Task: Copy LossLimit for Fishing World [RedmineID: 69825]
	DB: DBCUST/CustDB
	Date: 20170116
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
		roleid TINYINT
	)

	INSERT INTO #MemberTemp (CustID)
	SELECT custid
	FROM Custinfo WITH (NOLOCK)
	WHERE srecommend = @srecommend AND roleid = 1  AND Enabled = 1 AND custid <= @maxcustid
	
	
	INSERT INTO #SMATemp (CustID, roleid)
	SELECT custid, roleid
	FROM Custinfo WITH (NOLOCK)
	WHERE srecommend = @srecommend AND roleid IN (2,3,4) AND Enabled = 1 AND custid <= @maxcustid 		

	DECLARE @DefaultLossLimit MONEY,@Sporttype INT,@Bettype INT,@MaxPT TINYINT,@SporttypeRef INT,@BettypeRef INT
	DECLARE @ProductID INT
	SELECT @ProductID=24
	SELECT @DefaultLossLimit = ISNULL(DefaultLossLimit,0)
	FROM LossLimit_GlobalSetting WITH (NOLOCK)
	WHERE ProductId = @ProductID AND ExchangeId = @ExchangeID
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
	--------------------------------------PT-------------------------------------------------
	DECLARE @SuperPT TINYINT
	SELECT @SuperPT=CASE	WHEN @ExchangeID IN (5,13,67) THEN 70
				WHEN @ExchangeID IN (1,2) AND slivepositiontaking IN (0.7,0.8)THEN slivepositiontaking*100
				WHEN @ExchangeID IN (1,2) AND slivepositiontaking = 0.85 THEN 90
				WHEN @ExchangeID NOT IN (5,13,67,1,2) AND slivepositiontaking = 0.85 THEN 90
				ELSE slivepositiontaking*100 
				END
	FROM dbo.CustSetting3rd cs WITH(NOLOCK)			
	WHERE Custid=@srecommend AND cs.sporttype=@SporttypeRef AND	 cs.bettype=@BettypeRef
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
	
	
	--Master AGENT LEVEL
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
		,0
		,0
		,0
		,0
		,0
		,0
		,@MaxPT
	FROM #SMATemp ci 
	WHERE  ci.roleid IN(2,3)
	
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
INNER JOIN custInfo c WITH(NOLOCK) ON ci.custid=c.custid
WHERE (ci.roleid = 4 	
		AND ci.custid NOT IN (SELECT custid FROM Dep_CustSuper WITH(NOLOCK))
		AND ci.custid <= @max_custid AND Enabled=1
	
		AND ((ci.site in ('733333','222223', '222225', '222227', '222229')
		-- cross site
		AND ci.custid NOT IN (674248,395075,1164457,1016771,993226,2453866,1156957,1156957,17721601,1156957,1036451,993226,1016771,324561,506057,2453866,1127269,1036451,1036451,2042873
		,2042873,1036451,796555,5005322))
		OR (ci.currency=20 AND ci.custid NOT IN(23003140,14771858,15323100,15744710,17996464,18002026,18011327,18012360,18012400,18012427,18012473,18012480,18012482,18012484,18012696
											,18362423,18524451,18829945,19000014,19295126,19392121,19562449,19562472,20269385,20660425,20669162,20786437,21005407,21005647,21005670
											,21005685,21005748,21005851,21005868,21005888,21305783,21984259,23715203,24338704,1176070)))
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
INNER JOIN custInfo c WITH(NOLOCK) ON ci.custid=c.custid
WHERE (ci.roleid = 4 	
		AND ci.custid NOT IN (SELECT custid FROM Dep_CustSuper WITH(NOLOCK))
		AND ci.custid <= @max_custid AND Enabled=1
		
		AND ((ci.site in ('733333','222223', '222225', '222227', '222229')	
		-- cross site
		AND ci.custid NOT IN (674248,395075,1164457,1016771,993226,2453866,1156957,1156957,17721601,1156957,1036451,993226,1016771,324561,506057,2453866,1127269,1036451,1036451,2042873
		,2042873,1036451,796555,5005322))
		OR (ci.currency=20 AND ci.custid NOT IN(23003140,14771858,15323100,15744710,17996464,18002026,18011327,18012360,18012400,18012427,18012473,18012480,18012482,18012484,18012696
											,18362423,18524451,18829945,19000014,19295126,19392121,19562449,19562472,20269385,20660425,20669162,20786437,21005407,21005647,21005670
											,21005685,21005748,21005851,21005868,21005888,21305783,21984259,23715203,24338704,1176070)))
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

