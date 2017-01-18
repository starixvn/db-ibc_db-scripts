/*
	Created: Johnson
	Date: 2017-01-12
	Task: copy PT/Comm/Winlimit from LCS for GD for newly created customers
	DB: DBCUST/CustDB
*/

CREATE TABLE #supers (custid int)

INSERT INTO #supers(custid)
SELECT custid
FROM Customer WITH(NOLOCK)
WHERE roleid = 4 	
	AND site = '789y'
GO

---------------------------------------------------------------------------------------------
--check any mising setting before copy
DECLARE @max_custid INT = xx

SELECT COUNT(1) as 'missing custsettinggame'
FROM custinfo ci WITH(NOLOCK)
	LEFT JOIN custsettinggame cg WITH(NOLOCK) ON ci.custid = cg.custid
											AND cg.sporttype = 255
WHERE srecommend IN (select custid FROM #Supers)
	AND ci.custid > @max_custid	
	AND cg.custid IS NULL
	
	SELECT COUNT(1)  as 'missing custoverridegame'
FROM custinfo ci WITH(NOLOCK)
	LEFT JOIN custoverridegame cg WITH(NOLOCK) ON ci.custid = cg.custid
											AND cg.sporttype = 255
WHERE srecommend IN (select custid FROM #Supers)
	AND ci.custid > @max_custid	
	AND ci.roleid IN (2,3,4)
	AND cg.custid IS NULL

	SELECT COUNT(1) as 'missing custwinlimit'
FROM custinfo ci WITH(NOLOCK)
	LEFT JOIN custwinlimit cg WITH(NOLOCK) ON ci.custid = cg.custid
											AND cg.sporttype = 255
WHERE srecommend IN (select custid FROM #Supers)
	AND ci.custid > @max_custid	
	AND cg.custid IS NULL
GO

---------------------------------------------------------------------------------------------
--if missing winlimit
DECLARE @max_custid INT = xx			
		
CREATE TABLE #SMATemp
	(
		CustID INT PRIMARY KEY CLUSTERED,
		roleid TINYINT,
		SyncLiveCasino BIT,
		MaxWinLiveCasino SMALLMONEY,
		isAutoResetLiveCasino BIT
	)

INSERT INTO #SMATemp
SELECT custid, roleid, syncLiveCasino, MaxWinLiveCasino, isAutoResetLiveCasino
FROM custinfo ci WITH(NOLOCK)
WHERE srecommend IN (SELECT custid FROM #supers)
	AND roleid IN (2,3,4)
	AND Enabled = 1

--super level		
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
	LEFT JOIN CustWinLimit cs WITH (NOLOCK) ON ci.custid = cs.custid AND cs.sporttype = 255
WHERE ci.custid IN (SELECT custid FROM #supers)
	AND ci.custid >  @max_custid	
	AND ci.Enabled = 1
	AND cs.custid IS NULL
	
--master level
INSERT INTO CustWinLimit(CustId
						,SportType
						,BetType
						,MaxWinLimit
						,IsAutoReset)
SELECT ci.custid
	,255
	,1701
	,CASE WHEN ci.SyncLiveCasino = 1 THEN ci.MaxWinLiveCasino 
		WHEN s.syncLiveCasino = 1 THEN s.MaxWinLiveCasino
		ELSE 0 END 
	,CASE WHEN ci.SyncLiveCasino = 1 THEN ci.isAutoResetLiveCasino 
		WHEN s.syncLiveCasino = 1 THEN s.isAutoResetLiveCasino
		ELSE 1 END 
FROM CustInfo ci WITH(NOLOCK)
	INNER JOIN #SMATemp s ON ci.srecommend = s.custid
	LEFT JOIN CustWinLimit cs WITH (NOLOCK) ON ci.custid = cs.custid AND cs.sporttype = 255 
WHERE ci.srecommend IN (SELECT custid FROM #supers)
	AND ci.roleid = 3
	AND ci.custid >  @max_custid	
	AND ci.Enabled = 1
	AND cs.custid IS NULL
	
--agent level									
INSERT INTO CustWinLimit(CustId
						,SportType
						,BetType
						,MaxWinLimit
						,IsAutoReset)
SELECT ci.custid
	,255
	,1701
	,CASE WHEN ci.SyncLiveCasino = 1 THEN ci.MaxWinLiveCasino 
		WHEN m.syncLiveCasino = 1 THEN m.MaxWinLiveCasino
		WHEN s.syncLiveCasino = 1 THEN s.MaxWinLiveCasino
		ELSE 0 END 
	,CASE WHEN ci.SyncLiveCasino = 1 THEN ci.isAutoResetLiveCasino 
		WHEN m.syncLiveCasino = 1 THEN m.isAutoResetLiveCasino
		WHEN s.syncLiveCasino = 1 THEN s.isAutoResetLiveCasino
		ELSE 1 END 
FROM CustInfo ci WITH(NOLOCK)
	INNER JOIN #SMATemp s ON ci.srecommend = s.custid
	INNER JOIN #SMATemp m ON ci.mrecommend = m.custid
	LEFT JOIN CustWinLimit cs WITH (NOLOCK) ON ci.custid = cs.custid AND cs.sporttype = 255 
WHERE ci.srecommend IN (SELECT custid FROM #supers)
	AND ci.roleid = 2
	AND ci.custid >  @max_custid	
	AND ci.Enabled = 1
	AND cs.custid IS NULL
	
--member level
INSERT INTO CustWinLimit(CustId
						,SportType
						,BetType
						,MaxWinLimit
						,IsAutoReset)
SELECT ci.custid
	,255
	,1701
	,CASE WHEN ci.SyncLiveCasino = 1 THEN ci.MaxWinLiveCasino 
		WHEN a.syncLiveCasino = 1 THEN a.MaxWinLiveCasino
		WHEN m.syncLiveCasino = 1 THEN m.MaxWinLiveCasino
		WHEN s.syncLiveCasino = 1 THEN s.MaxWinLiveCasino
		ELSE 0 END 
	,CASE WHEN ci.SyncLiveCasino = 1 THEN ci.isAutoResetLiveCasino 
		WHEN a.syncLiveCasino = 1 THEN a.isAutoResetLiveCasino
		WHEN m.syncLiveCasino = 1 THEN m.isAutoResetLiveCasino
		WHEN s.syncLiveCasino = 1 THEN s.isAutoResetLiveCasino
		ELSE 1 END 
FROM CustInfo ci WITH(NOLOCK)
	INNER JOIN #SMATemp s ON ci.srecommend = s.custid
	INNER JOIN #SMATemp m ON ci.mrecommend = m.custid
	INNER JOIN #SMATemp a ON ci.recommend = a.custid
	LEFT JOIN CustWinLimit cs WITH (NOLOCK) ON ci.custid = cs.custid AND cs.sporttype = 255 
WHERE ci.srecommend IN (SELECT custid FROM #supers)
	AND ci.roleid = 1
	AND ci.custid >  @max_custid
	AND ci.Enabled = 1
	AND cs.custid IS NULL	
GO

---------------------------------------------------------------------------------------------
--if mising custsettinggame
--super/master/agent level

DECLARE @max_custid INT = xx

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
	LEFT JOIN CustSettingGame cs2 WITH(NOLOCK)  ON ci.custid = cs2.custid AND cs2.sporttype = 255
WHERE ci.srecommend IN (SELECT custid FROM #supers)
	AND ci.custid >  @max_custid
	AND ci.roleid IN (2,3,4)
	AND cs.sporttype = 162
	AND cs.bettype = 1101  
	AND ci.Enabled = 1
	AND cs2.custid IS NULL  

--member level
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
	   ,CASE WHEN SyncLiveCasino = 1 THEN cs.[discount] ELSE acs.discount END
	   ,CASE WHEN SyncLiveCasino = 1 THEN cs.[adiscount] ELSE mcs.adiscount END
	   ,CASE WHEN SyncLiveCasino = 1 THEN cs.[sdiscount] ELSE scs.sdiscount END
	   ,CASE WHEN SyncLiveCasino = 1 THEN cs.[autopositiontaking] ELSE 0 END
	   ,CASE WHEN SyncLiveCasino = 1 THEN cs.[isautopositiontaking] ELSE 0 END
	   ,CASE WHEN SyncLiveCasino = 1 THEN cs.[autompositiontaking] ELSE 0 END
	   ,CASE WHEN SyncLiveCasino = 1 THEN cs.[isautompositiontaking] ELSE 0 END
FROM  CustSettingGame cs WITH(NOLOCK) 
	INNER JOIN custinfo ci WITH(NOLOCK) ON ci.custid = cs.custid
	INNER JOIN CustSettingGame acs WITH(NOLOCK) ON acs.custid = ci.recommend
												AND acs.sporttype = 255
												AND acs.bettype = 1701
	INNER JOIN CustSettingGame mcs WITH(NOLOCK) ON mcs.custid = ci.mrecommend
												AND mcs.sporttype = 255
												AND mcs.bettype = 1701
	INNER JOIN CustSettingGame scs WITH(NOLOCK) ON scs.custid = ci.srecommend
												AND scs.sporttype = 255
												AND scs.bettype = 1701	
	LEFT JOIN CustSettingGame cs2 WITH(NOLOCK)  ON ci.custid = cs2.custid AND cs2.sporttype = 255												
WHERE ci.srecommend IN (SELECT custid FROM #supers)
	AND ci.custid >  @max_custid
	AND ci.roleid = 1
	AND cs.sporttype = 162
	AND cs.bettype = 1101  
	AND ci.enabled = 1   	
	AND cs2.custid IS NULL
GO

---------------------------------------------------------------------------------------------
--if mising custoverridegame	
	
DECLARE @max_custid INT = xx
			
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
	LEFT JOIN CustOverrideGame cs2 WITH(NOLOCK)  ON ci.custid = cs2.custid AND cs2.sporttype = 255
WHERE ci.srecommend IN (SELECT custid FROM #supers)
	AND ci.custid >  @max_custid
	AND ci.roleid IN (2,3,4)
	AND cs.sporttype = 162
	AND cs.bettype = 1101
	and enabled = 1	
	AND cs2.custid IS NULL


	
	
	
	
	
	
	
	