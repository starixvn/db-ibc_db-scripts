/*
	Created: 20170504@Helen
	Task: Keno - Missing PT setting for some accounts - [Redmine: 76020]
	Notes: 155 accounts: either adding missing setting or copying from NG [VIEW]
	
	Execution Date: Done on 06/06/2019 - At 93:30AM
*/
CREATE TABLE #Item3 (CustID INT PRIMARY KEY)
INSERT INTO #Item3 (CustID)
SELECT custid
FROM CustInfo WITH (NOLOCK)
WHERE custid IN (15668356,
15672002,
15671939,
15668550,
15669082,
15668057,
15668092,
15669921,
15669257,
15672397,
15669309,
15668441,
15669379,
15670392,
15671286,
15669093,
15669807,
15668385,
15672209,
15670371,
15670352,
15670341,
15670296,
15670316,
15671831,
15671059,
15671281,
15673602,
15673737,
15672815,
15672818,
15673075,
15669907,
15670059,
15668677,
15671321,
15671233,
15672919,
15673131,
15673133,
15673135,
15673137,
15673140,
15673142,
15673144,
15673148,
15673158,
15673164,
15671049,
15673531,
15668725,
15670406,
15672600,
15669201,
15673516,
15673517,
15673519,
15673522,
15673523,
15673524,
15673527,
15673530,
15673335,
15671217,
15671225,
15671237,
15671265,
15671267,
15671269,
15671279,
15671283,
15671440,
15671435,
15671486,
15671360,
15671289,
15671368,
15671397,
15671400,
15671410,
15671372,
15671378,
15671420,
15670747,
15673023,
15673000,
15670955,
15672811,
15671135,
15668824,
15668829,
15668832,
15668836,
15668842,
15668847,
15668819,
15668820,
15669357,
15669363,
15669366,
15669372,
15669441,
15669446,
15669450,
15669453,
15669457,
15669464,
15669469,
15669473,
15669477,
15669486,
15668737,
15668706,
15668722,
15669491,
15669496,
15669500,
15674115,
15673262,
15673272,
15673274,
15670683,
15670742,
15669397,
15673347,
15672874,
15671370,
15668823,
15669714,
15670096,
15669687,
15669700,
15669678,
15668957,
15672927,
15670220,
15668958,
15670756,
15670813,
15668723,
15670163,
15670552,
15672389,
15672479,
15671964,
15671437,
15671447,
15671456,
15671462,
15671471,
15671478,
15671424,
15671432,
15671414,
15671419)

DELETE I3
FROM #Item3 I3
	INNER JOIN custInfo CI (NOLOCK) ON I3.CustID = CI.custid
	INNER JOIN Customer C (NOLOCK) ON CI.recommend = C.custid
WHERE C.site <> '789y'

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
SELECT L1.custid
	 , ps.Bettype
	 , 202
	 , 0 --apos
	 , 0 --mpos
	 , 0 --spos
     , 0 --pdis
	 , 0 --dis
	 , 0 --adis
	 , 0 --sdis
	 , 0 --autopos
     , 0 --isautopos
	 , 0 --autompos
	 , 0 --isautompos
FROM #Item3 L1 
	CROSS JOIN ProductGlobalSetting ps WITH(NOLOCK)
WHERE ps.Sporttype = 202 AND ps.IsDep = 0 
	AND NOT EXISTS (SELECT 1 FROM CustSettingGame CSG WITH (NOLOCK) WHERE CSG.CustID = L1.custid AND CSG.Sporttype = 202 AND CSG.Bettype = PS.Bettype)   
-----------Step 2.2: Member: adjust PT 

DECLARE @sporttype SMALLINT = 202
declare @mpos smallmoney = 0
                ,@apos smallmoney = 0
                ,@spos smallmoney = 0
                ,@mapos1 smallmoney = 0
                ,@mapos2 smallmoney = 0
                ,@mapos smallmoney = 0
                ,@maxmapos smallmoney = 0
 DECLARE @recommend INT,@mrecommend INT,@srecommend INT

---Correct PT Member under Agent
CREATE TABLE #AgentList (CustID INT,isfinished bit default(0))

INSERT INTO #AgentList (CustID)
SELECT DISTINCT CI.recommend
FROM #Item3 A
	INNER JOIN custInfo CI WITH (NOLOCK) ON A.CustID = CI.custid

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
                AND cs.CustID IN (SELECT CustID From #Item3) 
            
            --Check m1+a1: m1+a1>m3 => modify m1 set m1=m3-a1
            UPDATE cs
            SET cs.mpositiontaking = mcs.mpositiontaking - cs.apositiontaking
            FROM CustSettingGame cs WITH (ROWLOCK, UPDLOCK)
                INNER JOIN CustInfo ci WITH(NOLOCK) ON cs.custid = ci.custid 
                INNER JOIN CustSettingGame mcs WITH(NOLOCK) ON mcs.custid = ci.mrecommend AND mcs.sporttype = cs.sporttype AND mcs.bettype = cs.bettype 
            WHERE ci.recommend = @recommend AND ci.roleid = 1
                AND cs.sporttype = @sporttype 
                AND cs.mpositiontaking + cs.apositiontaking > mcs.mpositiontaking 
                AND cs.CustID IN (SELECT CustID From #Item3)

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
                AND cs.CustID IN (SELECT CustID From #Item3)
            
            --Check min max n3<=m1+a1<=m3 => modify m1
            UPDATE cs
            SET cs.mpositiontaking = mco.minpositiontaking - cs.apositiontaking
            FROM CustSettingGame cs WITH (ROWLOCK, UPDLOCK)
                INNER JOIN custInfo ci WITH(NOLOCK) ON cs.custid = ci.custid 
                INNER JOIN CustOverrideGame mco WITH(NOLOCK) ON mco.custid = ci.mrecommend AND mco.sporttype = cs.sporttype AND mco.bettype = cs.bettype
            WHERE ci.recommend = @recommend AND ci.roleid = 1
                AND cs.sporttype = @sporttype 
                AND cs.mpositiontaking + cs.apositiontaking < mco.minpositiontaking
                AND cs.CustID IN (SELECT CustID From #Item3)
            
            UPDATE cs
            SET cs.mpositiontaking = mcs.mpositiontaking - cs.apositiontaking
            FROM CustSettingGame cs WITH (ROWLOCK, UPDLOCK)
                INNER JOIN custInfo ci WITH(NOLOCK) ON cs.CustID = ci.custid
                INNER JOIN CustSettingGame mcs WITH(NOLOCK) ON mcs.custid = ci.mrecommend AND mcs.sporttype = cs.sporttype AND mcs.bettype = cs.bettype 
            WHERE ci.recommend = @recommend AND ci.roleid = 1
                AND cs.sporttype = @sporttype 
                AND cs.mpositiontaking + cs.apositiontaking > mcs.mpositiontaking
                AND cs.CustID IN (SELECT CustID From #Item3)
            
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
                AND cs.CustID IN (SELECT CustID From #Item3)

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
                AND cs.CustID IN (SELECT CustID From #Item3)
            
            --check a1+m1+s1 > s4
            UPDATE cs
            SET cs.spositiontaking = scs.spositiontaking - cs.mpositiontaking - cs.apositiontaking
            FROM CustSettingGame cs WITH (ROWLOCK, UPDLOCK)
                INNER JOIN CustInfo ci WITH(NOLOCK) ON cs.custid = ci.custid 
                INNER JOIN CustSettingGame scs WITH(NOLOCK) ON scs.custid = ci.srecommend AND scs.sporttype = cs.sporttype AND scs.bettype = cs.bettype 
            WHERE ci.recommend = @recommend AND ci.roleid = 1 
                AND cs.sporttype = @sporttype 
                AND cs.spositiontaking + cs.mpositiontaking + cs.apositiontaking > scs.spositiontaking
                AND cs.CustID IN (SELECT CustID From #Item3)
                
END	

---Correct PT Member under Master
CREATE TABLE #MasterList (CustID INT,srecommend INT, isfinished bit default(0))

INSERT INTO #MasterList (CustID,srecommend)
SELECT DISTINCT CI.mrecommend,srecommend
FROM #Item3 AL
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
        AND cs.CustID IN (SELECT CustID From #Item3)

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
		AND cs.CustID IN (SELECT CustID From #Item3)
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
        AND cs.CustID IN (SELECT CustID From #Item3)
    
        
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
		AND cs.CustID IN (SELECT CustID From #Item3)
    
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
        AND cs.CustID IN (SELECT CustID From #Item3)    
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
		AND cs.CustID IN (SELECT CustID From #Item3)    
   
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
		AND cs.CustID IN (SELECT CustID From #Item3)
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
		AND cs.CustID IN (SELECT CustID From #Item3)
	
END	

