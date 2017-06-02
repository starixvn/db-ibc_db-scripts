/*
	Created: 20170504@Helen
	Task: Keno - Missing PT setting for some accounts - [Redmine: 76020]
	
	Notes: Item 2 - 47 members will have diffirent pt with NG - [VIEW]
*/
CREATE TABLE #Item2 (CustID INT PRIMARY KEY)
INSERT INTO #Item2 (CustID)
SELECT custid
FROM CustInfo WITH (NOLOCK)
WHERE custid IN (15671194,
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
15672801,
15671543,
15671976,
15671361,
15671362,
15670332,
15670610,
15673071,
15672803,
15672770,
15672782,
15672788,
15672800,
15667848,
15672530,
15671229,
15670366,
15673525,
15669993,
15672637,
15667957,
15671380,
15668987,
15672694,
15669782,
15670622,
15673061,
15671874,
15670485,
15668024,
15672441,
15672463,
15670979,
15669423,
15669716,
15669616
)

DELETE I2
FROM #Item2 I2
	INNER JOIN custInfo CI (NOLOCK) ON I2.CustID = CI.custid
	INNER JOIN Customer C (NOLOCK) ON CI.recommend = C.custid
WHERE C.site <> '789y'

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
FROM #Item2 L1
	INNER JOIN CustSetting3rd csn WITH(NOLOCK) ON L1.CustID = csn.CustID 
	CROSS JOIN ProductGlobalSetting ps WITH(NOLOCK) 
WHERE csn.Sporttype = 161 AND csn.bettype  = 81
	AND ps.Sporttype = 202 AND ps.IsDep = 0 
	AND NOT EXISTS (SELECT 1 FROM CustSettingGame CSG WITH (NOLOCK) WHERE CSG.CustID = L1.custid AND CSG.Sporttype = 202 AND CSG.Bettype = PS.Bettype)   

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
FROM #Item2 A
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
                AND cs.CustID IN (SELECT CustID From #Item2) 
            
            --Check m1+a1: m1+a1>m3 => modify m1 set m1=m3-a1
            UPDATE cs
            SET cs.mpositiontaking = mcs.mpositiontaking - cs.apositiontaking
            FROM CustSettingGame cs WITH (ROWLOCK, UPDLOCK)
                INNER JOIN CustInfo ci WITH(NOLOCK) ON cs.custid = ci.custid 
                INNER JOIN CustSettingGame mcs WITH(NOLOCK) ON mcs.custid = ci.mrecommend AND mcs.sporttype = cs.sporttype AND mcs.bettype = cs.bettype 
            WHERE ci.recommend = @recommend AND ci.roleid = 1
                AND cs.sporttype = @sporttype 
                AND cs.mpositiontaking + cs.apositiontaking > mcs.mpositiontaking 
                AND cs.CustID IN (SELECT CustID From #Item2)

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
                AND cs.CustID IN (SELECT CustID From #Item2)
            
            --Check min max n3<=m1+a1<=m3 => modify m1
            UPDATE cs
            SET cs.mpositiontaking = mco.minpositiontaking - cs.apositiontaking
            FROM CustSettingGame cs WITH (ROWLOCK, UPDLOCK)
                INNER JOIN custInfo ci WITH(NOLOCK) ON cs.custid = ci.custid 
                INNER JOIN CustOverrideGame mco WITH(NOLOCK) ON mco.custid = ci.mrecommend AND mco.sporttype = cs.sporttype AND mco.bettype = cs.bettype
            WHERE ci.recommend = @recommend AND ci.roleid = 1
                AND cs.sporttype = @sporttype 
                AND cs.mpositiontaking + cs.apositiontaking < mco.minpositiontaking
                AND cs.CustID IN (SELECT CustID From #Item2)
            
            UPDATE cs
            SET cs.mpositiontaking = mcs.mpositiontaking - cs.apositiontaking
            FROM CustSettingGame cs WITH (ROWLOCK, UPDLOCK)
                INNER JOIN custInfo ci WITH(NOLOCK) ON cs.CustID = ci.custid
                INNER JOIN CustSettingGame mcs WITH(NOLOCK) ON mcs.custid = ci.mrecommend AND mcs.sporttype = cs.sporttype AND mcs.bettype = cs.bettype 
            WHERE ci.recommend = @recommend AND ci.roleid = 1
                AND cs.sporttype = @sporttype 
                AND cs.mpositiontaking + cs.apositiontaking > mcs.mpositiontaking
                AND cs.CustID IN (SELECT CustID From #Item2)
            
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
                AND cs.CustID IN (SELECT CustID From #Item2)

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
                AND cs.CustID IN (SELECT CustID From #Item2)
            
            --check a1+m1+s1 > s4
            UPDATE cs
            SET cs.spositiontaking = scs.spositiontaking - cs.mpositiontaking - cs.apositiontaking
            FROM CustSettingGame cs WITH (ROWLOCK, UPDLOCK)
                INNER JOIN CustInfo ci WITH(NOLOCK) ON cs.custid = ci.custid 
                INNER JOIN CustSettingGame scs WITH(NOLOCK) ON scs.custid = ci.srecommend AND scs.sporttype = cs.sporttype AND scs.bettype = cs.bettype 
            WHERE ci.recommend = @recommend AND ci.roleid = 1 
                AND cs.sporttype = @sporttype 
                AND cs.spositiontaking + cs.mpositiontaking + cs.apositiontaking > scs.spositiontaking
                AND cs.CustID IN (SELECT CustID From #Item2)
                
END	

---Correct PT Member under Master
CREATE TABLE #MasterList (CustID INT,srecommend INT, isfinished bit default(0))

INSERT INTO #MasterList (CustID,srecommend)
SELECT DISTINCT CI.mrecommend,srecommend
FROM #Item2 AL
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
        AND cs.CustID IN (SELECT CustID From #Item2)

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
		AND cs.CustID IN (SELECT CustID From #Item2)
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
        AND cs.CustID IN (SELECT CustID From #Item2)
    
        
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
		AND cs.CustID IN (SELECT CustID From #Item2)
    
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
        AND cs.CustID IN (SELECT CustID From #Item2)    
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
		AND cs.CustID IN (SELECT CustID From #Item2)    
   
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
		AND cs.CustID IN (SELECT CustID From #Item2)
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
		AND cs.CustID IN (SELECT CustID From #Item2)
	
END	
