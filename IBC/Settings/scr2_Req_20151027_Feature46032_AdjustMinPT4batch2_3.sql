 /*
	Created: Johnson
	Date: 2015-10-27
	Task: Adjust min pt for customers list requested 2nd & 3rd batch
	DB: DBCUST/CUSTDB
 */
 
--- RUN FOR 2nd batch customers
---
-- BEGIN STEP 1: RUN THIS SCRIPT AT ALL REPLICATED SERVERS (06/DBTP) -----
--------------------------------------------------------------------------------------
 CREATE TABLE ##tmpCust (custid int, isfinished bit default(0))

DECLARE 
	@minpositiontaking_1 smallmoney = 0.5,
    @minpositiontaking_2 smallmoney= 0.5,
    @minpositiontaking_3 smallmoney= 0.5,
    @minpositiontaking_4 smallmoney= 0.5,
    @minpositiontaking_5 smallmoney= 0.5,
    @minpositiontaking_6 smallmoney= 0.5,
    @minpositiontaking_7 smallmoney= 0.5,
    @minpositiontaking_8 smallmoney= 0.5,
    @minpositiontaking_9 smallmoney= 0.5,
    @minpositiontaking_10 smallmoney= 0.5,
    @minpositiontaking_9999 smallmoney = 0.5,
    @minlivepositiontaking_1 smallmoney= 0.5,
    @minlivepositiontaking_3 smallmoney= 0.5,
    @minlivepositiontaking_7 smallmoney= 0.5,
    @minlivepositiontaking_8 smallmoney= 0.5,
    
    @minv2positiontaking_1 smallmoney= 0.5,
    @minv2positiontaking_2 smallmoney= 0.5,
    @minv2positiontaking_3 smallmoney= 0.5,
    @minv2positiontaking_7 smallmoney= 0.5,
    @minv2positiontaking_8 smallmoney= 0.5,    
    @minv2positiontaking_20 smallmoney= 0.5,

    @minv3positiontaking_1 smallmoney= 0.5,
    @minv3positiontaking_2 smallmoney= 0.5,
    @minv3positiontaking_3 smallmoney= 0.5,
    @minv3positiontaking_20 smallmoney= 0.5,

    @minv5positiontaking_1 smallmoney= 0.5,
    @minv5positiontaking_2 smallmoney= 0.5,
    @minv5positiontaking_3 smallmoney= 0.5,
    @minv5positiontaking_20 smallmoney= 0.5,
    @minv5positiontaking_9999 smallmoney = 0.5,

    @minv8positiontaking_1 smallmoney= 0.5,
    @minv8positiontaking_3 smallmoney= 0.5,
    @minv8positiontaking_20 smallmoney= 0.5,

    @minv10positiontaking_1 smallmoney= 0.5,
    @minv10positiontaking_2 smallmoney= 0.5,
    @minv10positiontaking_3 smallmoney= 0.5,
    @minv10positiontaking_20 smallmoney= 0.5,

    @minv11positiontaking_1 smallmoney= 0.5,
    @minv11positiontaking_20 smallmoney= 0.5,

    @minv99positiontaking_1 smallmoney= 0.5,
    @minv99positiontaking_2 smallmoney= 0.5,
    @minv99positiontaking_3 smallmoney= 0.5,
    @minv99positiontaking_9 smallmoney= 0.5,
    @minv99positiontaking_20 smallmoney= 0.5,
    
    @minv154positiontaking_20 smallmoney = 0.5
    
DECLARE @custid INT, @max_custid INT

SELECT @max_custid = xx

--277 customers
INSERT INTO ##tmpCust(custid)
		select 	16754954	--	3	21A
union all select 	3633125	--	2	21M
union all select 	46846	--	2	2588RM
union all select 	1052570	--	2	2588SD
union all select 	2904839	--	4	330GBP
union all select 	10063686	--	2	A31BP
union all select 	16204333	--	4	AGD
union all select 	2460833	--	2	ASA
union all select 	16311955	--	3	ASB
union all select 	5712158	--	4	AX
union all select 	12550356	--	4	AXA
union all select 	7292508	--	4	AXH
union all select 	12644625	--	4	AXHK
union all select 	11488917	--	4	AXRMB
union all select 	9932698	--	4	AXT
union all select 	14760978	--	4	BHJ
union all select 	14761185	--	4	CFT
union all select 	210710	--	2	CJEU
union all select 	11579803	--	4	GC
union all select 	966501	--	4	GEH
union all select 	1601946	--	4	GFH
union all select 	14727729	--	4	GL
union all select 	3824490	--	4	GN
union all select 	7881154	--	4	GX
union all select 	1069683	--	4	HAH
union all select 	10794871	--	4	HHK2
union all select 	11489398	--	4	HHK3
union all select 	7958991	--	4	HHN
union all select 	17905676	--	4	HIF
union all select 	889147	--	4	HIH
union all select 	1816739	--	4	HIK
union all select 	400973	--	4	HIS
union all select 	10392284	--	4	HIT
union all select 	2511910	--	4	HIW
union all select 	1797678	--	4	JM
union all select 	5261	--	2	JMRM
union all select 	8657557	--	4	JR
union all select 	2199854	--	4	JS2
union all select 	8218187	--	3	JTRIEU
union all select 	7141855	--	3	JTRIHK
union all select 	8218288	--	3	JTRIUSD
union all select 	18882011	--	4	JYT
union all select 	8236892	--	4	L25RM
union all select 	16597413	--	3	M101M
union all select 	14943	--	3	M12RM
union all select 	199104	--	3	M25ARMB
union all select 	259303	--	3	M25BRMB
union all select 	8093520	--	4	M25HK
union all select 	65338	--	3	M25RM
union all select 	268037	--	3	M26RM
union all select 	417557	--	3	M26SD
union all select 	973550	--	3	M28H
union all select 	97430	--	3	M28RMB
union all select 	12023210	--	3	M3CRM
union all select 	711935	--	3	M47R
union all select 	800275	--	3	M57AHK
union all select 	1075622	--	3	M63IHK
union all select 	1044110	--	3	M63IRMB
union all select 	3869873	--	3	M69H
union all select 	230731	--	3	M71ARMB
union all select 	250150	--	3	M71BRMB
union all select 	328390	--	3	M71CRMB
union all select 	561337	--	3	M71DRMB
union all select 	610550	--	3	M797M
union all select 	668389	--	3	M797RM
union all select 	39577	--	3	M7ARM
union all select 	10708	--	3	M7RM
union all select 	8436230	--	3	M88M
union all select 	175114	--	3	M88SD
union all select 	1822905	--	3	MA
union all select 	5875579	--	3	MPKS
union all select 	1609929	--	3	MR
union all select 	123990	--	3	MRTB
union all select 	3988315	--	4	PKA
union all select 	3988331	--	4	PKB
union all select 	4553978	--	4	PKC
union all select 	4638100	--	4	PKD
union all select 	4957465	--	4	PKE
union all select 	5205926	--	4	PKF
union all select 	6520522	--	4	PKG
union all select 	7694826	--	4	PKH
union all select 	4546391	--	4	PKID
union all select 	8363406	--	4	PKJ
union all select 	3934718	--	4	PKK
union all select 	8591808	--	4	PKL
union all select 	9368991	--	4	PKM
union all select 	11548361	--	4	PKO
union all select 	12033438	--	4	PKP
union all select 	15469734	--	4	PKQ
union all select 	4037362	--	4	PKRM
union all select 	16403843	--	4	PKS
union all select 	15852092	--	4	PKT
union all select 	9934460	--	4	POB
union all select 	15778049	--	4	POG
union all select 	17436696	--	4	POJ
union all select 	8488565	--	4	POK
union all select 	5340162	--	4	POR
union all select 	5340166	--	4	POT
union all select 	12300617	--	4	POW
union all select 	8621974	--	4	POY
union all select 	18023072	--	4	PYA
union all select 	16154752	--	4	PYG
union all select 	9525991	--	4	PYH
union all select 	14827246	--	4	PYM
union all select 	17724317	--	4	PYR
union all select 	13338762	--	4	PYT
union all select 	8095139	--	4	Pyy
union all select 	533951	--	4	S12HK
union all select 	1549924	--	4	S12M
union all select 	14176207	--	4	S12MM
union all select 	1071794	--	4	S25R
union all select 	8148919	--	4	S25RM
union all select 	1011974	--	4	S26H
union all select 	1020356	--	4	S2H
union all select 	1211024	--	4	S2M
union all select 	12341915	--	4	S2MM
union all select 	14385514	--	4	S2MN
union all select 	882346	--	4	S2R
union all select 	550141	--	4	S31ARM
union all select 	409524	--	4	S31SD
union all select 	987804	--	4	S35H
union all select 	2258222	--	4	S35M
union all select 	405391	--	4	S36RM
union all select 	324559	--	4	S36RMB
union all select 	941038	--	4	S3AAH
union all select 	576984	--	4	S3AAR
union all select 	941026	--	4	S3AH
union all select 	572607	--	4	S3AR
union all select 	443008	--	4	S3ARM
union all select 	9732491	--	4	S3BH
union all select 	7657763	--	4	S3EH
union all select 	1506023	--	4	S45AH
union all select 	18327825	--	4	S45BM
union all select 	1362437	--	4	S45H
union all select 	1492016	--	4	s45m
union all select 	8553985	--	4	S47DR
union all select 	3047517	--	4	S47IR
union all select 	17721092	--	4	S47M
union all select 	838051	--	4	S47R
union all select 	480725	--	4	S47RM
union all select 	406935	--	4	S47SD
union all select 	12591491	--	4	S53HHK
union all select 	17902498	--	4	S53M
union all select 	12142609	--	4	S53S
union all select 	800262	--	4	S57AR
union all select 	1397026	--	4	S5I
union all select 	365484	--	4	S5M
union all select 	365486	--	4	S5R
union all select 	365483	--	4	S5S
union all select 	3127387	--	4	S63H
union all select 	15252449	--	4	S69BP
union all select 	9342128	--	4	S69E
union all select 	4439144	--	4	S69H
union all select 	15473140	--	4	S69HD
union all select 	836949	--	4	S69R
union all select 	6153706	--	4	S69RD
union all select 	478394	--	4	S69RM
union all select 	15530542	--	4	S69RP
union all select 	404986	--	4	S69SD
union all select 	9918280	--	4	S69TB
union all select 	8100556	--	4	S70M
union all select 	726483	--	4	S70RMB
union all select 	1153081	--	4	S71AH
union all select 	2924293	--	4	S71BH
union all select 	12573367	--	4	S71DH
union all select 	993226	--	4	S71H
union all select 	2797447	--	4	S71M
union all select 	2957601	--	4	S71MA
union all select 	421328	--	4	S71RM
union all select 	3854395	--	4	S797S
union all select 	604044	--	4	S7RM
union all select 	2162072	--	4	S81R
union all select 	5402183	--	4	S81RA
union all select 	7247970	--	4	S81RB
union all select 	2042873	--	4	S822M
union all select 	7776236	--	4	S88D
union all select 	1572664	--	4	S88H
union all select 	665985	--	4	S88R
union all select 	1127269	--	4	S91R
union all select 	430524	--	4	S91RM
union all select 	1029269	--	4	S95AH
union all select 	1059173	--	4	S95BH
union all select 	2300662	--	4	S95DH
union all select 	967131	--	4	S95H
union all select 	1317514	--	4	S95M
union all select 	2291699	--	4	S95RM
union all select 	356946	--	4	S95RMB
union all select 	10321289	--	4	SAE
union all select 	13752690	--	4	SAI
union all select 	944306	--	4	SAKH
union all select 	994666	--	4	SAKM
union all select 	2383816	--	4	SAS
union all select 	11584923	--	4	SAZM
union all select 	17721601	--	4	SBMW
union all select 	837894	--	4	SBQ2J
union all select 	2214708	--	4	SBRR
union all select 	3230597	--	4	SBTH
union all select 	3254803	--	4	SBTK
union all select 	8282635	--	4	SBTL
union all select 	3131329	--	4	SBTM
union all select 	3515870	--	4	SBTN
union all select 	11979905	--	4	SBTR
union all select 	13973587	--	4	SBTY
union all select 	7711724	--	4	SBZ
union all select 	14644207	--	4	SBZB
union all select 	1721616	--	4	SBZR
union all select 	3046451	--	4	SCLH
union all select 	3090145	--	4	SCLM
union all select 	4283123	--	4	SEA
union all select 	7410076	--	4	SEB
union all select 	13802900	--	4	SEC
union all select 	3539281	--	4	SED
union all select 	3299391	--	4	SEH
union all select 	3237129	--	4	SEI
union all select 	4371323	--	4	SEK
union all select 	5900375	--	4	SEMA
union all select 	774701	--	4	SER
union all select 	13330822	--	4	SGKB
union all select 	4508624	--	4	SGMM
union all select 	2116268	--	4	SGSM
union all select 	642386	--	4	SGTB
union all select 	7516688	--	4	SHHK9
union all select 	4130248	--	4	SHR3
union all select 	4281327	--	4	SHR5
union all select 	838053	--	4	SHRMB
union all select 	430735	--	4	SHSD
union all select 	2829199	--	4	SJS
union all select 	1156957	--	4	SKHH
union all select 	14301612	--	4	SKKM
union all select 	3345772	--	4	SKMM
union all select 	356947	--	4	SKWRMB
union all select 	2222683	--	4	SLLM
union all select 	1374344	--	4	SMQARMB
union all select 	1517662	--	4	SMT
union all select 	2504697	--	4	SOGA
union all select 	753624	--	4	SOGO
union all select 	12478088	--	4	SPA2M
union all select 	13615649	--	4	SPA3M
union all select 	985934	--	4	SRH
union all select 	2341316	--	4	SRHKA
union all select 	1247148	--	4	SRMA
union all select 	12486216	--	4	SRMB
union all select 	711945	--	4	SRR
union all select 	324563	--	4	SRRMB
union all select 	17044959	--	4	SSMA
union all select 	2491953	--	4	SSTMH
union all select 	3009929	--	4	SSTMM
union all select 	18974796	--	4	SSYH
union all select 	3938541	--	4	SSYR
union all select 	1228922	--	4	STPH
union all select 	4204345	--	4	STPK
union all select 	755409	--	4	STPM
union all select 	1211231	--	4	SWK
union all select 	1211237	--	4	SWM
union all select 	14870436	--	4	SWO
union all select 	1201561	--	4	SWU
union all select 	1427766	--	4	SZ
union all select 	4792310	--	4	TED
union all select 	12696856	--	4	TEG
union all select 	2000098	--	4	TEH
union all select 	2504299	--	4	TEK
union all select 	2061201	--	4	THR
union all select 	8216498	--	4	THS
union all select 	17797101	--	4	THT
union all select 	4295	--	2	TKRM
union all select 	15098462	--	4	TTA
union all select 	19427239	--	4	VBH
union all select 	19447731	--	4	VBR
union all select 	3611231	--	4	W79
union all select 	2925993	--	4	WKR
union all select 	1376434	--	4	wm
union all select 	4045713	--	4	WMA
union all select 	8864806	--	4	WMB
union all select 	1131889	--	4	WWR
union all select 	13053739	--	4	YUH
union all select 	11472964	--	4	YUM
union all select 	10793	--	2	ywrm

WHILE (1 = 1)
BEGIN
	UPDATE TOP (1) ##tmpCust
	SET isfinished = 1
		,@custid = custid				
	WHERE isfinished = 0
	
	IF @@ROWCOUNT = 0 BREAK

	EXEC dbo.[Acc_CustSetting3rd_19] @custid = @custid					
			,@target = 'REPLICATED'
			,@minpositiontaking_1 = @minpositiontaking_1
			,@minpositiontaking_2 = @minpositiontaking_2 
			,@minpositiontaking_3 = @minpositiontaking_3
			,@minpositiontaking_4 = @minpositiontaking_4
			,@minpositiontaking_5 = @minpositiontaking_5
			,@minpositiontaking_6 =@minpositiontaking_6
			,@minpositiontaking_7 = @minpositiontaking_7
			,@minpositiontaking_8 = @minpositiontaking_8
			,@minpositiontaking_9 = @minpositiontaking_9
			,@minpositiontaking_10 = @minpositiontaking_10
			,@minpositiontaking_9999 = @minpositiontaking_9999
			,@minlivepositiontaking_1= @minlivepositiontaking_1
			,@minlivepositiontaking_3 = @minlivepositiontaking_3
			,@minlivepositiontaking_7 = @minlivepositiontaking_7
			,@minlivepositiontaking_8 = @minlivepositiontaking_8
		    
			,@minv2positiontaking_1 = @minv2positiontaking_1
			,@minv2positiontaking_2 = @minv2positiontaking_2
			,@minv2positiontaking_3 = @minv2positiontaking_3
			,@minv2positiontaking_7 = @minv2positiontaking_7
			,@minv2positiontaking_8 = @minv2positiontaking_8
			,@minv2positiontaking_20 = @minv2positiontaking_20

			,@minv3positiontaking_1 = @minv3positiontaking_1
			,@minv3positiontaking_2 = @minv3positiontaking_2
			,@minv3positiontaking_3 = @minv3positiontaking_3
			,@minv3positiontaking_20 = @minv3positiontaking_20

			,@minv5positiontaking_1 = @minv5positiontaking_1
			,@minv5positiontaking_2 = @minv5positiontaking_2
			,@minv5positiontaking_3 = @minv5positiontaking_3
			,@minv5positiontaking_20= @minv5positiontaking_20
			,@minv5positiontaking_9999 = @minv5positiontaking_9999
			
			,@minv8positiontaking_1 = @minv8positiontaking_1
			,@minv8positiontaking_3 = @minv8positiontaking_3
			,@minv8positiontaking_20 = @minv8positiontaking_20

			,@minv10positiontaking_1 = @minv10positiontaking_1 
			,@minv10positiontaking_2 =@minv10positiontaking_2
			,@minv10positiontaking_3 = @minv10positiontaking_3 
			,@minv10positiontaking_20 = @minv10positiontaking_20 

			,@minv11positiontaking_1 = @minv11positiontaking_1 
			,@minv11positiontaking_20 =@minv11positiontaking_20 

			,@minv99positiontaking_1 =@minv99positiontaking_1 
			,@minv99positiontaking_2 =@minv99positiontaking_2 
			,@minv99positiontaking_3 =@minv99positiontaking_3 
			,@minv99positiontaking_9 = @minv99positiontaking_9
			,@minv99positiontaking_20 = @minv99positiontaking_20
		    
			,@minv154positiontaking_20 = @minv154positiontaking_20
	
	waitfor delay '00:00:0.280'
END			

 DROP TABLE ##tmpCust
GO		
-- END STEP 1: RUN THIS SCRIPT AT ALL REPLICATED SERVERS (06/DBTP) -----
-----------------------------------------------------------------------------------



---
-- BEGIN STEP 2: RUN THIS SCRIPT AT DBCUST -----
--------------------------------------------------------------------------------------
CREATE TABLE ##tmpCust (custid int, isfinished bit default(0))
DECLARE @custid INT, @max_custid INT

DECLARE 
	@minpositiontaking_1 smallmoney = 0.5,
    @minpositiontaking_2 smallmoney= 0.5,
    @minpositiontaking_3 smallmoney= 0.5,
    @minpositiontaking_4 smallmoney= 0.5,
    @minpositiontaking_5 smallmoney= 0.5,
    @minpositiontaking_6 smallmoney= 0.5,
    @minpositiontaking_7 smallmoney= 0.5,
    @minpositiontaking_8 smallmoney= 0.5,
    @minpositiontaking_9 smallmoney= 0.5,
    @minpositiontaking_10 smallmoney= 0.5,
    @minpositiontaking_9999 smallmoney = 0.5,
    @minlivepositiontaking_1 smallmoney= 0.5,
    @minlivepositiontaking_3 smallmoney= 0.5,
    @minlivepositiontaking_7 smallmoney= 0.5,
    @minlivepositiontaking_8 smallmoney= 0.5,
    
    @minv2positiontaking_1 smallmoney= 0.5,
    @minv2positiontaking_2 smallmoney= 0.5,
    @minv2positiontaking_3 smallmoney= 0.5,
    @minv2positiontaking_7 smallmoney= 0.5,
    @minv2positiontaking_8 smallmoney= 0.5,    
    @minv2positiontaking_20 smallmoney= 0.5,

    @minv3positiontaking_1 smallmoney= 0.5,
    @minv3positiontaking_2 smallmoney= 0.5,
    @minv3positiontaking_3 smallmoney= 0.5,
    @minv3positiontaking_20 smallmoney= 0.5,

    @minv5positiontaking_1 smallmoney= 0.5,
    @minv5positiontaking_2 smallmoney= 0.5,
    @minv5positiontaking_3 smallmoney= 0.5,
    @minv5positiontaking_20 smallmoney= 0.5,
    @minv5positiontaking_9999 smallmoney = 0.5,

    @minv8positiontaking_1 smallmoney= 0.5,
    @minv8positiontaking_3 smallmoney= 0.5,
    @minv8positiontaking_20 smallmoney= 0.5,

    @minv10positiontaking_1 smallmoney= 0.5,
    @minv10positiontaking_2 smallmoney= 0.5,
    @minv10positiontaking_3 smallmoney= 0.5,
    @minv10positiontaking_20 smallmoney= 0.5,

    @minv11positiontaking_1 smallmoney= 0.5,
    @minv11positiontaking_20 smallmoney= 0.5,

    @minv99positiontaking_1 smallmoney= 0.5,
    @minv99positiontaking_2 smallmoney= 0.5,
    @minv99positiontaking_3 smallmoney= 0.5,
    @minv99positiontaking_9 smallmoney= 0.5,
    @minv99positiontaking_20 smallmoney= 0.5,
    
    @minv154positiontaking_20 smallmoney = 0.5
    
SELECT @max_custid = xx

INSERT INTO ##tmpCust(custid)
		select 	16754954	--	3	21A
union all select 	3633125	--	2	21M
union all select 	46846	--	2	2588RM
union all select 	1052570	--	2	2588SD
union all select 	2904839	--	4	330GBP
union all select 	10063686	--	2	A31BP
union all select 	16204333	--	4	AGD
union all select 	2460833	--	2	ASA
union all select 	16311955	--	3	ASB
union all select 	5712158	--	4	AX
union all select 	12550356	--	4	AXA
union all select 	7292508	--	4	AXH
union all select 	12644625	--	4	AXHK
union all select 	11488917	--	4	AXRMB
union all select 	9932698	--	4	AXT
union all select 	14760978	--	4	BHJ
union all select 	14761185	--	4	CFT
union all select 	210710	--	2	CJEU
union all select 	11579803	--	4	GC
union all select 	966501	--	4	GEH
union all select 	1601946	--	4	GFH
union all select 	14727729	--	4	GL
union all select 	3824490	--	4	GN
union all select 	7881154	--	4	GX
union all select 	1069683	--	4	HAH
union all select 	10794871	--	4	HHK2
union all select 	11489398	--	4	HHK3
union all select 	7958991	--	4	HHN
union all select 	17905676	--	4	HIF
union all select 	889147	--	4	HIH
union all select 	1816739	--	4	HIK
union all select 	400973	--	4	HIS
union all select 	10392284	--	4	HIT
union all select 	2511910	--	4	HIW
union all select 	1797678	--	4	JM
union all select 	5261	--	2	JMRM
union all select 	8657557	--	4	JR
union all select 	2199854	--	4	JS2
union all select 	8218187	--	3	JTRIEU
union all select 	7141855	--	3	JTRIHK
union all select 	8218288	--	3	JTRIUSD
union all select 	18882011	--	4	JYT
union all select 	8236892	--	4	L25RM
union all select 	16597413	--	3	M101M
union all select 	14943	--	3	M12RM
union all select 	199104	--	3	M25ARMB
union all select 	259303	--	3	M25BRMB
union all select 	8093520	--	4	M25HK
union all select 	65338	--	3	M25RM
union all select 	268037	--	3	M26RM
union all select 	417557	--	3	M26SD
union all select 	973550	--	3	M28H
union all select 	97430	--	3	M28RMB
union all select 	12023210	--	3	M3CRM
union all select 	711935	--	3	M47R
union all select 	800275	--	3	M57AHK
union all select 	1075622	--	3	M63IHK
union all select 	1044110	--	3	M63IRMB
union all select 	3869873	--	3	M69H
union all select 	230731	--	3	M71ARMB
union all select 	250150	--	3	M71BRMB
union all select 	328390	--	3	M71CRMB
union all select 	561337	--	3	M71DRMB
union all select 	610550	--	3	M797M
union all select 	668389	--	3	M797RM
union all select 	39577	--	3	M7ARM
union all select 	10708	--	3	M7RM
union all select 	8436230	--	3	M88M
union all select 	175114	--	3	M88SD
union all select 	1822905	--	3	MA
union all select 	5875579	--	3	MPKS
union all select 	1609929	--	3	MR
union all select 	123990	--	3	MRTB
union all select 	3988315	--	4	PKA
union all select 	3988331	--	4	PKB
union all select 	4553978	--	4	PKC
union all select 	4638100	--	4	PKD
union all select 	4957465	--	4	PKE
union all select 	5205926	--	4	PKF
union all select 	6520522	--	4	PKG
union all select 	7694826	--	4	PKH
union all select 	4546391	--	4	PKID
union all select 	8363406	--	4	PKJ
union all select 	3934718	--	4	PKK
union all select 	8591808	--	4	PKL
union all select 	9368991	--	4	PKM
union all select 	11548361	--	4	PKO
union all select 	12033438	--	4	PKP
union all select 	15469734	--	4	PKQ
union all select 	4037362	--	4	PKRM
union all select 	16403843	--	4	PKS
union all select 	15852092	--	4	PKT
union all select 	9934460	--	4	POB
union all select 	15778049	--	4	POG
union all select 	17436696	--	4	POJ
union all select 	8488565	--	4	POK
union all select 	5340162	--	4	POR
union all select 	5340166	--	4	POT
union all select 	12300617	--	4	POW
union all select 	8621974	--	4	POY
union all select 	18023072	--	4	PYA
union all select 	16154752	--	4	PYG
union all select 	9525991	--	4	PYH
union all select 	14827246	--	4	PYM
union all select 	17724317	--	4	PYR
union all select 	13338762	--	4	PYT
union all select 	8095139	--	4	Pyy
union all select 	533951	--	4	S12HK
union all select 	1549924	--	4	S12M
union all select 	14176207	--	4	S12MM
union all select 	1071794	--	4	S25R
union all select 	8148919	--	4	S25RM
union all select 	1011974	--	4	S26H
union all select 	1020356	--	4	S2H
union all select 	1211024	--	4	S2M
union all select 	12341915	--	4	S2MM
union all select 	14385514	--	4	S2MN
union all select 	882346	--	4	S2R
union all select 	550141	--	4	S31ARM
union all select 	409524	--	4	S31SD
union all select 	987804	--	4	S35H
union all select 	2258222	--	4	S35M
union all select 	405391	--	4	S36RM
union all select 	324559	--	4	S36RMB
union all select 	941038	--	4	S3AAH
union all select 	576984	--	4	S3AAR
union all select 	941026	--	4	S3AH
union all select 	572607	--	4	S3AR
union all select 	443008	--	4	S3ARM
union all select 	9732491	--	4	S3BH
union all select 	7657763	--	4	S3EH
union all select 	1506023	--	4	S45AH
union all select 	18327825	--	4	S45BM
union all select 	1362437	--	4	S45H
union all select 	1492016	--	4	s45m
union all select 	8553985	--	4	S47DR
union all select 	3047517	--	4	S47IR
union all select 	17721092	--	4	S47M
union all select 	838051	--	4	S47R
union all select 	480725	--	4	S47RM
union all select 	406935	--	4	S47SD
union all select 	12591491	--	4	S53HHK
union all select 	17902498	--	4	S53M
union all select 	12142609	--	4	S53S
union all select 	800262	--	4	S57AR
union all select 	1397026	--	4	S5I
union all select 	365484	--	4	S5M
union all select 	365486	--	4	S5R
union all select 	365483	--	4	S5S
union all select 	3127387	--	4	S63H
union all select 	15252449	--	4	S69BP
union all select 	9342128	--	4	S69E
union all select 	4439144	--	4	S69H
union all select 	15473140	--	4	S69HD
union all select 	836949	--	4	S69R
union all select 	6153706	--	4	S69RD
union all select 	478394	--	4	S69RM
union all select 	15530542	--	4	S69RP
union all select 	404986	--	4	S69SD
union all select 	9918280	--	4	S69TB
union all select 	8100556	--	4	S70M
union all select 	726483	--	4	S70RMB
union all select 	1153081	--	4	S71AH
union all select 	2924293	--	4	S71BH
union all select 	12573367	--	4	S71DH
union all select 	993226	--	4	S71H
union all select 	2797447	--	4	S71M
union all select 	2957601	--	4	S71MA
union all select 	421328	--	4	S71RM
union all select 	3854395	--	4	S797S
union all select 	604044	--	4	S7RM
union all select 	2162072	--	4	S81R
union all select 	5402183	--	4	S81RA
union all select 	7247970	--	4	S81RB
union all select 	2042873	--	4	S822M
union all select 	7776236	--	4	S88D
union all select 	1572664	--	4	S88H
union all select 	665985	--	4	S88R
union all select 	1127269	--	4	S91R
union all select 	430524	--	4	S91RM
union all select 	1029269	--	4	S95AH
union all select 	1059173	--	4	S95BH
union all select 	2300662	--	4	S95DH
union all select 	967131	--	4	S95H
union all select 	1317514	--	4	S95M
union all select 	2291699	--	4	S95RM
union all select 	356946	--	4	S95RMB
union all select 	10321289	--	4	SAE
union all select 	13752690	--	4	SAI
union all select 	944306	--	4	SAKH
union all select 	994666	--	4	SAKM
union all select 	2383816	--	4	SAS
union all select 	11584923	--	4	SAZM
union all select 	17721601	--	4	SBMW
union all select 	837894	--	4	SBQ2J
union all select 	2214708	--	4	SBRR
union all select 	3230597	--	4	SBTH
union all select 	3254803	--	4	SBTK
union all select 	8282635	--	4	SBTL
union all select 	3131329	--	4	SBTM
union all select 	3515870	--	4	SBTN
union all select 	11979905	--	4	SBTR
union all select 	13973587	--	4	SBTY
union all select 	7711724	--	4	SBZ
union all select 	14644207	--	4	SBZB
union all select 	1721616	--	4	SBZR
union all select 	3046451	--	4	SCLH
union all select 	3090145	--	4	SCLM
union all select 	4283123	--	4	SEA
union all select 	7410076	--	4	SEB
union all select 	13802900	--	4	SEC
union all select 	3539281	--	4	SED
union all select 	3299391	--	4	SEH
union all select 	3237129	--	4	SEI
union all select 	4371323	--	4	SEK
union all select 	5900375	--	4	SEMA
union all select 	774701	--	4	SER
union all select 	13330822	--	4	SGKB
union all select 	4508624	--	4	SGMM
union all select 	2116268	--	4	SGSM
union all select 	642386	--	4	SGTB
union all select 	7516688	--	4	SHHK9
union all select 	4130248	--	4	SHR3
union all select 	4281327	--	4	SHR5
union all select 	838053	--	4	SHRMB
union all select 	430735	--	4	SHSD
union all select 	2829199	--	4	SJS
union all select 	1156957	--	4	SKHH
union all select 	14301612	--	4	SKKM
union all select 	3345772	--	4	SKMM
union all select 	356947	--	4	SKWRMB
union all select 	2222683	--	4	SLLM
union all select 	1374344	--	4	SMQARMB
union all select 	1517662	--	4	SMT
union all select 	2504697	--	4	SOGA
union all select 	753624	--	4	SOGO
union all select 	12478088	--	4	SPA2M
union all select 	13615649	--	4	SPA3M
union all select 	985934	--	4	SRH
union all select 	2341316	--	4	SRHKA
union all select 	1247148	--	4	SRMA
union all select 	12486216	--	4	SRMB
union all select 	711945	--	4	SRR
union all select 	324563	--	4	SRRMB
union all select 	17044959	--	4	SSMA
union all select 	2491953	--	4	SSTMH
union all select 	3009929	--	4	SSTMM
union all select 	18974796	--	4	SSYH
union all select 	3938541	--	4	SSYR
union all select 	1228922	--	4	STPH
union all select 	4204345	--	4	STPK
union all select 	755409	--	4	STPM
union all select 	1211231	--	4	SWK
union all select 	1211237	--	4	SWM
union all select 	14870436	--	4	SWO
union all select 	1201561	--	4	SWU
union all select 	1427766	--	4	SZ
union all select 	4792310	--	4	TED
union all select 	12696856	--	4	TEG
union all select 	2000098	--	4	TEH
union all select 	2504299	--	4	TEK
union all select 	2061201	--	4	THR
union all select 	8216498	--	4	THS
union all select 	17797101	--	4	THT
union all select 	4295	--	2	TKRM
union all select 	15098462	--	4	TTA
union all select 	19427239	--	4	VBH
union all select 	19447731	--	4	VBR
union all select 	3611231	--	4	W79
union all select 	2925993	--	4	WKR
union all select 	1376434	--	4	wm
union all select 	4045713	--	4	WMA
union all select 	8864806	--	4	WMB
union all select 	1131889	--	4	WWR
union all select 	13053739	--	4	YUH
union all select 	11472964	--	4	YUM
union all select 	10793	--	2	ywrm
		

WHILE (1 = 1)
BEGIN
	UPDATE TOP (1) ##tmpCust
	SET isfinished = 1
		,@custid = custid			
	WHERE isfinished = 0
	
	IF @@ROWCOUNT = 0 BREAK

	EXEC dbo.[Acc_CustSetting3rd_19] @custid = @custid			
			,@target = 'DBCUST'
			,@minpositiontaking_1 = @minpositiontaking_1
			,@minpositiontaking_2 = @minpositiontaking_2 
			,@minpositiontaking_3 = @minpositiontaking_3
			,@minpositiontaking_4 = @minpositiontaking_4
			,@minpositiontaking_5 = @minpositiontaking_5
			,@minpositiontaking_6 =@minpositiontaking_6
			,@minpositiontaking_7 = @minpositiontaking_7
			,@minpositiontaking_8 = @minpositiontaking_8
			,@minpositiontaking_9 = @minpositiontaking_9
			,@minpositiontaking_10 = @minpositiontaking_10
			,@minpositiontaking_9999 = @minpositiontaking_9999
			,@minlivepositiontaking_1= @minlivepositiontaking_1
			,@minlivepositiontaking_3 = @minlivepositiontaking_3
			,@minlivepositiontaking_7 = @minlivepositiontaking_7
			,@minlivepositiontaking_8 = @minlivepositiontaking_8
		    
			,@minv2positiontaking_1 = @minv2positiontaking_1
			,@minv2positiontaking_2 = @minv2positiontaking_2
			,@minv2positiontaking_3 = @minv2positiontaking_3
			,@minv2positiontaking_7 = @minv2positiontaking_7
			,@minv2positiontaking_8 = @minv2positiontaking_8
			,@minv2positiontaking_20 = @minv2positiontaking_20

			,@minv3positiontaking_1 = @minv3positiontaking_1
			,@minv3positiontaking_2 = @minv3positiontaking_2
			,@minv3positiontaking_3 = @minv3positiontaking_3
			,@minv3positiontaking_20 = @minv3positiontaking_20

			,@minv5positiontaking_1 = @minv5positiontaking_1
			,@minv5positiontaking_2 = @minv5positiontaking_2
			,@minv5positiontaking_3 = @minv5positiontaking_3
			,@minv5positiontaking_20= @minv5positiontaking_20
			,@minv5positiontaking_9999 = @minv5positiontaking_9999
			
			,@minv8positiontaking_1 = @minv8positiontaking_1
			,@minv8positiontaking_3 = @minv8positiontaking_3
			,@minv8positiontaking_20 = @minv8positiontaking_20

			,@minv10positiontaking_1 = @minv10positiontaking_1 
			,@minv10positiontaking_2 =@minv10positiontaking_2
			,@minv10positiontaking_3 = @minv10positiontaking_3 
			,@minv10positiontaking_20 = @minv10positiontaking_20 

			,@minv11positiontaking_1 = @minv11positiontaking_1 
			,@minv11positiontaking_20 =@minv11positiontaking_20 

			,@minv99positiontaking_1 =@minv99positiontaking_1 
			,@minv99positiontaking_2 =@minv99positiontaking_2 
			,@minv99positiontaking_3 =@minv99positiontaking_3 
			,@minv99positiontaking_9 = @minv99positiontaking_9
			,@minv99positiontaking_20 = @minv99positiontaking_20
		    
			,@minv154positiontaking_20 = @minv154positiontaking_20
	
	waitfor delay '00:00:0.280'
END			

DROP TABLE ##tmpCust
GO		
-- END STEP 2: RUN THIS SCRIPT AT DBCUST -----
------------------------------------------------------------------------------
--****************************************************************************
--END 2nd batch
--****************************************************************************
------------------------------------------------------------------------------


---
--- RUN FOR 3rd batch customers
---
-- BEGIN STEP 1: RUN THIS SCRIPT AT ALL REPLICATED SERVERS (06/DBTP) -----
--------------------------------------------------------------------------------------
 CREATE TABLE ##tmpCust (custid int, isfinished bit default(0))

DECLARE 
	@minpositiontaking_1 smallmoney = 0.5,
    @minpositiontaking_2 smallmoney= 0.5,
    @minpositiontaking_3 smallmoney= 0.5,
    @minpositiontaking_4 smallmoney= 0.5,
    @minpositiontaking_5 smallmoney= 0.5,
    @minpositiontaking_6 smallmoney= 0.5,
    @minpositiontaking_7 smallmoney= 0.5,
    @minpositiontaking_8 smallmoney= 0.5,
    @minpositiontaking_9 smallmoney= 0.5,
    @minpositiontaking_10 smallmoney= 0.5,
    @minpositiontaking_9999 smallmoney = 0.5,
    @minlivepositiontaking_1 smallmoney= 0.5,
    @minlivepositiontaking_3 smallmoney= 0.5,
    @minlivepositiontaking_7 smallmoney= 0.5,
    @minlivepositiontaking_8 smallmoney= 0.5,
    
    @minv2positiontaking_1 smallmoney= 0.5,
    @minv2positiontaking_2 smallmoney= 0.5,
    @minv2positiontaking_3 smallmoney= 0.5,
    @minv2positiontaking_7 smallmoney= 0.5,
    @minv2positiontaking_8 smallmoney= 0.5,    
    @minv2positiontaking_20 smallmoney= 0.5,

    @minv3positiontaking_1 smallmoney= 0.5,
    @minv3positiontaking_2 smallmoney= 0.5,
    @minv3positiontaking_3 smallmoney= 0.5,
    @minv3positiontaking_20 smallmoney= 0.5,

    @minv5positiontaking_1 smallmoney= 0.5,
    @minv5positiontaking_2 smallmoney= 0.5,
    @minv5positiontaking_3 smallmoney= 0.5,
    @minv5positiontaking_20 smallmoney= 0.5,
    @minv5positiontaking_9999 smallmoney = 0.5,

    @minv8positiontaking_1 smallmoney= 0.5,
    @minv8positiontaking_3 smallmoney= 0.5,
    @minv8positiontaking_20 smallmoney= 0.5,

    @minv10positiontaking_1 smallmoney= 0.5,
    @minv10positiontaking_2 smallmoney= 0.5,
    @minv10positiontaking_3 smallmoney= 0.5,
    @minv10positiontaking_20 smallmoney= 0.5,

    @minv11positiontaking_1 smallmoney= 0.5,
    @minv11positiontaking_20 smallmoney= 0.5,

    @minv99positiontaking_1 smallmoney= 0.5,
    @minv99positiontaking_2 smallmoney= 0.5,
    @minv99positiontaking_3 smallmoney= 0.5,
    @minv99positiontaking_9 smallmoney= 0.5,
    @minv99positiontaking_20 smallmoney= 0.5,
    
    @minv154positiontaking_20 smallmoney = 0.5
    
DECLARE @custid INT, @max_custid INT

SELECT @max_custid = xx

--19 customers
INSERT INTO ##tmpCust(custid)
		select 	5973408	--	4	CYKM
union all select 	4940784	--	4	DKD
union all select 	3191187	--	3	DKE
union all select 	10231287	--	2	REU
union all select 	1140623	--	4	SBB
union all select 	8017299	--	4	SBC
union all select 	12968884	--	4	SBHF
union all select 	13549891	--	4	SBHG
union all select 	1604404	--	4	SBM
union all select 	1593254	--	4	SBS
union all select 	4622222	--	4	SBSD
union all select 	16576689	--	4	SBV
union all select 	865485	--	4	SKHK
union all select 	1995341	--	4	SKM
union all select 	884262	--	4	SKR
union all select 	11734366	--	4	SSF
union all select 	1993804	--	4	YKH
union all select 	5931469	--	4	YKM
union all select 	1993818	--	4	YKR

WHILE (1 = 1)
BEGIN
	UPDATE TOP (1) ##tmpCust
	SET isfinished = 1
		,@custid = custid				
	WHERE isfinished = 0
	
	IF @@ROWCOUNT = 0 BREAK

	EXEC dbo.[Acc_CustSetting3rd_19] @custid = @custid					
			,@target = 'REPLICATED'
			,@minpositiontaking_1 = @minpositiontaking_1
			,@minpositiontaking_2 = @minpositiontaking_2 
			,@minpositiontaking_3 = @minpositiontaking_3
			,@minpositiontaking_4 = @minpositiontaking_4
			,@minpositiontaking_5 = @minpositiontaking_5
			,@minpositiontaking_6 =@minpositiontaking_6
			,@minpositiontaking_7 = @minpositiontaking_7
			,@minpositiontaking_8 = @minpositiontaking_8
			,@minpositiontaking_9 = @minpositiontaking_9
			,@minpositiontaking_10 = @minpositiontaking_10
			,@minpositiontaking_9999 = @minpositiontaking_9999
			,@minlivepositiontaking_1= @minlivepositiontaking_1
			,@minlivepositiontaking_3 = @minlivepositiontaking_3
			,@minlivepositiontaking_7 = @minlivepositiontaking_7
			,@minlivepositiontaking_8 = @minlivepositiontaking_8
		    
			,@minv2positiontaking_1 = @minv2positiontaking_1
			,@minv2positiontaking_2 = @minv2positiontaking_2
			,@minv2positiontaking_3 = @minv2positiontaking_3
			,@minv2positiontaking_7 = @minv2positiontaking_7
			,@minv2positiontaking_8 = @minv2positiontaking_8
			,@minv2positiontaking_20 = @minv2positiontaking_20

			,@minv3positiontaking_1 = @minv3positiontaking_1
			,@minv3positiontaking_2 = @minv3positiontaking_2
			,@minv3positiontaking_3 = @minv3positiontaking_3
			,@minv3positiontaking_20 = @minv3positiontaking_20

			,@minv5positiontaking_1 = @minv5positiontaking_1
			,@minv5positiontaking_2 = @minv5positiontaking_2
			,@minv5positiontaking_3 = @minv5positiontaking_3
			,@minv5positiontaking_20= @minv5positiontaking_20
			,@minv5positiontaking_9999 = @minv5positiontaking_9999
			
			,@minv8positiontaking_1 = @minv8positiontaking_1
			,@minv8positiontaking_3 = @minv8positiontaking_3
			,@minv8positiontaking_20 = @minv8positiontaking_20

			,@minv10positiontaking_1 = @minv10positiontaking_1 
			,@minv10positiontaking_2 =@minv10positiontaking_2
			,@minv10positiontaking_3 = @minv10positiontaking_3 
			,@minv10positiontaking_20 = @minv10positiontaking_20 

			,@minv11positiontaking_1 = @minv11positiontaking_1 
			,@minv11positiontaking_20 =@minv11positiontaking_20 

			,@minv99positiontaking_1 =@minv99positiontaking_1 
			,@minv99positiontaking_2 =@minv99positiontaking_2 
			,@minv99positiontaking_3 =@minv99positiontaking_3 
			,@minv99positiontaking_9 = @minv99positiontaking_9
			,@minv99positiontaking_20 = @minv99positiontaking_20
		    
			,@minv154positiontaking_20 = @minv154positiontaking_20
	
	waitfor delay '00:00:0.280'
END			

 DROP TABLE ##tmpCust
GO		
-- END STEP 1: RUN THIS SCRIPT AT ALL REPLICATED SERVERS (06/DBTP) -----
-----------------------------------------------------------------------------------



---
-- BEGIN STEP 2: RUN THIS SCRIPT AT DBCUST -----
--------------------------------------------------------------------------------------
CREATE TABLE ##tmpCust (custid int, isfinished bit default(0))
DECLARE @custid INT, @max_custid INT

DECLARE 
	@minpositiontaking_1 smallmoney = 0.5,
    @minpositiontaking_2 smallmoney= 0.5,
    @minpositiontaking_3 smallmoney= 0.5,
    @minpositiontaking_4 smallmoney= 0.5,
    @minpositiontaking_5 smallmoney= 0.5,
    @minpositiontaking_6 smallmoney= 0.5,
    @minpositiontaking_7 smallmoney= 0.5,
    @minpositiontaking_8 smallmoney= 0.5,
    @minpositiontaking_9 smallmoney= 0.5,
    @minpositiontaking_10 smallmoney= 0.5,
    @minpositiontaking_9999 smallmoney = 0.5,
    @minlivepositiontaking_1 smallmoney= 0.5,
    @minlivepositiontaking_3 smallmoney= 0.5,
    @minlivepositiontaking_7 smallmoney= 0.5,
    @minlivepositiontaking_8 smallmoney= 0.5,
    
    @minv2positiontaking_1 smallmoney= 0.5,
    @minv2positiontaking_2 smallmoney= 0.5,
    @minv2positiontaking_3 smallmoney= 0.5,
    @minv2positiontaking_7 smallmoney= 0.5,
    @minv2positiontaking_8 smallmoney= 0.5,    
    @minv2positiontaking_20 smallmoney= 0.5,

    @minv3positiontaking_1 smallmoney= 0.5,
    @minv3positiontaking_2 smallmoney= 0.5,
    @minv3positiontaking_3 smallmoney= 0.5,
    @minv3positiontaking_20 smallmoney= 0.5,

    @minv5positiontaking_1 smallmoney= 0.5,
    @minv5positiontaking_2 smallmoney= 0.5,
    @minv5positiontaking_3 smallmoney= 0.5,
    @minv5positiontaking_20 smallmoney= 0.5,
    @minv5positiontaking_9999 smallmoney = 0.5,

    @minv8positiontaking_1 smallmoney= 0.5,
    @minv8positiontaking_3 smallmoney= 0.5,
    @minv8positiontaking_20 smallmoney= 0.5,

    @minv10positiontaking_1 smallmoney= 0.5,
    @minv10positiontaking_2 smallmoney= 0.5,
    @minv10positiontaking_3 smallmoney= 0.5,
    @minv10positiontaking_20 smallmoney= 0.5,

    @minv11positiontaking_1 smallmoney= 0.5,
    @minv11positiontaking_20 smallmoney= 0.5,

    @minv99positiontaking_1 smallmoney= 0.5,
    @minv99positiontaking_2 smallmoney= 0.5,
    @minv99positiontaking_3 smallmoney= 0.5,
    @minv99positiontaking_9 smallmoney= 0.5,
    @minv99positiontaking_20 smallmoney= 0.5,
    
    @minv154positiontaking_20 smallmoney = 0.5
    
SELECT @max_custid = xx

INSERT INTO ##tmpCust(custid)
	select 	5973408	--	4	CYKM
union all select 	4940784	--	4	DKD
union all select 	3191187	--	3	DKE
union all select 	10231287	--	2	REU
union all select 	1140623	--	4	SBB
union all select 	8017299	--	4	SBC
union all select 	12968884	--	4	SBHF
union all select 	13549891	--	4	SBHG
union all select 	1604404	--	4	SBM
union all select 	1593254	--	4	SBS
union all select 	4622222	--	4	SBSD
union all select 	16576689	--	4	SBV
union all select 	865485	--	4	SKHK
union all select 	1995341	--	4	SKM
union all select 	884262	--	4	SKR
union all select 	11734366	--	4	SSF
union all select 	1993804	--	4	YKH
union all select 	5931469	--	4	YKM
union all select 	1993818	--	4	YKR
		

WHILE (1 = 1)
BEGIN
	UPDATE TOP (1) ##tmpCust
	SET isfinished = 1
		,@custid = custid			
	WHERE isfinished = 0
	
	IF @@ROWCOUNT = 0 BREAK

	EXEC dbo.[Acc_CustSetting3rd_19] @custid = @custid			
			,@target = 'DBCUST'
			,@minpositiontaking_1 = @minpositiontaking_1
			,@minpositiontaking_2 = @minpositiontaking_2 
			,@minpositiontaking_3 = @minpositiontaking_3
			,@minpositiontaking_4 = @minpositiontaking_4
			,@minpositiontaking_5 = @minpositiontaking_5
			,@minpositiontaking_6 =@minpositiontaking_6
			,@minpositiontaking_7 = @minpositiontaking_7
			,@minpositiontaking_8 = @minpositiontaking_8
			,@minpositiontaking_9 = @minpositiontaking_9
			,@minpositiontaking_10 = @minpositiontaking_10
			,@minpositiontaking_9999 = @minpositiontaking_9999
			,@minlivepositiontaking_1= @minlivepositiontaking_1
			,@minlivepositiontaking_3 = @minlivepositiontaking_3
			,@minlivepositiontaking_7 = @minlivepositiontaking_7
			,@minlivepositiontaking_8 = @minlivepositiontaking_8
		    
			,@minv2positiontaking_1 = @minv2positiontaking_1
			,@minv2positiontaking_2 = @minv2positiontaking_2
			,@minv2positiontaking_3 = @minv2positiontaking_3
			,@minv2positiontaking_7 = @minv2positiontaking_7
			,@minv2positiontaking_8 = @minv2positiontaking_8
			,@minv2positiontaking_20 = @minv2positiontaking_20

			,@minv3positiontaking_1 = @minv3positiontaking_1
			,@minv3positiontaking_2 = @minv3positiontaking_2
			,@minv3positiontaking_3 = @minv3positiontaking_3
			,@minv3positiontaking_20 = @minv3positiontaking_20

			,@minv5positiontaking_1 = @minv5positiontaking_1
			,@minv5positiontaking_2 = @minv5positiontaking_2
			,@minv5positiontaking_3 = @minv5positiontaking_3
			,@minv5positiontaking_20= @minv5positiontaking_20
			,@minv5positiontaking_9999 = @minv5positiontaking_9999
			
			,@minv8positiontaking_1 = @minv8positiontaking_1
			,@minv8positiontaking_3 = @minv8positiontaking_3
			,@minv8positiontaking_20 = @minv8positiontaking_20

			,@minv10positiontaking_1 = @minv10positiontaking_1 
			,@minv10positiontaking_2 =@minv10positiontaking_2
			,@minv10positiontaking_3 = @minv10positiontaking_3 
			,@minv10positiontaking_20 = @minv10positiontaking_20 

			,@minv11positiontaking_1 = @minv11positiontaking_1 
			,@minv11positiontaking_20 =@minv11positiontaking_20 

			,@minv99positiontaking_1 =@minv99positiontaking_1 
			,@minv99positiontaking_2 =@minv99positiontaking_2 
			,@minv99positiontaking_3 =@minv99positiontaking_3 
			,@minv99positiontaking_9 = @minv99positiontaking_9
			,@minv99positiontaking_20 = @minv99positiontaking_20
		    
			,@minv154positiontaking_20 = @minv154positiontaking_20
	
	waitfor delay '00:00:0.280'
END			

DROP TABLE ##tmpCust
GO		
-- END STEP 2: RUN THIS SCRIPT AT DBCUST -----
-----------------------------------------------------------------------------------
 --END 3rd batch
-----------------------------------
