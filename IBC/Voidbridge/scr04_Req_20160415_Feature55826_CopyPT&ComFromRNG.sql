/*
	Created: Elodie
	Task: Copy PT & Comm & WinLossLimit for All Bet from Live Casino
	DB: DBCUST/CustDB
	Date: 20160226
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
	WHERE srecommend = @srecommend AND roleid = 1  AND Enabled = 1 AND custid <= @maxcustid
	
	
	INSERT INTO #SMATemp (CustID, roleid, SyncCasino)
	SELECT custid, roleid, SyncCasino
	FROM Custinfo WITH (NOLOCK)
	WHERE srecommend = @srecommend AND roleid IN (2,3,4) AND Enabled = 1 AND custid <= @maxcustid 

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
		ci.custid, @SportType, @BetType, @IsLive
		,ISNULL(cs.spositiontaking,0)  *100
		,ISNULL(cs.mpositiontaking,0)  *100
		,ISNULL(cs.apositiontaking,0)  *100
		,ISNULL(cs.isautompositiontaking,0)
		,ISNULL(cs.autompositiontaking,0) *100
		,ISNULL(cs.isautopositiontaking,0) 
		,ISNULL(cs.autopositiontaking,0)  *100
		,ISNULL(cs.minpositiontaking,0)  *100
		,@MaxPT
	FROM #SMATemp ci WITH(NOLOCK) 
		LEFT JOIN dbo.tmpCustGameKind cs WITH(NOLOCK) ON cs.custid = ci.custid
	
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
		ci.custid, @SportType, @BetType, @IsLive
		,ISNULL(cs.spositiontaking,0)  *100
		,ISNULL(cs.mpositiontaking,0)  *100
		,ISNULL(cs.apositiontaking,0)  *100
		,ISNULL(cs.isautompositiontaking,0)
		,ISNULL(cs.autompositiontaking,0) *100
		,ISNULL(cs.isautopositiontaking,0) 
		,ISNULL(cs.autopositiontaking,0)  *100
	FROM #MemberTemp ci WITH(NOLOCK)
		LEFT JOIN dbo.tmpCustGameKind cs WITH(NOLOCK) ON cs.CustID = ci.custid
	
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
		INNER JOIN #SMATemp ci WITH(NOLOCK) ON ci.custid = cs.custid
	WHERE ci.custid = @srecommend		
		AND cs.SuperPT > @MaxPT	AND cs.SportType = @SportType AND cs.BetType = @BetType

	
	--Update m4 = s4, a4 = s4	
	UPDATE CustPTSetting3rd_Agent
	SET 	[MasterPT] = [SuperPT],
			[AgentPT] = [SuperPT]
	WHERE SportType = 212 AND BetType = 4001
	AND Custid = @srecommend
	
	--------------------------------------Commission Setting-------------------------------------------------		
	--Agent Level
	INSERT INTO dbo.CustDiscount3rd_Agent(CustID, SportType, BetType, Discount)
	SELECT ci.custid, @SportType, @BetType, 
			CASE	WHEN roleid = 4 THEN ISNULL(cs.SMAgentRollingRate,0)
					WHEN roleid = 3 THEN ISNULL(cs.MAgentRollingRate,0)
					WHEN roleid = 2 THEN ISNULL(cs.AgentRollingRate,0) END
	FROM #SMATemp ci WITH(NOLOCK)
		LEFT JOIN dbo.tmpCustGameKind cs WITH(NOLOCK) ON cs.custid = ci.custid
		 
	--Member Level
	INSERT INTO dbo.CustDiscount3rd_Member(CustID, SportType, BetType, PlayerDiscount, AgentDiscount, MasterDiscount, SuperDiscount)
	SELECT ci.custid, @SportType, @BetType, ISNULL(cs.MemberRollingRate,0), ISNULL(cs.AgentRollingRate,0), ISNULL(cs.MAgentRollingRate,0), ISNULL(cs.SMAgentRollingRate,0)
	FROM #MemberTemp ci WITH(NOLOCK)
		LEFT JOIN dbo.tmpCustGameKind cs WITH(NOLOCK) ON cs.CustID = ci.custid

	--adjust commission Super = [0; 0.1]	
	--correct for super level
	IF EXISTS(	SELECT 1
				FROM dbo.CustDiscount3rd_Agent cs WITH(NOLOCK)
				WHERE cs.CustID = @srecommend AND cs.Discount > @MaxComm AND cs.SportType = @SportType AND cs.BetType = @BetType)
	BEGIN
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
		WHERE cs.SportType = @SportType AND cs.BetType = @BetType AND (cs.SuperDiscount > @MaxComm 
			OR cs.MasterDiscount > cs.SuperDiscount 
			OR cs.AgentDiscount > cs.MasterDiscount 
			OR cs.PlayerDiscount > cs.AgentDiscount)
		  
	END		
	
	DROP TABLE #SMATemp
	DROP TABLE #MemberTemp
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
FROM CustInfo ci WITH(NOLOCK)
 INNER JOIN customer c WITH (NOLOCK) ON ci.custid = c.custid
 INNER JOIN site s WITH (NOLOCK) ON c.site = s.site
 LEFT JOIN custsuper cs WITH (NOLOCK) ON ci.custid = cs.custid
WHERE ci.roleid = 4  
 AND ci.username NOT LIKE '3rdSuper%'
 AND cs.isinternal = 0
 AND ci.custid NOT IN (SELECT custid FROM Dep_CustSuper WITH(NOLOCK))
 AND s.islicensee = 0
 AND ci.custid <= @max_custid
 AND ci.currency IN (34,45,43) --IDR,WON,'THB'
 

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
FROM CustInfo ci WITH(NOLOCK)
 INNER JOIN customer c WITH (NOLOCK) ON ci.custid = c.custid
 INNER JOIN site s WITH (NOLOCK) ON c.site = s.site
 LEFT JOIN custsuper cs WITH (NOLOCK) ON ci.custid = cs.custid
WHERE ci.roleid = 4  
 AND ci.username NOT LIKE '3rdSuper%'
 AND cs.isinternal = 0
 AND ci.custid NOT IN (SELECT custid FROM Dep_CustSuper WITH(NOLOCK))
 AND s.islicensee = 0
 AND ci.custid <= @max_custid
 AND ci.currency IN (34,45,43) --IDR,WON,'THB'

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