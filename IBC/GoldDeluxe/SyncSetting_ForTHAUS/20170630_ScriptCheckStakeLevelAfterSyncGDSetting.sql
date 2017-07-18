/*
	Created: 20170630@Johnson
	Task : Correct Gold Deluxe StakeLevel setting again for accounts have stakelevel diff with upline	
	DB:  DBCUST/CustDB
*/

	--Step1: check if have any customers have stakelevel diff with upline
	SELECT ca.custid 
	INTO #super
	FROM custAccount ca with (Nolock)
		INNER JOIN custInfo ci with (Nolock) on ci.custid = ca.custid
	WHERE groupID = 515 AND roleid = 4

	SELECT DISTINCT s.custid, 0 AS IsFinished
	INTO #UnSyncSuper
	FROM custInfo ci WITH (NOLOCK) 
		INNER JOIN #super s ON ci.srecommend = s.custid
	WHERE ci.HideGoldDeluxe = 1
	GO
	
	CREATE TABLE #DiffStakeLevel (CustID INT, isFinished BIT DEFAULT(0))
		
	--Check stake level for un-sync masters
	--SELECT top 100 ci.srecommend, ci.username, ci.roleid, mcs.*, scs.StakeLevelList as StakeLevelList_Super
	INSERT INTO #DiffStakeLevel(custid)
	SELECT DISTINCT ci.srecommend
	FROM CustInfo ci WITH(NOLOCK)
		INNER JOIN CustGameType mcs WITH(NOLOCK) ON ci.custid = mcs.custid
		INNER JOIN CustGameType scs WITH(NOLOCK) ON scs.custid = ci.srecommend
													AND scs.GameTypeID = mcs.GameTypeID
	WHERE ci.srecommend IN (SELECT custid FROM #UnSyncSuper)
		AND ci.roleid = 3
		AND ci.HideGoldDeluxe = 1
		AND mcs.GameTypeID IN (1701,1702)
		AND mcs.StakeLevelList <> scs.StakeLevelList
	
	--Check stake level for un-sync agents
	--SELECT top 100 ci.srecommend, ci.username, ci.roleid, acs.*,mcs.StakeLevelList as StakeLevelList_Master
	INSERT INTO #DiffStakeLevel(custid)
	SELECT DISTINCT ci.srecommend
	FROM CustInfo ci WITH(NOLOCK)
		INNER JOIN CustGameType acs WITH(NOLOCK) ON ci.custid = acs.custid
		INNER JOIN CustGameType mcs WITH(NOLOCK) ON mcs.custid = ci.mrecommend
													AND mcs.GameTypeID = acs.GameTypeID
	WHERE ci.srecommend IN (SELECT custid FROM #UnSyncSuper)
		AND ci.roleid = 2
		AND ci.HideGoldDeluxe = 1
		AND mcs.GameTypeID IN (1701,1702)
		AND mcs.StakeLevelList <> acs.StakeLevelList
	
	--check stake level for un-sync members
	SELECT CustID,GameTypeID,
	(
		SELECT TOP 1 ISNULL(CONVERT(varchar(20),cd.val),'') LowestStakeLevel
			FROM (SELECT CAST(val AS INT) AS val
				  FROM dbo.strSplit(acs.StakeLevelList,','))  cd
					INNER JOIN dbo.StakeLevel SL WITH(NOLOCK) ON cd.val = sl.StakeLevelID
				 WHERE MinStake <> 0 AND MaxStake <> 0
				ORDER BY minstake , maxstake							
	)LowestStakeLevel,
	StakeLevelList
	INTO #CustGameType_agent 
	FROM CustGameType acs WITH(NOLOCK) 		
	WHERE acs.custid IN (SELECT DISTINCT ci.recommend 
						FROM CustInfo ci WITH(NOLOCK)
						WHERE ci.srecommend IN (SELECT custid FROM #UnSyncSuper)
							AND ci.roleid = 1
							AND ci.HideGoldDeluxe = 1
						)		
		AND acs.GameTypeID IN (1701,1702)
	
	--SELECT TOP 100 ci.srecommend, ci.username, ci.roleid, cs.*,
	--	acs.LowestStakeLevel as LowestStakeLevel_agent, acs.stakeLevelList as StakeLevelList_Agent
	INSERT INTO #DiffStakeLevel(custid)
	SELECT DISTINCT ci.srecommend
	FROM CustInfo ci WITH(NOLOCK)
		INNER JOIN CustGameType cs WITH(NOLOCK) ON ci.custid = cs.custid
		INNER JOIN #CustGameType_agent acs ON acs.custid = ci.recommend
											AND acs.GameTypeID = cs.GameTypeID
	WHERE ci.srecommend IN (SELECT custid FROM #UnSyncSuper)
		AND ci.roleid = 1
		AND ci.HideGoldDeluxe = 1
		AND cs.GameTypeID IN (1701,1702)	
		AND cs.StakeLevelList <> acs.LowestStakeLevel
		
	SELECT DISTINCT custid as CustStakeLevelList
	FROM #DiffStakeLevel
	
	SELECT DISTINCT custid,0 as isFinished 
	INTO #StakeLevelCustList
	FROM #DiffStakeLevel
GO	
--END checking StakeLevel
----------------------------------------------------------------------------


--------------------------------------------------------------------------
--IF having any account diff stakelevel, move to step 2	
--Step 2: DEPLOY this execrep sp on DBCUST
 ALTER PROCEDURE [dbo].[Acc_CustSetting3rd_19]
	@custid INT		
AS
BEGIN
	SET NOCOUNT ON
	
	IF dbo.f_CheckRepTable('Custinfo') = 0 RETURN
	IF dbo.f_CheckRepTable('CustGameType') = 0 RETURN
	
	--correct stake level for un-sync masters
	UPDATE mcs
	SET mcs.StakeLevelList = scs.StakeLevelList
	FROM CustInfo ci WITH(NOLOCK)
		INNER JOIN CustGameType mcs WITH(UPDLOCK,ROWLOCK) ON ci.custid = mcs.custid
		INNER JOIN CustGameType scs WITH(NOLOCK) ON scs.custid = @custid
													AND scs.GameTypeID = mcs.GameTypeID
	WHERE ci.srecommend = @custid
		AND ci.roleid = 3
		AND ci.HideGoldDeluxe = 1
		AND mcs.GameTypeID IN (1701,1702)
		AND mcs.StakeLevelList <> scs.StakeLevelList
	
	--correct stake level for un-sync agents
	UPDATE acs
	SET acs.StakeLevelList = mcs.StakeLevelList
	FROM CustInfo ci WITH(NOLOCK)
		INNER JOIN CustGameType acs WITH(UPDLOCK,ROWLOCK) ON ci.custid = acs.custid
		INNER JOIN CustGameType mcs WITH(NOLOCK) ON mcs.custid = ci.mrecommend
													AND mcs.GameTypeID = acs.GameTypeID
	WHERE ci.srecommend = @custid
		AND ci.roleid = 2
		AND ci.HideGoldDeluxe = 1
		AND mcs.GameTypeID IN (1701,1702)
		AND mcs.StakeLevelList <> acs.StakeLevelList
		
	--correct stake level for un-sync members
	SELECT CustID,GameTypeID,
	(
		SELECT TOP 1 ISNULL(CONVERT(varchar(20),cd.val),'') LowestStakeLevel
			FROM (SELECT CAST(val AS INT) AS val
				  FROM dbo.strSplit(acs.StakeLevelList,','))  cd
					INNER JOIN dbo.StakeLevel SL WITH(NOLOCK) ON cd.val = sl.StakeLevelID
				 WHERE MinStake <> 0 AND MaxStake <> 0
				ORDER BY minstake , maxstake							
	)LowestStakeLevel
	INTO #CustGameType_agent 
	FROM CustGameType acs WITH(NOLOCK) 		
	WHERE acs.custid IN (SELECT DISTINCT ci.recommend 
						FROM CustInfo ci WITH(NOLOCK)
						WHERE ci.srecommend = @custid
							AND ci.roleid = 1
							AND ci.HideGoldDeluxe = 1
						)		
		AND acs.GameTypeID IN (1701,1702)
		
	UPDATE cs
	SET cs.StakeLevelList = ISNULL(acs.LowestStakeLevel,'')
	FROM CustInfo ci WITH(NOLOCK)
		INNER JOIN CustGameType cs WITH(UPDLOCK,ROWLOCK) ON ci.custid = cs.custid
		INNER JOIN #CustGameType_agent acs ON acs.custid = ci.recommend
											AND acs.GameTypeID = cs.GameTypeID
	WHERE ci.srecommend = @custid
		AND ci.roleid = 1
		AND ci.HideGoldDeluxe = 1
		AND cs.GameTypeID IN (1701,1702)	
		AND cs.StakeLevelList <> ISNULL(acs.LowestStakeLevel,'')
		
	DROP TABLE #CustGameType_agent
END	
GO
-- END STEP 2: DEPLOY THIS SP @DBCUST.CustDB --------
------------------------------------------------------			

--Step 3: Run this script @DBCUST to adjust stakelevel setting 
	DECLARE @CustID INT		

	WHILE (1 = 1)
	BEGIN
		UPDATE TOP (1) #StakeLevelCustList
		SET isfinished = 1
			,@CustID = custid			
		WHERE isfinished = 0

		IF @@ROWCOUNT = 0 BREAK
		
		EXEC Acc_CustSetting3rd_19 @custid = @custid
	END
--END Step 3	
