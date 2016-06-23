/*
	Created: 20160622@Elodie
	Task: Fix data for Voidbridge PT setting 
	DB: DBCUST/CustDB
*/
USE [CustDB]
GO
--Action 1: 
UPDATE cs
SET cs.MasterPT = cs.MinPT
FROM dbo.CustPTSetting3rd_Agent cs
WHERE cs.CustID IN (423074,597212,640117,690112,614993,1631753)
	AND cs.SportType = 212 AND cs.BetType = 4001

--Action 2: 
CREATE TABLE #temp_mem (CustID INT, recommend INT, mrecommend INT, srecommend INT)

INSERT INTO #temp_mem (CustID, recommend, mrecommend, srecommend)
SELECT DISTINCT c.CustID, recommend, mrecommend, srecommend
FROM 
(SELECT	12908504 AS custid
UNION ALL SELECT	12518498
UNION ALL SELECT	13749767
UNION ALL SELECT	15016711
UNION ALL SELECT	15016790
UNION ALL SELECT	15016815
UNION ALL SELECT	15486892
UNION ALL SELECT	14265378
UNION ALL SELECT	14261035
UNION ALL SELECT	15165338
UNION ALL SELECT	15186615
UNION ALL SELECT	14219648
UNION ALL SELECT	14214541
UNION ALL SELECT	15465931
UNION ALL SELECT	17522509
UNION ALL SELECT	14205613
UNION ALL SELECT	14206816
UNION ALL SELECT	13645383
UNION ALL SELECT	13876931
UNION ALL SELECT	13876923
UNION ALL SELECT	14104452
UNION ALL SELECT	14104483
UNION ALL SELECT	14104448
UNION ALL SELECT	14106381
UNION ALL SELECT	14108887
UNION ALL SELECT	14109658
UNION ALL SELECT	14109689
UNION ALL SELECT	15360968
UNION ALL SELECT	15363401
UNION ALL SELECT	14109651
UNION ALL SELECT	14109687
UNION ALL SELECT	14111007
UNION ALL SELECT	15368331
UNION ALL SELECT	14109647
UNION ALL SELECT	14109681
UNION ALL SELECT	14109700
UNION ALL SELECT	14109654
UNION ALL SELECT	14109661
UNION ALL SELECT	14109693
UNION ALL SELECT	14117580
UNION ALL SELECT	15434106
UNION ALL SELECT	12649819
UNION ALL SELECT	12649849
UNION ALL SELECT	12649773
UNION ALL SELECT	12649805
UNION ALL SELECT	12680974
UNION ALL SELECT	14450108
UNION ALL SELECT	14667143
UNION ALL SELECT	14685802
UNION ALL SELECT	15967850
UNION ALL SELECT	14425333
UNION ALL SELECT	14425344
UNION ALL SELECT	14422407
UNION ALL SELECT	14425340
UNION ALL SELECT	14425357
UNION ALL SELECT	14629716
UNION ALL SELECT	14638046
UNION ALL SELECT	15950049
UNION ALL SELECT	15958104
UNION ALL SELECT	14313434
UNION ALL SELECT	14405005
UNION ALL SELECT	14425316
UNION ALL SELECT	14545486
UNION ALL SELECT	14545517
UNION ALL SELECT	15634924
UNION ALL SELECT	15637407
UNION ALL SELECT	15651812
UNION ALL SELECT	14567094
UNION ALL SELECT	15686165
UNION ALL SELECT	13337496
UNION ALL SELECT	13337577
UNION ALL SELECT	14888179
UNION ALL SELECT	14888318
UNION ALL SELECT	13622267
UNION ALL SELECT	13622274
UNION ALL SELECT	15016748
UNION ALL SELECT	13876927
UNION ALL SELECT	15293706
UNION ALL SELECT	15299154
UNION ALL SELECT	15299194
UNION ALL SELECT	15299246
UNION ALL SELECT	15303911
UNION ALL SELECT	15299225
UNION ALL SELECT	15303338
UNION ALL SELECT	14053183
UNION ALL SELECT	15346089
UNION ALL SELECT	14132361
UNION ALL SELECT	17075962
UNION ALL SELECT	17136133
UNION ALL SELECT	15392360
UNION ALL SELECT	14151405
UNION ALL SELECT	14157889
UNION ALL SELECT	14260906
UNION ALL SELECT	15513286
UNION ALL SELECT	15514405
UNION ALL SELECT	15514110
UNION ALL SELECT	15514393
UNION ALL SELECT	15514402
UNION ALL SELECT	14297541
UNION ALL SELECT	15512794
UNION ALL SELECT	15514399
UNION ALL SELECT	15536784
UNION ALL SELECT	14350520
UNION ALL SELECT	14545136
UNION ALL SELECT	14576879
UNION ALL SELECT	14699896
UNION ALL SELECT	15784381
UNION ALL SELECT	16016022
UNION ALL SELECT	17093599
UNION ALL SELECT	17112973
UNION ALL SELECT	17174613
UNION ALL SELECT	17219055
UNION ALL SELECT	17380865
UNION ALL SELECT	596206
UNION ALL SELECT	596239
UNION ALL SELECT	596218
UNION ALL SELECT	1836072
UNION ALL SELECT	1353937
UNION ALL SELECT	1365694
UNION ALL SELECT	1347718
UNION ALL SELECT	1641542
UNION ALL SELECT	1716433
UNION ALL SELECT	1787309
UNION ALL SELECT	999281
UNION ALL SELECT	1329095
UNION ALL SELECT	1329107
UNION ALL SELECT	1329108
UNION ALL SELECT	1440489
UNION ALL SELECT	1329101
UNION ALL SELECT	1424153
UNION ALL SELECT	1327135
UNION ALL SELECT	1347723
UNION ALL SELECT	1431688
UNION ALL SELECT	1041505
UNION ALL SELECT	999277) c
	INNER JOIN custinfo ci WITH (NOLOCK) ON c.Custid = ci.custid

-- declare variable table to keep super's settings 
CREATE TABLE #temp_sag (custid INT, sporttype SMALLINT, bettype SMALLINT, a4 SMALLMONEY, m4 SMALLMONEY, s4 SMALLMONEY, n4 SMALLMONEY, l4 SMALLMONEY
	UNIQUE CLUSTERED (custid, sporttype, bettype)
)

-- declare variable table to keep master's settings 
CREATE TABLE #temp_mag (custid INT, sporttype SMALLINT, bettype SMALLINT, a3 SMALLMONEY, m3 SMALLMONEY, s3 SMALLMONEY, u3 SMALLMONEY, i3 BIT, n3 SMALLMONEY, l3 SMALLMONEY
	UNIQUE CLUSTERED (custid, sporttype, bettype)
)

DECLARE @a2 smallmoney, @m2 smallmoney, @s2 smallmoney, @n2 smallmoney, @l2 smallmoney
DECLARE @im2 bit, @um2 smallmoney
DECLARE @a1 smallmoney, @m1 smallmoney, @s1 smallmoney, @i1 bit, @u1 smallmoney, @im1 bit, @um1 smallmoney
DECLARE @temp1 smallmoney, @temp2 smallmoney, @temp3 smallmoney
DECLARE @s_new smallmoney, @m_new smallmoney, @a_new smallmoney

INSERT INTO #temp_sag (custid, bettype, sporttype, a4, m4, s4, n4, l4)
SELECT DISTINCT scs.custid, scs.bettype, scs.sporttype, scs.AgentPT, scs.MasterPT, scs.SuperPT, scs.MinPT, scs.MaxPT
FROM dbo.CustPTSetting3rd_Agent scs WITH(NOLOCK)
	INNER JOIN #temp_mem tmp ON tmp.srecommend = scs.custid
WHERE scs.SportType = 212 AND scs.bettype = 4001 

INSERT INTO #temp_mag (custid, bettype, sporttype, a3, m3, s3, u3, i3, n3, l3)
SELECT DISTINCT mcs.custid, mcs.bettype, mcs.sporttype, mcs.AgentPT, mcs.MasterPT, mcs.SuperPT, mcs.AutoSuperPT, mcs.IsAutoSuperPT, mcs.MinPT, mcs.MaxPT
FROM dbo.CustPTSetting3rd_Agent mcs WITH(NOLOCK)
	INNER JOIN #temp_mem tmp ON tmp.mrecommend = mcs.custid
WHERE mcs.SportType = 212 AND mcs.bettype = 4001 

--*** START: update PT on member ***-----------------------	
UPDATE cs
SET @a1 = cs.AgentPT
	,@m1 = cs.MasterPT
	,@s1 = cs.SuperPT
	,@n2 = acs.MinPT
	,@l2 = acs.MaxPT
	,@im2 = acs.IsAutoMasterPT
	,@um2 = acs.AutoMasterPT
	,@i1 = cs.IsAutoSuperPT
	,@u1 = cs.AutoSuperPT
	,@im1 = cs.IsAutoMasterPT
	,@um1 = cs.AutoMasterPT
			
	-- rule #1: s1 = min(s1,s4-m3) if i=0
	,@s1 = CASE WHEN @i1 = 0 AND m.i3 = 0 AND s.s4-m.m3 < @s1 THEN s.s4-m.m3 ELSE @s1 END

	-- rule #2: a1 = max(a1,n2); m1 = (a1<n2) ? m3-n2 : m1 --agent min
	,@a_new = CASE WHEN @a1 < @n2 THEN @n2 ELSE @a1 END
	,@m_new = CASE WHEN @a1 < @n2 AND @m1+@n2 > m.m3 THEN m.m3-@n2 ELSE @m1 END
	,@a1 = @a_new
	,@m1 = @m_new								

	-- rule #3: a1 = min(a1,l2) -- agent max         
	,@a1 = CASE WHEN @a1 > @l2 THEN @l2 ELSE @a1 END

	-- rule #4: m1 = min(m3-a1,u2) if master auto -- Recalculate AUTO MPT 
	,@temp1 = CASE WHEN @im1 = 1 THEN @um1 ELSE @um2 END			
	,@m1 = CASE 
				WHEN @im2 = 1 OR @im1 = 1 
				THEN CASE WHEN m.m3-@a1 > @temp1 THEN @temp1 ELSE m.m3-@a1 END 
				ELSE @m1 
			END		

	-- rule #5: m1 = max(m1,n3-a1) -- master min   
	,@m1 = CASE WHEN @m1 < m.n3-@a1 THEN m.n3-@a1 ELSE @m1 END
			         
	-- rule #6: check master max 
	/*	@x1 = min(m3,l3) -- mpt max
		@x2 = max(@x1-a1,0) --mpt
		m1 = (a1+m1>l3) ? @x2 : m1
		@x3 = (a1+@x2 > @x1) ? @x1-@x2 : a1
		a1 = (a1+m1>l1) ? max(@x3, n2) : a1
	*/ 
	,@temp1 = CASE WHEN m.m3 > m.l3 THEN m.l3 ELSE m.m3 END
	,@temp2 = CASE WHEN @temp1-@a1 < 0 THEN 0 ELSE @temp1-@a1 END
	,@m_new = CASE WHEN @a1+@m1 > m.l3 THEN @temp2 ELSE @m1 END
	,@temp3 = CASE WHEN @a1+@temp2 > @temp1 THEN @temp1-@temp2 ELSE @a1 END
	,@a_new = CASE 
				WHEN @a1+@m1 > m.l3 
				THEN CASE WHEN @temp3 < @n2 THEN @n2 ELSE @temp3 END
				ELSE @a1 
			END	
				
	,@m1 = @m_new
	,@a1 = @a_new
	-- rule #7: s1 = min(s4-m1-a1, i1?u1:u3) --Recalculate auto pt
	/*
		@x1 = (i1=1) ? u1 : u3
		s1 = (s4-m1-a1 > @x1) ? @x1 : s4-m1-a1 
	*/
	,@temp1 = CASE WHEN @i1 = 1 THEN @u1 ELSE m.u3 END			
	,@s1 = CASE 
				WHEN @i1 = 1 OR m.i3 = 1 
				THEN CASE WHEN s.s4-@m1-@a1 > @temp1 THEN @temp1 ELSE s.s4-@m1-@a1 END
				ELSE @s1
			END		

	-- rule #8: s1 = max(n4-m1-a1,s1) --super min
	,@s1 = CASE WHEN @a1+@m1+@s1 < s.n4 THEN s.n4-@m1-@a1 ELSE @s1 END	

	-- rule #9: UPDATE s1,m1,a1 in case s1+m1+a1>s4
	/* -- explanation
		@x1 = (s4-m1-a1 < 0) ? 0 : s4-m1-a1
		s1 = (s1+a1+m1 > s4) ? @x1 : s1
		@x1 = (@x1+m1+a1 > s4) ? s4-@x1 : m1+a1
		@x2 = (m3 > l3) ? l3 : m3
		@x2 = (@x1 > @x2) ? @x2 : @x1
		@x2 = (@x2 < n3) ? n3 : @x2
		@x3 = (@x2-a1 < 0) ? 0 : @x2-a1
		m1 = (s1+a1+m1 > s4) ? @x3 : m1
		@x3 = (a1+@x3>@x2) ? @x2-@x3 : a1
		@x3 =  (@x3 < n2) ? n2 : @x3
		a1 = (s1+a1+m1 > s4) ? @x3 : a1				
	*/             
	,@temp1 = CASE WHEN s.s4-@m1-@a1 < 0 THEN 0 ELSE s.s4-@m1-@a1 END
	,@s_new = CASE WHEN @s1+@a1+@m1 > s.s4 THEN @temp1 ELSE @s1 END
	,@temp1 = CASE WHEN @temp1+@m1+@a1 > s.s4 THEN s.s4-@temp1 ELSE @m1+@a1 END
	,@temp2 = CASE WHEN m.m3 > m.l3 THEN m.l3 ELSE m.m3 END
	,@temp2 = CASE WHEN @temp1 > @temp2 THEN @temp2 ELSE @temp1 END
	,@temp2 = CASE WHEN @temp2 < m.n3 THEN m.n3 ELSE @temp2 END
	,@temp3 = CASE WHEN @temp2-@a1 < 0 THEN 0 ELSE @temp2-@a1 END
	,@m_new = CASE WHEN @s1+@a1+@m1 > s.s4 THEN @temp3 ELSE @m1 END
	,@temp3 = CASE WHEN @a1+@temp3 > @temp2 THEN @temp2-@temp3 ELSE @a1 END
	,@temp3 = CASE WHEN @temp3 < @n2 THEN @n2 ELSE @temp3 END
	,@a_new = CASE WHEN @s1+@a1+@m1 > s.s4 THEN @temp3 ELSE @a1 END
	,@s1 = @s_new
	,@m1 = @m_new
	,@a1 = @a_new
			
	--PT values must be in [0,100]
	,@s1 = CASE WHEN @s1 < 0 THEN 0 ELSE @s1 END
	,@s1 = CASE WHEN @s1 > 100 THEN 100 ELSE @s1 END
	,@m1 = CASE WHEN @m1 < 0 THEN 0 ELSE @m1 END
	,@m1 = CASE WHEN @m1 > 100 THEN 100 ELSE @m1 END
	,@a1 = CASE WHEN @a1 < 0 THEN 0 ELSE @a1 END
	,@a1 = CASE WHEN @a1 > 100 THEN 100 ELSE @a1 END
		
	--------------------------------	
	-- done apply all rule, then update to destination table
	,cs.AgentPT = @a1
	,cs.MasterPT = @m1
	,cs.SuperPT = @s1								       
FROM #temp_mem mem 
	INNER JOIN dbo.CustPTSetting3rd_Member cs ON cs.CustID = mem.CustID
	INNER JOIN CustPTSetting3rd_Agent acs WITH(NOLOCK) ON mem.recommend = acs.custid AND cs.sporttype = acs.sporttype AND cs.bettype = acs.bettype 
	INNER JOIN #temp_mag m ON mem.mrecommend = m.custid AND cs.sporttype = m.sporttype AND cs.bettype = m.bettype 
	INNER JOIN #temp_sag s ON mem.srecommend = s.custid AND cs.sporttype = s.sporttype AND cs.bettype = s.bettype 
WHERE cs.SportType = 212 AND cs.BetType = 4001
--*** END: update PT on member ***-------------------------		

--*** START: update PT group on member ***-----------------------	
UPDATE cs
SET @a1 = cs.AgentPT
	,@m1 = cs.MasterPT
	,@s1 = cs.SuperPT
	,@n2 = acs.MinPT
	,@l2 = acs.MaxPT
	,@im2 = acs.IsAutoMasterPT
	,@um2 = acs.AutoMasterPT
	,@i1 = cs.IsAutoSuperPT
	,@u1 = cs.AutoSuperPT
	,@im1 = cs.IsAutoMasterPT
	,@um1 = cs.AutoMasterPT
			
	-- rule #1: s1 = min(s1,s4-m3) if i=0
	,@s1 = CASE WHEN @i1 = 0 AND m.i3 = 0 AND s.s4-m.m3 < @s1 THEN s.s4-m.m3 ELSE @s1 END

	-- rule #2: a1 = max(a1,n2); m1 = (a1<n2) ? m3-n2 : m1 --agent min
	,@a_new = CASE WHEN @a1 < @n2 THEN @n2 ELSE @a1 END
	,@m_new = CASE WHEN @a1 < @n2 AND @m1+@n2 > m.m3 THEN m.m3-@n2 ELSE @m1 END
	,@a1 = @a_new
	,@m1 = @m_new								

	-- rule #3: a1 = min(a1,l2) -- agent max         
	,@a1 = CASE WHEN @a1 > @l2 THEN @l2 ELSE @a1 END

	-- rule #4: m1 = min(m3-a1,u2) if master auto -- Recalculate AUTO MPT 
	,@temp1 = CASE WHEN @im1 = 1 THEN @um1 ELSE @um2 END			
	,@m1 = CASE 
				WHEN @im2 = 1 OR @im1 = 1 
				THEN CASE WHEN m.m3-@a1 > @temp1 THEN @temp1 ELSE m.m3-@a1 END 
				ELSE @m1 
			END		

	-- rule #5: m1 = max(m1,n3-a1) -- master min   
	,@m1 = CASE WHEN @m1 < m.n3-@a1 THEN m.n3-@a1 ELSE @m1 END
			         
	-- rule #6: check master max 
	/*	@x1 = min(m3,l3) -- mpt max
		@x2 = max(@x1-a1,0) --mpt
		m1 = (a1+m1>l3) ? @x2 : m1
		@x3 = (a1+@x2 > @x1) ? @x1-@x2 : a1
		a1 = (a1+m1>l1) ? max(@x3, n2) : a1
	*/ 
	,@temp1 = CASE WHEN m.m3 > m.l3 THEN m.l3 ELSE m.m3 END
	,@temp2 = CASE WHEN @temp1-@a1 < 0 THEN 0 ELSE @temp1-@a1 END
	,@m_new = CASE WHEN @a1+@m1 > m.l3 THEN @temp2 ELSE @m1 END
	,@temp3 = CASE WHEN @a1+@temp2 > @temp1 THEN @temp1-@temp2 ELSE @a1 END
	,@a_new = CASE 
				WHEN @a1+@m1 > m.l3 
				THEN CASE WHEN @temp3 < @n2 THEN @n2 ELSE @temp3 END
				ELSE @a1 
			END	
				
	,@m1 = @m_new
	,@a1 = @a_new
	-- rule #7: s1 = min(s4-m1-a1, i1?u1:u3) --Recalculate auto pt
	/*
		@x1 = (i1=1) ? u1 : u3
		s1 = (s4-m1-a1 > @x1) ? @x1 : s4-m1-a1 
	*/
	,@temp1 = CASE WHEN @i1 = 1 THEN @u1 ELSE m.u3 END			
	,@s1 = CASE 
				WHEN @i1 = 1 OR m.i3 = 1 
				THEN CASE WHEN s.s4-@m1-@a1 > @temp1 THEN @temp1 ELSE s.s4-@m1-@a1 END
				ELSE @s1
			END		

	-- rule #8: s1 = max(n4-m1-a1,s1) --super min
	,@s1 = CASE WHEN @a1+@m1+@s1 < s.n4 THEN s.n4-@m1-@a1 ELSE @s1 END	

	-- rule #9: UPDATE s1,m1,a1 in case s1+m1+a1>s4
	/* -- explanation
		@x1 = (s4-m1-a1 < 0) ? 0 : s4-m1-a1
		s1 = (s1+a1+m1 > s4) ? @x1 : s1
		@x1 = (@x1+m1+a1 > s4) ? s4-@x1 : m1+a1
		@x2 = (m3 > l3) ? l3 : m3
		@x2 = (@x1 > @x2) ? @x2 : @x1
		@x2 = (@x2 < n3) ? n3 : @x2
		@x3 = (@x2-a1 < 0) ? 0 : @x2-a1
		m1 = (s1+a1+m1 > s4) ? @x3 : m1
		@x3 = (a1+@x3>@x2) ? @x2-@x3 : a1
		@x3 =  (@x3 < n2) ? n2 : @x3
		a1 = (s1+a1+m1 > s4) ? @x3 : a1				
	*/             
	,@temp1 = CASE WHEN s.s4-@m1-@a1 < 0 THEN 0 ELSE s.s4-@m1-@a1 END
	,@s_new = CASE WHEN @s1+@a1+@m1 > s.s4 THEN @temp1 ELSE @s1 END
	,@temp1 = CASE WHEN @temp1+@m1+@a1 > s.s4 THEN s.s4-@temp1 ELSE @m1+@a1 END
	,@temp2 = CASE WHEN m.m3 > m.l3 THEN m.l3 ELSE m.m3 END
	,@temp2 = CASE WHEN @temp1 > @temp2 THEN @temp2 ELSE @temp1 END
	,@temp2 = CASE WHEN @temp2 < m.n3 THEN m.n3 ELSE @temp2 END
	,@temp3 = CASE WHEN @temp2-@a1 < 0 THEN 0 ELSE @temp2-@a1 END
	,@m_new = CASE WHEN @s1+@a1+@m1 > s.s4 THEN @temp3 ELSE @m1 END
	,@temp3 = CASE WHEN @a1+@temp3 > @temp2 THEN @temp2-@temp3 ELSE @a1 END
	,@temp3 = CASE WHEN @temp3 < @n2 THEN @n2 ELSE @temp3 END
	,@a_new = CASE WHEN @s1+@a1+@m1 > s.s4 THEN @temp3 ELSE @a1 END
	,@s1 = @s_new
	,@m1 = @m_new
	,@a1 = @a_new
			
	--PT values must be in [0,100]
	,@s1 = CASE WHEN @s1 < 0 THEN 0 ELSE @s1 END
	,@s1 = CASE WHEN @s1 > 100 THEN 100 ELSE @s1 END
	,@m1 = CASE WHEN @m1 < 0 THEN 0 ELSE @m1 END
	,@m1 = CASE WHEN @m1 > 100 THEN 100 ELSE @m1 END
	,@a1 = CASE WHEN @a1 < 0 THEN 0 ELSE @a1 END
	,@a1 = CASE WHEN @a1 > 100 THEN 100 ELSE @a1 END
		
	--------------------------------	
	-- done apply all rule, then update to destination table
	,cs.AgentPT = @a1
	,cs.MasterPT = @m1
	,cs.SuperPT = @s1								       
FROM #temp_mem mem 
	INNER JOIN dbo.CustPTGroupSetting3rd_Member cs ON cs.AgentID = mem.recommend
	INNER JOIN CustPTSetting3rd_Agent acs WITH(NOLOCK) ON mem.recommend = acs.custid AND cs.sporttype = acs.sporttype AND cs.bettype = acs.bettype 
	INNER JOIN #temp_mag m ON mem.mrecommend = m.custid AND cs.sporttype = m.sporttype AND cs.bettype = m.bettype 
	INNER JOIN #temp_sag s ON mem.srecommend = s.custid AND cs.sporttype = s.sporttype AND cs.bettype = s.bettype 
WHERE cs.SportType = 212 AND cs.BetType = 4001
--*** END: update PT group on member ***-------------------------

DROP TABLE 	#temp_mem
DROP TABLE 	#temp_sag
DROP TABLE 	#temp_mag

