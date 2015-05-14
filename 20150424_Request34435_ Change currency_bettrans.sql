 
  /*
	Task: Change currency of some existing creadit supers to new currency (HKK)
	Create date: 2015-04-21
	Author: Susan
	Redmine link: https://redmine.nexcel.vn/issues/34435
	DB: DBTXN/CustDB
 */


-- BEGIN STEP 1: DEPLOY THIS SP @ DBTRANS.CustDB -----
------------------------------------------------------
ALTER PROCEDURE [dbo].[Acc_ExecRep_Cust_09]
	  @CustID int	
	 ,@newcurrency  varchar(50)
	 ,@target VARCHAR(20)
	 ,@maxtransid bigint
AS
BEGIN
	SET NOCOUNT ON;

	
	IF (@target = 'REPLICATED' AND @@SERVERNAME = 'DBTRANS') RETURN	-- run at all replicated servers
	IF (@target = 'DBTRANS' AND @@SERVERNAME <> 'DBTRANS') RETURN -- run at dbtrans only



	DECLARE  @ExchangeID int, @actualrate float 

	SELECT @ExchangeID=67, @actualrate=0.4
  
 --- Update bettrans from DBTrans
 IF (@target = 'DBTRANS' AND @@SERVERNAME = 'DBTRANS')
BEGIN
	 IF (SELECT COUNT(1) FROM bodb02.dbo.sysobjects WHERE name IN ('bettrans','bettransm','bettransg','translog') AND type = 'U') <> 4
			RETURN
	 --- UPDATE data FROM bettrans 
	 UPDATE b WITH (UPDLOCK, ROWLOCK)  
	 SET CurrencyName = @newcurrency  
		 ,currency = @ExchangeID  
		 ,actualrate = @actualrate  
		 ,virtualrate = CASE   
						WHEN bettype < 20000 THEN (virtualrate * @actualrate) / actualrate  
						ELSE 0  
						END  
	 FROM bodb02.dbo.bettrans b
	 WHERE srecommend = @CustID  
	  --AND status= 'running'    
	  AND actualrate IS NOT NULL  
	  AND winlostdate >= convert(VARCHAR(10), getdate(), 112)  
	  AND bettype NOT IN (71, 72, 73, 31, 32, 33, 41, 42, 43, 51, 52, 53, 54, 55, 56, 61, 62, 63, 64, 65, 66, 1000, 23001, 23002, 23101)  
	  AND currency<>67
	  AND transid<=@maxtransid
  
	 UPDATE b WITH (UPDLOCK, ROWLOCK)  
	 SET CurrencyName = @newcurrency  
		,currency = @ExchangeID  
		,actualrate = @actualrate  
		,virtualrate = (virtualrate * @actualrate) / actualrate  
	 FROM bodb02.dbo.bettrans b
	 WHERE srecommend = @CustID  
	  --AND status = 'running'    
	  AND statusID = 0  
	  AND actualrate IS NOT NULL  
	  AND winlostdate < convert(VARCHAR(10), getdate(), 112)  
	  AND bettype IN (9, 29)  
	  AND matchid IN (9, 29)  
	  AND currency<>67
	  AND transid<=@maxtransid 


	 --- KENO ticket in Translog table  
	 UPDATE t WITH (UPDLOCK, ROWLOCK)  
	 SET CurrencyName = @newcurrency  
		,currency = @ExchangeID  
		,actualrate = @actualrate  
		,virtualrate = (virtualrate * @actualrate) / actualrate  
	 From bodb02.dbo.translog t
	 WHERE srecommend = @CustID  
	  AND winlostdate >= convert(VARCHAR(10), getdate(), 112)  
	 AND currency<>67

	----Update bettransm
	 UPDATE bm WITH (UPDLOCK, ROWLOCK)  
	 SET bm.actualrate = @actualrate  
	 FROM bodb02.dbo.bettransm bm  
	 INNER JOIN bodb02.dbo.bettrans b WITH (NOLOCK) ON bm.refno = b.refno  
	 WHERE srecommend = @CustID  
	 AND b.actualrate IS NOT NULL  
	 AND ((  
			b.statusID = 0  
			AND b.winlostdate < convert(VARCHAR(10), getdate(), 112)  
	   ) -- Running tickets  
	 OR b.winlostdate >= convert(VARCHAR(10), getdate(), 112)) -- Today ticket and onwards  
	 AND b.bettype IN (9, 29)  
	 AND b.matchid IN (9, 29)  

	---Update bettransg  
	 UPDATE bg WITH (UPDLOCK, ROWLOCK)  
	 SET bg.actualrate = @actualrate  
		 ,bg.virtualrate = @actualrate  
	 FROM bodb02.dbo.bettransg bg  
	 INNER JOIN bodb02.dbo.bettrans b WITH (NOLOCK) ON bg.refno = b.refno  
	 WHERE srecommend = @CustID  
	 AND b.actualrate IS NOT NULL  
	 AND b.winlostdate >= convert(VARCHAR(10), getdate(), 112) -- Today ticket and onwards  
	 AND b.bettype IN (1101, 1102, 1103, 1104) 
	  
END

---Update bettrans from Replicated DB
 IF (@target = 'REPLICATED' AND @@SERVERNAME <> 'DBTRANS')
 BEGIN
	 IF (SELECT COUNT(1) FROM sys.objects WHERE name IN ('bettrans','bettransm','bettransg','translog') AND type = 'U') <> 4
			RETURN
	 --- UPDATE data FROM bettrans 
	 UPDATE b WITH (UPDLOCK, ROWLOCK)  
	 SET CurrencyName = @newcurrency  
	  ,currency = @ExchangeID  
	  ,actualrate = @actualrate  
	  ,virtualrate = CASE   
					 WHEN bettype < 20000 THEN (virtualrate * @actualrate) / actualrate  
					 ELSE 0  
					 END  
	 FROM bettrans b
	 WHERE srecommend = @CustID  
	  --AND status= 'running'    
	 AND actualrate IS NOT NULL  
	 AND winlostdate >= convert(VARCHAR(10), getdate(), 112)  
	 AND bettype NOT IN (71, 72, 73, 31, 32, 33, 41, 42, 43, 51, 52, 53, 54, 55, 56, 61, 62, 63, 64, 65, 66, 1000, 23001, 23002, 23101)  
	 AND transid<=@maxtransid 
  
	 UPDATE b WITH (UPDLOCK, ROWLOCK)  
	 SET CurrencyName = @newcurrency  
	    ,currency = @ExchangeID  
	    ,actualrate = @actualrate  
	    ,virtualrate = (virtualrate * @actualrate) / actualrate  
	 FROM bettrans b
	 WHERE srecommend = @CustID  
	  --AND status = 'running'    
	  AND statusID = 0  
	  AND actualrate IS NOT NULL  
	  AND winlostdate < convert(VARCHAR(10), getdate(), 112)  
	  AND bettype IN (9, 29)  
	  AND matchid IN (9, 29)  
	  AND transid<=@maxtransid 
  
	 --- KENO ticket in Translog table  
	 UPDATE t WITH (UPDLOCK, ROWLOCK)  
	 SET CurrencyName = @newcurrency  
	  ,currency = @ExchangeID  
	  ,actualrate = @actualrate  
	  ,virtualrate = (virtualrate * @actualrate) / actualrate  
	  From translog t
	 WHERE srecommend = @CustID  
	  AND winlostdate >= convert(VARCHAR(10), getdate(), 112)  
  
	---bettransm
	 UPDATE bm WITH (UPDLOCK, ROWLOCK)  
	 SET bm.actualrate = @actualrate  
	 FROM bettransm bm  
	  INNER JOIN bettrans b WITH (NOLOCK) ON bm.refno = b.refno  
	 WHERE srecommend = @CustID  
	 AND b.actualrate IS NOT NULL  
	 AND ((  
			 b.statusID = 0  
			AND b.winlostdate < convert(VARCHAR(10), getdate(), 112)  
	   ) -- Running tickets  
	 OR b.winlostdate >= convert(VARCHAR(10), getdate(), 112)) -- Today ticket and onwards  
	 AND b.bettype IN (9, 29)  
	 AND b.matchid IN (9, 29)  
	 AND b.transid<=@maxtransid 
  
	 UPDATE bg WITH (UPDLOCK, ROWLOCK)  
	 SET bg.actualrate = @actualrate  
	  ,bg.virtualrate = @actualrate  
	 FROM bettransg bg  
	 INNER JOIN bettrans b WITH (NOLOCK) ON bg.refno = b.refno  
	 WHERE srecommend = @CustID  
	 AND b.actualrate IS NOT NULL  
	 AND b.winlostdate >= convert(VARCHAR(10), getdate(), 112) -- Today ticket and onwards  
	 AND b.bettype IN (1101, 1102, 1103, 1104)  
	 AND b.transid<=@maxtransid 
END


END  
  


GO-- END STEP 1: DEPLOY THIS SP @ DBTRANS.CustDB -------
------------------------------------------------------


-- BEGIN STEP 2: RUN THIS SCRIPT AT REPLICATE DB -----
-------------------------------------------------
CREATE TABLE #Supers ( custid INT PRIMARY KEY, username varchar(50),newcurrency  varchar(50) , isfinished bit default(0))
DECLARE @currency int  ,@CustID int  ,@newcurrency  varchar(50), @maxtransid bigint

SELECT @maxtransid=xxx   ---input maxcustid here

---inser super in to #supers:
INSERT INTO #Supers
SELECT  custid,
		username,
		'HKK',
		 0
FROM Custinfo WITH(NOLOCK) 
WHERE custid IN (13650701,--1C
				16797404,--	2AA
				3634274	,--	2AH
				3673145	,--	2BH
				3741448	,--	2CH
				3800272	,--	2DH
				2468871	,--	2EH
				6660062	,--	2FH
				6660080	,--	2GH
				9178183	,--	2HH
				11779389,--	2HK
				16110555,--	2IH
				2850808	,--	2KH
				4002647	,--	2LH
				4582761	,--	2NH
				16632862,--	2OH
				4770359	,--	2PH
				16429517,--	2QH
				15862762,--	2RH
				16651313,--	2SH
				8452415	,--	2WH
				15691505,--	2WW
				15691361,--	2XX
				5430927	,--	2YH
				13308147,--	9H
				16629424,--	A6
				4115476	,--	AHA
				4154452	,--	AHC
				3026741	,--	AHE
				3387915	,--	AHF
				3780034	,--	AHL
				11028100,--	AHMA
				1628290	,--	AHN
				2197674	,--	AHO
				2572491	,--	AHP
				2798591	,--	AHR
				4542800	,--	AHU
				15479306,--	AHX
				15568896,--	AK1
				16376143,--	AKK
				16542371,--	ALB
				16007063,--	ALH
				2221671	,--	BHO
				5780740	,--	BHS
				10369357,--	C1
				11998757,--	C10
				12042691,--	C11
				12276108,--	C13
				12276215,--	C15
				10776607,--	C5
				12551127,--	C6
				10932984,--	C7
				11639821,--	C8
				11674120,--	C9
				14600271,--	CM
				13068960,--	CV
				2045218	,--	D5M
				8660821	,--	D71
				16781864,--	D77
				17639099,--	D78
				10851205,--	DAB
				10851237,--	DAC
				15926983,--	DAF
				12267541,--	DVD
				14393371,--	EEH
				13658529,--	EPL
				13877914,--	GAX
				966501	,--	GEH
				1601946	,--	GFH
				12334841,--	H1
				12645956,--	H2
				12697102,--	H3
				12747449,--	H5
				13864417,--	H8
				12276311,--	H9
				1069683	,--	HAH
				10369510,--	HDQ
				10229689,--	HG
				17598313,--	HG6
				17371180,--	HG7
				16697599,--	HG8
				16660203,--	HG9
				889147	,--	HIH
				1029732	,--	HJ
				14056309,--	HK01
				14056457,--	HK02
				15459128,--	HK03
				15479653,--	HK05
				15689139,--	HK06
				15814766,--	HK07
				16185668,--	HK10
				16288719,--	HK11
				17281063,--	HK12
				12969157,--	HKD
				17330507,--	HP1
				13552912,--	HPB
				8646071	,--	HPC
				14117461,--	HPF
				3352151	,--	HPK
				14689217,--	HPL
				2138601	,--	HPO
				2075164	,--	HPP
				3175356	,--	HPQ
				5375143	,--	HPR
				2895571	,--	HPU
				2953285	,--	HPV
				3040566	,--	HPW
				4262766	,--	HPX
				4339154	,--	HPY
				5294161	,--	HPZ
				12698394,--	HZ
				1220882	,--	JAH
				3158177	,--	JC1
				6512733	,--	JC10
				3637466	,--	JC2
				3803986	,--	JC6
				3161673	,--	JC7
				12172555,--	JC82
				14672236,--	JC83
				4106468	,--	JC9
				15296297,--	JHA
				15678760,--	JHB
				17519042,--	JHC
				5484091	,--	JJB
				12343335,--	JK6
				1262078	,--	JS
				1437413	,--	JS1
				2345677	,--	JS3
				2487351	,--	JS5
				2586897	,--	JS6
				2732315	,--	JS7
				3581309	,--	JSA
				3992866	,--	JSC
				4213345	,--	JSD
				5551253	,--	JSF
				14645537,--	JSI
				7665277	,--	JSK
				7744897	,--	JSL
				7925352	,--	JSM
				14288020,--	JSO
				12285701,--	JSU
				13216677,--	JSV
				13589028,--	JSW
				13916569,--	JSX
				13947290,--	JSY
				11895734,--	JSZ
				15368528,--	KAB
				16179977,--	KAD
				726562	,--	KAR
				15464062,--	KGK
				15472987,--	KGL
				15523574,--	KGM
				15833836,--	KGN
				194355	,--	KH
				3589741	,--	KH6
				913628	,--	KHBH
				1069029	,--	KHCH
				2400612	,--	KHDH
				674248	,--	KHH
				5061164	,--	KJC
				3299401	,--	KJD
				4568298	,--	KJE
				1574950	,--	KJH
				10488307,--	KKH
				13323754,--	KKK
				13959383,--	KKR
				11747087,--	KKY
				1088459	,--	KYH
				4374817	,--	LHH
				14654561,--	LHH10
				15973870,--	LHH12
				7754066	,--	LHH2
				10844414,--	LHH7
				11449326,--	LHH8
				14479158,--	LHH9
				997137	,--	MK1
				1074882	,--	MK10
				1074884	,--	MK11C
				1419577	,--	MK12
				1985118	,--	MK16
				1441097	,--	MK17
				1650176	,--	MK19
				997149	,--	MK2
				1731921	,--	MK21
				3140232	,--	MK23
				4127035	,--	MK27
				997151	,--	MK3
				7541492	,--	MK31
				14493592,--	MK32
				15643773,--	MK33
				16173167,--	MK35
				998346	,--	MK4C
				997152	,--	MK5
				997155	,--	MK6
				1026354	,--	MK8
				1030116	,--	MK9
				13999461,--	MOA
				14084599,--	MOB
				11581838,--	MYM
				3988315	,--	PKA
				3988331	,--	PKB
				4553978	,--	PKC
				4638100	,--	PKD
				4957465	,--	PKE
				5205926	,--	PKF
				6520522	,--	PKG
				7694826	,--	PKH
				8363406	,--	PKJ
				3934718	,--	PKK
				8591808	,--	PKL
				9368991	,--	PKM
				12033438,--	PKP
				16403843,--	PKS
				17568160,--	PPJ
				17550987,--	PPS
				12957917,--	QQBS
				7756579	,--	QQKA
				7756567	,--	QQKR
				16350958,--	QQKS
				15534612,--	QQKT
				7757433	,--	QQKU
				16996685,--	R8
				17131337,--	RG1
				17131340,--	RG2
				1867721	,--	S09H
				14117558,--	S1
				14374442,--	S11
				984326	,--	S188AH
				897682	,--	S188H
				14168098,--	S2
				1551473	,--	S222AH
				1607683	,--	S222BH
				2114958	,--	S222CH
				2267229	,--	S222DH
				2468882	,--	S222FH
				2644737	,--	S222GH
				900801	,--	S222H
				1005645	,--	S222HK
				8811657	,--	S222JH
				2864145	,--	S222MH
				15583137,--	S222N
				11644965,--	S222X
				1071794	,--	S25R
				1011974	,--	S26H
				3752852	,--	S27A
				1001999	,--	S27HK
				7945539	,--	S27TK
				1020356	,--	S2H
				5239932	,--	S2HH
				16094466,--	S2HY
				882346	,--	S2R
				14219614,--	S3
				356937	,--	S305CRMB
				771942	,--	S31ARMB
				478396	,--	S31RMB
				987497	,--	S32BH
				987499	,--	S32CH
				987501	,--	S32DH
				1272134	,--	S32EH
				857802	,--	S32H
				2284508	,--	S32HH
				15657898,--	S32HKD
				15731785,--	S32KH
				16312762,--	S32LH
				324558	,--	S32RMB
				6379932	,--	S359BH
				6552366	,--	S359CH
				7752889	,--	S359HH
				7655254	,--	S359HK
				324559	,--	S36RMB
				941038	,--	S3AAH
				941026	,--	S3AH
				572607	,--	S3AR
				9732491	,--	S3BH
				7657763	,--	S3EH
				972747	,--	S3H
				3560324	,--	S3HH
				15493382,--	S3HJ
				7763508	,--	S3HK
				2926808	,--	S41H
				1036451	,--	S42AH
				1652112	,--	S42CH
				16178052,--	S42EH
				1022404	,--	S42H
				8270016	,--	S43H
				1362437	,--	S45H
				838051	,--	S47R
				528691	,--	S50RMB
				3592236	,--	S51AH
				3592237	,--	S51BH
				3592239	,--	S51CH
				3801635	,--	S51DH
				835299	,--	S51R
				1755451	,--	S553H
				4910597	,--	S555
				5591058	,--	S56AA
				838203	,--	S56AH
				838210	,--	S56BBH
				838370	,--	S56CH
				877768	,--	S56EH
				1031455	,--	S56GH
				838201	,--	S56H
				844818	,--	S56HH
				1219867	,--	S56HK
				1031457	,--	S56JH
				1194960	,--	S56KH
				1294410	,--	S56LH
				3775566	,--	S56NH
				3775579	,--	S56PH
				4356717	,--	S56QH
				461775	,--	S56R
				5187839	,--	S56SH
				10630381,--	S56UH
				12162858,--	S56VH
				461780	,--	S58R
				14219726,--	S6
				1720567	,--	S62H
				4910667	,--	S666
				901840	,--	S688H
				726483	,--	S70RMB
				2924293	,--	S71BH
				993226	,--	S71H
				16189265,--	S777
				914839	,--	S788H
				987102	,--	S799H
				900371	,--	S79AHH
				836410	,--	S79H
				985943	,--	S79HK
				2775382	,--	S79HS
				989898	,--	S79SH
				14291649,--	S9
				1127269	,--	S91R
				14521186,--	S922A
				3721876	,--	S922G
				1019793	,--	S922H
				3043793	,--	S922L
				3212166	,--	S922P
				3517988	,--	S922W
				2300662	,--	S95DH
				1266057	,--	S96h
				4022510	,--	S99ah
				859594	,--	S99H
				4134975	,--	S99HK
				7604170	,--	S99HKD
				4793213	,--	S99HKK
				4554012	,--	S9H
				1456925	,--	SAMR
				932905	,--	SBH
				12968884,--	SBHF
				13549891,--	SBHG
				805450	,--	SBHK
				595962	,--	SBKH
				324336	,--	SBKHK
				17721601,--	SBMW
				15905075,--	SCDH
				838215	,--	SCH
				324557	,--	SCHK
				2285864	,--	SCI
				3046451	,--	SCLH
				984549	,--	SDH
				6621107	,--	SDHA
				3299391	,--	SEH
				4371323	,--	SEK
				774701	,--	SER
				3202337	,--	SG15H
				3299716	,--	SG16H
				3543954	,--	SG17H
				840993	,--	SG1H
				4181669	,--	SG21H
				4780138	,--	SG25H
				6032952	,--	SG27H
				7165270	,--	sg29h
				840999	,--	SG2H
				7643291	,--	SG31H
				10719518,--	SG33H
				13964983,--	SG36H
				14500765,--	SG37H
				17065592,--	SG41H
				1923414	,--	SG4H
				1927603	,--	SG6H
				2140377	,--	SG7H
				2260222	,--	SG8H
				2800652	,--	SG9H
				11930116,--	SHG
				463265	,--	SHK
				1156957	,--	SKHH
				506057	,--	SKPRMB
				12677536,--	SLE
				2178402	,--	SLH
				3872549	,--	SLJ
				7768121	,--	SLL
				7756983	,--	SLO
				14783808,--	SLV
				2278343	,--	SMBH
				13294314,--	SMCH
				984745	,--	SMH
				984746	,--	SMMH
				5395806	,--	SMOA
				6129341	,--	SMOB
				7146892	,--	SMOC
				10419083,--	SMOF
				15588279,--	SMOI
				14611891,--	SMOKH
				1568705	,--	SMOL
				1584511	,--	SMON
				1639382	,--	SMOP
				1833046	,--	SMOQ
				2864842	,--	SMOR
				10945672,--	SMORA
				2574511	,--	SMOT
				10228419,--	SMOU
				14804092,--	SMOV
				994735	,--	SPK
				14210898,--	SQHH
				14487413,--	SR
				16723695,--	SRHD
				12368437,--	SRHH
				2341316	,--	SRHKA
				6164108	,--	SRJ
				11213414,--	SRKH
				16155418,--	SRS
				11734366,--	SSF
				1013342	,--	SSF2H
				4362130	,--	SSF5H
				837904	,--	SSFH
				14776453,--	SSG
				2967035	,--	SSK
				2491953	,--	SSTMH
				5232827	,--	STPL
				997237	,--	SWAH
				1501259	,--	SWB
				1590290	,--	SWC
				1698383	,--	SWD
				1788386	,--	SWE
				2033407	,--	SWF
				2101733	,--	SWG
				965631	,--	SWH
				1244484	,--	SWHH
				2122304	,--	SWI
				2400801	,--	SWJ
				4011723	,--	SWN
				4290320	,--	SWP
				7204275	,--	SWQ
				8444096	,--	SWR
				1348932	,--	SWSH
				2522889	,--	SWW
				8864778	,--	SWX
				8212440	,--	SX1
				8226456	,--	SX2
				7752444	,--	SX3
				14822871,--	SX5
				15615804,--	SX6
				16406680,--	SX8
				14653772,--	SYCN
				11400410,--	SYLG
				4155328	,--	SYLH
				356948	,--	SYLHK
				5049084	,--	SYLHZ
				4501066	,--	SYSHK
				1427766	,--	SZ
				8314515	,--	SZZ
				10528317,--	TH
				2181729	,--	TH25
				2959987	,--	TH26
				4253518	,--	TH28
				4286209	,--	TH29
				998349	,--	TH7
				6647416	,--	TH89
				11395466,--	TLH
				7912978	,--	TLM
				8119664	,--	TLN
				10398791,--	VKH
				17004016,--	VVY
				3498147	,--	WD2
				4262711	,--	WDD
				1457236	,--	WKH
				1419459	,--	WN
				1465925	,--	WT
				10346439,--	XKH
				7757683	,--	YH
				13053739,--	YUH
				14629438--	ZS
				)
AND Roleid=4



WHILE (1 = 1)
BEGIN
	UPDATE TOP (1) #Supers
	SET isfinished = 1
		,@newcurrency = newcurrency
		,@CustID = custid	
	WHERE isfinished = 0
	
	IF @@ROWCOUNT = 0 BREAK
			
	EXEC dbo.Acc_ExecRep_Cust_09  @Custid = @CustID, @newcurrency = @newcurrency, @maxtransid=@maxtransid, @target = 'REPLICATED'  			
	
	WAITFOR DELAY '00:00:00.280'
END

DROP TABLE #Supers
GO

---- End of step 2

-- BEGIN STEP 3: RUN THIS SCRIPT AT DBTRANS/CustDB -----
-------------------------------------------------
-------------------------------------------------
-------------------------------------------------
CREATE TABLE #Supers ( custid INT PRIMARY KEY, username  varchar(50),newcurrency  varchar(50) , isfinished bit default(0))
DECLARE @currency int ,@CustID int ,@newcurrency  varchar(50), @maxtransid bigint

SELECT @maxtransid=xxx   --input maxcustid here
---inser super in to #supers:
INSERT INTO #Supers
SELECT  custid,
		username,
		'HKK',
		 0
FROM Custinfo WITH(NOLOCK) 
WHERE custid in (13650701,--1C
				16797404,--	2AA
				3634274	,--	2AH
				3673145	,--	2BH
				3741448	,--	2CH
				3800272	,--	2DH
				2468871	,--	2EH
				6660062	,--	2FH
				6660080	,--	2GH
				9178183	,--	2HH
				11779389,--	2HK
				16110555,--	2IH
				2850808	,--	2KH
				4002647	,--	2LH
				4582761	,--	2NH
				16632862,--	2OH
				4770359	,--	2PH
				16429517,--	2QH
				15862762,--	2RH
				16651313,--	2SH
				8452415	,--	2WH
				15691505,--	2WW
				15691361,--	2XX
				5430927	,--	2YH
				13308147,--	9H
				16629424,--	A6
				4115476	,--	AHA
				4154452	,--	AHC
				3026741	,--	AHE
				3387915	,--	AHF
				3780034	,--	AHL
				11028100,--	AHMA
				1628290	,--	AHN
				2197674	,--	AHO
				2572491	,--	AHP
				2798591	,--	AHR
				4542800	,--	AHU
				15479306,--	AHX
				15568896,--	AK1
				16376143,--	AKK
				16542371,--	ALB
				16007063,--	ALH
				2221671	,--	BHO
				5780740	,--	BHS
				10369357,--	C1
				11998757,--	C10
				12042691,--	C11
				12276108,--	C13
				12276215,--	C15
				10776607,--	C5
				12551127,--	C6
				10932984,--	C7
				11639821,--	C8
				11674120,--	C9
				14600271,--	CM
				13068960,--	CV
				2045218	,--	D5M
				8660821	,--	D71
				16781864,--	D77
				17639099,--	D78
				10851205,--	DAB
				10851237,--	DAC
				15926983,--	DAF
				12267541,--	DVD
				14393371,--	EEH
				13658529,--	EPL
				13877914,--	GAX
				966501	,--	GEH
				1601946	,--	GFH
				12334841,--	H1
				12645956,--	H2
				12697102,--	H3
				12747449,--	H5
				13864417,--	H8
				12276311,--	H9
				1069683	,--	HAH
				10369510,--	HDQ
				10229689,--	HG
				17598313,--	HG6
				17371180,--	HG7
				16697599,--	HG8
				16660203,--	HG9
				889147	,--	HIH
				1029732	,--	HJ
				14056309,--	HK01
				14056457,--	HK02
				15459128,--	HK03
				15479653,--	HK05
				15689139,--	HK06
				15814766,--	HK07
				16185668,--	HK10
				16288719,--	HK11
				17281063,--	HK12
				12969157,--	HKD
				17330507,--	HP1
				13552912,--	HPB
				8646071	,--	HPC
				14117461,--	HPF
				3352151	,--	HPK
				14689217,--	HPL
				2138601	,--	HPO
				2075164	,--	HPP
				3175356	,--	HPQ
				5375143	,--	HPR
				2895571	,--	HPU
				2953285	,--	HPV
				3040566	,--	HPW
				4262766	,--	HPX
				4339154	,--	HPY
				5294161	,--	HPZ
				12698394,--	HZ
				1220882	,--	JAH
				3158177	,--	JC1
				6512733	,--	JC10
				3637466	,--	JC2
				3803986	,--	JC6
				3161673	,--	JC7
				12172555,--	JC82
				14672236,--	JC83
				4106468	,--	JC9
				15296297,--	JHA
				15678760,--	JHB
				17519042,--	JHC
				5484091	,--	JJB
				12343335,--	JK6
				1262078	,--	JS
				1437413	,--	JS1
				2345677	,--	JS3
				2487351	,--	JS5
				2586897	,--	JS6
				2732315	,--	JS7
				3581309	,--	JSA
				3992866	,--	JSC
				4213345	,--	JSD
				5551253	,--	JSF
				14645537,--	JSI
				7665277	,--	JSK
				7744897	,--	JSL
				7925352	,--	JSM
				14288020,--	JSO
				12285701,--	JSU
				13216677,--	JSV
				13589028,--	JSW
				13916569,--	JSX
				13947290,--	JSY
				11895734,--	JSZ
				15368528,--	KAB
				16179977,--	KAD
				726562	,--	KAR
				15464062,--	KGK
				15472987,--	KGL
				15523574,--	KGM
				15833836,--	KGN
				194355	,--	KH
				3589741	,--	KH6
				913628	,--	KHBH
				1069029	,--	KHCH
				2400612	,--	KHDH
				674248	,--	KHH
				5061164	,--	KJC
				3299401	,--	KJD
				4568298	,--	KJE
				1574950	,--	KJH
				10488307,--	KKH
				13323754,--	KKK
				13959383,--	KKR
				11747087,--	KKY
				1088459	,--	KYH
				4374817	,--	LHH
				14654561,--	LHH10
				15973870,--	LHH12
				7754066	,--	LHH2
				10844414,--	LHH7
				11449326,--	LHH8
				14479158,--	LHH9
				997137	,--	MK1
				1074882	,--	MK10
				1074884	,--	MK11C
				1419577	,--	MK12
				1985118	,--	MK16
				1441097	,--	MK17
				1650176	,--	MK19
				997149	,--	MK2
				1731921	,--	MK21
				3140232	,--	MK23
				4127035	,--	MK27
				997151	,--	MK3
				7541492	,--	MK31
				14493592,--	MK32
				15643773,--	MK33
				16173167,--	MK35
				998346	,--	MK4C
				997152	,--	MK5
				997155	,--	MK6
				1026354	,--	MK8
				1030116	,--	MK9
				13999461,--	MOA
				14084599,--	MOB
				11581838,--	MYM
				3988315	,--	PKA
				3988331	,--	PKB
				4553978	,--	PKC
				4638100	,--	PKD
				4957465	,--	PKE
				5205926	,--	PKF
				6520522	,--	PKG
				7694826	,--	PKH
				8363406	,--	PKJ
				3934718	,--	PKK
				8591808	,--	PKL
				9368991	,--	PKM
				12033438,--	PKP
				16403843,--	PKS
				17568160,--	PPJ
				17550987,--	PPS
				12957917,--	QQBS
				7756579	,--	QQKA
				7756567	,--	QQKR
				16350958,--	QQKS
				15534612,--	QQKT
				7757433	,--	QQKU
				16996685,--	R8
				17131337,--	RG1
				17131340,--	RG2
				1867721	,--	S09H
				14117558,--	S1
				14374442,--	S11
				984326	,--	S188AH
				897682	,--	S188H
				14168098,--	S2
				1551473	,--	S222AH
				1607683	,--	S222BH
				2114958	,--	S222CH
				2267229	,--	S222DH
				2468882	,--	S222FH
				2644737	,--	S222GH
				900801	,--	S222H
				1005645	,--	S222HK
				8811657	,--	S222JH
				2864145	,--	S222MH
				15583137,--	S222N
				11644965,--	S222X
				1071794	,--	S25R
				1011974	,--	S26H
				3752852	,--	S27A
				1001999	,--	S27HK
				7945539	,--	S27TK
				1020356	,--	S2H
				5239932	,--	S2HH
				16094466,--	S2HY
				882346	,--	S2R
				14219614,--	S3
				356937	,--	S305CRMB
				771942	,--	S31ARMB
				478396	,--	S31RMB
				987497	,--	S32BH
				987499	,--	S32CH
				987501	,--	S32DH
				1272134	,--	S32EH
				857802	,--	S32H
				2284508	,--	S32HH
				15657898,--	S32HKD
				15731785,--	S32KH
				16312762,--	S32LH
				324558	,--	S32RMB
				6379932	,--	S359BH
				6552366	,--	S359CH
				7752889	,--	S359HH
				7655254	,--	S359HK
				324559	,--	S36RMB
				941038	,--	S3AAH
				941026	,--	S3AH
				572607	,--	S3AR
				9732491	,--	S3BH
				7657763	,--	S3EH
				972747	,--	S3H
				3560324	,--	S3HH
				15493382,--	S3HJ
				7763508	,--	S3HK
				2926808	,--	S41H
				1036451	,--	S42AH
				1652112	,--	S42CH
				16178052,--	S42EH
				1022404	,--	S42H
				8270016	,--	S43H
				1362437	,--	S45H
				838051	,--	S47R
				528691	,--	S50RMB
				3592236	,--	S51AH
				3592237	,--	S51BH
				3592239	,--	S51CH
				3801635	,--	S51DH
				835299	,--	S51R
				1755451	,--	S553H
				4910597	,--	S555
				5591058	,--	S56AA
				838203	,--	S56AH
				838210	,--	S56BBH
				838370	,--	S56CH
				877768	,--	S56EH
				1031455	,--	S56GH
				838201	,--	S56H
				844818	,--	S56HH
				1219867	,--	S56HK
				1031457	,--	S56JH
				1194960	,--	S56KH
				1294410	,--	S56LH
				3775566	,--	S56NH
				3775579	,--	S56PH
				4356717	,--	S56QH
				461775	,--	S56R
				5187839	,--	S56SH
				10630381,--	S56UH
				12162858,--	S56VH
				461780	,--	S58R
				14219726,--	S6
				1720567	,--	S62H
				4910667	,--	S666
				901840	,--	S688H
				726483	,--	S70RMB
				2924293	,--	S71BH
				993226	,--	S71H
				16189265,--	S777
				914839	,--	S788H
				987102	,--	S799H
				900371	,--	S79AHH
				836410	,--	S79H
				985943	,--	S79HK
				2775382	,--	S79HS
				989898	,--	S79SH
				14291649,--	S9
				1127269	,--	S91R
				14521186,--	S922A
				3721876	,--	S922G
				1019793	,--	S922H
				3043793	,--	S922L
				3212166	,--	S922P
				3517988	,--	S922W
				2300662	,--	S95DH
				1266057	,--	S96h
				4022510	,--	S99ah
				859594	,--	S99H
				4134975	,--	S99HK
				7604170	,--	S99HKD
				4793213	,--	S99HKK
				4554012	,--	S9H
				1456925	,--	SAMR
				932905	,--	SBH
				12968884,--	SBHF
				13549891,--	SBHG
				805450	,--	SBHK
				595962	,--	SBKH
				324336	,--	SBKHK
				17721601,--	SBMW
				15905075,--	SCDH
				838215	,--	SCH
				324557	,--	SCHK
				2285864	,--	SCI
				3046451	,--	SCLH
				984549	,--	SDH
				6621107	,--	SDHA
				3299391	,--	SEH
				4371323	,--	SEK
				774701	,--	SER
				3202337	,--	SG15H
				3299716	,--	SG16H
				3543954	,--	SG17H
				840993	,--	SG1H
				4181669	,--	SG21H
				4780138	,--	SG25H
				6032952	,--	SG27H
				7165270	,--	sg29h
				840999	,--	SG2H
				7643291	,--	SG31H
				10719518,--	SG33H
				13964983,--	SG36H
				14500765,--	SG37H
				17065592,--	SG41H
				1923414	,--	SG4H
				1927603	,--	SG6H
				2140377	,--	SG7H
				2260222	,--	SG8H
				2800652	,--	SG9H
				11930116,--	SHG
				463265	,--	SHK
				1156957	,--	SKHH
				506057	,--	SKPRMB
				12677536,--	SLE
				2178402	,--	SLH
				3872549	,--	SLJ
				7768121	,--	SLL
				7756983	,--	SLO
				14783808,--	SLV
				2278343	,--	SMBH
				13294314,--	SMCH
				984745	,--	SMH
				984746	,--	SMMH
				5395806	,--	SMOA
				6129341	,--	SMOB
				7146892	,--	SMOC
				10419083,--	SMOF
				15588279,--	SMOI
				14611891,--	SMOKH
				1568705	,--	SMOL
				1584511	,--	SMON
				1639382	,--	SMOP
				1833046	,--	SMOQ
				2864842	,--	SMOR
				10945672,--	SMORA
				2574511	,--	SMOT
				10228419,--	SMOU
				14804092,--	SMOV
				994735	,--	SPK
				14210898,--	SQHH
				14487413,--	SR
				16723695,--	SRHD
				12368437,--	SRHH
				2341316	,--	SRHKA
				6164108	,--	SRJ
				11213414,--	SRKH
				16155418,--	SRS
				11734366,--	SSF
				1013342	,--	SSF2H
				4362130	,--	SSF5H
				837904	,--	SSFH
				14776453,--	SSG
				2967035	,--	SSK
				2491953	,--	SSTMH
				5232827	,--	STPL
				997237	,--	SWAH
				1501259	,--	SWB
				1590290	,--	SWC
				1698383	,--	SWD
				1788386	,--	SWE
				2033407	,--	SWF
				2101733	,--	SWG
				965631	,--	SWH
				1244484	,--	SWHH
				2122304	,--	SWI
				2400801	,--	SWJ
				4011723	,--	SWN
				4290320	,--	SWP
				7204275	,--	SWQ
				8444096	,--	SWR
				1348932	,--	SWSH
				2522889	,--	SWW
				8864778	,--	SWX
				8212440	,--	SX1
				8226456	,--	SX2
				7752444	,--	SX3
				14822871,--	SX5
				15615804,--	SX6
				16406680,--	SX8
				14653772,--	SYCN
				11400410,--	SYLG
				4155328	,--	SYLH
				356948	,--	SYLHK
				5049084	,--	SYLHZ
				4501066	,--	SYSHK
				1427766	,--	SZ
				8314515	,--	SZZ
				10528317,--	TH
				2181729	,--	TH25
				2959987	,--	TH26
				4253518	,--	TH28
				4286209	,--	TH29
				998349	,--	TH7
				6647416	,--	TH89
				11395466,--	TLH
				7912978	,--	TLM
				8119664	,--	TLN
				10398791,--	VKH
				17004016,--	VVY
				3498147	,--	WD2
				4262711	,--	WDD
				1457236	,--	WKH
				1419459	,--	WN
				1465925	,--	WT
				10346439,--	XKH
				7757683	,--	YH
				13053739,--	YUH
				14629438--	ZS
				)
AND Roleid=4

WHILE (1 = 1)
BEGIN
	UPDATE TOP (1) #Supers
	SET isfinished = 1
		,@newcurrency = newcurrency
		,@CustID = custid	
	WHERE isfinished = 0
	
	IF @@ROWCOUNT = 0 BREAK
			
	EXEC dbo.Acc_ExecRep_Cust_09  @CustID = @CustID, @newcurrency = @newcurrency, @maxtransid=@maxtransid, @target = 'DBTRANS'  			
	
	WAITFOR DELAY '00:00:00.280'
END

DROP TABLE #Supers
GO


---- End of step 3