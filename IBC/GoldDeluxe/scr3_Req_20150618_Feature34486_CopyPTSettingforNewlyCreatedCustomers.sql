 /*
	Created: Johnson
	Task: copy pt & comm for Gold Deluxe from Live Casino for newly created customers
	DB: DBTXN/CustDB
	Date: 20150618
*/  


CREATE TABLE #supers (custid int)

INSERT INTO #supers(custid)
SELECT custid
FROM CustInfo WITH(NOLOCK)
WHERE roleid = 4 	
	AND custid NOT IN (SELECT custid FROM Dep_CustSuper WITH(NOLOCK))
GO

--step 1: copy settings for newly created customers
DECLARE @max_custid INT 
SELECT @max_custid = xx

INSERT INTO [dbo].[CustSettingGame]
           ([CustID]
           ,[Bettype]
           ,[Sporttype]
           ,[apositiontaking]
           ,[mpositiontaking]
           ,[spositiontaking]
           ,[playerdiscount]
           ,[discount]
           ,[adiscount]
           ,[sdiscount]
           ,[autopositiontaking]
           ,[isautopositiontaking]
           ,[autompositiontaking]
           ,[isautompositiontaking])
	SELECT cs.[CustID]
           ,1701 as [Bettype]
           ,255 as [Sporttype]
           ,CASE WHEN SyncLiveCasino = 1 THEN cs.[apositiontaking] ELSE 0 END
           ,CASE WHEN SyncLiveCasino = 1 THEN cs.[mpositiontaking] ELSE 0 END 
           ,CASE WHEN SyncLiveCasino = 1 THEN cs.[spositiontaking] ELSE 0 END
           ,CASE WHEN SyncLiveCasino = 1 THEN cs.[playerdiscount] ELSE 0 END
           ,CASE WHEN SyncLiveCasino = 1 THEN cs.[discount] ELSE 0 END
           ,CASE WHEN SyncLiveCasino = 1 THEN cs.[adiscount] ELSE 0 END
           ,CASE WHEN SyncLiveCasino = 1 THEN cs.[sdiscount] ELSE 0 END
           ,CASE WHEN SyncLiveCasino = 1 THEN cs.[autopositiontaking] ELSE 0 END
           ,CASE WHEN SyncLiveCasino = 1 THEN cs.[isautopositiontaking] ELSE 0 END
           ,CASE WHEN SyncLiveCasino = 1 THEN cs.[autompositiontaking] ELSE 0 END
           ,CASE WHEN SyncLiveCasino = 1 THEN cs.[isautompositiontaking] ELSE 0 END
	FROM  CustSettingGame cs WITH(NOLOCK) 
		INNER JOIN custinfo ci WITH(NOLOCK) ON ci.custid = cs.custid
		LEFT JOIN CustSettingGame cs2 WITH(NOLOCK) ON ci.custid = cs2.custid 
														AND cs2.sporttype = 255 
														AND cs2.bettype = 1701
	WHERE ci.srecommend IN (SELECT custid FROM #supers)
		AND ci.custid > @max_custid
		AND cs.sporttype = 162
		AND cs.bettype = 1101 
		AND cs2.custid IS NULL 
	       
	
	INSERT INTO [dbo].[CustOverrideGame]
           ([CustID]
           ,[Bettype]
           ,[Sporttype]
           ,[minpositiontaking])
	SELECT cs.[CustID]
           ,1701 as [Bettype]
           ,255 as [Sporttype]
           ,CASE WHEN SyncLiveCasino = 1 THEN cs.[minpositiontaking] ELSE 0 END          
    FROM  CustOverrideGame cs WITH(NOLOCK) 
		INNER JOIN custinfo ci WITH(NOLOCK) ON ci.custid = cs.custid
		LEFT JOIN CustOverrideGame cs2 WITH(NOLOCK) ON ci.custid = cs2.custid 
														AND cs2.sporttype = 255 
														AND cs2.bettype = 1701
	WHERE ci.srecommend IN (SELECT custid FROM #supers)
		AND ci.custid > @max_custid
		AND cs.sporttype = 162
		AND cs.bettype = 1101 
		AND cs2.custid IS NULL  
	
	INSERT INTO CustWinLimit(CustId
							,SportType
							,BetType
							,MaxWinLimit
							,IsAutoReset)
		SELECT ci.custid
			,255
			,1701
			,CASE WHEN SyncLiveCasino = 0 THEN 0 ELSE MaxWinLiveCasino END 
			,CASE WHEN SyncLiveCasino = 0 THEN 1 ELSE isAutoResetLiveCasino END
		FROM CustInfo ci WITH(NOLOCK)
			LEFT JOIN CustWinLimit cw WITH(NOLOCK) ON ci.custid = cw.custid
													AND cw.sporttype = 255
													AND cw.bettype = 1701
		WHERE srecommend IN (SELECT custid FROM #supers)
			AND ci.custid > @max_custid
			AND cw.custid IS NULL
	
GO

--step 2: update pt/comm for different settings not adjust for line super who take pt LCS more than 93%  		
DELETE s
FROM #sueprs s
	INNER JOIN CustSettingGame cs WITH(NOLOCK) ON s.custid = cs.custid
												AND cs.sporttype = 162
												AND cs.bettype = 1101
WHERE sposisiontaking > 0.93


	UPDATE cs
	SET
		cs.apositiontaking = cs2.apositiontaking
		,cs.mpositiontaking = cs2.mpositiontaking
		,cs.spositiontaking = cs2.spositiontaking
		,cs.playerdiscount = cs2.playerdiscount
		,cs.discount = cs2.discount
		,cs.adiscount = cs2.adiscount
		,cs.sdiscount = cs2.sdiscount
		,cs.autopositiontaking = cs2.autopositiontaking
		,cs.isautopositiontaking = cs2.isautopositiontaking
		,cs.autompositiontaking = cs2.autompositiontaking
		,cs.isautompositiontaking = cs2.isautompositiontaking
	FROM  custinfo ci WITH(NOLOCK) 		
		INNER JOIN CustSettingGame cs WITH(UPDLOCK,ROWLOCK) ON ci.custid = cs.custid 
														AND cs.sporttype = 255 
														AND cs.bettype = 1701
		INNER JOIN CustSettingGame cs2 WITH(NOLOCK) ON ci.custid = cs2.custid														
														AND cs2.sporttype = 162
														AND cs2.bettype = 1101 
	WHERE ci.srecommend IN (SELECT custid FROM #supers)
		AND ci.HideGoldDeluxe = 0	
		AND (cs.apositiontaking <> cs2.apositiontaking
			OR cs.mpositiontaking <> cs2.mpositiontaking
			OR cs.spositiontaking <> cs2.spositiontaking
			OR cs.playerdiscount <> cs2.playerdiscount
			OR cs.discount <> cs2.discount
			OR cs.adiscount <> cs2.adiscount
			OR cs.sdiscount <> cs2.sdiscount
			OR cs.autopositiontaking <> cs2.autopositiontaking
			OR cs.isautopositiontaking <> cs2.isautopositiontaking
			OR cs.autompositiontaking <> cs2.autompositiontaking
			OR cs.isautompositiontaking <> cs2.isautompositiontaking
		)
	GO
	
	UPDATE cs
	SET cs.minpositiontaking = cs2.minpositiontaking
	FROM  custinfo ci WITH(NOLOCK) 		
		INNER JOIN CustOverrideGame cs WITH(UPDLOCK,ROWLOCK) ON ci.custid = cs.custid 
														AND cs.sporttype = 255 
														AND cs.bettype = 1701
		INNER JOIN CustOverrideGame cs2 WITH(NOLOCK) ON ci.custid = cs2.custid														
														AND cs2.sporttype = 162
														AND cs2.bettype = 1101 
	WHERE ci.srecommend IN (SELECT custid FROM #supers)
		AND ci.HideGoldDeluxe = 0	
		AND cs.minpositiontaking <> cs2.minpositiontaking
GO


--step 3: adjust status

--agents list need to enable 
 select	16754954	custid,	3	roleid,	2	srecommend,	16754954 mrecommend	--	21A
 into #tmpEnableAgent
union select	3633125	,	2	,	2	,	4174	--	21M
union select	3290	,	2	,	2	,	4174	--	6599RM
union select	2430074	,	2	,	6	,	4179	--	6666AEU
union select	1937408	,	2	,	5	,	4178	--	6666AHK
union select	174095	,	2	,	9	,	4180	--	6666AUD
union select	3023	,	2	,	12	,	4181	--	6666BP
union select	9636	,	2	,	6	,	4179	--	6666EU
union select	2690	,	2	,	5	,	4178	--	6666HK
union select	7984	,	2	,	3	,	4176	--	6666US
union select	95304	,	2	,	1	,	4175	--	69SD
union select	15267	,	2	,	5	,	4178	--	6hk6601
union select	14737139	,	2	,	3	,	4176	--	A688U
union select	11999779	,	2	,	3	,	4176	--	A68US
union select	2460833	,	2	,	3	,	4176	--	ASA
union select	16311955	,	3	,	12	,	16311955	--	ASB
union select	17742	,	3	,	4	,	17742	--	CHITB
union select	5994	,	3	,	4	,	5994	--	CHTB
union select	210710	,	2	,	6	,	4179	--	CJEU
union select	3191187	,	3	,	6	,	3191187	--	DKE
union select	4458183	,	3	,	2	,	4458183	--	FFM
union select	3144218	,	3	,	12	,	3144218	--	JPG
union select	17003369	,	2	,	13	,	4182	--	LHHR
union select	3037128	,	3	,	5	,	3037128	--	LLKH
union select	861326	,	3	,	5	,	861326	--	M252H
union select	371646	,	3	,	13	,	371646	--	M252RMB
union select	199104	,	3	,	13	,	199104	--	M25ARMB
union select	259303	,	3	,	13	,	259303	--	M25BRMB
union select	65338	,	3	,	2	,	65338	--	M25RM
union select	974626	,	3	,	2	,	974626	--	M26ARM
union select	234010	,	3	,	13	,	234010	--	M26ARMB
union select	15334701	,	3	,	2	,	15334701	--	M26BRM
union select	834352	,	3	,	13	,	834352	--	M26BRMB
union select	268037	,	3	,	2	,	268037	--	M26RM
union select	234008	,	3	,	13	,	234008	--	M26RMB
union select	417557	,	3	,	1	,	417557	--	M26SD
union select	98332	,	3	,	2	,	98332	--	M359ARM
union select	252605	,	3	,	13	,	252605	--	M359ARMB
union select	186017	,	3	,	1	,	186017	--	M359ASD
union select	96337	,	3	,	6	,	96337	--	M359EU
union select	62834	,	3	,	2	,	62834	--	M359RM
union select	191176	,	3	,	13	,	191176	--	M359RMB
union select	68899	,	3	,	1	,	68899	--	M359SD
union select	1008226	,	3	,	5	,	1008226	--	M553AH
union select	666342	,	3	,	13	,	666342	--	M553AR
union select	1010926	,	3	,	5	,	1010926	--	M553BH
union select	946770	,	3	,	13	,	946770	--	M553BR
union select	1120951	,	3	,	5	,	1120951	--	M553CH
union select	1232142	,	3	,	5	,	1232142	--	M553DH
union select	994637	,	3	,	5	,	994637	--	M553H
union select	1175946	,	3	,	2	,	1175946	--	M553M
union select	666336	,	3	,	13	,	666336	--	M553R
union select	3869873	,	3	,	5	,	3869873	--	M69H
union select	2379922	,	3	,	3	,	2379922	--	M69U
union select	15219	,	3	,	5	,	15219	--	M6HK
union select	947130	,	3	,	2	,	947130	--	M6RM
union select	47030	,	3	,	1	,	47030	--	M6SD
union select	230731	,	3	,	13	,	230731	--	M71ARMB
union select	250150	,	3	,	13	,	250150	--	M71BRMB
union select	328390	,	3	,	13	,	328390	--	M71CRMB
union select	561337	,	3	,	13	,	561337	--	M71DRMB
union select	88659	,	3	,	13	,	88659	--	M71RMB
union select	1160105	,	3	,	5	,	1160105	--	M79H
union select	4148656	,	3	,	3	,	4148656	--	M79U
union select	5124437	,	3	,	3	,	5124437	--	M79V
union select	1111628	,	3	,	5	,	1111628	--	M8H
union select	8266979	,	3	,	2	,	8266979	--	MALM
union select	27026	,	3	,	2	,	27026	--	MAMRM
union select	16088600	,	3	,	6	,	16088600	--	MBY
union select	156124	,	3	,	4	,	156124	--	MGBTB
union select	206667	,	3	,	4	,	206667	--	MGCTB
union select	15517	,	3	,	4	,	15517	--	MGTB
union select	59305	,	3	,	13	,	59305	--	MJRMB
union select	207868	,	3	,	2	,	207868	--	MKWRM
union select	2114197	,	3	,	5	,	2114197	--	MMYBH
union select	325234	,	3	,	2	,	325234	--	MMYBRM
union select	3144085	,	3	,	5	,	3144085	--	MPH
union select	5875579	,	3	,	1	,	5875579	--	MPKS
union select	123990	,	3	,	4	,	123990	--	MRTB
union select	2486485	,	3	,	13	,	2486485	--	MSFR
union select	13348258	,	3	,	13	,	13348258	--	TG1
union select	13348483	,	3	,	13	,	13348483	--	TG2
union select	13348378	,	3	,	13	,	13348378	--	TG3
union select	13348559	,	3	,	13	,	13348559	--	TG4
union select	4295	,	2	,	2	,	4174	--	TKRM
union select	3411725	,	3	,	13	,	3411725	--	WBR
union select	4673332	,	3	,	13	,	4673332	--	WBRA
union select	6853841	,	3	,	13	,	6853841	--	wbrf
union select	11485599	,	3	,	13	,	11485599	--	WBRG
union select	11485623	,	3	,	13	,	11485623	--	WBRH
union select	11485641	,	3	,	13	,	11485641	--	WBRI
union select	11485655	,	3	,	13	,	11485655	--	WBRJ
union select	30168	,	3	,	13	,	30168	--	WBRMB
union select	4348440	,	3	,	13	,	4348440	--	WBRR
union select	10793	,	2	,	2	,	4174	--	ywrm

--only adjust for line agents change status
	DELETE t
	FROM #tmpEnableAgent t
		INNER JOIN custinfo ci WITH(NOLOCK) ON t.custid = ci.custid
	WHERE ci.DisableLiveCasino = ci.DisableGoldDeluxe
	
	--adjust for these lines
	IF EXISTS (SELECT TOP 1 1 FROM #tmpEnableAgent WHERE roleid = 4)
	BEGIN
		
	END
	
	
	--temp table store agents list need to update for whole line who have enable LCS
	
	 select 	16797404	custid,	4 roleid	,	16797404 srecommend	--	2AA
	 into #tmpDownlineEnable
	union select 	16804986	,	4	,	16804986	--	2AB
	union select 	16818047	,	4	,	16818047	--	2AC
	union select 	3634274	,	4	,	3634274	--	2AH
	union select 	3673145	,	4	,	3673145	--	2BH
	union select 	16252271	,	4	,	16252271	--	2BP
	union select 	3741448	,	4	,	3741448	--	2CH
	union select 	15848874	,	4	,	15848874	--	2CK
	union select 	13083302	,	4	,	13083302	--	2CR
	union select 	13344620	,	4	,	13344620	--	2CT
	union select 	8205964	,	4	,	8205964	--	2DD
	union select 	10050741	,	4	,	10050741	--	2DE
	union select 	3800272	,	4	,	3800272	--	2DH
	union select 	2468871	,	4	,	2468871	--	2EH
	union select 	7772435	,	4	,	7772435	--	2EU
	union select 	6660062	,	4	,	6660062	--	2FH
	union select 	6660080	,	4	,	6660080	--	2GH
	union select 	18826146	,	4	,	18826146	--	2HB
	union select 	9178183	,	4	,	9178183	--	2HH
	union select 	11779389	,	4	,	11779389	--	2HK
	union select 	4546372	,	4	,	4546372	--	2ID
	union select 	16110555	,	4	,	16110555	--	2IH
	union select 	14493765	,	4	,	14493765	--	2JH
	union select 	2850808	,	4	,	2850808	--	2KH
	union select 	4002647	,	4	,	4002647	--	2LH
	union select 	5154534	,	4	,	5154534	--	2MM
	union select 	8281764	,	4	,	8281764	--	2MN
	union select 	17045552	,	4	,	17045552	--	2MP
	union select 	17385596	,	4	,	17385596	--	2MQ
	union select 	17333226	,	4	,	17333226	--	2MY
	union select 	4582761	,	4	,	4582761	--	2NH
	union select 	11733282	,	4	,	11733282	--	2NN
	union select 	16632862	,	4	,	16632862	--	2OH
	union select 	4770359	,	4	,	4770359	--	2PH
	union select 	16429517	,	4	,	16429517	--	2QH
	union select 	15862762	,	4	,	15862762	--	2RH
	union select 	9670471	,	4	,	9670471	--	2RM
	union select 	12554928	,	4	,	12554928	--	2RR
	union select 	16651313	,	4	,	16651313	--	2SH
	union select 	18306101	,	4	,	18306101	--	2UH
	union select 	8452415	,	4	,	8452415	--	2WH
	union select 	15691505	,	4	,	15691505	--	2WW
	union select 	15691361	,	4	,	15691361	--	2XX
	union select 	5430927	,	4	,	5430927	--	2YH
	union select 	4347661	,	4	,	4347661	--	2ZH
	union select 	18608070	,	4	,	18608070	--	D66
	union select 	3535160	,	3	,	2	--	M222M
	union select 	668389	,	3	,	2	--	M797RM
	union select 	1551473	,	4	,	1551473	--	S222AH
	union select 	1607683	,	4	,	1607683	--	S222BH
	union select 	2114958	,	4	,	2114958	--	S222CH
	union select 	2267229	,	4	,	2267229	--	S222DH
	union select 	2468882	,	4	,	2468882	--	S222FH
	union select 	2644737	,	4	,	2644737	--	S222GH
	union select 	900801	,	4	,	900801	--	S222H
	union select 	1005645	,	4	,	1005645	--	S222HK
	union select 	8811657	,	4	,	8811657	--	S222JH
	union select 	2864145	,	4	,	2864145	--	S222MH
	union select 	15583137	,	4	,	15583137	--	S222N
	union select 	3033727	,	4	,	3033727	--	S222NH
	union select 	560429	,	4	,	560429	--	S222R
	union select 	1211966	,	4	,	1211966	--	S222T
	union select 	1716860	,	4	,	1716860	--	S222TA
	union select 	1687347	,	4	,	1687347	--	S222TH
	union select 	11644965	,	4	,	11644965	--	S222X
	union select 	15608059	,	4	,	15608059	--	S222ZH
	union select 	913630	,	4	,	913630	--	S797AH
	union select 	779655	,	4	,	779655	--	S797H
	union select 	582147	,	4	,	582147	--	S797R
	union select 	3854395	,	4	,	3854395	--	S797S
	union select 	7923118	,	4	,	7923118	--	S90H
	union select 	523974	,	4	,	523974	--	S90R
	union select 	997237	,	4	,	997237	--	SWAH
	union select 	1501259	,	4	,	1501259	--	SWB
	union select 	1590290	,	4	,	1590290	--	SWC
	union select 	1698383	,	4	,	1698383	--	SWD
	union select 	1788386	,	4	,	1788386	--	SWE
	union select 	2033407	,	4	,	2033407	--	SWF
	union select 	2101733	,	4	,	2101733	--	SWG
	union select 	965631	,	4	,	965631	--	SWH
	union select 	2122304	,	4	,	2122304	--	SWI
	union select 	2400801	,	4	,	2400801	--	SWJ
	union select 	4011723	,	4	,	4011723	--	SWN
	union select 	4290320	,	4	,	4290320	--	SWP
	union select 	7204275	,	4	,	7204275	--	SWQ
	union select 	8444096	,	4	,	8444096	--	SWR
	union select 	1348932	,	4	,	1348932	--	SWSH
	union select 	2522889	,	4	,	2522889	--	SWW
	union select 	8864778	,	4	,	8864778	--	SWX
	union select 	2895401	,	4	,	2895401	--	WE
	union select 	1376434	,	4	,	1376434	--	wm
	union select 	4045713	,	4	,	4045713	--	WMA
	union select 	8864806	,	4	,	8864806	--	WMB
	union select 	1419459	,	4	,	1419459	--	WN
	union select 	1465925	,	4	,	1465925	--	WT
	union select 	13216226	,	4	,	13216226	--	WTA			