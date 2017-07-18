/*
	Created: 20170718@Johnson
	Task : Correct Gold Deluxe PT setting again for account break rule PT
	DB:  DBCUST/CustDB
*/
--Step1: check if have any customer break rule pt
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
	
	CREATE TABLE #BreakRulePT (custID INT, isFinished BIT DEFAULT(0))
	
	--check PT for un-sync masters 
	--SELECT top 100 ci.srecommend,ci.username, ci.roleid, mcs.*
	INSERT INTO #BreakRulePT(custid)
	SELECT DISTINCT ci.srecommend
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
	--SELECT top 100 ci.srecommend, ci.username,ci.roleid,acs.*
	INSERT INTO #BreakRulePT(custid)
	SELECT DISTINCT ci.srecommend
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
	--SELECT top 100 ci.srecommend,ci.username,ci.roleid,scs.sdiscount as s4,mcs.adiscount as m3, acs.discount as a2
	--	, cs.sdiscount as s1, cs.adiscount as m1, cs.discount as a1
	INSERT INTO #BreakRulePT(custid)
	SELECT DISTINCT ci.srecommend
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
				scs.sdiscount <> cs.sdiscount
			OR mcs.adiscount <> cs.adiscount
			OR acs.discount <> cs.discount
			OR cs.discount > cs.adiscount
			OR cs.adiscount > cs.sdiscount
			)
	
	--Check win limit setting for un-sync masters
	--SELECT top 100 ci.srecommend, ci.username, ci.roleid, mcw.*,scw.MaxWinlimit as MaxWinlimit_super, 
	--scw.IsAutoReset as IsAutoReset_super
	INSERT INTO #BreakRulePT(custid)
	SELECT DISTINCT ci.srecommend
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
	--SELECT top 100 ci.srecommend, ci.username, ci.roleid, acw.*,mcw.MaxWinlimit as MaxWinlimit_master,
	--mcw.IsAutoReset as IsAutoReset_master
	INSERT INTO #BreakRulePT(custid)
	SELECT DISTINCT ci.srecommend
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
	--SELECT TOP 100 ci.srecommend, ci.username, ci.roleid, cw.*, acw.MaxWinlimit as MaxWinlimit_agent, acw.IsAutoReset as IsAutoReset_agent
	INSERT INTO #BreakRulePT(custid)
	SELECT DISTINCT ci.srecommend
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
		
	SELECT DISTINCT custid as CustPTList
	FROM #BreakRulePT
	
	SELECT DISTINCT custid, 0 as isFinished 
	INTO #PTCustList
	FROM #BreakRulePT
GO	
--END checking PT


--IF having any account break rule, move to step 2	
--Step 2: DEPLOY this execrep sp on DBCUST
 ALTER PROCEDURE [dbo].[Acc_CustSetting3rd_19]
	@custid INT		
AS
BEGIN
	SET NOCOUNT ON
	
	IF dbo.f_CheckRepTable('Custinfo') = 0 RETURN
	IF dbo.f_CheckRepTable('CustSettingGame') = 0 RETURN
	IF dbo.f_CheckRepTable('CustOverrideGame') = 0 RETURN
	IF dbo.f_CheckRepTable('CustWinlimit') = 0 RETURN	
	
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
END		
GO

-- END STEP 2: DEPLOY THIS SP @DBCUST.CustDB --------
------------------------------------------------------			

--Step 3: Run this script @DBCUST to correct setting for accounts break rule
	DECLARE @CustID INT,
		@v255discount_1701 SMALLMONEY

	WHILE (1 = 1)
	BEGIN
		UPDATE TOP (1) #PTCustList
		SET isfinished = 1
			,@CustID = custid			
		WHERE isfinished = 0

		IF @@ROWCOUNT = 0 BREAK
		
		EXEC Acc_CustSetting3rd_19 @custid = @custid
	
		--correct pt on member level
		--u = (i3 or i1)?(u3 or u1)
		--s1 = min(s4-m1-a1, u)
		EXEC dbo.Acc_CustSetting3rd_07 
			@srecommend = @custid 
			,@roleid = 4
			,@mode = 'GoldDeluxe'
			,@sporttype = 255
			,@bettype = 1701
		
		--corrrect s1/m1/a1 by min/auto rules
		EXEC [Acc_CustSetting3rd_04] 
			@srecommend = @custid
			,@roleid = 4
			,@mode = 'GoldDeluxe'
			,@sporttype = 255
			,@bettype = 1701
		
		--get current comm setting of super 
		SELECT @v255discount_1701 = sdiscount
		FROM CustSettingGame WITH(NOLOCK)
		WHERE custid = @custid 
			AND sporttype = 255
			AND bettype = 1701
			
		--correct comm setting on member level
		EXEC Acc_CustSetting3rd_06
				@CustId				= @custid,
				@RoleId				= 4,
				@Discount			= @v255discount_1701,
				@mode				= 'GoldDeluxe',
				@Sporttype			= 255,
				@Bettype			= 1701
		
		WAITFOR DELAY '00:00:0.280'
	END
--END Step 3