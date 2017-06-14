CREATE TABLE #CheckStatusResult_DCS(		
	[RuleId] [smallint] NULL,	
	[SportType] [smallint] NULL,	
	[BetType] [smallint] NULL,	
	[CustIdA] [int] NULL,	
	[CustIdB] [int] NULL,	
	[ValueA] [BIT] NULL,	
	[ValueB] [BIT] NULL,	
	[CreatedDate] [datetime] NULL,	
	IsDeposit BIT NULL	
)		

DECLARE	@RuleId	SMALLINT = 0
	, @SportType SMALLINT = 0

	
SELECT *
INTO #ProductStatusProfile
FROM ProductStatusProfile PSP WITH (NOLOCK)
WHERE PSP.Sporttype IN (211,212)

-------------------PREPARATION: GET LIST SUPER/Master/Agent disabled FIRST----------------------------
	
CREATE TABLE #DCS_Super (custID INT, bitmapOrder INT, IsDisabled BIT, IsHidden BIT, IsSync BIT )
CREATE TABLE #DCS_Master (custID INT, bitmapOrder INT, IsDisabled BIT, IsHidden BIT, IsSync BIT)
CREATE TABLE #DCS_Agent (custID INT, bitmapOrder INT, IsDisabled BIT,  IsHidden BIT, IsSync BIT)

INSERT INTO #DCS_Super (custID,bitmapOrder,IsDisabled,IsHidden,IsSync)
SELECT CPS.CustID,T.bitmapOrder,(SELECT * FROM  dbo.f_CustSetting_ProductStatusSel (cps.bitmapIsDisabled,T.bitmapOrder)) IsDisabled, (SELECT * FROM  dbo.f_CustSetting_ProductStatusSel (cps.bitmapIsHidden,T.bitmapOrder)) AS IsHidden, (SELECT * FROM  dbo.f_CustSetting_ProductStatusSel (cps.bitmapHasSynced,T.bitmapOrder)) isSync
FROM CustProductStatus CPS (NOLOCK)
	INNER JOIN custInfo CI (NOLOCK) ON CPS.CustID = CI.custid
	INNER JOIN CustSuper CS WITH (NOLOCK)  ON CI.srecommend = CS.custid AND CS.IsInternal = 0
	CROSS APPLY (SELECT bitmapOrder FROM #ProductStatusProfile)	AS T
WHERE CI.roleid = 4 
	AND ((SELECT * FROM  dbo.f_CustSetting_ProductStatusSel (cps.bitmapIsDisabled,T.bitmapOrder)) = 1 
		OR (SELECT * FROM  dbo.f_CustSetting_ProductStatusSel (cps.bitmapIsHidden,T.bitmapOrder)) = 1 
		OR (SELECT * FROM  dbo.f_CustSetting_ProductStatusSel (cps.bitmapHasSynced,T.bitmapOrder)) = 0
		)
	AND ci.srecommend NOT IN (SELECT custid FROM Dep_CustSuper WITH(NOLOCK))
	AND CI.Enabled = 1
	AND CI.Currency NOT IN (20,72,27)
	AND CI.username NOT LIKE '%Acc%'
	AND CI.username NOT LIKE '%3rdSuper%'
	AND CI.username NOT LIKE 'STEST%'
	AND CI.username NOT LIKE '%cashout%'
	AND CI.username NOT LIKE '%dummy%'
	AND CI.username NOT LIKE '%BetTrade%'

INSERT INTO #DCS_Master (custID,bitmapOrder,IsDisabled,IsHidden,IsSync)
SELECT CPS.CustID,T.bitmapOrder,(SELECT * FROM  dbo.f_CustSetting_ProductStatusSel (cps.bitmapIsDisabled,T.bitmapOrder))
	, (SELECT * FROM  dbo.f_CustSetting_ProductStatusSel (cps.bitmapIsHidden,T.bitmapOrder))
	,(SELECT * FROM  dbo.f_CustSetting_ProductStatusSel (cps.bitmapHasSynced,T.bitmapOrder))
FROM CustProductStatus CPS (NOLOCK)
	INNER JOIN custInfo CI (NOLOCK) ON CPS.CustID = CI.custid
	INNER JOIN CustSuper CS WITH (NOLOCK)  ON CI.srecommend = CS.custid AND CS.IsInternal = 0 
	CROSS APPLY (SELECT bitmapOrder FROM #ProductStatusProfile)	AS T
WHERE CI.roleid = 3 
	AND ((SELECT * FROM  dbo.f_CustSetting_ProductStatusSel (cps.bitmapIsDisabled,T.bitmapOrder)) = 1 
		OR (SELECT * FROM  dbo.f_CustSetting_ProductStatusSel (cps.bitmapIsHidden,T.bitmapOrder)) = 1 
		OR (SELECT * FROM  dbo.f_CustSetting_ProductStatusSel (cps.bitmapHasSynced,T.bitmapOrder)) = 0
		)
	AND ci.srecommend NOT IN (SELECT custid FROM Dep_CustSuper WITH(NOLOCK))
	AND CI.Enabled = 1
	AND CI.Currency NOT IN (20,72,27)
	AND CI.username NOT LIKE '%Acc%'
	AND CI.username NOT LIKE '%3rdSuper%'
	AND CI.username NOT LIKE 'STEST%'
	AND CI.username NOT LIKE '%cashout%'
	AND CI.username NOT LIKE '%dummy%'
	AND CI.username NOT LIKE '%BetTrade%'
	
INSERT INTO #DCS_Agent (custID,bitmapOrder,IsDisabled,IsHidden,IsSync)
SELECT CPS.CustID,T.bitmapOrder,(SELECT * FROM  dbo.f_CustSetting_ProductStatusSel (cps.bitmapIsDisabled,T.bitmapOrder)), (SELECT * FROM  dbo.f_CustSetting_ProductStatusSel (cps.bitmapIsHidden,T.bitmapOrder)),(SELECT * FROM  dbo.f_CustSetting_ProductStatusSel (cps.bitmapHasSynced,T.bitmapOrder))
FROM CustProductStatus CPS (NOLOCK)
	INNER JOIN custInfo CI (NOLOCK) ON CPS.CustID = CI.custid
	INNER JOIN CustSuper CS WITH (NOLOCK)  ON CI.srecommend = CS.custid AND CS.IsInternal = 0 
	CROSS APPLY (SELECT bitmapOrder FROM #ProductStatusProfile)	AS T
WHERE CI.roleid = 2 
	AND ((SELECT * FROM  dbo.f_CustSetting_ProductStatusSel (cps.bitmapIsDisabled,T.bitmapOrder)) = 1 
		OR (SELECT * FROM  dbo.f_CustSetting_ProductStatusSel (cps.bitmapIsHidden,T.bitmapOrder)) = 1 
		OR (SELECT * FROM  dbo.f_CustSetting_ProductStatusSel (cps.bitmapHasSynced,T.bitmapOrder)) = 0
		)
	AND ci.srecommend NOT IN (SELECT custid FROM Dep_CustSuper WITH(NOLOCK))
	AND CI.Enabled = 1
	AND CI.Currency NOT IN (20,72,27)
	AND CI.username NOT LIKE '%Acc%'
	AND CI.username NOT LIKE '%3rdSuper%'
	AND CI.username NOT LIKE 'STEST%'
	AND CI.username NOT LIKE '%cashout%'
	AND CI.username NOT LIKE '%dummy%'
	AND CI.username NOT LIKE '%BetTrade%'
-------------------END OF PREPARATION: GET LIST SUPER/Master/Agent disabled FIRST----------------------------
----------------------------FINAL RESULT ------------------------------------
-- Rule 1: Super IsDisabled= 1, Master IsDisabled = 0		
IF @RuleId IN (0,1)
BEGIN
	INSERT INTO #CheckStatusResult_DCS (RuleId, SportType, BetType, CustIdA, CustIdB, ValueA, ValueB, CreatedDate,IsDeposit )
	SELECT 1, PSP.Sporttype,PSP.Bettype, ci.custid AS MasterID,ci.srecommend,0,1,GETDATE() , 0
	FROM #DCS_Super S
		INNER JOIN custInfo CI (NOLOCK) ON S.CustID = CI.srecommend AND CI.roleid = 3
		INNER JOIN CustProductStatus CPS WITH (NOLOCK) ON CI.custid = CPS.CustID 
		INNER JOIN #ProductStatusProfile PSP WITH (NOLOCK) ON S.bitmapOrder = PSP.bitmapOrder
	WHERE CI.Enabled = 1
		AND (SELECT * FROM  dbo.f_CustSetting_ProductStatusSel (cps.bitmapIsDisabled,s.bitmapOrder)) = 0
		AND S.IsDisabled = 1
		AND CI.username NOT LIKE '%Acc%'
		AND CI.username NOT LIKE '%3rdSuper%'
		AND CI.username NOT LIKE 'STEST%'
		AND CI.username NOT LIKE '%cashout%'
		AND CI.username NOT LIKE '%dummy%'
		AND CI.username NOT LIKE '%BetTrade%'
END
-- Rule 2: Master IsDisabled= 1, Agent IsDisabled = 0		
IF @RuleId IN (0,2)
BEGIN
	INSERT INTO #CheckStatusResult_DCS (RuleId, SportType, BetType, CustIdA, CustIdB, ValueA, ValueB, CreatedDate,IsDeposit)
	SELECT 2, PSP.Sporttype,PSP.Bettype, ci.custid AS AgentID, ci.mrecommend,0,1,GETDATE(),0 
	FROM #DCS_Master m
		INNER JOIN custInfo CI (NOLOCK) ON m.CustID = CI.mrecommend AND CI.roleid = 2
		INNER JOIN CustProductStatus CPS WITH (NOLOCK) ON CI.custid = CPS.CustID 
		INNER JOIN #ProductStatusProfile PSP WITH (NOLOCK) ON M.bitmapOrder = PSP.bitmapOrder
	WHERE CI.Enabled = 1
		AND (SELECT * FROM  dbo.f_CustSetting_ProductStatusSel (cps.bitmapIsDisabled,m.bitmapOrder)) = 0
		AND M.IsDisabled = 1
		AND CI.username NOT LIKE '%Acc%'
		AND CI.username NOT LIKE '%3rdSuper%'
		AND CI.username NOT LIKE 'STEST%'
		AND CI.username NOT LIKE '%cashout%'
		AND CI.username NOT LIKE '%dummy%'
		AND CI.username NOT LIKE '%BetTrade%'
END	
-- Rule 3: Agent IsDisabled= 1, Member IsDisabled = 0		
IF @RuleId IN (0,3)
BEGIN
	INSERT INTO #CheckStatusResult_DCS (RuleId, SportType, BetType, CustIdA, CustIdB, ValueA, ValueB, CreatedDate,IsDeposit)
	SELECT 3, PSP.Sporttype,PSP.Bettype, ci.custid AS MemberID,ci.recommend,0,1,GETDATE(),0 
	FROM #DCS_Agent a
		INNER JOIN custInfo CI (NOLOCK) ON a.CustID = CI.recommend AND CI.roleid = 1
		INNER JOIN CustProductStatus CPS WITH (NOLOCK) ON CI.custid = CPS.CustID 
		INNER JOIN #ProductStatusProfile PSP WITH (NOLOCK) ON A.bitmapOrder = PSP.bitmapOrder
	WHERE CI.Enabled = 1
		AND (SELECT * FROM  dbo.f_CustSetting_ProductStatusSel (cps.bitmapIsDisabled,a.bitmapOrder)) = 0
		AND A.IsDisabled = 1
		AND ci.custid NOT IN (20696396) --(20696396:QW107AA121)
		AND CI.username NOT LIKE '%Acc%'
		AND CI.username NOT LIKE '%3rdSuper%'
		AND CI.username NOT LIKE 'STEST%'
		AND CI.username NOT LIKE '%cashout%'
		AND CI.username NOT LIKE '%dummy%'
		AND CI.username NOT LIKE '%BetTrade%'
END
-- Rule 4: Super IsHidden= 1, Master IsHidden= 0		
IF @RuleId IN (0,4)
BEGIN

	INSERT INTO #CheckStatusResult_DCS (RuleId, SportType, BetType, CustIdA, CustIdB, ValueA, ValueB, CreatedDate,IsDeposit)
	SELECT 4, PSP.Sporttype,PSP.Bettype, ci.custid AS MasterID,ci.srecommend,0,1,GETDATE(), 0 
	FROM #DCS_Super S
		INNER JOIN custInfo CI (NOLOCK) ON S.CustID = CI.srecommend AND CI.roleid = 3
		INNER JOIN CustProductStatus CPS WITH (NOLOCK) ON CI.custid = CPS.CustID 
		INNER JOIN #ProductStatusProfile PSP WITH (NOLOCK) ON S.bitmapOrder = PSP.bitmapOrder
	WHERE CI.Enabled = 1
		AND (SELECT * FROM  dbo.f_CustSetting_ProductStatusSel (cps.bitmapIsHidden,s.bitmapOrder)) = 0
		AND S.IsHidden = 1
		AND CI.username NOT LIKE '%Acc%'
		AND CI.username NOT LIKE '%3rdSuper%'
		AND CI.username NOT LIKE 'STEST%'
		AND CI.username NOT LIKE '%cashout%'
		AND CI.username NOT LIKE '%dummy%'
		AND CI.username NOT LIKE '%BetTrade%'
END
-- Rule 5: Master IsHidden= 1, Agent IsHidden= 0		
IF @RuleId IN (0,5)
BEGIN
	INSERT INTO #CheckStatusResult_DCS (RuleId, SportType, BetType, CustIdA, CustIdB, ValueA, ValueB, CreatedDate,IsDeposit)
	SELECT 5, PSP.Sporttype,PSP.Bettype, ci.custid AS AgentID, ci.mrecommend,0,1,GETDATE(), 0 
	FROM #DCS_Master m
		INNER JOIN custInfo CI (NOLOCK) ON m.CustID = CI.mrecommend AND CI.roleid = 2
		INNER JOIN CustProductStatus CPS WITH (NOLOCK) ON CI.custid = CPS.CustID 
		INNER JOIN #ProductStatusProfile PSP WITH (NOLOCK) ON M.bitmapOrder = PSP.bitmapOrder
	WHERE CI.Enabled = 1
		AND (SELECT * FROM  dbo.f_CustSetting_ProductStatusSel (cps.bitmapIsHidden,m.bitmapOrder)) = 0
		AND m.IsHidden = 1
		AND CI.username NOT LIKE '%Acc%'
		AND CI.username NOT LIKE '%3rdSuper%'
		AND CI.username NOT LIKE 'STEST%'
		AND CI.username NOT LIKE '%cashout%'
		AND CI.username NOT LIKE '%dummy%'
		AND CI.username NOT LIKE '%BetTrade%'
END	
-- Rule 6: Agent IsHidden= 1, Member IsHidden= 0		 
IF @RuleId IN (0,6)
BEGIN

	INSERT INTO #CheckStatusResult_DCS (RuleId, SportType, BetType, CustIdA, CustIdB, ValueA, ValueB, CreatedDate, IsDeposit)
	SELECT 6, PSP.Sporttype,PSP.Bettype, ci.custid AS MemberID,ci.recommend,0,1,GETDATE(), 0 
	FROM #DCS_Agent a
		INNER JOIN custInfo CI (NOLOCK) ON a.CustID = CI.recommend AND CI.roleid = 1
		INNER JOIN CustProductStatus CPS WITH (NOLOCK) ON CI.custid = CPS.CustID 
		INNER JOIN #ProductStatusProfile PSP WITH (NOLOCK) ON A.bitmapOrder = PSP.bitmapOrder
	WHERE CI.Enabled = 1
		AND (SELECT * FROM  dbo.f_CustSetting_ProductStatusSel (cps.bitmapIsHidden,a.bitmapOrder)) = 0
		AND a.IsHidden = 1
		AND ci.custid NOT IN (20696396) --(20696396:QW107AA121)
		AND CI.username NOT LIKE '%Acc%'
		AND CI.username NOT LIKE '%3rdSuper%'
		AND CI.username NOT LIKE 'STEST%'
		AND CI.username NOT LIKE '%cashout%'
		AND CI.username NOT LIKE '%dummy%'
		AND CI.username NOT LIKE '%BetTrade%'
END		

-- Rule 7: IsSync= 0, IsHidden= 0		 
IF @RuleId IN (0,7)
BEGIN

	INSERT INTO #CheckStatusResult_DCS (RuleId, SportType, BetType, CustIdA, CustIdB, ValueA, ValueB, CreatedDate,IsDeposit)
	-- Super Level
	SELECT 7, PSP.Sporttype,PSP.Bettype, ci.custid,ci.custid,0,0,GETDATE(),0 
	FROM #DCS_Super a
		INNER JOIN custInfo CI (NOLOCK) ON a.CustID = CI.CustID
		INNER JOIN #ProductStatusProfile PSP WITH (NOLOCK) ON A.bitmapOrder = PSP.bitmapOrder
	WHERE CI.Enabled = 1 AND a.IsSync = 0 AND A.IsHidden = 0
		AND CI.username NOT LIKE '%Acc%'
		AND CI.username NOT LIKE '%3rdSuper%'
		AND CI.username NOT LIKE 'STEST%'
		AND CI.username NOT LIKE '%cashout%'
		AND CI.username NOT LIKE '%dummy%'
		AND CI.username NOT LIKE '%BetTrade%'
	
	-- Master Level
	UNION ALL
	
	SELECT 7, PSP.Sporttype,PSP.Bettype, ci.custid,ci.custid,0,0,GETDATE(),0 
	FROM #DCS_Master a
		INNER JOIN custInfo CI (NOLOCK) ON a.CustID = CI.custID
		INNER JOIN #ProductStatusProfile PSP WITH (NOLOCK) ON A.bitmapOrder = PSP.bitmapOrder
	WHERE CI.Enabled = 1 AND a.IsSync = 0 AND A.IsHidden = 0
		AND CI.username NOT LIKE '%Acc%'
		AND CI.username NOT LIKE '%3rdSuper%'
		AND CI.username NOT LIKE 'STEST%'
		AND CI.username NOT LIKE '%cashout%'
		AND CI.username NOT LIKE '%dummy%'
		AND CI.username NOT LIKE '%BetTrade%'
	
	-- Agent Level
	UNION ALL
	
	SELECT 7, PSP.Sporttype,PSP.Bettype, ci.custid,ci.custid,0,0,GETDATE(),0 
	FROM #DCS_Agent a
		INNER JOIN custInfo CI (NOLOCK) ON a.CustID = CI.custid 
		INNER JOIN #ProductStatusProfile PSP WITH (NOLOCK) ON A.bitmapOrder = PSP.bitmapOrder
	WHERE CI.Enabled = 1 AND a.IsSync = 0 AND A.IsHidden = 0
		AND CI.username NOT LIKE '%Acc%'
		AND CI.username NOT LIKE '%3rdSuper%'
		AND CI.username NOT LIKE 'STEST%'
		AND CI.username NOT LIKE '%cashout%'
		AND CI.username NOT LIKE '%dummy%'
		AND CI.username NOT LIKE '%BetTrade%'	
	
	-- Member Level
	UNION ALL
	
	SELECT 7, PSP.Sporttype,PSP.Bettype, ci.custid,ci.custid,0,0,GETDATE(),0 
	FROM custInfo CI (NOLOCK) 
		INNER JOIN CustSuper CS WITH (NOLOCK)  ON CI.srecommend = CS.custid AND CS.IsInternal = 0 
		INNER JOIN CustProductStatus CPS WITH (NOLOCK) ON CI.custid = CPS.CustID AND CI.roleid = 1
		CROSS APPLY (SELECT PSP.Sporttype,PSP.Bettype,PSP.bitmapOrder FROM  #ProductStatusProfile PSP) PSP
	WHERE CI.Enabled = 1 AND (SELECT * FROM  dbo.f_CustSetting_ProductStatusSel (cps.bitmapHasSynced,psp.bitmapOrder)) = 0 AND (SELECT * FROM  dbo.f_CustSetting_ProductStatusSel(cps.bitmapIsHidden,psp.bitmapOrder)) = 0
		AND ci.srecommend NOT IN (SELECT custid FROM Dep_CustSuper WITH(NOLOCK))
		AND CI.Currency NOT IN (20,72,27)
		AND ci.custid NOT IN (20696396) --(20696396:QW107AA121)
		AND CI.username NOT LIKE '%Acc%'
		AND CI.username NOT LIKE '%3rdSuper%'
		AND CI.username NOT LIKE 'STEST%'
		AND CI.username NOT LIKE '%cashout%'
		AND CI.username NOT LIKE '%dummy%'
		AND CI.username NOT LIKE '%BetTrade%'
END	

-- Rule 8: IsSync= 0, IsDisable= 0		 
IF @RuleId IN (0,8)
BEGIN

	INSERT INTO #CheckStatusResult_DCS (RuleId, SportType, BetType, CustIdA, CustIdB, ValueA, ValueB, CreatedDate,IsDeposit)
	-- Super Level
	SELECT 8, PSP.Sporttype,PSP.Bettype, ci.custid,ci.custid,0,0,GETDATE(),0 
	FROM #DCS_Super a
		INNER JOIN custInfo CI (NOLOCK) ON a.CustID = CI.custID
		INNER JOIN #ProductStatusProfile PSP WITH (NOLOCK) ON A.bitmapOrder = PSP.bitmapOrder
	WHERE CI.Enabled = 1 AND a.IsSync = 0 AND A.IsDisabled = 0
		AND CI.username NOT LIKE '%Acc%'
		AND CI.username NOT LIKE '%3rdSuper%'
		AND CI.username NOT LIKE 'STEST%'
		AND CI.username NOT LIKE '%cashout%'
		AND CI.username NOT LIKE '%dummy%'
		AND CI.username NOT LIKE '%BetTrade%'
	--Master Level
	UNION ALL
	
	SELECT 8, PSP.Sporttype,PSP.Bettype, ci.custid,ci.custid,0,0,GETDATE(),0 
	FROM #DCS_Master a
		INNER JOIN custInfo CI (NOLOCK) ON a.CustID = CI.custid
		INNER JOIN #ProductStatusProfile PSP WITH (NOLOCK) ON A.bitmapOrder = PSP.bitmapOrder
	WHERE CI.Enabled = 1 AND a.IsSync = 0 AND A.IsDisabled = 0
		AND CI.username NOT LIKE '%Acc%'
		AND CI.username NOT LIKE '%3rdSuper%'
		AND CI.username NOT LIKE 'STEST%'
		AND CI.username NOT LIKE '%cashout%'
		AND CI.username NOT LIKE '%dummy%'
		AND CI.username NOT LIKE '%BetTrade%'
	-- Agent Level
	UNION ALL
	
	SELECT 8, PSP.Sporttype,PSP.Bettype, ci.custid,ci.custid,0,0,GETDATE(),0 
	FROM #DCS_Agent a
		INNER JOIN custInfo CI (NOLOCK) ON a.CustID = CI.custid
		INNER JOIN #ProductStatusProfile PSP WITH (NOLOCK) ON A.bitmapOrder = PSP.bitmapOrder
	WHERE CI.Enabled = 1 AND a.IsSync = 0 AND A.IsDisabled = 0	
		AND CI.username NOT LIKE '%Acc%'
		AND CI.username NOT LIKE '%3rdSuper%'
		AND CI.username NOT LIKE 'STEST%'
		AND CI.username NOT LIKE '%cashout%'
		AND CI.username NOT LIKE '%dummy%'
		AND CI.username NOT LIKE '%BetTrade%'
	-- Member Level
	UNION ALL
	
	SELECT 8, PSP.Sporttype,PSP.Bettype, ci.custid,ci.custid,0,0,GETDATE(),0 
	FROM custInfo CI (NOLOCK) 
		INNER JOIN CustSuper CS WITH (NOLOCK)  ON CI.srecommend = CS.custid AND CS.IsInternal = 0 
		INNER JOIN CustProductStatus CPS WITH (NOLOCK) ON CI.custid = CPS.CustID AND CI.roleid = 1
		CROSS APPLY (SELECT PSP.Sporttype,PSP.Bettype,PSP.bitmapOrder FROM  #ProductStatusProfile PSP) PSP
	WHERE CI.Enabled = 1 AND (SELECT * FROM  dbo.f_CustSetting_ProductStatusSel (cps.bitmapHasSynced,psp.bitmapOrder)) = 0 AND (SELECT * FROM  dbo.f_CustSetting_ProductStatusSel(cps.bitmapIsDisabled,psp.bitmapOrder)) = 0
		AND ci.srecommend NOT IN (SELECT custid FROM Dep_CustSuper WITH(NOLOCK))
		AND CI.Currency NOT IN (20,72,27)
		AND ci.custid NOT IN (20696396) --(20696396:QW107AA121)
		AND CI.username NOT LIKE '%Acc%'
		AND CI.username NOT LIKE '%3rdSuper%'
		AND CI.username NOT LIKE 'STEST%'
		AND CI.username NOT LIKE '%cashout%'
		AND CI.username NOT LIKE '%dummy%'
		AND CI.username NOT LIKE '%BetTrade%'
END	

-- Rule 9: Missing Product Status setting in the table CustProductStatus/CustProductStatus		
IF @RuleId IN (0,9)
BEGIN
	INSERT INTO #CheckStatusResult_DCS (RuleId, SportType, BetType, CustIdA, CustIdB, ValueA, ValueB, CreatedDate,IsDeposit)
	SELECT 9, NULL,NULL, ci.custid,ci.custid,0,1,GETDATE(),0 
	FROM custInfo CI (NOLOCK) 
		INNER JOIN CustSuper CS WITH (NOLOCK)  ON CI.srecommend = CS.custid AND CS.IsInternal = 0 
	WHERE CI.Enabled = 1 AND NOT EXISTS (SELECT 1 FROM CustProductStatus CPS WITH (NOLOCK) WHERE CI.custid = CPS.CustID)
		AND ci.srecommend NOT IN (SELECT custid FROM Dep_CustSuper WITH(NOLOCK))
		AND CI.Currency NOT IN (20,72,27)
		AND ci.custid NOT IN (20696396) --(20696396:QW107AA121)
		AND CI.username NOT LIKE '%Acc%'
		AND CI.username NOT LIKE '%3rdSuper%'
		AND CI.username NOT LIKE 'STEST%'
		AND CI.username NOT LIKE '%cashout%'
		AND CI.username NOT LIKE '%dummy%'
		AND CI.username NOT LIKE '%BetTrade%'
		
END	
------------------------ adding rule 10,11,12 ------------------------------------------------------------------------------------------
-- Rule 10: Super IsSync= 0, Master IsSync = 1
IF @RuleId IN (0,10)
BEGIN
	INSERT INTO #CheckStatusResult_DCS (RuleId, SportType, BetType, CustIdA, CustIdB, ValueA, ValueB, CreatedDate,IsDeposit )
	SELECT 10, PSP.Sporttype,PSP.Bettype, ci.custid AS MasterID,ci.srecommend,1,0,GETDATE() , 0
	FROM #DCS_Super S
		INNER JOIN custInfo CI (NOLOCK) ON S.CustID = CI.srecommend AND CI.roleid = 3
		INNER JOIN CustProductStatus CPS WITH (NOLOCK) ON CI.custid = CPS.CustID 
		INNER JOIN #ProductStatusProfile PSP WITH (NOLOCK) ON S.bitmapOrder = PSP.bitmapOrder
	WHERE CI.Enabled = 1
		AND (SELECT * FROM  dbo.f_CustSetting_ProductStatusSel (cps.bitmapHasSynced,s.bitmapOrder)) = 1
		AND S.IsSync = 0
		AND CI.username NOT LIKE '%Acc%'
		AND CI.username NOT LIKE '%3rdSuper%'
		AND CI.username NOT LIKE 'STEST%'
		AND CI.username NOT LIKE '%cashout%'
		AND CI.username NOT LIKE '%dummy%'
		AND CI.username NOT LIKE '%BetTrade%'
END
-- Rule 11: Master IsSync= 0, Agent IsSync = 1		
IF @RuleId IN (0,11)
BEGIN
	INSERT INTO #CheckStatusResult_DCS (RuleId, SportType, BetType, CustIdA, CustIdB, ValueA, ValueB, CreatedDate,IsDeposit)
	SELECT 11, PSP.Sporttype,PSP.Bettype, ci.custid AS AgentID, ci.mrecommend,1,0,GETDATE(),0 
	FROM #DCS_Master m
		INNER JOIN custInfo CI (NOLOCK) ON m.CustID = CI.mrecommend AND CI.roleid = 2
		INNER JOIN CustProductStatus CPS WITH (NOLOCK) ON CI.custid = CPS.CustID 
		INNER JOIN #ProductStatusProfile PSP WITH (NOLOCK) ON M.bitmapOrder = PSP.bitmapOrder
	WHERE CI.Enabled = 1
		AND (SELECT * FROM  dbo.f_CustSetting_ProductStatusSel (cps.bitmapHasSynced,m.bitmapOrder)) = 1
		AND M.IsSync = 0
		AND CI.username NOT LIKE '%Acc%'
		AND CI.username NOT LIKE '%3rdSuper%'
		AND CI.username NOT LIKE 'STEST%'
		AND CI.username NOT LIKE '%cashout%'
		AND CI.username NOT LIKE '%dummy%'
		AND CI.username NOT LIKE '%BetTrade%'
END	
-- Rule 12: Agent IsSync= 0, Member IsSync = 1		
IF @RuleId IN (0,12)
BEGIN
	INSERT INTO #CheckStatusResult_DCS (RuleId, SportType, BetType, CustIdA, CustIdB, ValueA, ValueB, CreatedDate,IsDeposit)
	SELECT 12, PSP.Sporttype,PSP.Bettype, ci.custid AS MemberID,ci.recommend,1,0,GETDATE(),0 
	FROM #DCS_Agent a
		INNER JOIN custInfo CI (NOLOCK) ON a.CustID = CI.recommend AND CI.roleid = 1
		INNER JOIN CustProductStatus CPS WITH (NOLOCK) ON CI.custid = CPS.CustID 
		INNER JOIN #ProductStatusProfile PSP WITH (NOLOCK) ON A.bitmapOrder = PSP.bitmapOrder
	WHERE CI.Enabled = 1
		AND (SELECT * FROM  dbo.f_CustSetting_ProductStatusSel (cps.bitmapHasSynced,a.bitmapOrder)) = 1
		AND A.IsSync = 0
		AND ci.custid NOT IN (20696396) --(20696396:QW107AA121)
		AND CI.username NOT LIKE '%Acc%'
		AND CI.username NOT LIKE '%3rdSuper%'
		AND CI.username NOT LIKE 'STEST%'
		AND CI.username NOT LIKE '%cashout%'
		AND CI.username NOT LIKE '%dummy%'
		AND CI.username NOT LIKE '%BetTrade%'
END
/*
DROP TABLE #DCS_Agent
DROP TABLE #DCS_Master
DROP TABLE #DCS_Super
DROP TABLE #ProductStatusProfile	
*/
SET NOCOUNT OFF	


		
