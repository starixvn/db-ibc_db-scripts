/*
	Created: 20170616@Johnson
	Task : Sync Gold Deluxe setting for THAUS headline
	DB:  DBCUST/CustDB
*/

 ALTER PROCEDURE [dbo].[Acc_CustSetting3rd_19]
	@custid INT		
AS
BEGIN
	SET NOCOUNT ON
	
	IF dbo.f_CheckRepTable('Custinfo') = 0 RETURN
	IF dbo.f_CheckRepTable('CustSettingGame') = 0 RETURN
	IF dbo.f_CheckRepTable('CustOverrideGame') = 0 RETURN
	IF dbo.f_CheckRepTable('CustWinlimit') = 0 RETURN
	IF dbo.f_CheckRepTable('CustGameType') = 0 RETURN
	
	--correct pt un-sync masters
	UPDATE mcs
	SET	mcs.spositiontaking = CASE WHEN mcs.isAutoPositiontaking = 0 
										THEN sco.minpositiontaking - mcs.mpositiontaking
										ELSE mcs.spositiontaking END,
			mcs.autopositiontaking = CASE WHEN mcs.isAutoPositiontaking = 1
										THEN sco.minpositiontaking - mcs.mpositiontaking
										ELSE mcs.autopositiontaking END											
	FROM CustInfo ci WITH(NOLOCK)
		INNER JOIN CustSettingGame mcs WITH(UPDLOCK,ROWLOCK) ON ci.custid = mcs.custid
		INNER JOIN CustOverrideGame sco WITH(NOLOCK) ON sco.custid = @custid
														AND sco.sporttype = mcs.sporttype
														AND sco.bettype = mcs.bettype
	WHERE ci.srecommend = @custid
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
	
	--correct pt un-sync agents
	UPDATE acs
	SET acs.mpositiontaking = CASE WHEN acs.isAutoMPositiontaking = 0 
										THEN mco.minpositiontaking - acs.apositiontaking
										ELSE acs.mpositiontaking END,
			acs.autompositiontaking = CASE WHEN acs.isAutoMPositiontaking = 1
										THEN mco.minpositiontaking - acs.apositiontaking
										ELSE acs.autompositiontaking END
	FROM CustInfo ci WITH(NOLOCK)
		INNER JOIN CustSettingGame acs WITH(UPDLOCK,ROWLOCK) ON ci.custid = acs.custid
		INNER JOIN CustOverrideGame mco WITH(NOLOCK) ON mco.custid = ci.mrecommend
														AND mco.sporttype = acs.sporttype
														AND mco.bettype = acs.bettype
	WHERE ci.srecommend = @custid
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
	
	--correct master's comm/agent's comm for un-sync members
	UPDATE cs
	SET cs.discount = CASE WHEN cs.discount <> acs.discount THEN acs.discount ELSE cs.discount END,
		cs.adiscount = CASE WHEN cs.adiscount <> mcs.adiscount THEN mcs.adiscount ELSE cs.adiscount END
	FROM CustInfo ci WITH(NOLOCK)
		INNER JOIN CustSettingGame cs WITH(UPDLOCK,ROWLOCK) ON ci.custid = cs.custid
		INNER JOIN CustSettingGame mcs WITH(NOLOCK) ON mcs.custid= ci.mrecommend
														AND mcs.sporttype= cs.sporttype
														AND mcs.bettype = cs.bettype
		INNER JOIN CustSettingGame acs WITH(NOLOCK) ON acs.custid= ci.recommend
														AND acs.sporttype= cs.sporttype
														AND acs.bettype = cs.bettype													
	WHERE ci.srecommend = @custid
		AND ci.roleid = 1
		AND ci.Enabled = 1
		AND ci.HideGoldDeluxe = 1
		AND cs.sporttype= 255
		AND cs.bettype = 1701
		AND (
				mcs.adiscount <> cs.adiscount
			OR
				acs.discount <> cs.discount
			)	
	
	--correct winlimit un-sync masters
	UPDATE mcw
	SET mcw.MaxWinlimit = scw.MaxWinlimit,
		mcw.IsAutoReset = scw.IsAutoReset								
	FROM CustInfo ci WITH(NOLOCK)
		INNER JOIN CustWinlimit mcw WITH(UPDLOCK,ROWLOCK) ON ci.custid = mcw.custid
		INNER JOIN CustWinlimit scw WITH(NOLOCK) ON scw.custid = @CustID
													AND mcw.sporttype = scw.sporttype
													AND mcw.bettype = scw.bettype
	WHERE ci.srecommend = @custid
		AND ci.roleid = 3
		AND ci.HideGoldDeluxe = 1
		AND mcw.Sporttype = 255
		AND mcw.bettype = 1701
		AND 
		(
			scw.MaxWinlimit <> mcw.MaxWinlimit
			OR scw.IsAutoReset <> mcw.IsAutoReset
		)
			
	--Correct winlimit un-sync agents
	UPDATE acw
	SET acw.MaxWinlimit = mcw.MaxWinlimit,
		acw.IsAutoReset = mcw.IsAutoReset								
	FROM CustInfo ci WITH(NOLOCK)
		INNER JOIN CustWinlimit acw WITH(UPDLOCK,ROWLOCK) ON ci.custid = acw.custid
		INNER JOIN CustWinlimit mcw WITH(NOLOCK) ON mcw.custid = ci.mrecommend
													AND mcw.sporttype = acw.sporttype
													AND mcw.bettype = acw.bettype
	WHERE ci.srecommend = @custid
		AND ci.roleid = 2
		AND ci.HideGoldDeluxe = 1
		AND acw.Sporttype = 255
		AND acw.bettype = 1701
		AND 
		(
			mcw.MaxWinlimit <> acw.MaxWinlimit 
			OR mcw.IsAutoReset <> acw.IsAutoReset
		)
	
	--Correct winlimit un-sync members
	UPDATE cw
	SET cw.MaxWinlimit = acw.MaxWinlimit,
		cw.IsAutoReset = acw.IsAutoReset							
	FROM CustInfo ci WITH(NOLOCK)
		INNER JOIN CustWinlimit cw WITH(UPDLOCK,ROWLOCK) ON ci.custid = cw.custid
		INNER JOIN CustWinlimit acw WITH(NOLOCK) ON acw.custid = ci.recommend
													AND acw.sporttype = cw.sporttype
													AND acw.bettype = cw.bettype
	WHERE ci.srecommend = @custid
		AND ci.roleid = 1
		AND ci.HideGoldDeluxe = 1
		AND cw.Sporttype = 255
		AND cw.bettype = 1701
		AND 
		(
			acw.MaxWinlimit <> cw.MaxWinlimit 
			OR acw.IsAutoReset <> cw.IsAutoReset
		)
	
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
	
	DROP TABLE #CustGameType_agent
END