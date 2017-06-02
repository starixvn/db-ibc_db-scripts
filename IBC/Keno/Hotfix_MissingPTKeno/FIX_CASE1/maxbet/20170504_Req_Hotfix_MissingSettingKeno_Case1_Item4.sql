/*
	Created: 20170504@Helen
	Task: Keno - Missing PT setting for some accounts - [Redmine: 76020]

*/
CREATE TABLE #Item4 (CustID INT PRIMARY KEY)
INSERT INTO #Item4 (CustID)
SELECT custid
FROM CustInfo WITH (NOLOCK)
WHERE custid IN (15673669,
15673693,
15673713,
15668937,
15667875,
15670590,
15671715,
15672306,
15668009,
15668764,
15673493,
15672146,
15669784,
15672832,
21127767,
15671008,
15670828,
15671307,
15668754,
15673201,
15670654,
15671082,
15668700,
15668382,
15667861,
15670291,
15670363,
15667880,
15670110,
15670637
)

DELETE I4
FROM #Item4 I4
	INNER JOIN Customer C (NOLOCK) ON C.custid = I4.custid
WHERE C.site = '789y'

-----------Step 1: Master and Agent: Insert default PT=0
INSERT INTO [dbo].[CustSettingGame]
(
    [custid]
  , [bettype]
  , [sporttype]
  , [apositiontaking]
  , [mpositiontaking]
  , [spositiontaking]
  , [playerdiscount]
  , [discount]
  , [adiscount]
  , [sdiscount]
  , [autopositiontaking]
  , [isautopositiontaking]
  , [autompositiontaking]
  , [isautompositiontaking]
)
SELECT L1.custid , CS.bettype, 202, 0, 0, spositiontaking, 0, 0, 0,  0, 0, 0 ,0 ,0       
FROM #Item4 L1 
	INNER JOIN custInfo CI WITH (NOLOCK) ON L1.CustID = CI.custid
	INNER JOIN CustSettingGame cs WITH(NOLOCK)ON cs.custid = CI.srecommend and cs.sporttype = 202 AND cs.bettype BETWEEN 1501 AND 1599
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
FROM #Item4 L1  
	INNER JOIN custInfo CI WITH (NOLOCK) ON L1.CustID = CI.custid
	INNER JOIN CustOverrideGame co WITH(NOLOCK) ON CO.CustID = CI.srecommend AND co.sporttype = 202 AND co.bettype BETWEEN 1501 AND 1599	
WHERE  NOT EXISTS (SELECT 1 FROM CustOverrideGame COG WITH (NOLOCK) WHERE COG.CustID = L1.custid AND COG.Sporttype = 202 AND COG.Bettype = CO.Bettype)   
	
