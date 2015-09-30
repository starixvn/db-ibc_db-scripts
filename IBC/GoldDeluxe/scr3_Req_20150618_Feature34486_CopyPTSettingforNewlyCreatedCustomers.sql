 /*
	Created: Johnson
	Task: copy pt & comm for Gold Deluxe from Live Casino for newly created customers
	DB: DBTXN/CustDB
	Date: 20150618
*/  


CREATE TABLE #supers (custid int)

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
 and s.islicensee = 0
 GO

--step 1: copy settings for newly created customers
DECLARE @max_custid INT 
SELECT @max_custid = xx

INSERT INTO [dbo].[CustSettingGame]
           ([CustID]
           ,[Bettype]
           ,[Sporttype]
           ,[apositiontaking]
           ,[mpositiontaking]
           ,[spositiontaking]
           ,[playerdiscount]
           ,[discount]
           ,[adiscount]
           ,[sdiscount]
           ,[autopositiontaking]
           ,[isautopositiontaking]
           ,[autompositiontaking]
           ,[isautompositiontaking])
	SELECT cs.[CustID]
           ,1701 as [Bettype]
           ,255 as [Sporttype]
           ,CASE WHEN SyncLiveCasino = 1 THEN cs.[apositiontaking] ELSE 0 END
           ,CASE WHEN SyncLiveCasino = 1 THEN cs.[mpositiontaking] ELSE 0 END 
           ,CASE WHEN SyncLiveCasino = 1 THEN cs.[spositiontaking] ELSE 0 END
           ,CASE WHEN SyncLiveCasino = 1 THEN cs.[playerdiscount] ELSE 0 END
           ,CASE WHEN SyncLiveCasino = 1 THEN cs.[discount] ELSE 0 END
           ,CASE WHEN SyncLiveCasino = 1 THEN cs.[adiscount] ELSE 0 END
           ,CASE WHEN SyncLiveCasino = 1 THEN cs.[sdiscount] ELSE 0 END
           ,CASE WHEN SyncLiveCasino = 1 THEN cs.[autopositiontaking] ELSE 0 END
           ,CASE WHEN SyncLiveCasino = 1 THEN cs.[isautopositiontaking] ELSE 0 END
           ,CASE WHEN SyncLiveCasino = 1 THEN cs.[autompositiontaking] ELSE 0 END
           ,CASE WHEN SyncLiveCasino = 1 THEN cs.[isautompositiontaking] ELSE 0 END
	FROM  CustSettingGame cs WITH(NOLOCK) 
		INNER JOIN custinfo ci WITH(NOLOCK) ON ci.custid = cs.custid
		LEFT JOIN CustSettingGame cs2 WITH(NOLOCK) ON ci.custid = cs2.custid 
														AND cs2.sporttype = 255 
														AND cs2.bettype = 1701
	WHERE ci.srecommend IN (SELECT custid FROM #supers)
		AND ci.custid > @max_custid
		AND cs.sporttype = 162
		AND cs.bettype = 1101 
		AND cs2.custid IS NULL 
	       
	
	INSERT INTO [dbo].[CustOverrideGame]
           ([CustID]
           ,[Bettype]
           ,[Sporttype]
           ,[minpositiontaking])
	SELECT cs.[CustID]
           ,1701 as [Bettype]
           ,255 as [Sporttype]
           ,CASE WHEN SyncLiveCasino = 1 THEN cs.[minpositiontaking] ELSE 0 END          
    FROM  CustOverrideGame cs WITH(NOLOCK) 
		INNER JOIN custinfo ci WITH(NOLOCK) ON ci.custid = cs.custid
		LEFT JOIN CustOverrideGame cs2 WITH(NOLOCK) ON ci.custid = cs2.custid 
														AND cs2.sporttype = 255 
														AND cs2.bettype = 1701
	WHERE ci.srecommend IN (SELECT custid FROM #supers)
		AND ci.custid > @max_custid
		AND cs.sporttype = 162
		AND cs.bettype = 1101 
		AND cs2.custid IS NULL  
	
	INSERT INTO CustWinLimit(CustId
							,SportType
							,BetType
							,MaxWinLimit
							,IsAutoReset)
		SELECT ci.custid
			,255
			,1701
			,CASE WHEN SyncLiveCasino = 0 THEN 0 ELSE MaxWinLiveCasino END 
			,CASE WHEN SyncLiveCasino = 0 THEN 1 ELSE isAutoResetLiveCasino END
		FROM CustInfo ci WITH(NOLOCK)
			LEFT JOIN CustWinLimit cw WITH(NOLOCK) ON ci.custid = cw.custid
													AND cw.sporttype = 255
													AND cw.bettype = 1701
		WHERE srecommend IN (SELECT custid FROM #supers)
			AND ci.custid > @max_custid
			AND cw.custid IS NULL
	
GO

--step 2: correct comm for newly created customers have comm > 0.007
CREATE TABLE #tmpCust(custid INT, roleid INT)
DECLARE @max_custid INT 
SELECT @max_custid = xx

INSERT INTO #tmpCust(custid,roleid)
SELECT ci.custid, ci.roleid
FROM custSettingGame cs WITH(NOLOCK)
	INNER JOIN custinfo ci WITH(NOLOCK) ON cs.custid = ci.custid
											AND cs.sporttype = 255
											AND cs.bettype = 1701
WHERE ci.srecommend IN (SELECT custid FROM #supers)											
	AND ci.custid > @max_custid
	AND (cs.sdiscount > 0.007 OR cs.adiscount > 0.007 
		OR cs.discount > 0.007 OR cs.playerdiscount > 0.007)

UPDATE CustSettingGame WITH(UPDLOCK,ROWLOCK)
SET adiscount = CASE WHEN adiscount > 0.007 THEN 0.007 ELSE adiscount END
WHERE custid IN (SELECT custid FROM #tmpCust WHERE roleid =3)
	AND sporttype = 255
	AND bettype = 1701
	
UPDATE CustSettingGame WITH(UPDLOCK,ROWLOCK)
SET discount = CASE WHEN discount > 0.007 THEN 0.007 ELSE discount END
WHERE custid IN (SELECT custid FROM #tmpCust WHERE roleid = 2)
	AND sporttype = 255
	AND bettype = 1701	

UPDATE CustSettingGame WITH(UPDLOCK,ROWLOCK)
SET sdiscount = CASE WHEN sdiscount > 0.007 THEN 0.007 ELSE sdiscount END,
	adiscount = CASE WHEN adiscount > 0.007 THEN 0.007 ELSE adiscount END,
	discount = CASE WHEN discount > 0.007 THEN 0.007 ELSE discount END,
	playerdiscount = CASE WHEN playerdiscount > 0.007 THEN 0.007 ELSE playerdiscount END
WHERE custid IN (SELECT custid FROM #tmpCust WHERE roleid = 1)
	AND sporttype = 255
	AND bettype = 1701		
GO

--step 3: update pt/comm for different settings not adjust for line super who take pt LCS more than 93%  		
DELETE s
FROM #supers s
	INNER JOIN CustSettingGame cs WITH(NOLOCK) ON s.custid = cs.custid
												AND cs.sporttype = 162
												AND cs.bettype = 1101
WHERE spositiontaking > 0.93 


	UPDATE cs
	SET
		cs.apositiontaking = cs2.apositiontaking
		,cs.mpositiontaking = cs2.mpositiontaking
		,cs.spositiontaking = cs2.spositiontaking		
		,cs.autopositiontaking = cs2.autopositiontaking
		,cs.isautopositiontaking = cs2.isautopositiontaking
		,cs.autompositiontaking = cs2.autompositiontaking
		,cs.isautompositiontaking = cs2.isautompositiontaking
	FROM  custinfo ci WITH(NOLOCK) 		
		INNER JOIN CustSettingGame cs WITH(UPDLOCK,ROWLOCK) ON ci.custid = cs.custid 
														AND cs.sporttype = 255 
														AND cs.bettype = 1701
		INNER JOIN CustSettingGame cs2 WITH(NOLOCK) ON ci.custid = cs2.custid														
														AND cs2.sporttype = 162
														AND cs2.bettype = 1101 
	WHERE ci.srecommend IN (SELECT custid FROM #supers)
		AND ci.enabled = 1
		AND ci.SyncLiveCasino = 1
		AND (cs.apositiontaking <> cs2.apositiontaking
			OR cs.mpositiontaking <> cs2.mpositiontaking
			OR cs.spositiontaking <> cs2.spositiontaking			
			OR cs.autopositiontaking <> cs2.autopositiontaking
			OR cs.isautopositiontaking <> cs2.isautopositiontaking
			OR cs.autompositiontaking <> cs2.autompositiontaking
			OR cs.isautompositiontaking <> cs2.isautompositiontaking
		)
	GO
	
	UPDATE cs
	SET cs.minpositiontaking = cs2.minpositiontaking
	FROM  custinfo ci WITH(NOLOCK) 		
		INNER JOIN CustOverrideGame cs WITH(UPDLOCK,ROWLOCK) ON ci.custid = cs.custid 
														AND cs.sporttype = 255 
														AND cs.bettype = 1701
		INNER JOIN CustOverrideGame cs2 WITH(NOLOCK) ON ci.custid = cs2.custid														
														AND cs2.sporttype = 162
														AND cs2.bettype = 1101 
	WHERE ci.srecommend IN (SELECT custid FROM #supers)
		AND ci.enabled = 1
		AND ci.SyncLiveCasino = 1	
		AND cs.minpositiontaking <> cs2.minpositiontaking
GO


--step 4: correct enable status for newly created customers
CREATE TABLE #tmpCust(custid INT, roleid INT)

DECLARE @max_custid INT 
SELECT @max_custid = xx

INSERT INTO #tmpCust(custid,roleid)
SELECT custid,roleid
FROM custinfo WITH(NOLOCK)
WHERE srecommend IN (SELECT custid from #supers)				
	AND custid > @max_custid
	AND DisableGoldDeluxe IS NULL
GO

UPDATE ci
SET ci.DisableGoldDeluxe = upline.DisableGoldDeluxe
FROM Custinfo ci WITH(UPDLOCK, ROWLOCK)	
	INNER JOIN custinfo upline WITH(NOLOCK) ON upline.Custid = ci.srecommend
WHERE ci.custid IN (SELECT custid FROM #tmpCust WHERE roleid = 3)

UPDATE ci
SET ci.DisableGoldDeluxe = upline.DisableGoldDeluxe
FROM Custinfo ci WITH(UPDLOCK, ROWLOCK)	
	INNER JOIN custinfo upline WITH(NOLOCK) ON upline.Custid = ci.mrecommend
WHERE ci.custid IN (SELECT custid FROM #tmpCust WHERE roleid = 2)	
	
UPDATE ci
SET ci.DisableGoldDeluxe = upline.DisableGoldDeluxe
FROM Custinfo ci WITH(UPDLOCK, ROWLOCK)	
	INNER JOIN custinfo upline WITH(NOLOCK) ON upline.Custid = ci.recommend
WHERE ci.custid IN (SELECT custid FROM #tmpCust WHERE roleid = 1)				