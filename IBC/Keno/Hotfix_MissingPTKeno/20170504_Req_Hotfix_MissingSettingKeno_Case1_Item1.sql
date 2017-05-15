/*
	Created: 20170504@Helen
	Task: Keno - Missing PT setting for some accounts - [Redmine: 76020]

	Notes: 54 members will be having master + agent pt = 0 => super take all pt on members - [VIEW]
*/
CREATE TABLE #Item1 (CustID INT PRIMARY KEY)
INSERT INTO #Item1 (CustID)
VALUES (1)

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
SELECT L1.custid
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
FROM #Item1 L1
	INNER JOIN CustSetting3rd csn WITH(NOLOCK) ON L1.CustID = csn.CustID 
	CROSS JOIN ProductGlobalSetting ps WITH(NOLOCK) 
WHERE csn.Sporttype = 161 AND csn.bettype  = 81
	AND ps.Sporttype = 202 AND ps.IsDep = 0 
	AND NOT EXISTS (SELECT 1 FROM CustSettingGame CSG WITH (NOLOCK) WHERE CSG.CustID = L1.custid AND CSG.Sporttype = 202 AND CSG.Bettype = PS.Bettype)   

