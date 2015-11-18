/*
	Created: Dominic
	Date: 2015-10-15
	Task: Copy Bet Setting / Position Taking from Other Sports to MuayThai for Credit customers
	DB: DBCust.CustDB
*/  
-- BEGIN STEP 1: DEPLOY THIS SP @DBCUST.CustDB ------
------------------------------------------------------
ALTER PROCEDURE Acc_DynamicCustSetting3rd_09
	@srecommend INT	
	,@maxcustid INT
	,@target VARCHAR(30)
AS
BEGIN   
	SET NOCOUNT ON
	
	IF (@target = 'REPLICATED' AND @@SERVERNAME = 'DBCUST') RETURN	-- run at all replicated servers
	IF (@target = 'DBCUST' AND @@SERVERNAME <> 'DBCUST') RETURN -- run at DBCUST only
	
	IF NOT (dbo.f_CheckRepTable('Custinfo') = 1 
	   AND dbo.f_CheckRepTable('CustSetting') = 1
	   AND dbo.f_CheckRepTable('custOverride') = 1 
	   AND dbo.f_CheckRepTable('CustBetSetting3rd_Member') = 1
	   AND dbo.f_CheckRepTable('CustBetSetting3rd_Agent') = 1
	   AND dbo.f_CheckRepTable('CustPTSetting3rd_Member') = 1
	   AND dbo.f_CheckRepTable('CustPTSetting3rd_Agent') = 1
	   AND dbo.f_CheckRepTable('CustSettingMode3rd') = 1
	   )
	  RETURN


	CREATE TABLE #DestinationSportBetType(fSportType SMALLINT, fBetType SMALLINT,tSportType SMALLINT, tBetType SMALLINT, IsLive BIT,  SettingType INT)
	INSERT INTO #DestinationSportBetType
	VALUES
	(99, 3, 44	,3, 0, 1), --PT
	(99, 1, 44	,1,0, 1), --PT
	(99, 3, 44	,3, 0, 2) --Bet Limit

				
	/*****************************POSITION TAKING**************************/
	CREATE TABLE #MemberTemp
	(
		CustID INT PRIMARY KEY CLUSTERED,
		maxpermatch99 MONEY
	)

	CREATE TABLE #SMATemp
	(
		CustID INT PRIMARY KEY CLUSTERED,
		maxpermatch99 MONEY
	)
	
	INSERT INTO #MemberTemp (CustID,maxpermatch99)
	SELECT custid,maxpermatch99
	FROM Custinfo WITH (NOLOCK)
	WHERE srecommend = @srecommend AND roleid = 1 AND custid <= @maxcustid 
	
	
	INSERT INTO #SMATemp (CustID,maxpermatch99)
	SELECT custid,maxpermatch99
	FROM Custinfo WITH (NOLOCK)
	WHERE srecommend = @srecommend AND roleid IN (2,3,4) AND custid <= @maxcustid 


	--AGENT LEVEL
	INSERT INTO dbo.CustPTSetting3rd_Agent
		([CustID]
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
		cs.custid,dest.tsporttype,dest.tbettype,dest.IsLive
		,cs.spositiontaking  *100
		,cs.mpositiontaking  *100
		,cs.apositiontaking  *100
		,cs.isautompositiontaking
		,cs.autompositiontaking *100
		,cs.isautopositiontaking 
		,cs.autopositiontaking  *100
		,co.minpositiontaking  *100
		,90
	FROM dbo.CustSetting cs WITH(NOLOCK) 
		INNER JOIN dbo.custOverride co WITH(NOLOCK) 
			ON cs.custid = co.custid and cs.sporttype = co.sporttype and cs.bettype = co.bettype
		INNER JOIN #SMATemp ci WITH(NOLOCK) 
			ON ci.custid = cs.custid
		INNER JOIN #DestinationSportBetType dest WITH(NOLOCK)
			ON dest.SettingType = 1
				AND cs.bettype = dest.fBetType
				AND cs.sporttype = dest.fSportType
	
	
	--MEMBER LEVEL
	INSERT INTO dbo.CustPTSetting3rd_Member
			([custid]
		  ,[sporttype]
		  ,[bettype]
		  ,[islive]
		  ,[superPT]
		  ,[masterPT]
		  ,[agentPT]
		  ,[IsAutoMasterPT]
		  ,[AutoMasterPT]
		  ,[IsAutoSuperPT]
		  ,[AutoSuperPT])
	SELECT 
		cs.custid,dest.tsporttype,dest.tbettype,dest.IsLive
		,cs.spositiontaking  *100
		,cs.mpositiontaking  *100
		,cs.apositiontaking  *100
		,cs.isautompositiontaking
		,cs.autompositiontaking *100
		,cs.isautopositiontaking 
		,cs.autopositiontaking  *100
	FROM dbo.custSetting cs WITH(NOLOCK)
		INNER JOIN #MemberTemp ci WITH(NOLOCK) ON cs.CustID = ci.custid
		INNER JOIN #DestinationSportBetType dest WITH(NOLOCK)
			ON dest.SettingType = 1
				AND cs.bettype = dest.fBetType
				AND cs.sporttype = dest.fSportType
	
	
	INSERT INTO [dbo].[CustSettingMode3rd]
			   ([CustID]
			   ,[IsGrouped])
	SELECT custid,0
	FROM #MemberTemp ci WITH(NOLOCK)
	--WHERE ci.srecommend = @srecommend AND  ci.custid <= @maxcustid AND  ci.roleid = 1	
	
	/*****************************BET LIMIT SETTING**************************/	
	--Agent Level
	INSERT INTO dbo.CustBetSetting3rd_Agent
	SELECT cs.custid,dest.tsporttype,dest.tbettype,cs.minbet,cs.maxbet,ci.maxpermatch99
	FROM dbo.CustSetting cs WITH(NOLOCK)
		INNER JOIN #SMATemp ci WITH(NOLOCK) 
			ON  ci.custid = cs.custid
		INNER JOIN #DestinationSportBetType dest WITH(NOLOCK)
			ON dest.SettingType = 2
				AND cs.bettype = dest.fBetType
				AND cs.sporttype = dest.fSportType

	 
	--Member Level
	INSERT INTO dbo.CustBetSetting3rd_Member
	SELECT cs.custid,dest.tsporttype,dest.tbettype,cs.minbet,cs.maxbet,ci.maxpermatch99
	FROM dbo.CustSetting cs WITH(NOLOCK)
		INNER JOIN #MemberTemp ci WITH(NOLOCK) 
			ON  ci.custid = cs.custid
		INNER JOIN #DestinationSportBetType dest WITH(NOLOCK)
			ON dest.SettingType = 2
				AND cs.bettype = dest.fBetType
				AND cs.sporttype = dest.fSportType
	
	DROP TABLE #MemberTemp
	DROP TABLE #SMATemp
END

-- BEGIN STEP 2: RUN THIS SCRIPT AT ALL REPLICATED SERVERS (06/DBTP) -----
--------------------------------------------------------------------------------------
CREATE TABLE #supers (custid int,isfinished bit default(0))

DECLARE @max_custid INT, @srecommend INT

SELECT @max_custid = xxx


INSERT INTO #supers(custid)
SELECT ci.custid
FROM CustInfo ci WITH(NOLOCK)
WHERE ci.roleid = 4 	
	AND ci.custid NOT IN (SELECT custid FROM Dep_CustSuper WITH(NOLOCK))
	AND custid <= @max_custid 
	
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
WHERE ci.roleid = 4 	
	AND ci.custid NOT IN (SELECT custid FROM Dep_CustSuper WITH(NOLOCK))
	AND custid <= @max_custid 
	
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
