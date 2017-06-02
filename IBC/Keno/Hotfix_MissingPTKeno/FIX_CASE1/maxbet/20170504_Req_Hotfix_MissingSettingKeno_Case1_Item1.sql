/*
	Created: 20170504@Helen
	Task: Keno - Missing PT setting for some accounts - [Redmine: 76020]

	Notes: 54 members will be having master + agent pt = 0 => super take all pt on members - [VIEW]
*/

CREATE TABLE #Item1 (CustID INT PRIMARY KEY)
INSERT INTO #Item1 (CustID)
SELECT custid
FROM CustInfo WITH (NOLOCK)
WHERE custid IN (15670602,
15670662,
15670677,
15670684,
15670791,
15670881,
15669942,
15669704,
15668348,
15671177,
15672613,
15672708,
15672652,
15672291,
15671086,
15668551,
15670895,
15670910,
15670922,
15670933,
15670939,
15670941,
15670946,
15670950,
15671951,
15672378,
15670878,
15674041,
15669398,
15669436,
15671702,
15672363,
15672009,
15672029,
15667879,
15667986,
15668033,
15668133,
15668189,
15670759,
15670975,
15671088,
15671102,
15673718,
15673634,
15669487,
15671634,
15674083,
15670099,
15670343,
15668420,
15668806,
15669947,
15669346)

DELETE I1
FROM #Item1 I1
	INNER JOIN custInfo CI (NOLOCK) ON I1.CustID = CI.custid
	INNER JOIN Customer C (NOLOCK) ON CI.recommend = C.custid
WHERE C.site = '789y'

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

