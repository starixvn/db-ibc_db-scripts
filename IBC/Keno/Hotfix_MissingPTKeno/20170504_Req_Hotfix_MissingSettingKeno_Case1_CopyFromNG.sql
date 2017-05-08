/*
	Created: 20170504@Helen
	Task: Keno - Missing PT setting for some accounts - [Redmine: 76020]

*/
CREATE TABLE #List1 (CustID INT PRIMARY KEY,RoleID INT)
INSERT INTO #List1 (CustID,roleID)
VALUES 
(15671811,2),
(15678959,2),
(20282854,2),
(20304143,2),
(15671268,2),
(15671307,3),
(15669684,2),
(15670476,2),
(15673022,2),
(15671941,2),
(15670828,3),
(15668433,2),
(15672477,2),
(15672705,2),
(15670333,2),
(15671502,2),
(15670110,3),
(20550119,2),
(15668627,2),
(15669976,2),
(15671897,2),
(15673201,3),
(15668514,2),
(15668754,3),
(16709766,2),
(15669784,3),
(15672146,3),
(15669514,2),
(15669155,2),
(25263739,2),
(16222011,2),
(15761195,2),
(15668009,3),
(15670165,2),
(15668700,3),
(15668776,2),
(15668778,2),
(15672306,3),
(15667875,3),
(15668382,3),
(17025943,2),
(15681809,2),
(15671745,2),
(16581742,2),
(15670590,3),
(17022669,2),
(20220846,2),
(15671715,3),
(21442091,2),
(15671512,2),
(15672082,2),
(15684592,2),
(15672832,3),
(15671008,3),
(21127767,3),
(15670141,2),
(15676027,2),
(15685066,2),
(15685548,2),
(15683313,2),
(15683362,2),
(15668764,3),
(15670363,3),
(15667880,3),
(15670282,2),
(15667861,3),
(20961676,2),
(15673493,3),
(15671998,2),
(15673669,3),
(15673693,3),
(15673713,3),
(15670291,3),
(15673044,2),
(15673050,2),
(15673058,2),
(15672039,2),
(15670654,3),
(15668937,3),
(15670060,2),
(15667866,2),
(15672582,2),
(15671082,3),
(15670637,3),
(21442964,2),
(15669616,1),
(15669423,1),
(15670163,1),
(15669716,1),
(15670552,1),
(15668723,1),
(15671874,1),
(15669397,1),
(15670742,1),
(15667957,1),
(15673602,1),
(15671059,1),
(15671281,1),
(15672815,1),
(15672818,1),
(15673075,1),
(15671380,1),
(15673737,1),
(15668987,1),
(15669907,1),
(15670059,1),
(15670485,1),
(15668024,1),
(15670813,1),
(15670366,1),
(15673000,1),
(15671233,1),
(15671321,1),
(15672637,1),
(15671831,1),
(15668823,1),
(15672919,1),
(15670955,1),
(15672811,1),
(15671135,1),
(15668737,1),
(15668819,1),
(15668820,1),
(15668706,1),
(15668722,1),
(15669357,1),
(15669363,1),
(15669366,1),
(15669372,1),
(15668824,1),
(15668829,1),
(15668832,1),
(15668836,1),
(15668842,1),
(15668847,1),
(15669491,1),
(15669496,1),
(15669500,1),
(15669441,1),
(15669446,1),
(15669450,1),
(15669453,1),
(15669457,1),
(15669464,1),
(15669469,1),
(15669473,1),
(15669477,1),
(15669486,1),
(15673061,1),
(15674115,1),
(15673262,1),
(15673272,1),
(15673274,1),
(15671486,1),
(15671269,1),
(15671279,1),
(15671237,1),
(15671265,1),
(15671267,1),
(15671217,1),
(15671225,1),
(15670747,1),
(15671435,1),
(15671440,1),
(15671283,1),
(15671289,1),
(15671360,1),
(15671368,1),
(15671397,1),
(15671400,1),
(15671410,1),
(15671372,1),
(15671378,1),
(15671420,1),
(15673335,1),
(15673525,1),
(15669346,1),
(15670756,1),
(15671976,1),
(15671543,1),
(15672397,1),
(15669309,1),
(15669993,1),
(15668385,1),
(15669093,1),
(15668677,1),
(15669807,1),
(15672530,1),
(15671229,1),
(15673071,1),
(15670332,1),
(15670610,1),
(15671361,1),
(15671362,1),
(15673131,1),
(15673133,1),
(15673135,1),
(15673137,1),
(15673140,1),
(15673142,1),
(15673144,1),
(15673148,1),
(15673158,1),
(15673164,1),
(15670341,1),
(15670352,1),
(15670296,1),
(15670316,1),
(15670371,1),
(15671049,1),
(15669782,1),
(15672694,1),
(15668356,1),
(15671194,1),
(15672209,1),
(15672002,1),
(15671939,1),
(15669947,1),
(15668725,1),
(15669487,1),
(15674083,1),
(15671634,1),
(15673634,1),
(15667848,1),
(15672600,1),
(15670406,1),
(15668551,1),
(15673527,1),
(15673530,1),
(15673516,1),
(15673517,1),
(15673519,1),
(15673522,1),
(15673523,1),
(15673524,1),
(15673347,1),
(15672874,1),
(15671370,1),
(15669201,1),
(15672803,1),
(15672770,1),
(15672782,1),
(15672788,1),
(15672800,1),
(15672441,1),
(15672463,1),
(15669714,1),
(15669687,1),
(15669700,1),
(15669678,1),
(15668957,1),
(15670096,1),
(15672009,1),
(15672029,1),
(15669257,1),
(15672801,1),
(15670979,1),
(21443084,1),
(15670683,1),
(15668550,1),
(15672363,1),
(15671702,1),
(15669398,1),
(15669436,1),
(15672389,1),
(15672479,1),
(15668057,1),
(15668092,1),
(15670622,1),
(15669082,1),
(15671964,1),
(15670099,1),
(15670343,1),
(15668420,1),
(15670392,1),
(15669379,1),
(15671286,1),
(15668441,1),
(15670878,1),
(15672378,1),
(15671951,1),
(15670895,1),
(15670910,1),
(15670922,1),
(15670933,1),
(15670939,1),
(15670941,1),
(15670946,1),
(15670950,1),
(15674041,1),
(15668958,1),
(15670220,1),
(15672927,1),
(15669921,1),
(15670602,1),
(15670684,1),
(15670662,1),
(15670677,1),
(15670791,1),
(15672708,1),
(15671177,1),
(15672652,1),
(15672613,1),
(15668348,1),
(15670881,1),
(15669704,1),
(15669942,1),
(15672291,1),
(15671086,1),
(15671437,1),
(15671447,1),
(15671456,1),
(15671462,1),
(15671471,1),
(15671478,1),
(15671424,1),
(15671432,1),
(15671414,1),
(15671419,1),
(15668806,1),
(15673023,1),
(15673531,1),
(15673867,1),
(15673869,1),
(15673870,1),
(15673917,1),
(15673920,1),
(15673922,1),
(15673927,1),
(15673929,1),
(15673949,1),
(15673952,1),
(15670975,1),
(15673718,1),
(15671088,1),
(15671102,1),
(15670759,1),
(15668133,1),
(15668189,1),
(15667986,1),
(15667879,1),
(15668033,1),
(21443093,1),
(20696396,1)



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
FROM #List1 L1
	INNER JOIN CustSetting3rd csn WITH(NOLOCK) ON L1.CustID = csn.CustID 
	CROSS JOIN ProductGlobalSetting ps WITH(NOLOCK) 
WHERE csn.Sporttype = 161 AND csn.bettype  = 81
	AND ps.Sporttype = 202 AND ps.IsDep = 0 
	AND NOT EXISTS (SELECT 1 FROM CustSettingGame CSG WITH (NOLOCK) WHERE CSG.CustID = L1.custid AND CSG.Sporttype = 202 AND CSG.Bettype = PS.Bettype)   

--CustOverrideGame
INSERT INTO [dbo].[CustOverrideGame]
(
    [custid]
  , [bettype]
  , [sporttype]
  , [minpositiontaking]
)
SELECT l1.custid
	 , ps.Bettype
	 , 202
	 , csn.minpositiontaking
FROM #List1 L1  
	INNER JOIN custOverride3rd csn WITH(NOLOCK) ON L1.CustID = csn.CustID AND csn.Sporttype = 161 AND csn.bettype  = 81
	CROSS JOIN ProductGlobalSetting ps WITH(NOLOCK) 
WHERE ps.Sporttype = 202 AND ps.IsDep = 0 AND L1.RoleID IN (2,3) 
	AND NOT EXISTS (SELECT 1 FROM CustOverrideGame COG WITH (NOLOCK) WHERE COG.CustID = L1.custid AND COG.Sporttype = 202 AND COG.Bettype = PS.Bettype)   

---------


-----------Step 2: Member: Disable Keno for member, Insert PT and adjust PT 

-----------Step 2.1: Member: Disable Keno for member
UPDATE CGT
	SET IsDisabled = 1
FROM CustGameType CGT WITH (ROWLOCK,UPDLOCK)
	INNER JOIN #List1 l1 ON CGT.CustID = L1.CustID AND L1.RoleID = 1
WHERE CGT.GameTypeID IN (1,3,4,5,8,11,13,14,15,16)	

-----------Step 2.2: Member: Insert PT and adjust PT 
--- Correct PT Members under Agent
DECLARE @recommend INT

CREATE TABLE #AgentList (CustID INT, isfinished bit default(0))

INSERT INTO #AgentList (CustID)
SELECT custid FROM #List1 L 
WHERE L.RoleID = 2

UNION

SELECT CI.recommend
FROM #List1 L 
	INNER JOIN custInfo CI WITH (NOLOCK) ON L.CustID = CI.custid
WHERE L.RoleID = 1

WHILE (1 = 1)
BEGIN
	UPDATE TOP (1) #AgentList
	SET isfinished = 1
		,@recommend = custid	
	WHERE isfinished = 0
	
	IF @@ROWCOUNT = 0 BREAK
	
	EXEC dbo.Acc_CustSetting3rd_07 @recommend = @recommend, @roleid = 2, @mode = 'Keno', @Sporttype = 202, @BetType = 1501

	EXEC dbo.Acc_CustSetting3rd_07 @recommend = @recommend, @roleid = 2, @mode = 'Keno', @Sporttype = 202, @BetType = 1503

	EXEC dbo.Acc_CustSetting3rd_07 @recommend = @recommend, @roleid = 2, @mode = 'Keno', @Sporttype = 202, @BetType = 1504

	EXEC dbo.Acc_CustSetting3rd_07 @recommend = @recommend, @roleid = 2, @mode = 'Keno', @Sporttype = 202, @BetType = 1505

	EXEC dbo.Acc_CustSetting3rd_07 @recommend = @recommend, @roleid = 2, @mode = 'Keno', @Sporttype = 202, @BetType = 1507

	EXEC dbo.Acc_CustSetting3rd_07 @recommend = @recommend, @roleid = 2, @mode = 'Keno', @Sporttype = 202, @BetType = 1508

	EXEC dbo.Acc_CustSetting3rd_07 @recommend = @recommend, @roleid = 2, @mode = 'Keno', @Sporttype = 202, @BetType = 1509

	EXEC dbo.Acc_CustSetting3rd_07 @recommend = @recommend, @roleid = 2, @mode = 'Keno', @Sporttype = 202, @BetType = 1511

	EXEC dbo.Acc_CustSetting3rd_07 @recommend = @recommend, @roleid = 2, @mode = 'Keno', @Sporttype = 202, @BetType = 1513
	
	EXEC dbo.Acc_CustSetting3rd_07 @recommend = @recommend, @roleid = 2, @mode = 'Keno', @Sporttype = 202, @BetType = 1514
	
	--EXEC dbo.Acc_CustSetting3rd_07 @recommend = @recommend, @roleid = 2, @mode = 'Keno', @Sporttype = 202, @BetType = 1515
	
	--EXEC dbo.Acc_CustSetting3rd_07 @recommend = @recommend, @roleid = 2, @mode = 'Keno', @Sporttype = 202, @BetType = 1516
	
END		
---Correct PT Member under Master
DECLARE @mrecommend INT

CREATE TABLE #MasterList (CustID INT, isfinished bit default(0))

INSERT INTO #MasterList (CustID)
SELECT custid 
FROM #List1 L 
WHERE L.RoleID = 3

UNION

SELECT CI.mrecommend
FROM #List1 L 
	INNER JOIN custInfo CI WITH (NOLOCK) ON L.CustID = CI.custid
WHERE L.RoleID = 1


WHILE (1 = 1)
BEGIN
	UPDATE TOP (1) #MasterList
	SET isfinished = 1
		,@mrecommend = custid	
	WHERE isfinished = 0
	
	IF @@ROWCOUNT = 0 BREAK
	
	EXEC dbo.Acc_CustSetting3rd_07 @mrecommend = @mrecommend, @roleid = 3, @mode = 'Keno', @Sporttype = 202, @BetType = 1501

	EXEC dbo.Acc_CustSetting3rd_07 @mrecommend = @mrecommend, @roleid = 3, @mode = 'Keno', @Sporttype = 202, @BetType = 1503

	EXEC dbo.Acc_CustSetting3rd_07 @mrecommend = @mrecommend, @roleid = 3, @mode = 'Keno', @Sporttype = 202, @BetType = 1504

	EXEC dbo.Acc_CustSetting3rd_07 @mrecommend = @mrecommend, @roleid = 3, @mode = 'Keno', @Sporttype = 202, @BetType = 1505

	EXEC dbo.Acc_CustSetting3rd_07 @mrecommend = @mrecommend, @roleid = 3, @mode = 'Keno', @Sporttype = 202, @BetType = 1507

	EXEC dbo.Acc_CustSetting3rd_07 @mrecommend = @mrecommend, @roleid = 3, @mode = 'Keno', @Sporttype = 202, @BetType = 1508

	EXEC dbo.Acc_CustSetting3rd_07 @mrecommend = @mrecommend, @roleid = 3, @mode = 'Keno', @Sporttype = 202, @BetType = 1509

	EXEC dbo.Acc_CustSetting3rd_07 @mrecommend = @mrecommend, @roleid = 3, @mode = 'Keno', @Sporttype = 202, @BetType = 1511

	EXEC dbo.Acc_CustSetting3rd_07 @mrecommend = @mrecommend, @roleid = 3, @mode = 'Keno', @Sporttype = 202, @BetType = 1513
	
	EXEC dbo.Acc_CustSetting3rd_07 @mrecommend = @mrecommend, @roleid = 3, @mode = 'Keno', @Sporttype = 202, @BetType = 1514
	
	--EXEC dbo.Acc_CustSetting3rd_07 @mrecommend = @mrecommend, @roleid = 3, @mode = 'Keno', @Sporttype = 202, @BetType = 1515
	
	--EXEC dbo.Acc_CustSetting3rd_07 @mrecommend = @mrecommend, @roleid = 3, @mode = 'Keno', @Sporttype = 202, @BetType = 1516
	
END	

---Correct PT Member under Super

DECLARE @srecommend INT

CREATE TABLE #SuperList (CustID INT, isfinished bit default(0))

INSERT INTO #SuperList (CustID)
SELECT CI.srecommend
FROM #List1 L 
	INNER JOIN custInfo CI WITH (NOLOCK) ON L.CustID = CI.custid
WHERE L.RoleID = 1

UNION 

SELECT CI.srecommend
FROM #List1 L 
	INNER JOIN custInfo CI WITH (NOLOCK) ON L.CustID = CI.custid
WHERE L.RoleID = 2

UNION 

SELECT CI.srecommend
FROM #List1 L 
	INNER JOIN custInfo CI WITH (NOLOCK) ON L.CustID = CI.custid
WHERE L.RoleID = 3

WHILE (1 = 1)
BEGIN
	UPDATE TOP (1) #MasterList
	SET isfinished = 1
		,@srecommend = custid	
	WHERE isfinished = 0
	
	IF @@ROWCOUNT = 0 BREAK
	
	EXEC dbo.Acc_CustSetting3rd_07 @srecommend = @srecommend, @roleid = 4, @mode = 'Keno', @Sporttype = 202, @BetType = 1501

	EXEC dbo.Acc_CustSetting3rd_07 @srecommend = @srecommend, @roleid = 4, @mode = 'Keno', @Sporttype = 202, @BetType = 1503

	EXEC dbo.Acc_CustSetting3rd_07 @srecommend = @srecommend, @roleid = 4, @mode = 'Keno', @Sporttype = 202, @BetType = 1504

	EXEC dbo.Acc_CustSetting3rd_07 @srecommend = @srecommend, @roleid = 4, @mode = 'Keno', @Sporttype = 202, @BetType = 1505

	EXEC dbo.Acc_CustSetting3rd_07 @srecommend = @srecommend, @roleid = 4, @mode = 'Keno', @Sporttype = 202, @BetType = 1507

	EXEC dbo.Acc_CustSetting3rd_07 @srecommend = @srecommend, @roleid = 4, @mode = 'Keno', @Sporttype = 202, @BetType = 1508

	EXEC dbo.Acc_CustSetting3rd_07 @srecommend = @srecommend, @roleid = 4, @mode = 'Keno', @Sporttype = 202, @BetType = 1509

	EXEC dbo.Acc_CustSetting3rd_07 @srecommend = @srecommend, @roleid = 4, @mode = 'Keno', @Sporttype = 202, @BetType = 1511

	EXEC dbo.Acc_CustSetting3rd_07 @srecommend = @srecommend, @roleid = 4, @mode = 'Keno', @Sporttype = 202, @BetType = 1513
	
	EXEC dbo.Acc_CustSetting3rd_07 @srecommend = @srecommend, @roleid = 4, @mode = 'Keno', @Sporttype = 202, @BetType = 1514
	
	--EXEC dbo.Acc_CustSetting3rd_07 @srecommend = @srecommend, @roleid = 4, @mode = 'Keno', @Sporttype = 202, @BetType = 1515
	
	--EXEC dbo.Acc_CustSetting3rd_07 @srecommend = @srecommend, @roleid = 4, @mode = 'Keno', @Sporttype = 202, @BetType = 1516
	
END	
