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
		








