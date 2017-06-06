/*
	Created: 20170504@Helen
	Task: Keno - Missing PT setting for some accounts - [Redmine: 76020]
	
	Notes: Item 5: 55 Agents [VIEW]
	
	Execution Date: Done on 06/06/2019 - At 93:30AM
	
*/
CREATE TABLE #Item5 (CustID INT PRIMARY KEY)
INSERT INTO #Item5 (CustID)
SELECT custid
FROM CustInfo WITH (NOLOCK)
WHERE custid IN (
15668627,
20550119,
15671745,
16581742,
17022669,
20220846,
15671512,
15672082,
15669514,
25263739,
15761195,
16222011,
15685066,
15685548,
15676027,
15683313,
15683362,
15668514,
20961676,
16709766,
15672039,
15673044,
15673050,
15673058,
15670333,
15671502,
15668433,
15684592,
15672477,
15678959,
20282854,
20304143,
15671941,
15671998,
15671268,
15670282,
15673022,
15669155,
15671811,
15670060,
15667866,
15672582,
15671897,
15670165,
15668776,
15668778,
15681809,
17025943,
15670141,
15672705,
15669976,
15669684,
15670476)

DELETE I5
FROM #Item5 I5
	INNER JOIN Customer C (NOLOCK) ON C.custid = I5.custid
WHERE C.site <> '789y'

-----------Step 1: Master and Agent: Insert default PT=0
INSERT INTO [dbo].[CustSettingGame] (CustID, Bettype, Sporttype, apositiontaking, mpositiontaking, spositiontaking, playerdiscount, discount, adiscount, sdiscount, autopositiontaking, isautopositiontaking, autompositiontaking, isautompositiontaking)
SELECT L1.custid , CS.bettype, 202, 0, mpositiontaking, 0, 0, 0, 0,  0, 0, 0 ,0 ,0       
FROM #Item5 L1 
	INNER JOIN custInfo CI WITH (NOLOCK) ON L1.CustID = CI.custid
	INNER JOIN CustSettingGame cs WITH(NOLOCK)ON cs.custid = CI.mrecommend and cs.sporttype = 202 AND cs.bettype BETWEEN 1501 AND 1599
WHERE NOT EXISTS (SELECT 1 FROM CustSettingGame CSG WITH (NOLOCK) WHERE CSG.CustID = L1.custid AND CSG.Sporttype = 202 AND CSG.Bettype = CS.Bettype)   

--CustOverrideGame
INSERT INTO [dbo].[CustOverrideGame]
(
    [custid]
  , [bettype]
  , [sporttype]
  , [minpositiontaking]
)
SELECT l1.custid
	 , CO.Bettype
	 , 202
	 , 0 --minpos
FROM #Item5 L1  
	INNER JOIN custInfo CI WITH (NOLOCK) ON L1.CustID = CI.custid
	INNER JOIN CustOverrideGame co WITH(NOLOCK) ON CO.CustID = CI.mrecommend AND co.sporttype = 202 AND co.bettype BETWEEN 1501 AND 1599	
WHERE  NOT EXISTS (SELECT 1 FROM CustOverrideGame COG WITH (NOLOCK) WHERE COG.CustID = L1.custid AND COG.Sporttype = 202 AND COG.Bettype = CO.Bettype)   
	
