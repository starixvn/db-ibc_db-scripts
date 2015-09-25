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

--step 2: update pt/comm for different settings not adjust for line super who take pt LCS more than 93%  		
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
