/*
	Created: Johnson
	Task: copy pt & comm for Gold Deluxe from Live Casino
	DB: DBCUST/CustDB
	Date: 20150618
*/ 
 ALTER PROCEDURE [dbo].[Acc_ExecRep_Cust_09]
	@srecommend INT	
	,@maxcustid INT
	,@target VARCHAR(20)
	,@DisableGoldDeluxe BIT
AS
BEGIN
	SET NOCOUNT ON
	
	IF (@target = 'REPLICATED' AND @@SERVERNAME = 'DBCUST') RETURN	-- run at all replicated servers
	IF (@target = 'DBCUST' AND @@SERVERNAME <> 'DBCUST') RETURN -- run at dbtrans only
	
	IF ( SELECT COUNT(1) FROM sys.objects WHERE NAME IN ('Custinfo')) <> 1
		RETURN
	
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
	
	--remove from enable agents list for accounts are disabled LCS
	DELETE t
	FROM #tmpEnableAgent t
		INNER JOIN custinfo ci WITH(NOLOCK) ON ci.custid = t.custid
	WHERE ci.DisableLiveCasino = 1
	
	
	--temp table store agents list need to update super/master only
	 select 	16597391 custid	,	3 roleid	,	2 srecommend	--	M999RM
	INTO #tmpSuperOnly
	union select 	463265	,	4	,	463265	--	SHK
	union select 	796555	,	4	,	796555	--	SPHM
	union select 	17818490	,	4	,	17818490	--	SQK
	union select 	955286	,	4	,	955286 -- SB8R
	union select 	1140623	,	4	,	1140623 -- SBB
	union select 	4622222	,	4	,	4622222 -- SBSD
	union select 	16576689	,	4	,	16576689 -- SBV
	union select 	1687145	,	4	,	1687145 -- TH8
	
	
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
	--20150930@Johnson: move 2 accounts to enable whole line list
	/*
	union select 	7923118	,	4	,	7923118	--	S90H
	union select 	523974	,	4	,	523974	--	S90R
	*/
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
			
	--update status for Gold Deluxe
	IF @srecommend <= 100--for line dummy
	BEGIN
		--Disable downlines under this dummy				
		UPDATE CustInfo WITH(UPDLOCK,ROWLOCK)
		SET DisableGoldDeluxe = 1,
			HideGoldDeluxe = 1				
		WHERE srecommend = @srecommend
			AND custid <= @maxcustid
			AND roleid < 4
			
		--Enable for dummy super only or some direct masters, agents
		UPDATE CustInfo WITH(UPDLOCK,ROWLOCK)
		SET DisableGoldDeluxe = 0
			,HideGoldDeluxe = 1					
		WHERE custid = @srecommend
		OR 
		(srecommend = @srecommend
			AND (
					--update all downlines under super/master
					mrecommend IN (SELECT custid FROM #tmpEnableAgent WHERE roleid = 3 AND srecommend = @srecommend)--downline of master
					OR recommend IN (SELECT custid FROM #tmpEnableAgent WHERE roleid = 2 AND srecommend = @srecommend)--downline of agent
					OR custid IN (SELECT mrecommend FROM #tmpEnableAgent WHERE roleid = 2 AND srecommend = @srecommend)--upline of agent				
					--update only super/master
					OR custid IN (SELECT custid FROM #tmpSuperOnly WHERE srecommend = @srecommend )--only update super/master
					--update downlines who enable LCS under master 
					OR (mrecommend IN (SELECT custid FROM #tmpDownlineEnable WHERE srecommend = @srecommend and roleid = 3) 
						AND DisableLiveCasino = 0
						)
				)
			AND custid <= @maxcustid			
		)		
	END
	ELSE 
	BEGIN
		IF @DisableGoldDeluxe = 1
		BEGIN
			UPDATE CustInfo WITH(UPDLOCK,ROWLOCK)
			SET DisableGoldDeluxe = 1,
				HideGoldDeluxe = 1
			WHERE srecommend = @srecommend
				AND custid <= @maxcustid
		END				
		ELSE-- enable Gold Deluxe
		BEGIN
			--update for super/master only
			IF EXISTS (SELECT 1 FROM #tmpSuperOnly WHERE srecommend = @srecommend)
			BEGIN
				UPDATE CustInfo WITH(UPDLOCK,ROWLOCK)
				SET DisableGoldDeluxe = 0,
					HideGoldDeluxe = 1
				WHERE custid = @srecommend
				
				UPDATE CustInfo WITH(UPDLOCK,ROWLOCK)
				SET DisableGoldDeluxe = 1,
					HideGoldDeluxe = 1
				WHERE srecommend = @srecommend
					AND custid <= @maxcustid	
					AND custid <> @srecommend
			END
			--update for whole line who enable LCS
			ELSE IF EXISTS(SELECT TOP 1 1 FROM #tmpDownlineEnable WHERE srecommend = @srecommend)
			BEGIN
				UPDATE CustInfo WITH(UPDLOCK,ROWLOCK)
				SET DisableGoldDeluxe = CASE WHEN DisableLiveCasino = 0 THEN 0 ELSE 1 END,
					HideGoldDeluxe = 1
				WHERE srecommend = @srecommend
					AND custid <= @maxcustid					
			END
			--update for all downlines
			ELSE
			BEGIN
				UPDATE CustInfo WITH(UPDLOCK,ROWLOCK)
				SET DisableGoldDeluxe = 0,
					HideGoldDeluxe = 1									
				WHERE srecommend = @srecommend
					AND custid <= @maxcustid
					
			END
		END	
		
	END
	
	IF ( SELECT COUNT(1) FROM sys.objects WHERE NAME IN ('CustWinlimit')) = 1	 		
	BEGIN
		INSERT INTO CustWinLimit(CustId
								,SportType
								,BetType
								,MaxWinLimit
								,IsAutoReset)
		SELECT custid
			,255
			,1701
			,CASE WHEN SyncLiveCasino = 0 THEN 0 ELSE MaxWinLiveCasino END 
			,CASE WHEN SyncLiveCasino = 0 THEN 1 ELSE isAutoResetLiveCasino END
		FROM CustInfo WITH(NOLOCK)
		WHERE srecommend = @srecommend
			AND custid <= @maxcustid
			AND enabled = 1
									
	END
	
	
	IF ( SELECT COUNT(1) FROM sys.objects WHERE NAME IN ('CustSettingGame','CustOverrideGame')) <> 2
		RETURN
		
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
           ,CASE WHEN SyncLiveCasino = 1 THEN [apositiontaking] ELSE 0 END
           ,CASE WHEN SyncLiveCasino = 1 THEN [mpositiontaking] ELSE 0 END 
           ,CASE WHEN SyncLiveCasino = 1 THEN [spositiontaking] ELSE 0 END
           ,CASE WHEN SyncLiveCasino = 1 THEN [playerdiscount] ELSE 0 END
           ,CASE WHEN SyncLiveCasino = 1 THEN [discount] ELSE 0 END
           ,CASE WHEN SyncLiveCasino = 1 THEN [adiscount] ELSE 0 END
           ,CASE WHEN SyncLiveCasino = 1 THEN [sdiscount] ELSE 0 END
           ,CASE WHEN SyncLiveCasino = 1 THEN [autopositiontaking] ELSE 0 END
           ,CASE WHEN SyncLiveCasino = 1 THEN [isautopositiontaking] ELSE 0 END
           ,CASE WHEN SyncLiveCasino = 1 THEN [autompositiontaking] ELSE 0 END
           ,CASE WHEN SyncLiveCasino = 1 THEN [isautompositiontaking] ELSE 0 END
	FROM  CustSettingGame cs WITH(NOLOCK) 
		INNER JOIN custinfo ci WITH(NOLOCK) ON ci.custid = cs.custid
	WHERE ci.srecommend = @srecommend
		AND ci.custid <= @maxcustid
		AND cs.sporttype = 162
		AND cs.bettype = 1101  
	    AND ci.enabled = 1   
	
	INSERT INTO [dbo].[CustOverrideGame]
           ([CustID]
           ,[Bettype]
           ,[Sporttype]
           ,[minpositiontaking])
	SELECT cs.[CustID]
           ,1701 as [Bettype]
           ,255 as [Sporttype]
           ,CASE WHEN SyncLiveCasino = 1 THEN [minpositiontaking] ELSE 0 END          
    FROM  CustOverrideGame cs WITH(NOLOCK) 
		INNER JOIN custinfo ci WITH(NOLOCK) ON ci.custid = cs.custid
	WHERE ci.srecommend = @srecommend
		AND ci.custid <= @maxcustid
		AND cs.sporttype = 162
		AND cs.bettype = 1101
		and enabled = 1  
	
	DECLARE @apos SMALLMONEY,
			@mpos SMALLMONEY
	
	UPDATE cs
	SET minpositiontaking = 0.93
	FROM CustOverrideGame cs WITH(UPDLOCK,ROWLOCK) 
		INNER JOIN custinfo ci WITH(NOLOCK) ON ci.custid = cs.custid
	WHERE ci.srecommend = @srecommend
		AND ci.custid <= @maxcustid		
		AND cs.sporttype = 255
		AND cs.bettype = 1701 
		AND  minpositiontaking > 0.93		
	
	UPDATE cs
	SET @apos = CASE WHEN apositiontaking > 0.93 THEN 0.93 ELSE apositiontaking END,
		apositiontaking = @apos,
		@mpos = CASE WHEN @apos + mpositiontaking > 0.93 THEN 0.93- @apos ELSE mpositiontaking END,
		mpositiontaking = @mpos,
		spositiontaking = CASE WHEN @apos + @mpos + spositiontaking > 0.93 THEN 0.93 - @mpos -@apos ELSE spositiontaking END
	FROM  CustSettingGame cs WITH(UPDLOCK,ROWLOCK) 
		INNER JOIN custinfo ci WITH(NOLOCK) ON ci.custid = cs.custid
	WHERE ci.srecommend = @srecommend
		AND ci.custid <= @maxcustid
		AND ci.roleid = 1
		AND cs.sporttype = 255
		AND cs.bettype = 1701 
		AND spositiontaking + mpositiontaking + apositiontaking > 0.93
		
	UPDATE cs
	SET @apos = CASE WHEN apositiontaking > 0.93 THEN 0.93 ELSE apositiontaking END,
		apositiontaking = @apos,
		mpositiontaking = CASE WHEN @apos + mpositiontaking > 0.93 THEN 0.93- @apos ELSE mpositiontaking END		
	FROM  CustSettingGame cs WITH(UPDLOCK,ROWLOCK) 
		INNER JOIN custinfo ci WITH(NOLOCK) ON ci.custid = cs.custid
	WHERE ci.srecommend = @srecommend
		AND ci.custid <= @maxcustid
		AND ci.roleid = 2
		AND cs.sporttype = 255
		AND cs.bettype = 1701 
		AND mpositiontaking + apositiontaking > 0.93	
	
	UPDATE cs
	SET @mpos = CASE WHEN mpositiontaking > 0.93 THEN 0.93 ELSE mpositiontaking END,
		mpositiontaking = @mpos,
		spositiontaking = CASE WHEN spositiontaking + @mpos > 0.93 THEN 0.93 - @mpos ELSE spositiontaking END 		
	FROM  CustSettingGame cs WITH(UPDLOCK,ROWLOCK) 
		INNER JOIN custinfo ci WITH(NOLOCK) ON ci.custid = cs.custid
	WHERE ci.srecommend = @srecommend
		AND ci.custid <= @maxcustid
		AND ci.roleid = 3
		AND cs.sporttype = 255
		AND cs.bettype = 1701 
		AND mpositiontaking + spositiontaking > 0.93	
		
	UPDATE cs
	SET spositiontaking = CASE WHEN spositiontaking > 0.93 THEN 0.93 ELSE spositiontaking END 		
	FROM  CustSettingGame cs WITH(UPDLOCK,ROWLOCK) 
		INNER JOIN custinfo ci WITH(NOLOCK) ON ci.custid = cs.custid
	WHERE ci.custid = @srecommend		
		AND cs.sporttype = 255
		AND cs.bettype = 1701 
		AND spositiontaking > 0.93	
		
	--adjust commission Super = [0; 0.007]	
	--correct for super level
	IF EXISTS(
			SELECT 1 
			FROM custSettingGame cs WITH(NOLOCK) 
			WHERE cs.custid = @srecommend		
				AND cs.sporttype = 255
				AND cs.bettype = 1701 
				AND cs.sdiscount > 0.007
			)
	BEGIN
		UPDATE cs
		SET cs.sdiscount = 0.007
		FROM  CustSettingGame cs WITH(UPDLOCK,ROWLOCK) 
			INNER JOIN custinfo ci WITH(NOLOCK) ON ci.custid = cs.custid
		WHERE ci.custid = @srecommend		
			AND cs.sporttype = 255
			AND cs.bettype = 1701 
			AND cs.sdiscount > 0.007
		
		UPDATE cs
		SET cs.adiscount = 0.007
		FROM  CustSettingGame cs WITH(UPDLOCK,ROWLOCK) 
			INNER JOIN custinfo ci WITH(NOLOCK) ON ci.custid = cs.custid
		WHERE ci.srecommend = @srecommend		
			AND roleid = 3
			AND ci.custid <= @maxcustid
			AND cs.sporttype = 255
			AND cs.bettype = 1701 
			AND cs.adiscount > 0.007
		
		UPDATE cs
		SET cs.discount = 0.007
		FROM dbo.CustSettingGame cs WITH(UPDLOCK, ROWLOCK)
			INNER JOIN dbo.CustInfo ci WITH(NOLOCK) ON cs.custid = ci.custid
		WHERE ci.srecommend = @srecommend
		   AND ci.roleid     = 2
		   AND ci.Enabled    = 1
		   AND ci.custid <= @maxcustid
		   AND bettype       = 1701
		   AND cs.sporttype  = 255
		   AND cs.discount   > 0.007
		
		UPDATE cs
		SET cs.sdiscount = 0.007
		FROM dbo.CustSettingGame cs WITH(UPDLOCK, ROWLOCK)
			INNER JOIN dbo.CustInfo ci WITH(NOLOCK) ON cs.custid = ci.custid
		WHERE ci.srecommend = @srecommend
		   AND ci.roleid     = 1
		   AND ci.Enabled    = 1
		   AND ci.custid <= @maxcustid
		   AND bettype       = 1701
		   AND cs.sporttype  = 255
		   AND cs.sdiscount   > 0.007
		   
		UPDATE cs
		SET cs.adiscount = cs.sdiscount
		FROM dbo.CustSettingGame cs WITH(UPDLOCK, ROWLOCK)
			INNER JOIN dbo.CustInfo ci WITH(NOLOCK) ON cs.custid = ci.custid
		WHERE ci.srecommend = @srecommend
		   AND ci.roleid     = 1
		   AND ci.Enabled    = 1
		   AND ci.custid <= @maxcustid
		   AND bettype       = 1701
		   AND cs.sporttype  = 255
		   AND cs.adiscount > cs.sdiscount
		
		UPDATE cs
		SET cs.discount = cs.adiscount
		FROM dbo.CustSettingGame cs WITH(UPDLOCK, ROWLOCK)
			INNER JOIN dbo.CustInfo ci WITH(NOLOCK) ON cs.custid = ci.custid
		WHERE ci.srecommend = @srecommend
		   AND ci.roleid     = 1
		   AND ci.Enabled    = 1
		   AND ci.custid <= @maxcustid
		   AND bettype       = 1701
		   AND cs.sporttype  = 255
		   AND cs.discount > cs.adiscount
		
		UPDATE cs
		SET cs.playerdiscount = cs.discount 
		FROM dbo.CustSettingGame cs WITH(UPDLOCK, ROWLOCK)
			INNER JOIN dbo.CustInfo ci WITH(NOLOCK) ON cs.custid = ci.custid
		WHERE ci.srecommend = @srecommend
		   AND ci.roleid     = 1
		   AND ci.Enabled    = 1
		   AND ci.custid <= @maxcustid
		   AND bettype       = 1701
		   AND cs.sporttype  = 255
		   AND cs.playerdiscount > cs.discount  
	END		
	
	DROP TABLE #tmpEnableAgent
	DROP TABLE #tmpSuperOnly
	DROP TABLE #tmpDownlineEnable		
END
GO
-- END STEP 1: DEPLOY THIS SP @DBCUST.CustDB --------
------------------------------------------------------	



---
---
-- BEGIN STEP 2: RUN THIS SCRIPT AT ALL REPLICATED SERVERS (052/053/054/06/DBTP) -----
--------------------------------------------------------------------------------------
CREATE TABLE #supers (custid int, DisableGoldDeluxe BIT, isfinished bit default(0))
DECLARE @srecommend INT, @max_custid INT, @DisableGoldDeluxe BIT

SELECT @max_custid = xx

--disable supers list
INSERT INTO #supers(custid, DisableGoldDeluxe)
SELECT ci.custid, 1
FROM Customer ci WITH(NOLOCK)
WHERE USERname IN ('M312T','312BP','S312R','M312RR','R312R','S312C','S312RMB','S312US','S312H','S312G','R313R','S32RMB','M32RM','S32R','S32AR','S32H','S32AH','S32BH','S32CH','S32DH','M32M','S32EH','S32FH','S32GH','S32M','S32AM','S32HH','S32IH','S32JH','S32BM','S32HK','S32K','S32HKD','S32RM','S32KH','S32LH','S32CM','MGRM','SGURMB','SGM','SGR','SG1M','SGH','SG1H','SG2H','SG3H','SG5H','SG4H','SG6H','SG7H','SG8H','SG9H','SG10H','SG11H','SG12H','SG13H','SG15H','SG1R','SG16H','SG17H','SG18H','SG19H','SG20H','SG21H','SG22H','SG23H','SG2M','SG25H','SG3M','SG26H','SG27H','SG28h','sg29h','SG5M','sg30h','SG6M','SG31H','SG7M','SGGT','SG32H','SG8M','sg9m','SG1T','SG2T','SG3T','SG33H','SGRD','SG35H','SG36H','SG37H','SG38H','SG39H','SG40H','SGRP','SG41H','SG42H','SGRI','SPR','SPH','SSR','PPB','PPR','S922H','M922U','M922M','S922M','M922T','S922T','S922K','S922N','S922U','S922L','S922P','S922W','S922G','S922US','S922MA','S922Y','S922R','S922C','S922V','S922B','S922O','S922S','S922A','M39IRMB','S39R','S39RR','SKHK','SKR','SKM','SKRR','SKUS','266HK','JMRM','S35H','S35M','S35AH','S35RM','MMMRM','SBKHK','SBKRMB','SBKTB','MMPRM','SMM','SMSM','SBKH','MMSD','SBKT','SMH','SMMH','SBK','SMAH','SMMS','SMAT','SMR','MMRMB','SMMR','SMBT','SMBH','SSMS','SMCH','SMMP','MSRMB','M7RM','M7ARM','M7SD','M7RMB','M7ARMB','M7BRMB','M7BRM','S7RMB','M7ZRMB','M7CRM','M926R','HK7','1158RM','M58SD','S58RM','S58R','M12RM','S12HK','S12M','S12MM','7899HK','789R','M96RM','S96h','M318HK','M318RMB','S318U','2588RM','M258RM','2588SD','M57HK','S57R','S57H','M863HK','S863R','KM','KH','KR','KS','KT','KRC','KSD','KMM','KRR','KMA','KHH','KHK','KAR','KBR','KCR','KAM','KMAM','KMBM','KHAH','KHBH','KAT','KHCH','KDR','KER','KHT','KHDH','M28RMB','M28H','S09H','S09M','MQRM','MQARM','MQRMB','MQR','SQHH','S33M','S33E','S33R','S33C','S33AR','S33MR','S33SM','S33S','S33BR','S33CR','S33T','S33A','MPTUS','MPTRMB','MPPU','PTM','166HK','M16RMB','S80R','S80U','S80H','S5S','S5M','S5R','S5U','S5I','330GBP','W79','HIS','HIH','HIU','HAH','HIM','HIK','HIW','HIT','HIF','SMORMB','SMORM','SMOEH','SMOHK','SMOH','SMOK','SMOL','SMOM','SMON','SMOO','SMOP','SMOQ','SMOT','SMOR','SMOS','SMOA','SMOB','SMOC','SMOD','SMOCNY','SMOE','SMOU','SMOF','SMORA','MOU','MOW','SMOG','MOA','MOB','MOD','SMOKH','SMOV','SMOI','SMODH','SMOTH','SMOJ','SMOW','SMOY','SMOX','S31SD','S31ARM','SBQJ','SBQ1J','SBQ2J','SAPM','SBQ3J','SBQ5J','S31HK','S116SD','S31D','SBQ6J','S31RRM','SBQ8J','SBQ9J','S31ASD','A31BP','SBQ7J','S31BSD','SPA1M','M3CRM','SBQ4J','S31AHK','SPA2M','SPA3M','M50RM','S50RMB','S50R','A50RM','M53SD','M53HK','S53S','S53HHK','S53M','M91RMB','M91ARMB','M91CRMB','M91DRMB','S91RM','M91FRMB','M91HK','S91R','S3ARM','S3AR','S3AAR','S3AH','S3AAH','S3AK','S3AG','S3EH','S3BH','S3AB','M83RM','M83RMB','M83ARM','M83H','M98RM','M98HK','S98R','M98ZR','S98H','M98ZH','S98E','S98K','SDRM','SDSD','SDRMB','SDARM','SDR','SDH','SDHK','SDHA','SDEU','SDBP','1188RM','S188R','S188RM','S188ARM','M188SD','S188AR','S188H','S188AH','S188BH','S188US','M79BR','M79CR','79AH','79AR','S70RMB','S70M','3KHK','SOGO','SOGA','S57AR','M57AHK','M606HK','M818H','M818R','M818RA','S59BR','S989R','S989M','S989H','SORM','MK1','MK2','MK3','MK5','MK6','MK4C','TH7','MK8','MK9','MK10','MK11C','CKT','CKT1','CKT2','MKM','MK12','TH88','MKS','MK17','CK18','MKTB','MK13','CKU','MKM1','MK19','MK20','MK21','MK16','MK15','TH25','MK22','MK30','TH26','MK23','JC1','JC7','JC2','JC8','MKI','JC6','JC81','JC3','JC9','MK27','TH28','TH29','THM','JCM','JC10','TH89','MK31','MKM2','JC5','JC82','MKS1','JCH','GAX','MK32','JC83','MKH','AK1','AKM1','MK33','MK35','MKHA','HJ','HM','M113H','KYH','KYM','MKYM','M85TB','M85ATB','S85RMB','M85BTB','S85RM','M85CTB','M85DTB','S85R','S85AR','S85BR','S85RR','S85H','S85S','S85M','S85T','S85GTH','S85A','S42RM','S42H','S42AH','S42S','S42BH','S42CH','S42DH','M42M','S42ARM','S42M','S42D','YH','YHA','TWS','S88ML','S42U','S42EH','S42T','STPM','STPH','STPK','STPL','JAT','JAH','JAS','JAM','JAHA','JAU','JAHP','JAHB','JARWRONG','JAR','JAHE','JAA','S120R','S121R','S122R','S120H','S123R','S124R','S120M','S120S','DDS','BBS','BBM','MR','MRU','SBZR','SBZ','SBZB','SZ','MA','M822M','S822R','GEH','GFH','S822M','S822MA','GFJ','S822D','D5M','M81ARMB','S81R','S81RA','S81RB','SLH','SLK','SLJ','SLM','SLD','SSS','SSSD','SSSR','SSH','S23H','S23S','S23M','MLLRMB','SLLM','S95RMB','M95RM','S95H','S95AH','S95BH','S95CH','S95M','S95RM','S95DH','S95AM','PPH','PPM','SYLHK','SYLRM','SYLSD','SYLM','SYLH','SYLHZ','SYLK','SYLG','SYCN','SYLT','SYLL','SSK','SSM','SSMA','SSKA','SSKB','SSKC','SSN','SF8','S62H','S62AH','M62SD','S62M','KM6','KH6','KS6','M62H','M62R','M62AH','M62RA','m62rb','S62D','M62BH','S27RMB','S27HK','S27H','S27A','SADA','S27TK','GN','GX','GC','GL','LHH','LHU','LHM','LHI','LHM1','LHM2','LHH1','LHH2','LHH3','LHH4','LHH5','LHS ','LHH6','LHHRMB','LHR','LHH7','LHH8','LHH9','LHH10','LHH11','LHH12','LHA','LHM3','LHM5','LHM6','POR','POT','U311','POK','POY','POB','POW','KTV','KTW','POG','POM','POH','POJ','AX','AXH','AXG','FYG','AXT','AX1','AXRMB','AX3','AXA','AXHK','AX5','VVG','SVVG','87R','QQMZ','QQKR','QQKA','QQMW','QQMY','QQMA','QQKU','QQK3','QQUS','QQMR','QQMD','QQHK','QQKY','QQBS','QQKT','QQKH','QQKS','QQKV','QQTB','QQTC','QQTD','QQTE','QQTF','Pyy','PYH','PYT','PYU','PYM','PYG','PYR','PYA','MLH','MLI','TLM','TLN','D71','cks','C1','C2','C3','C5','C7','TLH','C8','C9','C10','C11','C12','C13','C15','H9','H1','JK6','C6','H2','H3','HZ','H5','CV','9H','1C','EPL','MMS','KP','H8','S1','S2','S3','S6','S7','S8','S9','S11','SR','CM','ZS','CN','JD','JG','U8','A6','R8','A1','A2','A3','A5','YUM','YUH','WPR','KPW','JGBP','XCN','BPK','EEM','EEH','EGH','EGM','ETB','MKLHK','MKLTB','1E','MLAMRM','A919HK','SA-RMB00110','SBET339','M72H','S26AH','S26M','S8T','S8R','S8U','S8KT','S8H','S8AR','S8AH','S8BR','S8BH','S8CR','RC','MHK8','MHK9','HK8','M7RRMB','A7HK','S7D','S7RR','TU1','TU2','JYT','WHT01','WHT02','WHT03','WHT04','WHT05','WHD','SMTG','GT','M8HK','M8RMB','M51SD','M51TB','TAS51S','M51RMB','S51SM','S51R','M51H','S51H','S51AH','S51BH','S51CH','S51DH','S51EH','S51HA','S51TB','M47RMB','S47SD','S47RM','M47R','S47R','S47U','S47IR','S47DR','S47H','S47M','S31M','S31MR','SS32U','SS31U','SS31K','SS31L','SS31N','SS31P','SS31G','ANY','SS31A','M63H','M63IRMB','M63IHK','S63H','M033R','M033H','SBSR','SBH','SBSU','SBS','SBM','SBU','SBHA','SBHB','SBHC','SBC','SBHD','MYM','SSF','SBHE','SBHF','SBHG','SBHJ','SBTB','SSG','WWR','WKR','MTRE','MTRU','FBR','FBM','SFB','FBH','FBB','YKH','YKR','YKM','CYKM','SBRR','HS','HSK','SBMW','M88SD','M88ASD','S88R','S88AR','S88M','S88H','S88T','M88US','S88RMB','S88K','M88M','S88US','8188BP','MMYTB','SVM','SVR','SVS','SVH','SVUS','SVP','SVE','SVA','S11S','S11MY','M73TB','S1188','SS11H','S1100','s1199','S11YY','S11M1','S11M4','S11M6','S11M8','S11N','HYY','S93RM','S93M','S93S','S93R','S97R','S100R','S101R','S93H','S97H','S93SS','S93HK','M93S','S93RRMB','S93HK1','S93D','S93P','s66h','s66s','S77AH','s66bh','s66pk','s66y','s667','s663','s664','s66m','s66b','S77X','s66a','s66c','s668','S66D','S66V','S66T','S66E','SBT','BBBU','SBBT','SBBR','SBCT','RB168','FYY','FYU','FYS','FYK','FYT','FYD','JTRIHK','JTRIEU','JTRIUSD','JTRIGBP','AHMA','A68M','A68H','REU','VKJ','VKP','VKG','AGO','AGD','BQ','AGK','AGJ','M101M'
--add LLR to disable list
,'LLR')
AND roleid = 4

--special supers list will disable
INSERT INTO #supers(custid, DisableGoldDeluxe)
SELECT ci.custid, 1
FROM Customer ci WITH(NOLOCK)
WHERE USERname IN ('9999SD','M999SD','M9999S','S999S','99HK','PHRM','MPHSD','SPK','SPKM','SPKR','M90RM','S90AR','S90RM','S90C','M797M','M797AM','SWHH','D77','D78','D79','D80','D81','D82','D83','D85','DRM','DADR','D99','2MH','2HA')
AND roleid = 4

--enable supers list
--remove 'LLR' out of enable list
INSERT INTO #supers(custid, DisableGoldDeluxe)
SELECT ci.custid, 0
FROM Custinfo ci WITH(NOLOCK)
WHERE USERname IN ('M359RM','M359SD','M359EU','M359ARM','M359ASD','M359RMB','M359ARMB','S359AH','HD','HE','S359HK','S359CM','S359HL','S359RM','HF','HG','HDN','HDQ','HH','DAA','DAB','DAC','DAD','HB','DAE','DAF','HX','DAM','HN','HQ','TKRM','WBRMB','WBR','WBRR','WBRA','wbrf','WBRG','WBRH','WBRI','WBRJ','TG1','TG3','TG2','TG4','CHTB','CHITB','ST','STT','ST1T','ST2T','ST3T','ST4T','ST5T','ST6T','ST7T','ST8T','ST9T','BT','B5T','B1T','B2T','B3T','B4T','B6T','B7T','B8T','B9T','B10T','B11T','B12T','B13T','B14T','B15T','B16T','B17T','B18T','B19T','B20T','B21T','B22T','B23T','B24T','B25T','STEB','SABT','B26T','B27T','B28t','B29T','B30T','B31T','B32T','B33T','B35T','B34T','B36T','B37T','B38T','B39T','B40T','B41T','B42T','B43T','B44T','B45T','B46T','B47T','B48T','B49T','B50T','B51T','SKKM','ywrm','6599RM','SALR','SALH','MALM','MGTB','MGBTB','MGCTB','SGS','SGTB','SGATB','SGI','SGT','SGAT','SGBT','SGCT','SGAR','TEH','TEC','THR','SGSM','SGSN','TEK','SGMM','TED','THH','THS','TEG','THT','MAMRM','SMAMRMB','SAMR','M25RM','M25ARMB','M25BRMB','S25R','M25HK','S25RM','L25RM','MMYBRM','MMYBH','BYS','MBY','BYM','BYU','SI','UU','WH','UT','D8G','UK','IB','LK','JA','AS','UM','AP','SB','UN','UL','IM','AJ','JB','IN','JC','YN','CL','UA','UB','WB','IK','IJ','AN','WU','AT','ZZ','UC','LN','KK','VB','YY','UE','IF','BB','HO','HU','SL','UD','IZ','JK','HW','UW','CX','UV','AK','AZ','JN','AI','JT','UF','CY','UZ','UH','MH','AH','UG','UY','YM','TA','AQ','AD','WJ','WG','HI','BI','BJ','LI','LW','UI','II','IA','IE','IG','HP','GI','SW','DI','WI','QQ','DW','FF','TI','CI','IP','RR','IC','AW','AG','AF','CO','CU','CS','YI','JJ','IR','VV','ID','WW','MW','MM','AL','DB','SD','CJEU','M26RMB','M26ARMB','M26RM','M26SD','M26BRMB','M26ARM','S26H','M26BRM','M252RMB','M252H','SCHK','SCM','SCS','SCSM','SCH','SCAH','SCAI','SCI','SCBH','SCHI','SCDH','69SD','S69SD','S69RM','S7RM','S69R','M69U','M69H','S69H','S69RD','S69E','S69TB','S69BP','S69HD','S69RP','S56RM','S56R','S56ARM','S56BRM','S556R','S556AR','S56CRM','S56H','S56AH','S56BBH','S56CH','S56DH','S56HH','S56EH','S56DRM','S56FH','S56TB','S56GH','S56JH','S56KH','S56HK','S56T','S56TC','S56LH','S56MH','S56TH','S56TA','S56TD','S56TT','S56I','S56D','S56NH','S56PH','S56QH','s56rh','S56SH','S56KK','S56SD','S56AA','S56AB','S56AC','S56AD','S56AI','S56II','S56UH','S56VH','S56A','HKD','HKD01','HKD02','HK01','HK02','HK03','HK05','HK06','S56AE','HK07','S56ASD','HK09','HK10','HK11','S56ERM','HK12','HK13','HK15','HK16','HK17','HK18','HK19','HK20','HK21','HK22','TM01','TM02','TM03','TM04','TM05','TM06','TM07','TM08','TM09','TM10','TM11','S36RMB','S36RM','SD1R','s79rrr','S79RM','S79AR','S79R','S79H','S79AHH','S79HH','S79HK','S799H','S79SH','M79H','S79HG','S79hz','S79CR','S79HS','S79I','S79C','WD1','WD2','WD3','S79RMB','M79U','WDD','WDE','WDH','WDI','WDJ','WDK','WDL','M79V','WDR','WD','WC','WD7','S49RM','S49R','S49H','SSTMR','SSTMH','SSTMJ','SSTMM','SSTMK','SSTMI','S60RUP','S60AR','D60','E60','S16RUP','6666HK','6666BP','6666US','6666EU','M6HK','6hk6601','M6SD','6666AUD','S6EU','S6RUP','S6US','S6ARUP','M6RM','AA','BA','6666AHK','DA','6666AEU','MPH','JPG','S6H','FA','VC','S6BP','VD','VM','VF','GA','VO','GG','s6cn','VP','VQ','S6HK','S6RMB','FM','S6P','VI','VE','VA','VG','MD','S9EU','S6T','VJ','S6S','S6AHK','S88D','M553R','M553AR','M553BR','M553H','M553AH','M553BH','M553CH','M553M','M553DH','S553H','S553M','SEM','SEI','SEH','SED','SEK','SEMA','MJRMB','SJM','SJH','SJSD','SBHK','S305CRMB','S305RM','S31RM','S31RMB','S305R','S31ARMB','SSFH','SSF1H','S3H','SSF2H','SSF3H','MSFR','SSFK','S3HH','SSF5H','S31BRM','S3HK','S305M','S3HG','S3HJ','S3HP','SSF6H','SHSD','SHRMB','SHTB','SHHK','hhm','SHKK','SHHT','SHDK','SHHK1','SHHK2','SHR','SHR1','SHHK3','SHI','shhk5','SHR3','shhk6','SHR5','SHHK7','hhma','sh8','SHHK9','HHN','SHHK8','HHK1','HHK10','HHK2','HHK3','HHR','HHK4','BHJ','CFT','TT','TTA','TTB','S2R','S2T','S2AR','S2BR','S2TB','S688R','S688H','S788H','S688T','S688AH','S688M','LP','LLP','A68US','A688U','SAKH','SAKM','DKE','DKD','M8H','SWU','SWK','SWM','S2H','S2M','S2HH','S2MM','S2MN','S2HY','MRTB','MKWRM','SRRMB','SKWRMB','SRARMB','SRRH','SRR','SRH','SRHK','SRRR','SRMA','SRHKA','SRJ','SRKH','SRHH','SRMB','SRK','SRHC','SRHD','SRMC','SRQ','SMQARMB','M99RMB','S99H','S99TB','S99M','S99T','S99R','S99ah','S99HK','S99HKK','S99HKD','S99BH','S99TH','S99RMB','S999TB','S99C','S99THB','S99D','S99MHK','S99CH','S99BT','S99HA','S99TC','S99E','S99BA','S99BB','S99BC','S99BD','WKH','S45H','s45m','S45AH','S45BH','S45AM','S45BM','S45HK','KJH','KJHB','KJM','KJI','KJD','KJT','KJMB','KJK','KJE','KJB','KJC','KJF','KJMC','KJMA','KJG','KJMD','KJL','KJO','KJME','KJMF','AHM','AHN','AHI','AHO','BHO','AHP','AHQ','AHR','BHN','AHH','AHE','bhu','AHF','AHD','AHG','AHJ','AHL','AHT','AHA','AHC','AHY','AHU','AHV','BHS','AHZ','AHX','AKK','DDD','DDA','GM1','DDB','GM2','GMG','BKK','S41S','S41M','S41H','S43S','S43H','S41K','MC','MC1','MC2','MCR','MC3','MC5','LJ','LH','LU','LY','LL','LB','LC','LD','LE','LV','LF','LT','KD','KL','HA','LS','LA','LG','LM','LII','LZ','BGR','CHU','HPP','HPO','HPM','HPU','HPV','HPW','HPQ','HPK','HPN','HPX','HPY','HPMM','HPI','HPZ','HPR','HPJ','HPH','SX3','SX1','SX2','SZZ','SMY','HPC','HPD','HPE','HPA','MO','MP','HPG','HPB','HPF','HPL','SX5','MQ','SX6','HP2','MG','SX7','SX8','HTB','HPS','HPM2','HP1','HPT','HP3','SX9','HSS','HMN','SATU','SATE','SATS','SATM','JS','JS1','JM','JS2','SFH','JS3','JS5','JS6','JS7','JS8','SJS','SFHA','JS9','JSA','JSC','JSB','JSD','SYSM','SYSHK','JSR','JMA','JSE','JSQ','JSF','JSG','JST','JSH','JSK','JSL','JSM','JR','JSZ','SHG','JSN','JSP','JSU','JRA','JSV','JSW','JSX','JSY','JTH','JSO','JSI','JMJ','JHA','JHB','JMK','JML','JHC','JHH','JHJ','SAS','ASA','SAE','SAI','ASB','M71RMB','M71ARMB','M71BRMB','M71CRMB','S71RM','M71DRMB','SER','S71H','S71AH','S71M','S71BH','S71MA','S71CH','S71DH','S71MB','SCLH','SCLM','SMT','SBTM','SBTH','SBTK','SBTN','SBTD','SBTL','SBTR','SBTY','SKHH','SKMM','PKK','PKA','PKB','PKRM','PKID','PKC','PKD','PKE','PKF','MPKS','PKG','PKH','PKJ','PKL','PKM','PKO','PKP','PKQ','PKT','PKS','SSYR','SSYH','SKPRMB','KPM','WVW','SEA','SEB','SEC','S9M','S9H','XKS','SYI','SNI','S555','S666','S777','JJB','JJM','S359BH','S359M','S359CH','S359S','S359HH','S359am','S359bm','SLP','SLI','SLN','SLO','SLG','SLQ','SLW','SLB','SLL','SLR','SLT','LGA','SLY','SLS','SLE','SLF','SLV','SLU','ALR','ALM','ALH','ALA','ALB','ALC','ALD','RMB','TP','TH','TR','AC1','AC2','ACH','ACH1','ACH2','ACH3','AC3','AC4','ACH4','ACH5','ACH6','AC7','HT1','HT2','HT3','KKT','KKM','KKH','KKMA','KKS','KKB','KKC','KKD','KKE','KKJ','KKN','KKY','KKF','KKG','KKK','KKL','KKI','KKR','KAA','KAB','KGK','KGL','KGM','KGN','KGO','KGP','KAC','KGD','SRS','KAD','KGA','KGB','KAE','KAF','KBA','KBB','KBC','KGE','KBD','KBE','KAG','KAH','KAK','KAJ','KBF','XKM','XKH','VKH','VKD','FJM','SAZM','FFM','21M','21A','LLKH','LHHR','HG9','HGG','HG8','HG7','HG6','HG88','HG101','HG102','HG71','VVY','RG1','RG2','RG3','RG5','RG6','RG7','PPS','PPJ','TS1','TS2','TS3','TS4','DS1','DS2','PK','P11','P12','P13','P14','P15','P16','P17','P18','P19','P22','CTH','CTV','CTM')
AND roleid = 4
AND DisableLiveCasino = 0--enable GD for line has been enabled LCS

--special supers list will enable
--2 accounts 'S90R','S90H' will be enabled for whole line 
INSERT INTO #supers(custid, DisableGoldDeluxe)
SELECT ci.custid, 0
FROM Customer ci WITH(NOLOCK)
WHERE USERname IN ('M999RM','SHK','S90R','S90H','SPHM','SQK','S797R','M797RM','S797H','S797AH','SWH','SWAH','SWSH','wm','WN','WT','SWB','SWC','SWD','SWE','SWF','SWG','SWI','SWJ','SWW','WE','S797S','SWN','WMA','SWP','SWQ','SWR','SWX','WMB','WTA','D66','S222R','S222H','S222HK','S222T','S222AH','S222BH','S222TH','S222TA','S222CH','S222DH','2EH','S222FH','S222GH','2KH','S222MH','S222NH','M222M','2AH','2BH','2HB','2CH','2DH','2LH','2ZH','2ID','2NH','2PH','2MM','2YH','2FH','2GH','2EU','2DD','2MN','2WH','S222JH','2HH','2RM','2DE','S222X','2NN','2HK','2RR','2CR','2CT','2JH','S222N','S222ZH','2XX','2WW','2CK','2RH','2IH','2BP','2QH','2OH','2SH','2AA','2AB','2AC','2MP','2MY','2MQ','2UH','SB8R','SBB','TH8','SBSD','SBV')
AND roleid = 4

--UUS currency enable by default
INSERT INTO #supers(custid, DisableGoldDeluxe)
SELECT ci.custid, 0
FROM Customer ci WITH(NOLOCK)
WHERE roleid = 4
	AND custid NOT IN (SELECT custid FROM Dep_CustSuper WITH(NOLOCK))
	AND currency = 20
	AND site <> '789y'

--ohters will disable by default
INSERT INTO #supers(custid, DisableGoldDeluxe)
SELECT ci.custid, 1
FROM CustInfo ci WITH(NOLOCK)
WHERE ci.roleid = 4 	
	AND ci.custid NOT IN (SELECT custid FROM Dep_CustSuper WITH(NOLOCK))
	AND ci.custid NOT IN (SELECT custid FROM #supers)
	AND custid <= @max_custid 
	
WHILE (1 = 1)
BEGIN
	UPDATE TOP (1) #Supers
	SET isfinished = 1
		,@srecommend = custid		
		,@DisableGoldDeluxe = DisableGoldDeluxe		
	WHERE isfinished = 0
	
	IF @@ROWCOUNT = 0 BREAK

	EXEC dbo.[Acc_ExecRep_Cust_09] @srecommend = @srecommend
			,@maxcustid = @max_custid
			,@target = 'REPLICATED'
			,@DisableGoldDeluxe = @DisableGoldDeluxe
	
	waitfor delay '00:00:0.280'
END			
GO		
-- END STEP 2: RUN THIS SCRIPT AT ALL REPLICATED SERVERS (052/053/054/06/DBTP) -----
-----------------------------------------------------------------------------------
 
 
 
---
---
-- BEGIN STEP 3: RUN THIS SCRIPT AT DBCUST -----
--------------------------------------------------------------------------------------
CREATE TABLE #supers (custid int, DisableGoldDeluxe BIT, isfinished bit default(0))
DECLARE @srecommend INT, @max_custid INT, @DisableGoldDeluxe BIT

SELECT @max_custid = xx

--disable supers list
INSERT INTO #supers(custid, DisableGoldDeluxe)
SELECT ci.custid, 1
FROM Customer ci WITH(NOLOCK)
WHERE USERname IN ('M312T','312BP','S312R','M312RR','R312R','S312C','S312RMB','S312US','S312H','S312G','R313R','S32RMB','M32RM','S32R','S32AR','S32H','S32AH','S32BH','S32CH','S32DH','M32M','S32EH','S32FH','S32GH','S32M','S32AM','S32HH','S32IH','S32JH','S32BM','S32HK','S32K','S32HKD','S32RM','S32KH','S32LH','S32CM','MGRM','SGURMB','SGM','SGR','SG1M','SGH','SG1H','SG2H','SG3H','SG5H','SG4H','SG6H','SG7H','SG8H','SG9H','SG10H','SG11H','SG12H','SG13H','SG15H','SG1R','SG16H','SG17H','SG18H','SG19H','SG20H','SG21H','SG22H','SG23H','SG2M','SG25H','SG3M','SG26H','SG27H','SG28h','sg29h','SG5M','sg30h','SG6M','SG31H','SG7M','SGGT','SG32H','SG8M','sg9m','SG1T','SG2T','SG3T','SG33H','SGRD','SG35H','SG36H','SG37H','SG38H','SG39H','SG40H','SGRP','SG41H','SG42H','SGRI','SPR','SPH','SSR','PPB','PPR','S922H','M922U','M922M','S922M','M922T','S922T','S922K','S922N','S922U','S922L','S922P','S922W','S922G','S922US','S922MA','S922Y','S922R','S922C','S922V','S922B','S922O','S922S','S922A','M39IRMB','S39R','S39RR','SKHK','SKR','SKM','SKRR','SKUS','266HK','JMRM','S35H','S35M','S35AH','S35RM','MMMRM','SBKHK','SBKRMB','SBKTB','MMPRM','SMM','SMSM','SBKH','MMSD','SBKT','SMH','SMMH','SBK','SMAH','SMMS','SMAT','SMR','MMRMB','SMMR','SMBT','SMBH','SSMS','SMCH','SMMP','MSRMB','M7RM','M7ARM','M7SD','M7RMB','M7ARMB','M7BRMB','M7BRM','S7RMB','M7ZRMB','M7CRM','M926R','HK7','1158RM','M58SD','S58RM','S58R','M12RM','S12HK','S12M','S12MM','7899HK','789R','M96RM','S96h','M318HK','M318RMB','S318U','2588RM','M258RM','2588SD','M57HK','S57R','S57H','M863HK','S863R','KM','KH','KR','KS','KT','KRC','KSD','KMM','KRR','KMA','KHH','KHK','KAR','KBR','KCR','KAM','KMAM','KMBM','KHAH','KHBH','KAT','KHCH','KDR','KER','KHT','KHDH','M28RMB','M28H','S09H','S09M','MQRM','MQARM','MQRMB','MQR','SQHH','S33M','S33E','S33R','S33C','S33AR','S33MR','S33SM','S33S','S33BR','S33CR','S33T','S33A','MPTUS','MPTRMB','MPPU','PTM','166HK','M16RMB','S80R','S80U','S80H','S5S','S5M','S5R','S5U','S5I','330GBP','W79','HIS','HIH','HIU','HAH','HIM','HIK','HIW','HIT','HIF','SMORMB','SMORM','SMOEH','SMOHK','SMOH','SMOK','SMOL','SMOM','SMON','SMOO','SMOP','SMOQ','SMOT','SMOR','SMOS','SMOA','SMOB','SMOC','SMOD','SMOCNY','SMOE','SMOU','SMOF','SMORA','MOU','MOW','SMOG','MOA','MOB','MOD','SMOKH','SMOV','SMOI','SMODH','SMOTH','SMOJ','SMOW','SMOY','SMOX','S31SD','S31ARM','SBQJ','SBQ1J','SBQ2J','SAPM','SBQ3J','SBQ5J','S31HK','S116SD','S31D','SBQ6J','S31RRM','SBQ8J','SBQ9J','S31ASD','A31BP','SBQ7J','S31BSD','SPA1M','M3CRM','SBQ4J','S31AHK','SPA2M','SPA3M','M50RM','S50RMB','S50R','A50RM','M53SD','M53HK','S53S','S53HHK','S53M','M91RMB','M91ARMB','M91CRMB','M91DRMB','S91RM','M91FRMB','M91HK','S91R','S3ARM','S3AR','S3AAR','S3AH','S3AAH','S3AK','S3AG','S3EH','S3BH','S3AB','M83RM','M83RMB','M83ARM','M83H','M98RM','M98HK','S98R','M98ZR','S98H','M98ZH','S98E','S98K','SDRM','SDSD','SDRMB','SDARM','SDR','SDH','SDHK','SDHA','SDEU','SDBP','1188RM','S188R','S188RM','S188ARM','M188SD','S188AR','S188H','S188AH','S188BH','S188US','M79BR','M79CR','79AH','79AR','S70RMB','S70M','3KHK','SOGO','SOGA','S57AR','M57AHK','M606HK','M818H','M818R','M818RA','S59BR','S989R','S989M','S989H','SORM','MK1','MK2','MK3','MK5','MK6','MK4C','TH7','MK8','MK9','MK10','MK11C','CKT','CKT1','CKT2','MKM','MK12','TH88','MKS','MK17','CK18','MKTB','MK13','CKU','MKM1','MK19','MK20','MK21','MK16','MK15','TH25','MK22','MK30','TH26','MK23','JC1','JC7','JC2','JC8','MKI','JC6','JC81','JC3','JC9','MK27','TH28','TH29','THM','JCM','JC10','TH89','MK31','MKM2','JC5','JC82','MKS1','JCH','GAX','MK32','JC83','MKH','AK1','AKM1','MK33','MK35','MKHA','HJ','HM','M113H','KYH','KYM','MKYM','M85TB','M85ATB','S85RMB','M85BTB','S85RM','M85CTB','M85DTB','S85R','S85AR','S85BR','S85RR','S85H','S85S','S85M','S85T','S85GTH','S85A','S42RM','S42H','S42AH','S42S','S42BH','S42CH','S42DH','M42M','S42ARM','S42M','S42D','YH','YHA','TWS','S88ML','S42U','S42EH','S42T','STPM','STPH','STPK','STPL','JAT','JAH','JAS','JAM','JAHA','JAU','JAHP','JAHB','JARWRONG','JAR','JAHE','JAA','S120R','S121R','S122R','S120H','S123R','S124R','S120M','S120S','DDS','BBS','BBM','MR','MRU','SBZR','SBZ','SBZB','SZ','MA','M822M','S822R','GEH','GFH','S822M','S822MA','GFJ','S822D','D5M','M81ARMB','S81R','S81RA','S81RB','SLH','SLK','SLJ','SLM','SLD','SSS','SSSD','SSSR','SSH','S23H','S23S','S23M','MLLRMB','SLLM','S95RMB','M95RM','S95H','S95AH','S95BH','S95CH','S95M','S95RM','S95DH','S95AM','PPH','PPM','SYLHK','SYLRM','SYLSD','SYLM','SYLH','SYLHZ','SYLK','SYLG','SYCN','SYLT','SYLL','SSK','SSM','SSMA','SSKA','SSKB','SSKC','SSN','SF8','S62H','S62AH','M62SD','S62M','KM6','KH6','KS6','M62H','M62R','M62AH','M62RA','m62rb','S62D','M62BH','S27RMB','S27HK','S27H','S27A','SADA','S27TK','GN','GX','GC','GL','LHH','LHU','LHM','LHI','LHM1','LHM2','LHH1','LHH2','LHH3','LHH4','LHH5','LHS ','LHH6','LHHRMB','LHR','LHH7','LHH8','LHH9','LHH10','LHH11','LHH12','LHA','LHM3','LHM5','LHM6','POR','POT','U311','POK','POY','POB','POW','KTV','KTW','POG','POM','POH','POJ','AX','AXH','AXG','FYG','AXT','AX1','AXRMB','AX3','AXA','AXHK','AX5','VVG','SVVG','87R','QQMZ','QQKR','QQKA','QQMW','QQMY','QQMA','QQKU','QQK3','QQUS','QQMR','QQMD','QQHK','QQKY','QQBS','QQKT','QQKH','QQKS','QQKV','QQTB','QQTC','QQTD','QQTE','QQTF','Pyy','PYH','PYT','PYU','PYM','PYG','PYR','PYA','MLH','MLI','TLM','TLN','D71','cks','C1','C2','C3','C5','C7','TLH','C8','C9','C10','C11','C12','C13','C15','H9','H1','JK6','C6','H2','H3','HZ','H5','CV','9H','1C','EPL','MMS','KP','H8','S1','S2','S3','S6','S7','S8','S9','S11','SR','CM','ZS','CN','JD','JG','U8','A6','R8','A1','A2','A3','A5','YUM','YUH','WPR','KPW','JGBP','XCN','BPK','EEM','EEH','EGH','EGM','ETB','MKLHK','MKLTB','1E','MLAMRM','A919HK','SA-RMB00110','SBET339','M72H','S26AH','S26M','S8T','S8R','S8U','S8KT','S8H','S8AR','S8AH','S8BR','S8BH','S8CR','RC','MHK8','MHK9','HK8','M7RRMB','A7HK','S7D','S7RR','TU1','TU2','JYT','WHT01','WHT02','WHT03','WHT04','WHT05','WHD','SMTG','GT','M8HK','M8RMB','M51SD','M51TB','TAS51S','M51RMB','S51SM','S51R','M51H','S51H','S51AH','S51BH','S51CH','S51DH','S51EH','S51HA','S51TB','M47RMB','S47SD','S47RM','M47R','S47R','S47U','S47IR','S47DR','S47H','S47M','S31M','S31MR','SS32U','SS31U','SS31K','SS31L','SS31N','SS31P','SS31G','ANY','SS31A','M63H','M63IRMB','M63IHK','S63H','M033R','M033H','SBSR','SBH','SBSU','SBS','SBM','SBU','SBHA','SBHB','SBHC','SBC','SBHD','MYM','SSF','SBHE','SBHF','SBHG','SBHJ','SBTB','SSG','WWR','WKR','MTRE','MTRU','FBR','FBM','SFB','FBH','FBB','YKH','YKR','YKM','CYKM','SBRR','HS','HSK','SBMW','M88SD','M88ASD','S88R','S88AR','S88M','S88H','S88T','M88US','S88RMB','S88K','M88M','S88US','8188BP','MMYTB','SVM','SVR','SVS','SVH','SVUS','SVP','SVE','SVA','S11S','S11MY','M73TB','S1188','SS11H','S1100','s1199','S11YY','S11M1','S11M4','S11M6','S11M8','S11N','HYY','S93RM','S93M','S93S','S93R','S97R','S100R','S101R','S93H','S97H','S93SS','S93HK','M93S','S93RRMB','S93HK1','S93D','S93P','s66h','s66s','S77AH','s66bh','s66pk','s66y','s667','s663','s664','s66m','s66b','S77X','s66a','s66c','s668','S66D','S66V','S66T','S66E','SBT','BBBU','SBBT','SBBR','SBCT','RB168','FYY','FYU','FYS','FYK','FYT','FYD','JTRIHK','JTRIEU','JTRIUSD','JTRIGBP','AHMA','A68M','A68H','REU','VKJ','VKP','VKG','AGO','AGD','BQ','AGK','AGJ','M101M')
AND roleid = 4

--special supers list will disable
INSERT INTO #supers(custid, DisableGoldDeluxe)
SELECT ci.custid, 1
FROM Customer ci WITH(NOLOCK)
WHERE USERname IN ('9999SD','M999SD','M9999S','S999S','99HK','PHRM','MPHSD','SPK','SPKM','SPKR','M90RM','S90AR','S90RM','S90C','M797M','M797AM','SWHH','D77','D78','D79','D80','D81','D82','D83','D85','DRM','DADR','D99','2MH','2HA'
--add LLR to disable list
,'LLR'
)
AND roleid = 4

--enable supers list
--remove LLR out of enable list
INSERT INTO #supers(custid, DisableGoldDeluxe)
SELECT ci.custid, 0
FROM Custinfo ci WITH(NOLOCK)
WHERE USERname IN ('M359RM','M359SD','M359EU','M359ARM','M359ASD','M359RMB','M359ARMB','S359AH','HD','HE','S359HK','S359CM','S359HL','S359RM','HF','HG','HDN','HDQ','HH','DAA','DAB','DAC','DAD','HB','DAE','DAF','HX','DAM','HN','HQ','TKRM','WBRMB','WBR','WBRR','WBRA','wbrf','WBRG','WBRH','WBRI','WBRJ','TG1','TG3','TG2','TG4','CHTB','CHITB','ST','STT','ST1T','ST2T','ST3T','ST4T','ST5T','ST6T','ST7T','ST8T','ST9T','BT','B5T','B1T','B2T','B3T','B4T','B6T','B7T','B8T','B9T','B10T','B11T','B12T','B13T','B14T','B15T','B16T','B17T','B18T','B19T','B20T','B21T','B22T','B23T','B24T','B25T','STEB','SABT','B26T','B27T','B28t','B29T','B30T','B31T','B32T','B33T','B35T','B34T','B36T','B37T','B38T','B39T','B40T','B41T','B42T','B43T','B44T','B45T','B46T','B47T','B48T','B49T','B50T','B51T','SKKM','ywrm','6599RM','SALR','SALH','MALM','MGTB','MGBTB','MGCTB','SGS','SGTB','SGATB','SGI','SGT','SGAT','SGBT','SGCT','SGAR','TEH','TEC','THR','SGSM','SGSN','TEK','SGMM','TED','THH','THS','TEG','THT','MAMRM','SMAMRMB','SAMR','M25RM','M25ARMB','M25BRMB','S25R','M25HK','S25RM','L25RM','MMYBRM','MMYBH','BYS','MBY','BYM','BYU','SI','UU','WH','UT','D8G','UK','IB','LK','JA','AS','UM','AP','SB','UN','UL','IM','AJ','JB','IN','JC','YN','CL','UA','UB','WB','IK','IJ','AN','WU','AT','ZZ','UC','LN','KK','VB','YY','UE','IF','BB','HO','HU','SL','UD','IZ','JK','HW','UW','CX','UV','AK','AZ','JN','AI','JT','UF','CY','UZ','UH','MH','AH','UG','UY','YM','TA','AQ','AD','WJ','WG','HI','BI','BJ','LI','LW','UI','II','IA','IE','IG','HP','GI','SW','DI','WI','QQ','DW','FF','TI','CI','IP','RR','IC','AW','AG','AF','CO','CU','CS','YI','JJ','IR','VV','ID','WW','MW','MM','AL','DB','SD','CJEU','M26RMB','M26ARMB','M26RM','M26SD','M26BRMB','M26ARM','S26H','M26BRM','M252RMB','M252H','SCHK','SCM','SCS','SCSM','SCH','SCAH','SCAI','SCI','SCBH','SCHI','SCDH','69SD','S69SD','S69RM','S7RM','S69R','M69U','M69H','S69H','S69RD','S69E','S69TB','S69BP','S69HD','S69RP','S56RM','S56R','S56ARM','S56BRM','S556R','S556AR','S56CRM','S56H','S56AH','S56BBH','S56CH','S56DH','S56HH','S56EH','S56DRM','S56FH','S56TB','S56GH','S56JH','S56KH','S56HK','S56T','S56TC','S56LH','S56MH','S56TH','S56TA','S56TD','S56TT','S56I','S56D','S56NH','S56PH','S56QH','s56rh','S56SH','S56KK','S56SD','S56AA','S56AB','S56AC','S56AD','S56AI','S56II','S56UH','S56VH','S56A','HKD','HKD01','HKD02','HK01','HK02','HK03','HK05','HK06','S56AE','HK07','S56ASD','HK09','HK10','HK11','S56ERM','HK12','HK13','HK15','HK16','HK17','HK18','HK19','HK20','HK21','HK22','TM01','TM02','TM03','TM04','TM05','TM06','TM07','TM08','TM09','TM10','TM11','S36RMB','S36RM','SD1R','s79rrr','S79RM','S79AR','S79R','S79H','S79AHH','S79HH','S79HK','S799H','S79SH','M79H','S79HG','S79hz','S79CR','S79HS','S79I','S79C','WD1','WD2','WD3','S79RMB','M79U','WDD','WDE','WDH','WDI','WDJ','WDK','WDL','M79V','WDR','WD','WC','WD7','S49RM','S49R','S49H','SSTMR','SSTMH','SSTMJ','SSTMM','SSTMK','SSTMI','S60RUP','S60AR','D60','E60','S16RUP','6666HK','6666BP','6666US','6666EU','M6HK','6hk6601','M6SD','6666AUD','S6EU','S6RUP','S6US','S6ARUP','M6RM','AA','BA','6666AHK','DA','6666AEU','MPH','JPG','S6H','FA','VC','S6BP','VD','VM','VF','GA','VO','GG','s6cn','VP','VQ','S6HK','S6RMB','FM','S6P','VI','VE','VA','VG','MD','S9EU','S6T','VJ','S6S','S6AHK','S88D','M553R','M553AR','M553BR','M553H','M553AH','M553BH','M553CH','M553M','M553DH','S553H','S553M','SEM','SEI','SEH','SED','SEK','SEMA','MJRMB','SJM','SJH','SJSD','SBHK','S305CRMB','S305RM','S31RM','S31RMB','S305R','S31ARMB','SSFH','SSF1H','S3H','SSF2H','SSF3H','MSFR','SSFK','S3HH','SSF5H','S31BRM','S3HK','S305M','S3HG','S3HJ','S3HP','SSF6H','SHSD','SHRMB','SHTB','SHHK','hhm','SHKK','SHHT','SHDK','SHHK1','SHHK2','SHR','SHR1','SHHK3','SHI','shhk5','SHR3','shhk6','SHR5','SHHK7','hhma','sh8','SHHK9','HHN','SHHK8','HHK1','HHK10','HHK2','HHK3','HHR','HHK4','BHJ','CFT','TT','TTA','TTB','S2R','S2T','S2AR','S2BR','S2TB','S688R','S688H','S788H','S688T','S688AH','S688M','LP','LLP','A68US','A688U','SAKH','SAKM','DKE','DKD','M8H','SWU','SWK','SWM','S2H','S2M','S2HH','S2MM','S2MN','S2HY','MRTB','MKWRM','SRRMB','SKWRMB','SRARMB','SRRH','SRR','SRH','SRHK','SRRR','SRMA','SRHKA','SRJ','SRKH','SRHH','SRMB','SRK','SRHC','SRHD','SRMC','SRQ','SMQARMB','M99RMB','S99H','S99TB','S99M','S99T','S99R','S99ah','S99HK','S99HKK','S99HKD','S99BH','S99TH','S99RMB','S999TB','S99C','S99THB','S99D','S99MHK','S99CH','S99BT','S99HA','S99TC','S99E','S99BA','S99BB','S99BC','S99BD','WKH','S45H','s45m','S45AH','S45BH','S45AM','S45BM','S45HK','KJH','KJHB','KJM','KJI','KJD','KJT','KJMB','KJK','KJE','KJB','KJC','KJF','KJMC','KJMA','KJG','KJMD','KJL','KJO','KJME','KJMF','AHM','AHN','AHI','AHO','BHO','AHP','AHQ','AHR','BHN','AHH','AHE','bhu','AHF','AHD','AHG','AHJ','AHL','AHT','AHA','AHC','AHY','AHU','AHV','BHS','AHZ','AHX','AKK','DDD','DDA','GM1','DDB','GM2','GMG','BKK','S41S','S41M','S41H','S43S','S43H','S41K','MC','MC1','MC2','MCR','MC3','MC5','LJ','LH','LU','LY','LL','LB','LC','LD','LE','LV','LF','LT','KD','KL','HA','LS','LA','LG','LM','LII','LZ','BGR','CHU','HPP','HPO','HPM','HPU','HPV','HPW','HPQ','HPK','HPN','HPX','HPY','HPMM','HPI','HPZ','HPR','HPJ','HPH','SX3','SX1','SX2','SZZ','SMY','HPC','HPD','HPE','HPA','MO','MP','HPG','HPB','HPF','HPL','SX5','MQ','SX6','HP2','MG','SX7','SX8','HTB','HPS','HPM2','HP1','HPT','HP3','SX9','HSS','HMN','SATU','SATE','SATS','SATM','JS','JS1','JM','JS2','SFH','JS3','JS5','JS6','JS7','JS8','SJS','SFHA','JS9','JSA','JSC','JSB','JSD','SYSM','SYSHK','JSR','JMA','JSE','JSQ','JSF','JSG','JST','JSH','JSK','JSL','JSM','JR','JSZ','SHG','JSN','JSP','JSU','JRA','JSV','JSW','JSX','JSY','JTH','JSO','JSI','JMJ','JHA','JHB','JMK','JML','JHC','JHH','JHJ','SAS','ASA','SAE','SAI','ASB','M71RMB','M71ARMB','M71BRMB','M71CRMB','S71RM','M71DRMB','SER','S71H','S71AH','S71M','S71BH','S71MA','S71CH','S71DH','S71MB','SCLH','SCLM','SMT','SBTM','SBTH','SBTK','SBTN','SBTD','SBTL','SBTR','SBTY','SKHH','SKMM','PKK','PKA','PKB','PKRM','PKID','PKC','PKD','PKE','PKF','MPKS','PKG','PKH','PKJ','PKL','PKM','PKO','PKP','PKQ','PKT','PKS','SSYR','SSYH','SKPRMB','KPM','WVW','SEA','SEB','SEC','S9M','S9H','XKS','SYI','SNI','S555','S666','S777','JJB','JJM','S359BH','S359M','S359CH','S359S','S359HH','S359am','S359bm','SLP','SLI','SLN','SLO','SLG','SLQ','SLW','SLB','SLL','SLR','SLT','LGA','SLY','SLS','SLE','SLF','SLV','SLU','ALR','ALM','ALH','ALA','ALB','ALC','ALD','RMB','TP','TH','TR','AC1','AC2','ACH','ACH1','ACH2','ACH3','AC3','AC4','ACH4','ACH5','ACH6','AC7','HT1','HT2','HT3','KKT','KKM','KKH','KKMA','KKS','KKB','KKC','KKD','KKE','KKJ','KKN','KKY','KKF','KKG','KKK','KKL','KKI','KKR','KAA','KAB','KGK','KGL','KGM','KGN','KGO','KGP','KAC','KGD','SRS','KAD','KGA','KGB','KAE','KAF','KBA','KBB','KBC','KGE','KBD','KBE','KAG','KAH','KAK','KAJ','KBF','XKM','XKH','VKH','VKD','FJM','SAZM','FFM','21M','21A','LLKH','LHHR','HG9','HGG','HG8','HG7','HG6','HG88','HG101','HG102','HG71','VVY','RG1','RG2','RG3','RG5','RG6','RG7','PPS','PPJ','TS1','TS2','TS3','TS4','DS1','DS2','PK','P11','P12','P13','P14','P15','P16','P17','P18','P19','P22','CTH','CTV','CTM')
AND roleid = 4
AND DisableLiveCasino = 0--enable GD for line has been enabled LCS

--special supers list will enable
INSERT INTO #supers(custid, DisableGoldDeluxe)
SELECT ci.custid, 0
FROM Customer ci WITH(NOLOCK)
WHERE USERname IN ('M999RM','SHK','SPHM','S90R','S90H','SQK','S797R','M797RM','S797H','S797AH','SWH','SWAH','SWSH','wm','WN','WT','SWB','SWC','SWD','SWE','SWF','SWG','SWI','SWJ','SWW','WE','S797S','SWN','WMA','SWP','SWQ','SWR','SWX','WMB','WTA','D66','S222R','S222H','S222HK','S222T','S222AH','S222BH','S222TH','S222TA','S222CH','S222DH','2EH','S222FH','S222GH','2KH','S222MH','S222NH','M222M','2AH','2BH','2HB','2CH','2DH','2LH','2ZH','2ID','2NH','2PH','2MM','2YH','2FH','2GH','2EU','2DD','2MN','2WH','S222JH','2HH','2RM','2DE','S222X','2NN','2HK','2RR','2CR','2CT','2JH','S222N','S222ZH','2XX','2WW','2CK','2RH','2IH','2BP','2QH','2OH','2SH','2AA','2AB','2AC','2MP','2MY','2MQ','2UH','SB8R','SBB','TH8','SBSD','SBV')
AND roleid = 4

--UUS currency enable by default
INSERT INTO #supers(custid, DisableGoldDeluxe)
SELECT ci.custid, 0
FROM CustInfo ci WITH(NOLOCK)
WHERE roleid = 4
	AND custid NOT IN (SELECT custid FROM Dep_CustSuper WITH(NOLOCK))
	AND currency = 20

--ohters will disable by default
INSERT INTO #supers(custid, DisableGoldDeluxe)
SELECT ci.custid, 1
FROM CustInfo ci WITH(NOLOCK)
WHERE ci.roleid = 4 	
	AND ci.custid NOT IN (SELECT custid FROM Dep_CustSuper WITH(NOLOCK))
	AND ci.custid NOT IN (SELECT custid FROM #supers)
	AND custid <= @max_custid 
	
WHILE (1 = 1)
BEGIN
	UPDATE TOP (1) #Supers
	SET isfinished = 1
		,@srecommend = custid		
		,@DisableGoldDeluxe = DisableGoldDeluxe		
	WHERE isfinished = 0
	
	IF @@ROWCOUNT = 0 BREAK

	EXEC dbo.[Acc_ExecRep_Cust_09] @srecommend = @srecommend
			,@maxcustid = @max_custid
			,@target = 'DBCUST'
			,@DisableGoldDeluxe = @DisableGoldDeluxe
	
	waitfor delay '00:00:0.280'
END			
GO		

-- END STEP 3: RUN THIS SCRIPT AT DBCUST -----
-----------------------------------------------------------------------------------