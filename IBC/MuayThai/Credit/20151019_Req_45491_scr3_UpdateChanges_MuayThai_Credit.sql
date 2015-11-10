/*
	Created: Dominic
	Date: 2015-10-15
	Task: Update Bet Setting / Position Taking of MuayThai for credit customer if there are any changes
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
	   )
	  RETURN


	CREATE TABLE #DestinationSportBetType(fSportType SMALLINT, fBetType SMALLINT,tSportType SMALLINT, tBetType SMALLINT, IsLive BIT,  SettingType INT)
	INSERT INTO #DestinationSportBetType
	VALUES
	(99, 3, 44	,3, 0, 1), --PT
	(99, 1, 44	,1,0, 1), --PT
	(99, 3, 44	,3, 0, 2) --Bet Limit

				
	/*****************************POSITION TAKING**************************/
	--PT of SMA
	UPDATE csa
	SET
		csa.SuperPT = cs.spositiontaking  *100,
		csa.MasterPT = cs.mpositiontaking  *100,
		csa.AgentPT = cs.apositiontaking  *100, 
		csa.IsAutoMasterPT = cs.isautompositiontaking,
		csa.AutoMasterPT = cs.autompositiontaking *100, 
		csa.IsAutoSuperPT = cs.isautopositiontaking, 
		csa.AutoSuperPT = cs.autopositiontaking  *100, 
		csa.MinPT = co.minpositiontaking  *100,
		csa.MaxPT = co.maxpositiontaking  *100
	FROM custinfo ci WITH(NOLOCK)
		CROSS JOIN #DestinationSportBetType map WITH(NOLOCK)
		INNER JOIN dbo.CustPTSetting3rd_Agent csa WITH(UPDLOCK,ROWLOCK)
			ON csa.CustID = ci.custid 
					AND csa.SportType = map.tSportType 
					AND csa.BetType = map.tBetType 
					AND csa.IsLive = map.IsLive
		INNER JOIN dbo.custOverride co WITH(NOLOCK) 
				ON ci.custid = co.custid 
					AND map.fSportType = co.sporttype 
					AND map.fBetType = co.bettype
		INNER JOIN dbo.CustSetting cs WITH(NOLOCK) 
				ON cs.custid = ci.custid 
					AND cs.sporttype = map.fSportType 
					AND cs.bettype = map.fBetType
	WHERE ci.srecommend = @srecommend	AND map.SettingType = 1 AND ci.roleid IN (2,3,4) AND ci.custid <= @maxcustid
			AND (
				cs.spositiontaking  *100 <> csa.SuperPT
				OR cs.mpositiontaking  *100 <> csa.MasterPT
				OR cs.apositiontaking  *100 <> csa.AgentPT
				OR cs.isautompositiontaking <> csa.IsAutoMasterPT
				OR cs.autompositiontaking *100 <> csa.AutoMasterPT
				OR cs.isautopositiontaking <> csa.IsAutoSuperPT
				OR cs.autopositiontaking  *100 <> csa.AutoSuperPT
				OR co.minpositiontaking  *100 <> csa.MinPT
				OR co.maxpositiontaking  *100 <> csa.MaxPT
			)

	
	--MEMBER LEVEL - Update Individual Settings
	UPDATE csm
	SET
		csm.SuperPT = cs.spositiontaking  *100,
		csm.MasterPT = cs.mpositiontaking  *100,
		csm.AgentPT = cs.apositiontaking  *100, 
		csm.IsAutoMasterPT = cs.isautompositiontaking,
		csm.AutoMasterPT = cs.autompositiontaking *100, 
		csm.IsAutoSuperPT = cs.isautopositiontaking, 
		csm.AutoSuperPT = cs.autopositiontaking  *100
	FROM custinfo ci WITH(NOLOCK)
		CROSS JOIN #DestinationSportBetType map WITH(NOLOCK)
		INNER JOIN dbo.CustPTSetting3rd_Member csm WITH(UPDLOCK,ROWLOCK)
			ON csm.CustID = ci.custid 
					AND csm.SportType = map.tSportType 
					AND csm.BetType = map.tBetType 
					AND csm.IsLive = map.IsLive
		INNER JOIN dbo.CustSetting cs WITH(NOLOCK) 
				ON cs.custid = ci.custid 
					AND cs.sporttype = map.fSportType 
					AND cs.bettype = map.fBetType
	WHERE ci.srecommend = @srecommend	AND map.SettingType = 1 AND ci.roleid = 1 AND ci.custid <= @maxcustid
			AND (
				cs.spositiontaking  *100 <> csm.SuperPT
				OR cs.mpositiontaking  *100 <> csm.MasterPT
				OR cs.apositiontaking  *100 <> csm.AgentPT
				OR cs.isautompositiontaking <> csm.IsAutoMasterPT
				OR cs.autompositiontaking *100 <> csm.AutoMasterPT
				OR cs.isautopositiontaking <> csm.IsAutoSuperPT
				OR cs.autopositiontaking  *100 <> csm.AutoSuperPT
			)
	
	/*****************************BET LIMIT SETTING**************************/	
	--Agent Level
	UPDATE csa
	SET
		csa.MinBet = cs.minbet,
		csa.MaxBet = cs.maxbet,
		csa.MaxPerMatch = ci.maxpermatch99
	FROM custinfo ci WITH(NOLOCK)
		CROSS JOIN #DestinationSportBetType map WITH(NOLOCK)
		INNER JOIN dbo.CustBetSetting3rd_Agent csa WITH(UPDLOCK,ROWLOCK)
			ON csa.CustID = ci.custid 
					AND csa.SportType = map.tSportType 
					AND csa.BetType = map.tBetType 
		INNER JOIN dbo.CustSetting cs WITH(NOLOCK) 
				ON cs.custid = ci.custid 
					AND cs.sporttype = map.fSportType 
					AND cs.bettype = map.fBetType
	WHERE ci.srecommend = @srecommend	AND map.SettingType = 2 AND ci.roleid IN (2,3,4) AND ci.custid <= @maxcustid
			AND (
				cs.minbet <> csa.MinBet
				OR
				cs.maxbet <> csa.MaxBet
				OR
				ci.maxpermatch99 <> csa.MaxPerMatch
			)
			

	 
	--Member Level
	UPDATE csm
	SET
		csm.MinBet = cs.minbet,
		csm.MaxBet = cs.maxbet,
		csm.MaxPerMatch = ci.maxpermatch99
	FROM custinfo ci WITH(NOLOCK)
		CROSS JOIN #DestinationSportBetType map WITH(NOLOCK)
		INNER JOIN dbo.CustBetSetting3rd_Member csm WITH(UPDLOCK,ROWLOCK)
			ON csm.CustID = ci.custid 
					AND csm.SportType = map.tSportType 
					AND csm.BetType = map.tBetType 
		INNER JOIN dbo.CustSetting cs WITH(NOLOCK) 
				ON cs.custid = ci.custid 
					AND cs.sporttype = map.fSportType 
					AND cs.bettype = map.fBetType
	WHERE ci.srecommend = @srecommend	AND map.SettingType = 2 AND ci.roleid = 1 AND ci.custid <= @maxcustid
			AND (
				cs.minbet <> csm.MinBet
				OR
				cs.maxbet <> csm.MaxBet
				OR
				ci.maxpermatch99 <> csm.MaxPerMatch
			)

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
	AND ci.Currency = 20 --UUS
	
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
	AND ci.Currency = 20 --UUS
	
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
	
