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
--UPDATE CGT
--	SET IsDisabled = 1
--FROM CustGameType CGT WITH (ROWLOCK,UPDLOCK)
--	INNER JOIN #List1 l1 ON CGT.CustID = L1.CustID AND L1.RoleID = 1
--WHERE CGT.GameTypeID IN (1,3,4,5,8,11,13,14,15,16)	

-----------Step 2.2: Member: Insert PT and adjust PT 
DECLARE @sporttype SMALLINT = 202
declare @mpos smallmoney = 0
                ,@apos smallmoney = 0
                ,@spos smallmoney = 0
                ,@mapos1 smallmoney = 0
                ,@mapos2 smallmoney = 0
                ,@mapos smallmoney = 0
                ,@maxmapos smallmoney = 0
                
CREATE TABLE #AffectList (CustID INT)

INSERT INTO #AffectList (CustID)
SELECT CI.custid
FROM custInfo CI WITH (NOLOCK)
WHERE CI.custid IN (15672530,
15669993,
15671194,
15673061,
15671976,
15668987,
15671380,
15667957,
15667848,
15672770,
15672782,
15672788,
15672800,
15672803,
15671362,
15670610,
15673071,
15671361,
15670332,
15669616,
15673525,
15669716,
15672801,
20696396,
15670366,
15670485,
15668024,
15671874,
15672441,
15672463,
15669423,
15670979,
15671543,
15673867,
15673869,
15673870,
15673917,
15673920,
15673922,
15673927,
15673929,
15673949,
15673952,
15669782,
15672694,
15670622,
15672637)

DECLARE @recommend INT,@mrecommend INT,@srecommend INT

---Correct PT Member under Agent
CREATE TABLE #AgentList (CustID INT,isfinished bit default(0))

INSERT INTO #AgentList (CustID)
SELECT DISTINCT CI.recommend
FROM #AffectList A
	INNER JOIN custInfo CI WITH (NOLOCK) ON A.CustID = CI.custid
---Correct PT Member under Master
WHILE (1 = 1)
BEGIN
	
	UPDATE TOP (1) #AgentList
	SET isfinished = 1
		,@recommend = custid
	WHERE isfinished = 0
	
	IF @@ROWCOUNT = 0 BREAK
	
	UPDATE cs
            SET cs.apositiontaking = aco.minpositiontaking
            FROM CustSettingGame cs WITH (ROWLOCK, UPDLOCK)
                INNER JOIN CustInfo ci WITH(NOLOCK) ON cs.custid = ci.custid 
                INNER JOIN CustOverrideGame aco WITH(NOLOCK) ON aco.custid = @recommend AND cs.sporttype = aco.sporttype AND cs.bettype = aco.bettype
            WHERE ci.recommend = @recommend AND ci.roleid = 1
                AND cs.sporttype = @sporttype 
                AND cs.apositiontaking < aco.minpositiontaking
                AND cs.CustID IN (SELECT CustID From #AffectList) 
            
            --Check m1+a1: m1+a1>m3 => modify m1 set m1=m3-a1
            UPDATE cs
            SET cs.mpositiontaking = mcs.mpositiontaking - cs.apositiontaking
            FROM CustSettingGame cs WITH (ROWLOCK, UPDLOCK)
                INNER JOIN CustInfo ci WITH(NOLOCK) ON cs.custid = ci.custid 
                INNER JOIN CustSettingGame mcs WITH(NOLOCK) ON mcs.custid = ci.mrecommend AND mcs.sporttype = cs.sporttype AND mcs.bettype = cs.bettype 
            WHERE ci.recommend = @recommend AND ci.roleid = 1
                AND cs.sporttype = @sporttype 
                AND cs.mpositiontaking + cs.apositiontaking > mcs.mpositiontaking 
                AND cs.CustID IN (SELECT CustID From #AffectList)

            --Recal um2
            --Recal AUTO MPT m1=min(m3-a1,um2)
            UPDATE cs
            SET cs.mpositiontaking = CASE WHEN mcs.mpositiontaking-cs.apositiontaking > (CASE WHEN cs.isautompositiontaking = 1 THEN cs.autompositiontaking ELSE acs.autompositiontaking END)
                    THEN (CASE WHEN cs.isautompositiontaking = 1 THEN cs.autompositiontaking ELSE acs.autompositiontaking END)
                ELSE  mcs.mpositiontaking-cs.apositiontaking END
            FROM CustSettingGame cs WITH (ROWLOCK, UPDLOCK)
                INNER JOIN CustInfo ci WITH(NOLOCK) ON cs.custid = ci.custid 
                INNER JOIN CustSettingGame acs WITH(NOLOCK) ON acs.custid = @recommend AND acs.sporttype = cs.sporttype AND acs.bettype = cs.bettype 
                INNER JOIN CustSettingGame mcs WITH(NOLOCK) ON mcs.custid = ci.mrecommend AND mcs.sporttype = cs.sporttype AND mcs.bettype = cs.bettype 
            WHERE ci.recommend = @recommend AND ci.roleid = 1
                AND cs.sporttype = @sporttype 
                AND (cs.isautompositiontaking = 1 OR acs.isautompositiontaking = 1)
                AND cs.CustID IN (SELECT CustID From #AffectList)
            
            --Check min max n3<=m1+a1<=m3 => modify m1
            UPDATE cs
            SET cs.mpositiontaking = mco.minpositiontaking - cs.apositiontaking
            FROM CustSettingGame cs WITH (ROWLOCK, UPDLOCK)
                INNER JOIN custInfo ci WITH(NOLOCK) ON cs.custid = ci.custid 
                INNER JOIN CustOverrideGame mco WITH(NOLOCK) ON mco.custid = ci.mrecommend AND mco.sporttype = cs.sporttype AND mco.bettype = cs.bettype
            WHERE ci.recommend = @recommend AND ci.roleid = 1
                AND cs.sporttype = @sporttype 
                AND cs.mpositiontaking + cs.apositiontaking < mco.minpositiontaking
                AND cs.CustID IN (SELECT CustID From #AffectList)
            
            UPDATE cs
            SET cs.mpositiontaking = mcs.mpositiontaking - cs.apositiontaking
            FROM CustSettingGame cs WITH (ROWLOCK, UPDLOCK)
                INNER JOIN custInfo ci WITH(NOLOCK) ON cs.CustID = ci.custid
                INNER JOIN CustSettingGame mcs WITH(NOLOCK) ON mcs.custid = ci.mrecommend AND mcs.sporttype = cs.sporttype AND mcs.bettype = cs.bettype 
            WHERE ci.recommend = @recommend AND ci.roleid = 1
                AND cs.sporttype = @sporttype 
                AND cs.mpositiontaking + cs.apositiontaking > mcs.mpositiontaking
                AND cs.CustID IN (SELECT CustID From #AffectList)
            
            --Recal u3,u1
            -- s1=min(s4-m1-a1,u)
            UPDATE cs
            SET cs.spositiontaking = CASE WHEN scs.spositiontaking - cs.mpositiontaking - cs.apositiontaking > (CASE WHEN cs.isautopositiontaking = 1 THEN cs.autopositiontaking ELSE mcs.autopositiontaking END) THEN
                                CASE WHEN cs.isautopositiontaking = 1 THEN cs.autopositiontaking ELSE mcs.autopositiontaking END  ELSE
                                scs.spositiontaking - cs.mpositiontaking - cs.apositiontaking END
            FROM CustSettingGame cs WITH (ROWLOCK, UPDLOCK)
                INNER JOIN CustInfo ci WITH(NOLOCK) ON cs.custid = ci.custid 
                INNER JOIN CustSettingGame scs WITH(NOLOCK) ON scs.custid = ci.srecommend AND scs.sporttype = cs.sporttype AND scs.bettype = cs.bettype
                INNER JOIN CustSettingGame mcs WITH(NOLOCK) ON mcs.custid = ci.mrecommend AND mcs.sporttype = cs.sporttype AND mcs.bettype = cs.bettype         
            WHERE ci.recommend = @recommend AND ci.roleid = 1         
                AND cs.sporttype = @sporttype 
                AND (cs.isautopositiontaking = 1 OR mcs.isautopositiontaking = 1)
                AND cs.CustID IN (SELECT CustID From #AffectList)

            --check super min/max when a1+m1+s1<n4
            -- s1=n4-m1-a1
            UPDATE cs
            SET cs.spositiontaking = sco.minpositiontaking - cs.mpositiontaking - cs.apositiontaking 
            FROM CustSettingGame cs WITH (ROWLOCK, UPDLOCK)
                INNER JOIN CustInfo ci WITH(NOLOCK) ON cs.custid = ci.custid 
                INNER JOIN CustOverrideGame sco WITH(NOLOCK) ON sco.custid = ci.srecommend AND sco.sporttype = cs.sporttype AND sco.bettype = cs.bettype 
            WHERE ci.recommend = @recommend AND ci.roleid = 1
                AND cs.sporttype = @sporttype  
                AND cs.spositiontaking + cs.mpositiontaking + cs.apositiontaking < sco.minpositiontaking
                AND cs.CustID IN (SELECT CustID From #AffectList)
            
            --check a1+m1+s1 > s4
            UPDATE cs
            SET cs.spositiontaking = scs.spositiontaking - cs.mpositiontaking - cs.apositiontaking
            FROM CustSettingGame cs WITH (ROWLOCK, UPDLOCK)
                INNER JOIN CustInfo ci WITH(NOLOCK) ON cs.custid = ci.custid 
                INNER JOIN CustSettingGame scs WITH(NOLOCK) ON scs.custid = ci.srecommend AND scs.sporttype = cs.sporttype AND scs.bettype = cs.bettype 
            WHERE ci.recommend = @recommend AND ci.roleid = 1 
                AND cs.sporttype = @sporttype 
                AND cs.spositiontaking + cs.mpositiontaking + cs.apositiontaking > scs.spositiontaking
                AND cs.CustID IN (SELECT CustID From #AffectList)
                
END	

CREATE TABLE #MasterList (CustID INT,srecommend INT, isfinished bit default(0))

INSERT INTO #MasterList (CustID,srecommend)
SELECT DISTINCT CI.mrecommend,srecommend
FROM #AffectList AL
	INNER JOIN custInfo CI WITH (NOLOCK) ON AL.CustID = CI.custid

WHILE (1 = 1)
BEGIN
	
	UPDATE TOP (1) #MasterList
	SET isfinished = 1
		,@mrecommend = custid
		,@srecommend = srecommend	
	WHERE isfinished = 0
	
	IF @@ROWCOUNT = 0 BREAK
	
	--Recal AUTO MPT m1=min(m3-a1,u2)
    UPDATE cs
    SET cs.mpositiontaking = CASE WHEN mcs.mpositiontaking - cs.apositiontaking > CASE WHEN cs.isautompositiontaking = 1 THEN cs.autompositiontaking ELSE acs.autompositiontaking END THEN
                                        CASE WHEN cs.isautompositiontaking = 1 THEN cs.autompositiontaking ELSE acs.autompositiontaking END 
                                        ELSE mcs.mpositiontaking - cs.apositiontaking END
    FROM CustSettingGame cs WITH (ROWLOCK, UPDLOCK)
        INNER JOIN CustInfo ci WITH(NOLOCK) ON cs.custid = ci.custid
        INNER JOIN CustSettingGame acs WITH(NOLOCK) ON acs.custid = ci.recommend AND acs.sporttype = cs.sporttype AND acs.bettype = cs.bettype
        INNER JOIN CustSettingGame mcs WITH(NOLOCK) ON mcs.custid = @mrecommend AND mcs.sporttype = cs.sporttype AND mcs.bettype = cs.bettype 
    WHERE ci.mrecommend = @mrecommend AND ci.roleid = 1 AND ci.Enabled = 1
        AND cs.sporttype = @sporttype 
        AND (cs.isautompositiontaking = 1 OR acs.isautompositiontaking = 1)
        AND cs.CustID IN (SELECT CustID From #AffectList)

    --check master min/max
    --m1=n3-a1
    UPDATE cs
    SET cs.mpositiontaking = mco.minpositiontaking - cs.apositiontaking 
    FROM CustSettingGame cs WITH (ROWLOCK, UPDLOCK)
        INNER JOIN CustInfo ci WITH(NOLOCK) ON cs.custid = ci.custid 
        INNER JOIN CustOverrideGame mco WITH(NOLOCK) ON mco.custid = @mrecommend AND mco.sporttype = cs.sporttype AND mco.bettype = cs.bettype
    WHERE ci.mrecommend = @mrecommend AND ci.roleid = 1 AND ci.Enabled = 1
        AND cs.sporttype = @sporttype 
         AND cs.mpositiontaking + cs.apositiontaking < mco.minpositiontaking
		AND cs.CustID IN (SELECT CustID From #AffectList)
    -- Update m1,a1 when m1+a1>m3
    -- m1=m3-a1
    UPDATE cs
    SET @mpos = CASE WHEN mcs.mpositiontaking - cs.apositiontaking < 0 THEN 0 ELSE mcs.mpositiontaking - cs.apositiontaking END,
        cs.mpositiontaking = @mpos,
        @apos = CASE WHEN cs.apositiontaking + @mpos > mcs.mpositiontaking THEN mcs.mpositiontaking - @mpos ELSE cs.apositiontaking END ,
        cs.apositiontaking = CASE WHEN @apos < aco.minpositiontaking THEN aco.minpositiontaking ELSE @apos END 
    FROM CustSettingGame cs WITH (ROWLOCK, UPDLOCK)
        INNER JOIN CustInfo ci WITH(NOLOCK) ON cs.custid = ci.custid 
        INNER JOIN CustSettingGame mcs WITH(NOLOCK) ON mcs.custid = @mrecommend AND mcs.sporttype = cs.sporttype AND mcs.bettype = cs.bettype 
        INNER JOIN CustOverrideGame aco WITH(NOLOCK) ON aco.custid = ci.recommend AND aco.sporttype = cs.sporttype AND aco.bettype = cs.bettype
    WHERE ci.mrecommend = @mrecommend AND ci.roleid = 1 AND ci.Enabled = 1
        AND cs.sporttype = @sporttype  
        AND cs.mpositiontaking + cs.apositiontaking > mcs.mpositiontaking        
        AND cs.CustID IN (SELECT CustID From #AffectList)
    
        
    --recal autopos
    -- s1=min(s4-m1-a1,u)
    UPDATE cs
    SET cs.spositiontaking = CASE WHEN scs.spositiontaking - cs.mpositiontaking - cs.apositiontaking > CASE WHEN cs.isautopositiontaking = 1 THEN cs.autopositiontaking ELSE mcs.autopositiontaking END
                                THEN CASE WHEN cs.isautopositiontaking = 1 THEN cs.autopositiontaking ELSE mcs.autopositiontaking END
                                ELSE scs.spositiontaking - cs.mpositiontaking - cs.apositiontaking END 
    FROM CustSettingGame cs WITH (ROWLOCK, UPDLOCK)
        INNER JOIN CustInfo ci WITH(NOLOCK) ON cs.custid = ci.custid 
        INNER JOIN CustSettingGame scs WITH(NOLOCK) ON scs.custid = @srecommend AND scs.sporttype = cs.sporttype AND scs.bettype = cs.bettype 
        INNER JOIN CustSettingGame mcs WITH(NOLOCK) ON mcs.custid = @mrecommend AND mcs.sporttype = cs.sporttype AND mcs.bettype = cs.bettype 
    WHERE ci.mrecommend = @mrecommend AND ci.roleid = 1 AND ci.Enabled = 1
        AND cs.sporttype = @sporttype 
        AND (mcs.isautopositiontaking = 1 OR cs.isautopositiontaking = 1)
		AND cs.CustID IN (SELECT CustID From #AffectList)
    
    --check super min/max when a1+m1+s1<n4
    -- s1=n4-m1-a1
    UPDATE cs
    SET cs.spositiontaking = sco.minpositiontaking - cs.mpositiontaking - cs.apositiontaking 
    FROM CustSettingGame cs WITH (ROWLOCK, UPDLOCK)
        INNER JOIN CustInfo ci WITH(NOLOCK) ON cs.custid = ci.custid 
        INNER JOIN CustOverrideGame sco WITH(NOLOCK) ON sco.custid = @srecommend AND sco.sporttype = cs.sporttype AND sco.bettype = cs.bettype
    WHERE ci.mrecommend = @mrecommend AND ci.roleid = 1 AND ci.Enabled = 1
        AND cs.sporttype = @sporttype 
        AND cs.spositiontaking + cs.mpositiontaking + cs.apositiontaking < sco.minpositiontaking 
        AND cs.CustID IN (SELECT CustID From #AffectList)    
    --update s1,m1,a1 in case s1+m1+a1>s4
    --s1=max(0,s4-m1-a1)
    --@mapos1=iif(s1_new+m1+a1>s4,s4-s1_new,m1+a1)
    --@maxmapos=min(m3,l3)
    --@mapos2=min(@mapos1,@maxmapos)
    --@mapos=max(@mapos2,n3)
    --m1=max(0,@mapos-a1)
    --a1=iif(m1_new+a1>@mapos,@mapos-m1_new,a1)
    UPDATE cs
    SET @spos = CASE WHEN scs.spositiontaking - cs.mpositiontaking - cs.apositiontaking < 0 THEN 0 ELSE scs.spositiontaking - cs.mpositiontaking - cs.apositiontaking END,
        cs.spositiontaking = @spos,
        @mapos1 = CASE WHEN cs.mpositiontaking + cs.apositiontaking + @spos > scs.spositiontaking THEN scs.spositiontaking - @spos ELSE cs.mpositiontaking + cs.apositiontaking END,
        @mapos2 = CASE WHEN @mapos1 > mcs.mpositiontaking THEN mcs.mpositiontaking ELSE @mapos1 END,
        @mapos = CASE WHEN @mapos2 < mco.minpositiontaking THEN mco.minpositiontaking ELSE @mapos2 END,
        @mpos =  CASE WHEN @mapos - cs.apositiontaking < 0 THEN 0 ELSE @mapos - cs.apositiontaking END,
        cs.mpositiontaking = @mpos,
        @apos = CASE WHEN cs.apositiontaking + @mpos > @mapos THEN @mapos - @mpos ELSE cs.apositiontaking END,
        cs.apositiontaking = CASE WHEN @apos < aco.minpositiontaking THEN aco.minpositiontaking ELSE @apos END
    FROM CustSettingGame cs WITH (ROWLOCK, UPDLOCK)
        INNER JOIN CustInfo ci WITH(NOLOCK) ON cs.custid = ci.custid 
        INNER JOIN CustSettingGame scs WITH(NOLOCK) ON scs.custid = @srecommend AND scs.sporttype = cs.sporttype AND scs.bettype = cs.bettype 
        INNER JOIN CustSettingGame mcs WITH(NOLOCK) ON mcs.custid = @mrecommend AND mcs.sporttype = cs.sporttype AND mcs.bettype = cs.bettype 
        INNER JOIN CustOverrideGame mco WITH(NOLOCK) ON mco.custid = @mrecommend AND mco.sporttype = cs.sporttype AND mco.bettype = cs.bettype
        INNER JOIN CustSettingGame acs WITH(NOLOCK) ON acs.custid = ci.recommend AND acs.sporttype = cs.sporttype AND acs.bettype = cs.bettype 
        INNER JOIN CustOverrideGame aco WITH(NOLOCK) ON aco.custid = ci.recommend AND aco.sporttype = cs.sporttype AND aco.bettype = cs.bettype
    WHERE ci.mrecommend = @mrecommend AND ci.roleid = 1 AND ci.Enabled = 1
        AND cs.sporttype = @sporttype 
        AND cs.spositiontaking + cs.mpositiontaking + cs.apositiontaking > scs.spositiontaking 
		AND cs.CustID IN (SELECT CustID From #AffectList)    
   
END	

---Correct PT Member under Super
CREATE TABLE #SuperList (CustID INT, isfinished bit default(0))

INSERT INTO #SuperList (CustID)
SELECT DISTINCT srecommend
FROM #MasterList

SELECT @mpos  = 0
    ,@apos  = 0
    ,@spos  = 0
    ,@mapos1  = 0
    ,@mapos2  = 0
    ,@mapos  = 0
    ,@maxmapos  = 0
                
WHILE (1 = 1)
BEGIN
	UPDATE TOP (1) #SuperList
	SET isfinished = 1
		,@srecommend = custid	
	WHERE isfinished = 0
	
	IF @@ROWCOUNT = 0 BREAK


	 --u = (i3 or i1)?(u3 or u1)
    --s1 = min(s4-m1-a1, u)
    UPDATE cs 
    SET spositiontaking = CASE WHEN scs.spositiontaking - cs.mpositiontaking - cs.apositiontaking >
                                 CASE WHEN cs.isautopositiontaking = 1 THEN cs.autopositiontaking ELSE mcs.autopositiontaking END THEN
                                (CASE WHEN cs.isautopositiontaking = 1 THEN cs.autopositiontaking ELSE mcs.autopositiontaking END) 
                            ELSE scs.spositiontaking - cs.mpositiontaking - cs.apositiontaking 
                        END                            
    FROM CustSettingGame cs WITH (ROWLOCK, UPDLOCK)
        INNER JOIN CustInfo ci WITH(NOLOCK) ON ci.custid = cs.custid
        INNER JOIN CustSettingGame mcs WITH(NOLOCK) ON mcs.custid = ci.mrecommend AND mcs.sporttype = cs.sporttype AND mcs.bettype = cs.bettype
        INNER JOIN CustSettingGame scs WITH(NOLOCK) ON scs.custid = @srecommend AND scs.sporttype = cs.sporttype AND scs.bettype = cs.bettype
    WHERE ci.srecommend = @srecommend AND ci.roleid = 1
        AND ci.Enabled = 1
        AND cs.sporttype = @sporttype 
        AND (cs.isautopositiontaking = 1 OR mcs.isautopositiontaking = 1)     
		AND cs.CustID IN (SELECT CustID From #AffectList)
	--check super min
    --s1=max(n4-m1-a1,s1)
    UPDATE cs
       SET spositiontaking = sco.minpositiontaking - cs.mpositiontaking - cs.apositiontaking
    FROM CustSettingGame cs WITH(ROWLOCK, UPDLOCK)
		INNER JOIN custinfo mb WITH(NOLOCK) ON cs.custid = mb.custid
										   AND mb.srecommend = @srecommend
										   AND mb.roleid = 1
										   AND mb.Enabled = 1
		INNER JOIN CustOverrideGame sco WITH(NOLOCK) ON sco.custid = @srecommend
												   AND sco.sporttype = cs.sporttype
												   AND sco.bettype = cs.bettype
	WHERE  cs.sporttype = @sporttype 
		AND cs.apositiontaking + cs.mpositiontaking + cs.spositiontaking < sco.minpositiontaking
		AND cs.CustID IN (SELECT CustID From #AffectList)
	
END	
