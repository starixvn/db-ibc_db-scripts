/*
	Created: Johnson
	Date: 2017-01-12
	Task: adjust pt/comm/win limit
	DB: DBCust/CustDB
*/

---------------------------------------------------------------------------------------------
---adjust pt/comm 
CREATE TABLE #supers (custid int)

INSERT INTO #supers(custid)
SELECT custid
FROM Customer WITH(NOLOCK)
WHERE roleid = 4 	
	AND site = '789y'
GO

--SMA settings
UPDATE cs
SET
	cs.apositiontaking = CASE WHEN SyncLiveCasino = 1 THEN cs2.apositiontaking ELSE 0 END 
	,cs.mpositiontaking = CASE WHEN SyncLiveCasino = 1 THEN cs2.mpositiontaking ELSE 0 END  
	,cs.spositiontaking = CASE WHEN SyncLiveCasino = 1 THEN cs2.spositiontaking ELSE 0 END			
	,cs.autopositiontaking = CASE WHEN SyncLiveCasino = 1 THEN cs2.autopositiontaking ELSE 0 END
	,cs.isautopositiontaking = CASE WHEN SyncLiveCasino = 1 THEN cs2.isautopositiontaking ELSE 0 END
	,cs.autompositiontaking = CASE WHEN SyncLiveCasino = 1 THEN cs2.autompositiontaking ELSE 0 END
	,cs.isautompositiontaking = CASE WHEN SyncLiveCasino = 1 THEN cs2.isautompositiontaking ELSE 0 END
	,cs.playerdiscount = CASE WHEN SyncLiveCasino = 1 THEN cs2.playerdiscount ELSE 0 END 
	,cs.discount = CASE WHEN SyncLiveCasino = 1 THEN cs2.discount ELSE 0 END 
	,cs.adiscount = CASE WHEN SyncLiveCasino = 1 THEN cs2.adiscount ELSE 0 END 
	,cs.sdiscount = CASE WHEN SyncLiveCasino = 1 THEN cs2.sdiscount ELSE 0 END 
FROM  custinfo ci WITH(NOLOCK) 		
	INNER JOIN CustSettingGame cs WITH(UPDLOCK,ROWLOCK) ON ci.custid = cs.custid 
													AND cs.sporttype = 255 
													AND cs.bettype = 1701
	INNER JOIN CustSettingGame cs2 WITH(NOLOCK) ON ci.custid = cs2.custid														
													AND cs2.sporttype = 162
													AND cs2.bettype = 1101 
WHERE ci.srecommend IN (SELECT custid FROM #supers)
	AND ci.enabled = 1	
	AND ci.roleid IN (2,3,4)	
	AND (cs.apositiontaking <> CASE WHEN SyncLiveCasino = 1 THEN cs2.apositiontaking ELSE 0 END 
		OR cs.mpositiontaking <> CASE WHEN SyncLiveCasino = 1 THEN cs2.mpositiontaking ELSE 0 END  
		OR cs.spositiontaking <> CASE WHEN SyncLiveCasino = 1 THEN cs2.spositiontaking ELSE 0 END			
		OR cs.autopositiontaking <> CASE WHEN SyncLiveCasino = 1 THEN cs2.autopositiontaking ELSE 0 END
		OR cs.isautopositiontaking <> CASE WHEN SyncLiveCasino = 1 THEN cs2.isautopositiontaking ELSE 0 END
		OR cs.autompositiontaking <> CASE WHEN SyncLiveCasino = 1 THEN cs2.autompositiontaking ELSE 0 END
		OR cs.isautompositiontaking <> CASE WHEN SyncLiveCasino = 1 THEN cs2.isautompositiontaking ELSE 0 END
		OR cs.playerdiscount <> CASE WHEN SyncLiveCasino = 1 THEN cs2.playerdiscount ELSE 0 END 
		OR cs.discount <> CASE WHEN SyncLiveCasino = 1 THEN cs2.discount ELSE 0 END 
		OR cs.adiscount <> CASE WHEN SyncLiveCasino = 1 THEN cs2.adiscount ELSE 0 END 
		OR cs.sdiscount <> CASE WHEN SyncLiveCasino = 1 THEN cs2.sdiscount ELSE 0 END 
	)
GO

--member pt/comm settings
UPDATE cs
SET
	cs.apositiontaking = CASE WHEN SyncLiveCasino = 1 THEN cs2.apositiontaking ELSE 0 END 
	,cs.mpositiontaking = CASE WHEN SyncLiveCasino = 1 THEN cs2.mpositiontaking ELSE 0 END  
	,cs.spositiontaking = CASE WHEN SyncLiveCasino = 1 THEN cs2.spositiontaking ELSE 0 END			
	,cs.autopositiontaking = CASE WHEN SyncLiveCasino = 1 THEN cs2.autopositiontaking ELSE 0 END
	,cs.isautopositiontaking = CASE WHEN SyncLiveCasino = 1 THEN cs2.isautopositiontaking ELSE 0 END
	,cs.autompositiontaking = CASE WHEN SyncLiveCasino = 1 THEN cs2.autompositiontaking ELSE 0 END
	,cs.isautompositiontaking = CASE WHEN SyncLiveCasino = 1 THEN cs2.isautompositiontaking ELSE 0 END
	,cs.playerdiscount = CASE WHEN SyncLiveCasino = 1 THEN cs2.playerdiscount ELSE 0 END 
	,cs.discount = CASE WHEN SyncLiveCasino = 1 THEN cs2.discount ELSE acs.discount END 
	,cs.adiscount = CASE WHEN SyncLiveCasino = 1 THEN cs2.adiscount ELSE mcs.adiscount END 
	,cs.sdiscount = CASE WHEN SyncLiveCasino = 1 THEN cs2.sdiscount ELSE scs.sdiscount END 
FROM  CustSettingGame cs WITH(UPDLOCK,ROWLOCK)
	INNER JOIN custinfo ci WITH(NOLOCK) ON ci.custid = cs.custid
											AND cs.sporttype = 255
											AND cs.bettype = 1701
	INNER JOIN CustSettingGame cs2 WITH(NOLOCK) ON cs2.custid = ci.custid 
												AND cs2.sporttype = 162 
												AND cs2.bettype = 1101
	INNER JOIN CustSettingGame acs WITH(NOLOCK) ON acs.custid = ci.recommend
												AND acs.sporttype = cs.sporttype
												AND acs.bettype = cs.bettype
	INNER JOIN CustSettingGame mcs WITH(NOLOCK) ON mcs.custid = ci.mrecommend
												AND mcs.sporttype = cs.sporttype
												AND mcs.bettype = cs.bettype
	INNER JOIN CustSettingGame scs WITH(NOLOCK) ON scs.custid = ci.srecommend
												AND scs.sporttype = cs.sporttype
												AND scs.bettype = cs.bettype													
WHERE ci.srecommend IN (SELECT custid FROM #supers)
	AND ci.enabled = 1	
	AND ci.roleid = 1	
	AND (cs.apositiontaking <> CASE WHEN SyncLiveCasino = 1 THEN cs2.apositiontaking ELSE 0 END 
		OR cs.mpositiontaking <> CASE WHEN SyncLiveCasino = 1 THEN cs2.mpositiontaking ELSE 0 END  
		OR cs.spositiontaking <> CASE WHEN SyncLiveCasino = 1 THEN cs2.spositiontaking ELSE 0 END			
		OR cs.autopositiontaking <> CASE WHEN SyncLiveCasino = 1 THEN cs2.autopositiontaking ELSE 0 END
		OR cs.isautopositiontaking <> CASE WHEN SyncLiveCasino = 1 THEN cs2.isautopositiontaking ELSE 0 END
		OR cs.autompositiontaking <> CASE WHEN SyncLiveCasino = 1 THEN cs2.autompositiontaking ELSE 0 END
		OR cs.isautompositiontaking <> CASE WHEN SyncLiveCasino = 1 THEN cs2.isautompositiontaking ELSE 0 END
		OR cs.playerdiscount <> CASE WHEN SyncLiveCasino = 1 THEN cs2.playerdiscount ELSE 0 END 
		OR cs.discount <> CASE WHEN SyncLiveCasino = 1 THEN cs2.discount ELSE acs.discount END 
		OR cs.adiscount <> CASE WHEN SyncLiveCasino = 1 THEN cs2.adiscount ELSE mcs.adiscount END 
		OR cs.sdiscount <> CASE WHEN SyncLiveCasino = 1 THEN cs2.sdiscount ELSE scs.sdiscount END 
	)
GO

UPDATE cs
SET cs.minpositiontaking =  CASE WHEN ci.SyncLiveCasino = 1	 THEN cs2.minpositiontaking	ELSE 0 END
FROM  custinfo ci WITH(NOLOCK) 		
	INNER JOIN CustOverrideGame cs WITH(UPDLOCK,ROWLOCK) ON ci.custid = cs.custid 
													AND cs.sporttype = 255 
													AND cs.bettype = 1701
	INNER JOIN CustOverrideGame cs2 WITH(NOLOCK) ON ci.custid = cs2.custid														
													AND cs2.sporttype = 162
													AND cs2.bettype = 1101 
WHERE ci.srecommend IN (SELECT custid FROM #supers)
	AND ci.enabled = 1
	AND cs.minpositiontaking <> CASE WHEN ci.SyncLiveCasino = 1	 THEN cs2.minpositiontaking	ELSE 0 END
GO

---------------------------------------------------------------------------------------------
---adjust winlimit
CREATE TABLE #MemberTemp
(
	CustID INT PRIMARY KEY CLUSTERED,
	SyncLiveCasino BIT,
	MaxWinLiveCasino SMALLMONEY,
	isAutoResetLiveCasino BIT
)

CREATE TABLE #SMATemp
(
	CustID INT PRIMARY KEY CLUSTERED,
	roleid TINYINT,
	SyncLiveCasino BIT,
	MaxWinLiveCasino SMALLMONEY,
	isAutoResetLiveCasino BIT
)

INSERT INTO #MemberTemp (CustID, SyncLiveCasino, MaxWinLiveCasino, isAutoResetLiveCasino)
SELECT custid, SyncLiveCasino, MaxWinLiveCasino, isAutoResetLiveCasino
FROM Custinfo WITH (NOLOCK)
WHERE srecommend IN (SELECT custid FROM #supers) AND roleid = 1  AND Enabled = 1
	
	
INSERT INTO #SMATemp (CustID, roleid, SyncLiveCasino, MaxWinLiveCasino, isAutoResetLiveCasino)
SELECT custid, roleid, SyncLiveCasino, MaxWinLiveCasino, isAutoResetLiveCasino
FROM Custinfo WITH (NOLOCK)
WHERE srecommend IN (SELECT custid FROM #supers) AND roleid IN (2,3,4) AND Enabled = 1

--super level
--select affected rows before update
UPDATE cs
SET cs.MaxWinLimit = CASE WHEN ci.syncLiveCasino = 1  THEN ci.MaxWinLiveCasino ELSE 0 END,
	cs.IsAutoReset = CASE WHEN ci.syncLiveCasino = 1  THEN ci.isAutoResetLiveCasino ELSE 1 END
FROM custinfo ci WITH(NOLOCK)
	INNER JOIN CustWinLimit cs WITH(UPDLOCK,ROWLOCK) ON cs.custid = ci.custid 
WHERE cs.sporttype = 255
	AND ci.custid IN (SELECT custid FROM #supers)	
	AND (cs.MaxWinLimit <> CASE WHEN ci.syncLiveCasino = 1  THEN ci.MaxWinLiveCasino ELSE 0 END
	OR cs.IsAutoReset <> CASE WHEN ci.syncLiveCasino = 1  THEN ci.isAutoResetLiveCasino ELSE 1 END)

--Master level
--select affected rows before update
UPDATE cs
SET cs.MaxWinLimit = CASE WHEN m.SyncLiveCasino = 1 THEN m.MaxWinLiveCasino 
						WHEN s.SyncLiveCasino = 1 THEN s.MaxWinLiveCasino ELSE 0 END,
	cs.IsAutoReset = CASE WHEN m.SyncLiveCasino = 1 THEN m.isAutoResetLiveCasino 
						WHEN s.SyncLiveCasino = 1 THEN s.isAutoResetLiveCasino ELSE 1 END					
FROM custinfo ci WITH(NOLOCK)
	INNER JOIN custWinlimit cs WITH(UPDLOCK,ROWLOCK) ON cs.custid = ci.custid 
	INNER JOIN #SMATemp m ON ci.custid = m.custid
	INNER JOIN #SMATemp s ON ci.srecommend = s.custid
WHERE cs.sporttype = 255
	AND ci.roleid = 3	
	AND ( cs.MaxWinLimit <> CASE WHEN m.SyncLiveCasino = 1 THEN m.MaxWinLiveCasino 
								WHEN s.SyncLiveCasino = 1 THEN s.MaxWinLiveCasino ELSE 0 END
		OR cs.IsAutoReset <> CASE WHEN m.SyncLiveCasino = 1 THEN m.isAutoResetLiveCasino 
								WHEN s.SyncLiveCasino = 1 THEN s.isAutoResetLiveCasino ELSE 1 END)

--Agent level
--select affected rows before update
UPDATE cs
SET cs.MaxWinLimit = CASE WHEN a.SyncLiveCasino = 1 THEN a.MaxWinLiveCasino 
						WHEN m.SyncLiveCasino = 1 THEN m.MaxWinLiveCasino 
						WHEN s.SyncLiveCasino = 1 THEN s.MaxWinLiveCasino ELSE 0 END,
	cs.IsAutoReset = CASE WHEN a.SyncLiveCasino = 1 THEN a.isAutoResetLiveCasino 
						WHEN m.SyncLiveCasino = 1 THEN m.isAutoResetLiveCasino 
						WHEN s.SyncLiveCasino = 1 THEN s.isAutoResetLiveCasino ELSE 1 END					
FROM custinfo ci WITH(NOLOCK)
	INNER JOIN custWinlimit cs WITH(UPDLOCK,ROWLOCK) ON cs.custid = ci.custid 
	INNER JOIN #SMATemp a ON ci.custid = a.custid
	INNER JOIN #SMATemp m ON ci.mrecommend = m.custid
	INNER JOIN #SMATemp s ON ci.srecommend = s.custid
WHERE cs.sporttype = 255
	AND ci.roleid = 2	
	AND ( cs.MaxWinLimit <> CASE WHEN a.SyncLiveCasino = 1 THEN a.MaxWinLiveCasino  
								WHEN m.SyncLiveCasino = 1 THEN m.MaxWinLiveCasino 
								WHEN s.SyncLiveCasino = 1 THEN s.MaxWinLiveCasino ELSE 0 END
		OR cs.IsAutoReset <> CASE WHEN a.SyncLiveCasino = 1 THEN a.isAutoResetLiveCasino 
								WHEN m.SyncLiveCasino = 1 THEN m.isAutoResetLiveCasino 
								WHEN s.SyncLiveCasino = 1 THEN s.isAutoResetLiveCasino ELSE 1 END)	

--member level
--select affected rows before update
UPDATE cs
SET cs.MaxWinLimit = CASE WHEN mem.SyncLiveCasino = 1 THEN mem.MaxWinLiveCasino 
						WHEN a.SyncLiveCasino = 1 THEN a.MaxWinLiveCasino 
						WHEN m.SyncLiveCasino = 1 THEN m.MaxWinLiveCasino 
						WHEN s.SyncLiveCasino = 1 THEN s.MaxWinLiveCasino ELSE 0 END,
	cs.IsAutoReset = CASE WHEN mem.SyncLiveCasino = 1 THEN mem.isAutoResetLiveCasino 
						WHEN a.SyncLiveCasino = 1 THEN a.isAutoResetLiveCasino 
						WHEN m.SyncLiveCasino = 1 THEN m.isAutoResetLiveCasino 
						WHEN s.SyncLiveCasino = 1 THEN s.isAutoResetLiveCasino ELSE 1 END					
FROM custinfo ci WITH(NOLOCK)
	INNER JOIN custWinlimit cs WITH(UPDLOCK,ROWLOCK) ON cs.custid = ci.custid 
	INNER JOIN  #MemberTemp mem ON ci.custid = mem.custid 
	INNER JOIN #SMATemp a ON ci.recommend = a.custid
	INNER JOIN #SMATemp m ON ci.mrecommend = m.custid
	INNER JOIN #SMATemp s ON ci.srecommend = s.custid
WHERE cs.sporttype = 255
	AND ci.roleid = 1	
	AND ( cs.MaxWinLimit <> CASE WHEN mem.SyncLiveCasino = 1 THEN mem.MaxWinLiveCasino   
								WHEN a.SyncLiveCasino = 1 THEN a.MaxWinLiveCasino  
								WHEN m.SyncLiveCasino = 1 THEN m.MaxWinLiveCasino 
								WHEN s.SyncLiveCasino = 1 THEN s.MaxWinLiveCasino ELSE 0 END
		OR cs.IsAutoReset <> CASE WHEN mem.SyncLiveCasino = 1 THEN mem.isAutoResetLiveCasino 
								WHEN a.SyncLiveCasino = 1 THEN a.isAutoResetLiveCasino 
								WHEN m.SyncLiveCasino = 1 THEN m.isAutoResetLiveCasino 
								WHEN s.SyncLiveCasino = 1 THEN s.isAutoResetLiveCasino ELSE 1 END)	






