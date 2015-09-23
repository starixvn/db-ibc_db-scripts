  /*
	Created: Johnson
	Task: Adjust status for agents list in special sheet
	DB: DBTXN/CustDB
	Date: 20150923
*/  


--only adjust for downlines under these lines have changed live casino status
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
GO

UPDATE custinfo WITH(UPDLOCK,ROWLOCK)
SET DisableGoldDeluxe = DisableLiveCasino
WHERE mrecommend IN (SELECT custid FROM #tmpDownlineEnable WHERE roleid = 3)	
	AND DisableGoldDeluxe <> DisableLiveCasino
GO

UPDATE custinfo WITH(UPDLOCK,ROWLOCK)
SET DisableGoldDeluxe = DisableLiveCasino
WHERE srecommend IN (SELECT custid FROM #tmpDownlineEnable WHERE roleid = 4)	
	AND DisableGoldDeluxe <> DisableLiveCasino
GO
	


