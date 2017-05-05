/*
	Created: 20170504@Helen
	Task: Keno - Missing PT setting for some accounts - [Redmine: 76020]

*/

CREATE TABLE #List2 (CustID INT PRIMARY KEY,RoleID INT)
INSERT INTO #List2 (CustID,roleID)
VALUES (15669625),
(15672158),
(15669572),
(15735528),
(15669655),
(15671024),
(15670788),
(25265974),
(25267663),
(25322548),
(25263729),
(25450708),
(25450700),
(15671109),
(15673960),
(15670718),
(15953857),
(15670055),
(15671149),
(19743526),
(19743586),
(19743726),
(19743775),
(19743825),
(15671014),
(16061880),
(15671442),
(16328595),
(16518702),
(25015139),
(25431906),
(24794345),
(15672253),
(17372015),
(19357194),
(25131857),
(18639617),
(25741280),
--(20550129),
--(15668318),
(15669891),
(15674028),
(15673568),
(15863545),
(15712814)


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
SELECT L2.custid
	 , ps.Bettype
	 , 202
	 , csn.apositiontaking --apos
	 , csn.mpositiontaking --mpos
	 , csn.spositiontaking --spos
     , csn.playerdiscount --pdis
	 , csn.discount --dis
	 , csn.adiscount --adis
	 , csn.sdiscount --sdis
	 , csn.autopositiontaking --autopos
     , csn.isautopositiontaking --isautopos
	 , csn.autompositiontaking --autompos
	 , csn.isautompositiontaking --isautompos
FROM #List2 L2 
	INNER JOIN CustSetting3rd csn WITH(NOLOCK) ON L2.CustID = csn.CustID 
	CROSS JOIN ProductGlobalSetting ps WITH(NOLOCK) 
WHERE L2.RoleID IN (2,3) AND csn.Sporttype = 161 AND csn.bettype  = 81
	AND ps.Sporttype = 202 AND ps.IsDep = 0 
	AND NOT EXISTS (SELECT 1 FROM CustSettingGame CSG WITH (NOLOCK) WHERE CSG.CustID = L2.custid AND CSG.Sporttype = 202 AND CSG.Bettype = PS.Bettype)   

--CustOverrideGame
INSERT INTO [dbo].[CustOverrideGame]
(
    [custid]
  , [bettype]
  , [sporttype]
  , [minpositiontaking]
)
SELECT l2.custid
	 , ps.Bettype
	 , 202
	 , csn.minpositiontaking
FROM #List2 L2  
	INNER JOIN custOverride3rd csn WITH(NOLOCK) ON L2.CustID = csn.CustID AND csn.Sporttype = 161 AND csn.bettype  = 81
	CROSS JOIN ProductGlobalSetting ps WITH(NOLOCK) 
WHERE ps.Sporttype = 202 AND ps.IsDep = 0  
	AND NOT EXISTS (SELECT 1 FROM CustOverrideGame COG WITH (NOLOCK) WHERE COG.CustID = L2.custid AND COG.Sporttype = 202 AND COG.Bettype = PS.Bettype)   
