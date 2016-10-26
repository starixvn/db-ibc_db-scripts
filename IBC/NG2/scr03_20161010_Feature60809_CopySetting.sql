/*
	Created: Elodie
	Task: Copy PT & Comm & Bet Setting for NG2
	DB: DBCUST/CustDB
	Date: 20161010
*/ 

ALTER PROCEDURE [dbo].[Acc_DynamicCustSetting3rd_09]
	@srecommend INT	
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
	IF dbo.f_CheckRepTable('CustDiscount3rd_Member') = 0 RETURN
	IF dbo.f_CheckRepTable('CustDiscount3rd_Agent') = 0 RETURN
	IF dbo.f_CheckRepTable('CustBetSetting3rd_Member') = 0 RETURN
	IF dbo.f_CheckRepTable('CustBetSetting3rd_Agent') = 0 RETURN
	
	CREATE TABLE #DestinationSportBetType(fSportType SMALLINT, fBetType SMALLINT,tSportType SMALLINT, tBetType SMALLINT, IsLive BIT,  SettingType INT)
	INSERT INTO #DestinationSportBetType
	SELECT 1, 1, SportType, BetType, 0, SettingType
	FROM dbo.ProductSettingDetail WITH (NOLOCK)
	WHERE ProductID = 23 AND SettingType IN (1, 3, 9)

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
	WHERE srecommend = @srecommend AND roleid = 1  AND Enabled = 1 AND custid <= @maxcustid
	
	
	INSERT INTO #SMATemp (CustID, roleid)
	SELECT custid, roleid
	FROM Custinfo WITH (NOLOCK)
	WHERE srecommend = @srecommend AND roleid IN (2,3,4) AND Enabled = 1 AND custid <= @maxcustid 

	DECLARE @MaxPT TINYINT, @MaxComm DECIMAL(9,8), @Currency INT
	SELECT TOP 1 @MaxPT = MaxPT FROM dbo.ProductSettingDetail WITH (NOLOCK) WHERE ProductID = 23 AND SettingType = 1
	SELECT TOP 1 @MaxComm = MaxDiscount FROM dbo.ProductSettingDetail WITH (NOLOCK) WHERE ProductID = 23 AND SettingType = 3
	SELECT @Currency = currency FROM customer WITH (NOLOCK) WHERE custid = @srecommend
	
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
		cs.custid, dest.tsporttype, dest.tbettype, dest.IsLive
		,cs.spositiontaking  *100
		,cs.mpositiontaking  *100
		,cs.apositiontaking  *100
		,cs.isautompositiontaking
		,cs.autompositiontaking *100
		,cs.isautopositiontaking 
		,cs.autopositiontaking  *100
		,CASE WHEN ci.roleid = 4 THEN 0 ELSE co.minpositiontaking  *100 END
		,@MaxPT
	FROM dbo.CustSetting cs WITH(NOLOCK) 
		INNER JOIN dbo.custOverride co WITH(NOLOCK) ON cs.custid = co.custid and cs.sporttype = co.sporttype and cs.bettype = co.bettype
		INNER JOIN #SMATemp ci WITH(NOLOCK) ON ci.custid = cs.custid
		INNER JOIN #DestinationSportBetType dest WITH(NOLOCK) ON dest.SettingType = 1 AND cs.bettype = dest.fBetType AND cs.sporttype = dest.fSportType
	
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
	FROM dbo.CustSetting cs WITH(NOLOCK)
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
	SET cs.SuperPT = CASE WHEN cs.SuperPT <> @MaxPT THEN @MaxPT ELSE cs.SuperPT END, 		
		cs.MasterPT = CASE WHEN cs.MasterPT <> @MaxPT THEN @MaxPT ELSE cs.MasterPT END, 	
		cs.AgentPT = CASE WHEN cs.AgentPT <> @MaxPT THEN @MaxPT ELSE cs.AgentPT END 	
	FROM  CustPTSetting3rd_Agent cs WITH(UPDLOCK,ROWLOCK) 
		INNER JOIN #SMATemp ci WITH(NOLOCK) ON ci.custid = cs.custid
		INNER JOIN #DestinationSportBetType dest WITH(NOLOCK) ON dest.SettingType = 1 AND cs.bettype = dest.tBetType AND cs.sporttype = dest.tSportType
	WHERE ci.custid = @srecommend		
		AND (cs.SuperPT <> @MaxPT	
			OR cs.MasterPT <> @MaxPT
			OR cs.AgentPT <> @MaxPT)

	--------------------------------------Commission Setting-------------------------------------------------		
	--Agent Level
	INSERT INTO dbo.CustDiscount3rd_Agent(CustID, SportType, BetType, Discount)
	SELECT ci.custid, dest.tsporttype, dest.tbettype, 
			CASE	WHEN roleid = 4 THEN @MaxComm
					WHEN roleid = 3 THEN 0
					WHEN roleid = 2 THEN 0 END
	FROM #SMATemp ci WITH(NOLOCK) 
		CROSS APPLY #DestinationSportBetType dest WITH(NOLOCK) 
	WHERE dest.SettingType = 3
		 
	--Member Level
	INSERT INTO dbo.CustDiscount3rd_Member(CustID, SportType, BetType, PlayerDiscount, AgentDiscount, MasterDiscount, SuperDiscount)
	SELECT ci.custid, dest.tsporttype, dest.tbettype, 0, 0, 0, @MaxComm
	FROM #MemberTemp ci WITH(NOLOCK) 
		CROSS APPLY #DestinationSportBetType dest WITH(NOLOCK) 
	WHERE dest.SettingType = 3

	--------------------------------------Bet Setting-------------------------------------------------		
	--Agent Level
	INSERT INTO dbo.CustBetSetting3rd_Agent(CustID, SportType, BetType, MinBet, MaxBet, MaxPerMatch)
	SELECT ci.custid, dest.tsporttype, dest.tbettype, 
			CASE	WHEN roleid = 4 THEN ps.MinBet
					WHEN roleid = 3 THEN 0
					WHEN roleid = 2 THEN 0 END,
			CASE	WHEN roleid = 4 THEN ps.MaxBet
					WHEN roleid = 3 THEN 0
					WHEN roleid = 2 THEN 0 END,
			CASE	WHEN roleid = 4 THEN ps.MaxPerMatch
					WHEN roleid = 3 THEN 0
					WHEN roleid = 2 THEN 0 END
	FROM  dbo.ProductBetSetting ps WITH (NOLOCK)
		INNER JOIN #DestinationSportBetType dest WITH(NOLOCK) ON dest.SettingType = 9 AND ps.bettype = dest.tBetType AND ps.sporttype = dest.tSportType
		CROSS APPLY #SMATemp ci
	WHERE ps.Currency = @Currency
		 
	--Member Level
	INSERT INTO dbo.CustBetSetting3rd_Member(CustID, SportType, BetType, MinBet, MaxBet, MaxPerMatch)
	SELECT ci.custid, dest.tsporttype, dest.tbettype, 0, 0, 0			
	FROM  #DestinationSportBetType dest WITH(NOLOCK) 
		CROSS APPLY #MemberTemp ci
	WHERE dest.SettingType = 9
	
	DROP TABLE #SMATemp
	DROP TABLE #MemberTemp
	DROP TABLE #DestinationSportBetType		
END
GO
-- END STEP 1: DEPLOY THIS SP @DBCUST.CustDB --------
------------------------------------------------------	

-- BEGIN STEP 2: RUN THIS SCRIPT AT ALL REPLICATED SERVERS (06/DBTP) -----
--------------------------------------------------------------------------------------
CREATE TABLE #supers (custid int,isfinished bit default(0))

DECLARE @max_custid INT, @srecommend INT

SELECT @max_custid = xxx

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
			AND ci.custid <= @max_custid
			AND ci.site IN ('789y')

WHILE (1 = 1)
BEGIN
	UPDATE TOP (1) #Supers
	SET isfinished = 1
		,@srecommend = custid	
	WHERE isfinished = 0
	
	IF @@ROWCOUNT = 0 BREAK
			
	EXEC dbo.Acc_DynamicCustSetting3rd_09 @srecommend = @srecommend
			,@maxcustid = @max_custid
			,@target = 'REPLICATED'
			
			
	waitfor delay '00:00:0.280'
END

-- BEGIN STEP 3: RUN THIS SCRIPT AT DBCUST -----
--------------------------------------------------------------------------------------
CREATE TABLE #supers (custid int,isfinished bit default(0))

DECLARE @max_custid INT, @srecommend INT

SELECT @max_custid = xxx

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
			AND ci.custid <= @max_custid
			AND ci.site IN ('789y')

WHILE (1 = 1)
BEGIN
	UPDATE TOP (1) #Supers
	SET isfinished = 1
		,@srecommend = custid	
	WHERE isfinished = 0
	
	IF @@ROWCOUNT = 0 BREAK

	EXEC dbo.Acc_DynamicCustSetting3rd_09 @srecommend = @srecommend
			,@maxcustid = @max_custid
			,@target = 'DBCUST'
						
	waitfor delay '00:00:0.280'
END