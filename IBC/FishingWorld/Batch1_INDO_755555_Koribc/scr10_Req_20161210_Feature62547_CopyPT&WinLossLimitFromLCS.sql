/*
	Created: Helen
	Task: Copy PT & Comm & WinLossLimit for Fishing World
	DB: DBCUST/CustDB
	Date: 20161210
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
	IF dbo.f_CheckRepTable('CustPTSetting3rd_Agent') = 0 RETURN
	IF dbo.f_CheckRepTable('CustPTSetting3rd_Member') = 0 RETURN
	IF dbo.f_CheckRepTable('CustPTGroupSetting3rd_Member') = 0 RETURN
	IF dbo.f_CheckRepTable('CustWinLossLimit_Agent') = 0 RETURN
	IF dbo.f_CheckRepTable('CustWinLossLimit_Member') = 0 RETURN	
	
	CREATE TABLE #DestinationSportBetType(fSportType SMALLINT, fBetType SMALLINT,tSportType SMALLINT, tBetType SMALLINT, IsLive BIT,  SettingType INT)
	INSERT INTO #DestinationSportBetType
	VALUES
	(161, 85, 219	, 1011, 0, 1), --PT
	(219, 1011, 219	, 1011, 0, 6) --WinLossLimit

	CREATE TABLE #MemberTemp
	(
		CustID INT PRIMARY KEY CLUSTERED
	)

	CREATE TABLE #SMATemp
	(
		CustID INT PRIMARY KEY CLUSTERED,
		roleid TINYINT
	)
	CREATE TABLE #DirectMaster (CustID INT PRIMARY KEY,roleid INT)
	CREATE TABLE #DirectAgent (CustID INT PRIMARY KEY,mrecommend INT,roleid INT)
	
	DECLARE @ProductID INT 
	SET @ProductID = 24
	
	IF @srecommend NOT IN (2,4,13,15)
	BEGIN
		INSERT INTO #MemberTemp (CustID)
		SELECT custid
		FROM Custinfo WITH (NOLOCK)
		WHERE srecommend = @srecommend AND roleid = 1  AND Enabled = 1 AND custid <= @maxcustid
		
		
		INSERT INTO #SMATemp (CustID, roleid)
		SELECT custid, roleid
		FROM Custinfo WITH (NOLOCK)
		WHERE srecommend = @srecommend AND roleid IN (2,3,4) AND Enabled = 1 AND custid <= @maxcustid 
		
		
	END
	ELSE IF @srecommend IN (2,4,13,15)
	BEGIN 
		
		--- get direct master
		INSERT INTO #DirectMaster (CustID,roleid)
		SELECT custid, roleid
		FROM Customer with(nolock)
		WHERE SITE in ('INDO','755555','Koribc')
			and custid NOT IN (SELECT custid from Acc_CustDirect WITH(NOLOCK))
			and srecommend IN (SELECT custid from Acc_CustDirect WITH(NOLOCK))
			and roleid=3 AND srecommend = @srecommend AND custid <= @maxcustid 
			
		--- get direct agent
		INSERT INTO #DirectAgent (CustID,mrecommend,roleid)
		SELECT custid, mrecommend,roleid
		FROM Customer WITH(NOLOCK)
		WHERE site in ('INDO','755555','Koribc')
			and custid NOT IN (SELECT custid from Acc_CustDirect WITH(NOLOCK))
			and mrecommend IN (SELECT custid from Acc_CustDirect WITH(NOLOCK))
			and roleid=2 AND srecommend = @srecommend AND custid <= @maxcustid

		----------- For SMA  -----------
		INSERT INTO #SMATemp (CustID,roleid)
		SELECT CustID,roleid
		FROM custInfo CI WITH (NOLOCK)
		WHERE CI.custid = @srecommend -- SUPER
		UNION ALL

		SELECT CI.CustID,CI.roleid -- Direct Master 
		FROM custInfo CI WITH (NOLOCK)
			INNER JOIN #DirectMaster D ON CI.custid = D.CustID 
		UNION ALL
		SELECT DISTINCT CI.CustID,CI.roleid -- Master of direct agent
		FROM custInfo CI WITH (NOLOCK)
			INNER JOIN #DirectAgent D ON CI.custid = D.mrecommend 
			
		UNION ALL

		SELECT CI.CustID,CI.roleid -- Agent of direct master
		FROM custInfo CI WITH (NOLOCK)
			INNER JOIN #DirectMaster D ON CI.mrecommend = D.CustID 
		WHERE CI.roleid = 2
		UNION ALL
		SELECT CI.CustID,CI.roleid -- Direct Agent
		FROM custInfo CI WITH (NOLOCK)
			INNER JOIN #DirectAgent D ON CI.custid = D.CustID 
		---------- For members ---------
		INSERT INTO #MemberTemp (CustID)
		SELECT CI.custid
		FROM Custinfo CI WITH (NOLOCK)
			INNER JOIN #DirectMaster M ON CI.mrecommend = M.CustID
		WHERE CI.roleid = 1	

		UNION ALL
		SELECT CI.custid
		FROM Custinfo CI WITH (NOLOCK)
			INNER JOIN #DirectAgent M ON CI.recommend = M.CustID
		WHERE CI.roleid = 1

		
		---- REMOVE SMA OR member if existing Allbet Setting
		DELETE M
		FROM #SMATemp M 
			INNER JOIN CustWinLossLimit_Agent ps WITH (NOLOCK) ON M.CustID = PS.CustID AND PS.SportType = 219
			
		DELETE M
		FROM #MemberTemp M 
			INNER JOIN CustWinLossLimit_Member ps WITH (NOLOCK) ON M.CustID = PS.CustID AND PS.SportType = 219
	END		
	
	DECLARE @MaxPT TINYINT, @MaxComm DECIMAL(9,8)
	SELECT @MaxPT = MaxPT FROM dbo.ProductSettingDetail WITH (NOLOCK) WHERE ProductID = @ProductID AND SettingType = 1
	
	DECLARE @DefaultLossLimit MONEY
	
	SELECT @DefaultLossLimit = ISNULL(DefaultLossLimit,0)
	FROM LossLimit_GlobalSetting WITH (NOLOCK)
	WHERE ProductId = @ProductID AND ExchangeId = @ExchangeID
	--------------------------------------WinLossLimit-------------------------------------------------
	--SuperLevel
	INSERT INTO CustWinLossLimit_Agent(CustId, SportType, BetType,MaxWinLimit, MaxLossLimit, IsAutoReset)
	SELECT si.custid, dest.tSportType, dest.tBetType
		, 0 AS MaxWinLimit	
		, @DefaultLossLimit AS MaxLossLimit 
		, 1 IsAutoReset
	FROM #SMATemp si WITH (NOLOCK) 
		CROSS JOIN #DestinationSportBetType dest WITH(NOLOCK) 
	WHERE dest.SettingType = 6 
	
	--Member Level
	INSERT INTO CustWinLossLimit_Member(CustId, SportType, BetType, MaxWinLimit, MaxLossLimit, IsAutoReset)
	SELECT si.custid, dest.tSportType, dest.tBetType	
		, 0 AS MaxWinLimit	
		, @DefaultLossLimit AS MaxLossLimit 
		, 1 IsAutoReset
	FROM #MemberTemp si WITH (NOLOCK) 
		CROSS JOIN #DestinationSportBetType dest WITH(NOLOCK) 
	WHERE dest.SettingType = 6 
	
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
				WHEN c.site = '755555' THEN 90
				WHEN c.site = 'Indo' THEN 90
				WHEN c.site = 'Koribc' THEN 90
				ELSE 90
				END
		
		, CASE WHEN c.custid IN (2,4,13,15) THEN 90
				WHEN c.site = '755555' THEN 90
				WHEN c.site = 'Indo' THEN 90
				WHEN c.site = 'Koribc' THEN 90
				ELSE 90
				END
		
		, CASE WHEN c.custid IN (2,4,13,15) THEN 90
				WHEN c.site = '755555' THEN 90
				WHEN c.site = 'Indo' THEN 90
				WHEN c.site = 'Koribc' THEN 90
				ELSE 90
				END
		
		,cs.isautompositiontaking
		,cs.autompositiontaking *100
		,cs.isautopositiontaking 
		,cs.autopositiontaking  *100
		,co.minpositiontaking  *100
		, CASE WHEN c.custid IN (2,4,13,15) THEN 90
				WHEN c.site = '755555' THEN 90
				WHEN c.site = 'Indo' THEN 90
				WHEN c.site = 'Koribc' THEN 90
				ELSE 90
				END
	FROM dbo.CustSetting3rd cs WITH(NOLOCK) 
		INNER JOIN dbo.custOverride3rd co WITH(NOLOCK) ON cs.custid = co.custid and cs.sporttype = co.sporttype and cs.bettype = co.bettype 
		INNER JOIN #SMATemp ci WITH(NOLOCK) ON ci.custid = cs.custid 
		INNER JOIN #DestinationSportBetType dest WITH(NOLOCK) ON dest.SettingType = 1 AND cs.bettype = dest.fBetType AND cs.sporttype = dest.fSportType
		INNER JOIN Customer c (NOLOCK) ON c.custid = ci.CustID
	WHERE ci.roleid = 4
	
	--MASTER/AGENT LEVEL
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
		INNER JOIN #SMATemp ci WITH(NOLOCK) ON ci.custid = cs.custid
		INNER JOIN #DestinationSportBetType dest WITH(NOLOCK) ON dest.SettingType = 1 AND cs.bettype = dest.tBetType AND cs.sporttype = dest.tSportType
	WHERE ci.custid = @srecommend		
		AND cs.SuperPT > @MaxPT	

	DECLARE @SportBettypeXML VARCHAR(MAX)
	SET @SportBettypeXML = '<ROOT><PT SportType="219" BetType="1011" IsLive="0" /></ROOT>'
				
	EXEC Acc_DynamicCustSetting3rd_07 @SuperID = @srecommend,@SportBettypeXML = @SportBettypeXML, @Roleid = 4
	
	DROP TABLE #SMATemp
	DROP TABLE #MemberTemp
	DROP TABLE #DestinationSportBetType		
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
WHERE (ci.roleid = 4 	
		AND ci.custid NOT IN (SELECT custid FROM Dep_CustSuper WITH(NOLOCK))
		AND ci.custid <= @max_custid
		-- Production
		AND ci.site in ('INDO','755555','Koribc')
		AND ci.custid <> 72
	) OR ci.custid IN (2,4,13,15) -- DUMMY 

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
WHERE (ci.roleid = 4 	
		AND ci.custid NOT IN (SELECT custid FROM Dep_CustSuper WITH(NOLOCK))
		AND ci.custid <= @max_custid 
		-- Production
		AND ci.site in ('INDO','755555','Koribc')
		AND ci.custid <> 72
		)
	OR ci.custid IN (2,4,13,15) -- DUMMY 

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