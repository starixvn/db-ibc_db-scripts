/*
	Created: 20170630@Johnson
	Task : Check data after sync GD settings
	DB:  DBCUST/CustDB
*/

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

	--check PT for un-sync masters 
	SELECT top 100 ci.srecommend,ci.username, ci.roleid, mcs.*
	FROM CustInfo ci WITH(NOLOCK)
		INNER JOIN CustSettingGame mcs WITH(UPDLOCK,ROWLOCK) ON ci.custid = mcs.custid
		INNER JOIN CustOverrideGame sco WITH(NOLOCK) ON sco.custid = ci.srecommend
														AND sco.sporttype = mcs.sporttype
														AND sco.bettype = mcs.bettype
	WHERE ci.srecommend IN (SELECT custid FROM #UnSyncSuper)
		AND ci.roleid = 3
		AND ci.HideGoldDeluxe = 1
		AND mcs.sporttype = 255
		AND mcs.bettype = 1701
		AND (
				--is3 = 0 & s3 + m3 <n4
				(mcs.isAutoPositiontaking = 0 
				AND mcs.spositiontaking + mcs.mpositiontaking < sco.minpositiontaking
				)
			OR
				--is3 = 1 & u3 + m3 < n4
				(mcs.isAutoPositiontaking = 1
				AND mcs.autopositiontaking + mcs.mpositiontaking < sco.minpositiontaking
				)
			)
			
	--check pt for un-sync agents
	SELECT top 100 ci.srecommend, ci.username,ci.roleid,acs.*
	FROM CustInfo ci WITH(NOLOCK)
		INNER JOIN CustSettingGame acs WITH(NOLOCK) ON ci.custid = acs.custid
		INNER JOIN CustOverrideGame mco WITH(NOLOCK) ON mco.custid = ci.mrecommend
														AND mco.sporttype = acs.sporttype
														AND mco.bettype = acs.bettype
	WHERE ci.srecommend IN (SELECT custid FROM #UnSyncSuper)
		AND ci.roleid = 2
		AND ci.HideGoldDeluxe = 1
		AND acs.sporttype = 255
		AND acs.bettype = 1701
		AND (
				--im2 = 0 & a2 + m2 <n3
				(acs.isAutoMPositiontaking = 0 
				AND acs.mpositiontaking + acs.apositiontaking < mco.minpositiontaking
				)
			OR
				--im2 = 1 & a2 + u2 <n3
				(acs.isAutoMPositiontaking = 1
				AND acs.autompositiontaking + acs.apositiontaking < mco.minpositiontaking
				)
			)
	
	--check comm setting
	SELECT top 100 ci.srecommend,ci.username,ci.roleid,scs.sdicousnt as s4,mcs.adiscount as m3, acs.discount as a2
		, cs.sdicousnt as s1, cs.adiscount as m1, cs.discount as a1
	FROM CustInfo ci WITH(NOLOCK)
		INNER JOIN CustSettingGame cs WITH(NOLOCK) ON ci.custid = cs.custid
		INNER JOIN CustSettingGame scs WITH(NOLOCK) ON scs.custid = ci.srecommend
														AND scs.sporttype = cs.sporttype
														AND scs.bettype = cs.bettype
		INNER JOIN CustSettingGame mcs WITH(NOLOCK) ON mcs.custid= ci.mrecommend
														AND mcs.sporttype= cs.sporttype
														AND mcs.bettype = cs.bettype
		INNER JOIN CustSettingGame acs WITH(NOLOCK) ON acs.custid= ci.recommend
														AND acs.sporttype= cs.sporttype
														AND acs.bettype = cs.bettype													
	WHERE ci.srecommend IN (SELECT custid FROM #UnSyncSuper)
		AND ci.roleid = 1
		AND ci.Enabled = 1
		AND ci.HideGoldDeluxe = 1
		AND cs.sporttype= 255
		AND cs.bettype = 1701
		AND (
				scs.sdicousnt <> cs.sdicousnt
			OR mcs.adiscount <> cs.adiscount
			OR acs.discount <> cs.discount
			OR cs.discount > cs.adiscount
			OR cs.adiscount > cs.sdicousnt
			)
	
	--Check win limit setting for un-sync masters
	SELECT top 100 ci.srecommend, ci.username, ci.roleid, mcw.*,scw.MaxWinlimit as MaxWinlimit_super, scw.IsAutoReset as IsAutoReset_super
	FROM CustInfo ci WITH(NOLOCK)
		INNER JOIN CustWinlimit mcw WITH(NOLOCK) ON ci.custid = mcw.custid
		INNER JOIN CustWinlimit scw WITH(NOLOCK) ON scw.custid = ci.srecommend
													AND mcw.sporttype = scw.sporttype
													AND mcw.bettype = scw.bettype
	WHERE ci.srecommend IN (SELECT custid FROM #UnSyncSuper)
		AND ci.roleid = 3
		AND ci.HideGoldDeluxe = 1
		AND mcw.Sporttype = 255
		AND mcw.bettype = 1701
		AND 
		(
			(scw.MaxWinlimit > 0 AND ( mcw.MaxWinlimit = 0 OR mcw.MaxWinlimit > scw.MaxWinlimit))
			OR (scw.IsAutoReset = 0 AND mcw.IsAutoReset =1)
		)
	
	--Check win limit setting for un-sync agents	
	SELECT top 100 ci.srecommend, ci.username, ci.roleid, acw.*,mcw.MaxWinlimit as MaxWinlimit_master, mcw.IsAutoReset as IsAutoReset_master
	FROM CustInfo ci WITH(NOLOCK)
		INNER JOIN CustWinlimit acw WITH(NOLOCK) ON ci.custid = acw.custid
		INNER JOIN CustWinlimit mcw WITH(NOLOCK) ON mcw.custid = ci.mrecommend
													AND mcw.sporttype = acw.sporttype
													AND mcw.bettype = acw.bettype
	WHERE ci.srecommend IN (SELECT custid FROM #UnSyncSuper)
		AND ci.roleid = 2
		AND ci.HideGoldDeluxe = 1
		AND acw.Sporttype = 255
		AND acw.bettype = 1701
		AND 
		(
			(mcw.MaxWinlimit > 0 AND ( acw.MaxWinlimit = 0 OR acw.MaxWinlimit > mcw.MaxWinlimit))
			OR (mcw.IsAutoReset = 0 AND acw.IsAutoReset =1)
		)	
	
	--Check win limit setting for un-sync members
	SELECT TOP 100 ci.srecommend, ci.username, ci.roleid, cw.*, acw.MaxWinlimit as MaxWinlimit_agent, acw.IsAutoReset as IsAutoReset_agent
	FROM CustInfo ci WITH(NOLOCK)
		INNER JOIN CustWinlimit cw WITH(UPDLOCK,ROWLOCK) ON ci.custid = cw.custid
		INNER JOIN CustWinlimit acw WITH(NOLOCK) ON acw.custid = ci.recommend
													AND acw.sporttype = cw.sporttype
													AND acw.bettype = cw.bettype
	WHERE ci.srecommend IN (SELECT custid FROM #UnSyncSuper)
		AND ci.roleid = 1
		AND ci.HideGoldDeluxe = 1
		AND cw.Sporttype = 255
		AND cw.bettype = 1701
		AND 
		(
			(acw.MaxWinlimit > 0 AND ( cw.MaxWinlimit = 0 OR cw.MaxWinlimit > acw.MaxWinlimit))
			OR (acw.IsAutoReset = 0 AND cw.IsAutoReset =1)
		)
	
	--Check stake level for un-sync masters
	SELECT top 100 ci.srecommend, ci.username, ci.roleid, mcs.*, scs.StakeLevelList as StakeLevelList_Super
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
	SELECT top 100 ci.srecommend, ci.username, ci.roleid, acs.*,mcs.StakeLevelList as StakeLevelList_Master
	FROM CustInfo ci WITH(NOLOCK)
		INNER JOIN CustGameType acs WITH(NOLOCK) ON ci.custid = acs.custid
		INNER JOIN CustGameType mcs WITH(NOLOCK) ON mcs.custid = ci.mrecommend
													AND mcs.GameTypeID = acs.GameTypeID
	WHERE ci.srecommend IN (SELECT custid FROM #UnSyncSuper)
		AND ci.roleid = 2
		AND ci.HideGoldDeluxe = 1
		AND mcs.GameTypeID IN (1701,1702)
	
	--check stake level for un-sync members
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
						WHERE ci.srecommend IN (SELECT custid FROM #UnSyncSuper)
							AND ci.roleid = 1
							AND ci.HideGoldDeluxe = 1
						)		
		AND acs.GameTypeID IN (1701,1702)
	
	SELECT TOP 100 ci.srecommend, ci.username, ci.roleid, cs.*,acs.StakeLevelList as StakeLevelList_agent
	FROM CustInfo ci WITH(NOLOCK)
		INNER JOIN CustGameType cs WITH(NOLOCK) ON ci.custid = cs.custid
		INNER JOIN #CustGameType_agent acs ON acs.custid = ci.recommend
											AND acs.GameTypeID = cs.GameTypeID
	WHERE ci.srecommend IN (SELECT custid FROM #UnSyncSuper)
		AND ci.roleid = 1
		AND ci.HideGoldDeluxe = 1
		AND cs.GameTypeID IN (1701,1702)	
	
	DROP TABLE #CustGameType_agent