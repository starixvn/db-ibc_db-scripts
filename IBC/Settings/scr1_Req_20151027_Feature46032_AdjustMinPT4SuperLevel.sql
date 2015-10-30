 /*
	Created: Johnson
	Date: 2015-10-27
	Task: Adjust min pt for customers list requested
	DB: DBCUST/CUSTDB
 */
 
 ---STEP 1: deploy this sp on DBCUST
 ALTER PROCEDURE [dbo].[Acc_CustSetting3rd_19]
    @custid int,
    @Target VARCHAR(20) = '',
    @minpositiontaking_1 smallmoney = 0,
    @minpositiontaking_2 smallmoney= 0,
    @minpositiontaking_3 smallmoney= 0,
    @minpositiontaking_4 smallmoney= 0,
    @minpositiontaking_5 smallmoney= 0,
    @minpositiontaking_6 smallmoney= 0,
    @minpositiontaking_7 smallmoney= 0,
    @minpositiontaking_8 smallmoney= 0,
    @minpositiontaking_9 smallmoney= 0,
    @minpositiontaking_10 smallmoney= 0,
    @minpositiontaking_9999 smallmoney = 0,
    @minlivepositiontaking_1 smallmoney= 0,
    @minlivepositiontaking_3 smallmoney= 0,
    @minlivepositiontaking_7 smallmoney= 0,
    @minlivepositiontaking_8 smallmoney= 0,
    
    @minv2positiontaking_1 smallmoney= 0,
    @minv2positiontaking_2 smallmoney= 0,
    @minv2positiontaking_3 smallmoney= 0,
    @minv2positiontaking_7 smallmoney= 0,
    @minv2positiontaking_8 smallmoney= 0,
    --@minv2positiontaking_9 smallmoney,
    @minv2positiontaking_20 smallmoney= 0,

    @minv3positiontaking_1 smallmoney= 0,
    @minv3positiontaking_2 smallmoney= 0,
    @minv3positiontaking_3 smallmoney= 0,
    @minv3positiontaking_20 smallmoney= 0,

    @minv5positiontaking_1 smallmoney= 0,
    @minv5positiontaking_2 smallmoney= 0,
    @minv5positiontaking_3 smallmoney= 0,
    @minv5positiontaking_20 smallmoney= 0,
    @minv5positiontaking_9999 smallmoney = 0,

    @minv8positiontaking_1 smallmoney= 0,
    @minv8positiontaking_3 smallmoney= 0,
    @minv8positiontaking_20 smallmoney= 0,

    @minv10positiontaking_1 smallmoney= 0,
    @minv10positiontaking_2 smallmoney= 0,
    @minv10positiontaking_3 smallmoney= 0,
    @minv10positiontaking_20 smallmoney= 0,

    @minv11positiontaking_1 smallmoney= 0,
    @minv11positiontaking_20 smallmoney= 0,

    @minv99positiontaking_1 smallmoney= 0,
    @minv99positiontaking_2 smallmoney= 0,
    @minv99positiontaking_3 smallmoney= 0,
    @minv99positiontaking_9 smallmoney= 0,
    @minv99positiontaking_20 smallmoney= 0,
    
    @minv154positiontaking_20 smallmoney = 0
AS
BEGIN
	SET NOCOUNT ON
	
	IF (@target = 'REPLICATED' AND @@SERVERNAME = 'DBCUST') RETURN	-- run at all replicated servers
	IF (@target = 'DBCUST' AND @@SERVERNAME <> 'DBCUST') RETURN -- run at dbtrans only
		
	Declare @roleid int, @srecommend int, @mrecommend int, @recommend int
	select @roleid = roleid, @srecommend=srecommend, @mrecommend=mrecommend, @recommend=recommend from customer with (NOLOCK) where custid = @custid
	
	
    Update custoverride with (ROWLOCK, UPDLOCK) set minpositiontaking = b.minpositiontaking, minlivepositiontaking = b.minlivepositiontaking
    from custoverride inner join     
            (
                select         @custid as custid,  1 as sporttype, 1 as bettype, @minpositiontaking_1 as minpositiontaking,  @minlivepositiontaking_1 as minlivepositiontaking
                union all select     @custid as custid,  1 as sporttype, 2 as bettype, @minpositiontaking_2 as minpositiontaking,  0 as minlivepositiontaking
                union all select     @custid as custid,  1 as sporttype, 3 as bettype, @minpositiontaking_3 as minpositiontaking,  @minlivepositiontaking_3 as minlivepositiontaking
                union all select     @custid as custid,  1 as sporttype, 4 as bettype, @minpositiontaking_4 as minpositiontaking,  0 as minlivepositiontaking
                union all select     @custid as custid,  1 as sporttype, 5 as bettype, @minpositiontaking_5 as minpositiontaking,  0 as minlivepositiontaking
                union all select     @custid as custid,  1 as sporttype, 6 as bettype, @minpositiontaking_6 as minpositiontaking,  0 as minlivepositiontaking
                union all select     @custid as custid,  1 as sporttype, 7 as bettype, @minpositiontaking_7 as minpositiontaking,  @minlivepositiontaking_7 as minlivepositiontaking
                union all select     @custid as custid,  1 as sporttype, 8 as bettype, @minpositiontaking_8 as minpositiontaking,  @minlivepositiontaking_8 as minlivepositiontaking
                union all select     @custid as custid,  1 as sporttype, 9 as bettype, @minpositiontaking_9 as minpositiontaking,  0 as minlivepositiontaking
                union all select     @custid as custid,  1 as sporttype, 10 as bettype, @minpositiontaking_10 as minpositiontaking,  0 as minlivepositiontaking
                union all select     @custid as custid,  1 as sporttype, 9999 as bettype, @minpositiontaking_9999 as minpositiontaking,  0 as minlivepositiontaking
                
                union all select     @custid as custid,  2 as sporttype, 1 as bettype, @minv2positiontaking_1 as minpositiontaking,  0 as minlivepositiontaking
                union all select     @custid as custid,  2 as sporttype, 2 as bettype, @minv2positiontaking_2 as minpositiontaking,  0 as minlivepositiontaking
                union all select     @custid as custid,  2 as sporttype, 3 as bettype, @minv2positiontaking_3 as minpositiontaking,  0 as minlivepositiontaking
                union all select     @custid as custid,  2 as sporttype, 7 as bettype, @minv2positiontaking_7 as minpositiontaking,  0 as minlivepositiontaking
                union all select     @custid as custid,  2 as sporttype, 8 as bettype, @minv2positiontaking_8 as minpositiontaking,  0 as minlivepositiontaking
                --union all select     @custid as custid,  2 as sporttype, 9 as bettype, @minv2positiontaking_9 as minpositiontaking,  0 as minlivepositiontaking
                union all select     @custid as custid,  2 as sporttype, 20 as bettype, @minv2positiontaking_20 as minpositiontaking,  0 as minlivepositiontaking

                union all select     @custid as custid,  3 as sporttype, 1 as bettype, @minv3positiontaking_1 as minpositiontaking,  0 as minlivepositiontaking
                union all select     @custid as custid,  3 as sporttype, 2 as bettype, @minv3positiontaking_2 as minpositiontaking,  0 as minlivepositiontaking
                union all select     @custid as custid,  3 as sporttype, 3 as bettype, @minv3positiontaking_3 as minpositiontaking,  0 as minlivepositiontaking
                union all select     @custid as custid,  3 as sporttype, 20 as bettype, @minv3positiontaking_20 as minpositiontaking,  0 as minlivepositiontaking

                union all select     @custid as custid,  5 as sporttype, 1 as bettype, @minv5positiontaking_1 as minpositiontaking,  0 as minlivepositiontaking
                union all select     @custid as custid,  5 as sporttype, 2 as bettype, @minv5positiontaking_2 as minpositiontaking,  0 as minlivepositiontaking
                union all select     @custid as custid,  5 as sporttype, 3 as bettype, @minv5positiontaking_3 as minpositiontaking,  0 as minlivepositiontaking
                union all select     @custid as custid,  5 as sporttype, 20 as bettype, @minv5positiontaking_20 as minpositiontaking,  0 as minlivepositiontaking
                union all select     @custid as custid,  5 as sporttype, 9999 as bettype, @minv5positiontaking_9999 as minpositiontaking,  0 as minlivepositiontaking

                union all select     @custid as custid,  8 as sporttype, 1 as bettype, @minv8positiontaking_1 as minpositiontaking,  0 as minlivepositiontaking
                union all select     @custid as custid,  8 as sporttype, 3 as bettype, @minv8positiontaking_3 as minpositiontaking,  0 as minlivepositiontaking
                union all select     @custid as custid,  8 as sporttype, 20 as bettype, @minv8positiontaking_20 as minpositiontaking,  0 as minlivepositiontaking

                union all select     @custid as custid,  10 as sporttype, 1 as bettype, @minv10positiontaking_1 as minpositiontaking,  0 as minlivepositiontaking
                union all select     @custid as custid,  10 as sporttype, 2 as bettype, @minv10positiontaking_2 as minpositiontaking,  0 as minlivepositiontaking
                union all select     @custid as custid,  10 as sporttype, 3 as bettype, @minv10positiontaking_3 as minpositiontaking,  0 as minlivepositiontaking
                union all select     @custid as custid,  10 as sporttype, 20 as bettype, @minv10positiontaking_20 as minpositiontaking,  0 as minlivepositiontaking

                union all select     @custid as custid,  11 as sporttype, 1 as bettype, @minv11positiontaking_1 as minpositiontaking,  0 as minlivepositiontaking
                union all select     @custid as custid,  11 as sporttype, 20 as bettype, @minv11positiontaking_20 as minpositiontaking,  0 as minlivepositiontaking

                union all select     @custid as custid,  99 as sporttype, 1 as bettype, @minv99positiontaking_1 as minpositiontaking,  0 as minlivepositiontaking
                union all select     @custid as custid,  99 as sporttype, 2 as bettype, @minv99positiontaking_2 as minpositiontaking,  0 as minlivepositiontaking
                union all select     @custid as custid,  99 as sporttype, 3 as bettype, @minv99positiontaking_3 as minpositiontaking,  0 as minlivepositiontaking
                union all select     @custid as custid,  99 as sporttype, 9 as bettype, @minv99positiontaking_9 as minpositiontaking,  0 as minlivepositiontaking
                union all select     @custid as custid,  99 as sporttype, 20 as bettype, @minv99positiontaking_20 as minpositiontaking,  0 as minlivepositiontaking
                
                union all select     @custid as custid,  154 as sporttype, 20 as bettype, @minv154positiontaking_20 as minpositiontaking,  0 as minlivepositiontaking
                
            ) as b on custoverride.custid = b.custid and custoverride.sporttype=b.sporttype and custoverride.bettype = b.bettype
    where custoverride.custid = @custid
		AND b.minpositiontaking > 0 
		AND 1 = case when b.sporttype=1 and b.bettype in (1,3,7,8) and b.minlivepositiontaking = 0 THEN 0 ELSE 1 END
		
	
	if @roleid = 2
	BEGIN
		EXEC dbo.Acc_CustSetting_04 @recommend = @recommend, @mrecommend = @mrecommend, @srecommend = @srecommend, @roleid = 2					
	END
	else if @roleid = 3
	BEGIN
		EXEC dbo.Acc_CustSetting_04 @mrecommend = @mrecommend, @srecommend = @srecommend, @roleid = 3					
	END
	else if @roleid= 4 
	BEGIN
		EXEC dbo.Acc_CustSetting_04 @srecommend = @srecommend, @roleid = 4					
	END
	              
END    
GO
-- END STEP 1: DEPLOY THIS SP @DBCUST.CustDB --------
------------------------------------------------------	
 
---
-- BEGIN STEP 2: RUN THIS SCRIPT AT ALL REPLICATED SERVERS (06/DBTP) -----
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

INSERT INTO ##tmpCust(custid)
		SELECT 	916947	--	2	,	02R
UNION ALL SELECT 	11237	--	2	,	1158RM
UNION ALL SELECT 	16252271	--	4	,	2BP
UNION ALL SELECT 	15848874	--	4	,	2CK
UNION ALL SELECT 	13083302	--	4	,	2CR
UNION ALL SELECT 	13344620	--	4	,	2CT
UNION ALL SELECT 	3800272	--	4	,	2DH
UNION ALL SELECT 	7772435	--	4	,	2EU
UNION ALL SELECT 	8281764	--	4	,	2MN
UNION ALL SELECT 	17045552	--	4	,	2MP
UNION ALL SELECT 	11733282	--	4	,	2NN
UNION ALL SELECT 	9670471	--	4	,	2RM
UNION ALL SELECT 	2831919	--	2	,	312BP
UNION ALL SELECT 	734658	--	2	,	3KHK
UNION ALL SELECT 	3290	--	2	,	6599RM
UNION ALL SELECT 	174095	--	2	,	6666AUD
UNION ALL SELECT 	3023	--	2	,	6666BP
UNION ALL SELECT 	9636	--	2	,	6666EU
UNION ALL SELECT 	2690	--	2	,	6666HK
UNION ALL SELECT 	7984	--	2	,	6666US
UNION ALL SELECT 	15267	--	2	,	6hk6601
UNION ALL SELECT 	16129	--	2	,	7899HK
UNION ALL SELECT 	4521616	--	2	,	789R
UNION ALL SELECT 	4204225	--	4	,	79AH
UNION ALL SELECT 	4204369	--	4	,	79AR
UNION ALL SELECT 	6249438	--	4	,	87R
UNION ALL SELECT 	15103340	--	2	,	A50RM
UNION ALL SELECT 	14737139	--	2	,	A688U
UNION ALL SELECT 	3080407	--	2	,	A7HK
UNION ALL SELECT 	1575555	--	4	,	AA
UNION ALL SELECT 	9905998	--	4	,	AC1
UNION ALL SELECT 	13290701	--	4	,	ACH
UNION ALL SELECT 	13562677	--	4	,	ACH1
UNION ALL SELECT 	13563191	--	4	,	ACH2
UNION ALL SELECT 	13863347	--	4	,	ACH3
UNION ALL SELECT 	18515475	--	4	,	ACH6
UNION ALL SELECT 	19310674	--	4	,	ACH7
UNION ALL SELECT 	12168675	--	4	,	ACK
UNION ALL SELECT 	17612940	--	4	,	AD
UNION ALL SELECT 	13744152	--	4	,	AG
UNION ALL SELECT 	13792957	--	4	,	AH
UNION ALL SELECT 	4115476	--	4	,	AHA
UNION ALL SELECT 	3780034	--	4	,	AHL
UNION ALL SELECT 	1628179	--	4	,	AHM
UNION ALL SELECT 	11028100	--	4	,	AHMA
UNION ALL SELECT 	1628290	--	4	,	AHN
UNION ALL SELECT 	2197674	--	4	,	AHO
UNION ALL SELECT 	3872491	--	4	,	AHT
UNION ALL SELECT 	5336854	--	4	,	AHV
UNION ALL SELECT 	13058363	--	4	,	AHZ
UNION ALL SELECT 	4404031	--	4	,	AJ
UNION ALL SELECT 	13892822	--	4	,	AKO1
UNION ALL SELECT 	13893053	--	4	,	AKO2
UNION ALL SELECT 	17120967	--	4	,	AKO3
UNION ALL SELECT 	15200915	--	4	,	ALR
UNION ALL SELECT 	5086616	--	4	,	AN
UNION ALL SELECT 	4314665	--	4	,	AP
UNION ALL SELECT 	17050644	--	4	,	AQ
UNION ALL SELECT 	4212172	--	4	,	AS
UNION ALL SELECT 	5528833	--	4	,	AT
UNION ALL SELECT 	1812820	--	4	,	AW
UNION ALL SELECT 	8066804	--	4	,	AZ
UNION ALL SELECT 	1528421	--	4	,	B10T
UNION ALL SELECT 	1528422	--	4	,	B11T
UNION ALL SELECT 	1536432	--	4	,	B12T
UNION ALL SELECT 	1538057	--	4	,	B13T
UNION ALL SELECT 	1538175	--	4	,	B14T
UNION ALL SELECT 	1538183	--	4	,	B15T
UNION ALL SELECT 	1538997	--	4	,	B16T
UNION ALL SELECT 	1539009	--	4	,	B17T
UNION ALL SELECT 	1539693	--	4	,	B18T
UNION ALL SELECT 	1539698	--	4	,	B19T
UNION ALL SELECT 	1523261	--	4	,	B1T
UNION ALL SELECT 	1539699	--	4	,	B20T
UNION ALL SELECT 	1539700	--	4	,	B21T
UNION ALL SELECT 	1540216	--	4	,	B22T
UNION ALL SELECT 	1540217	--	4	,	B23T
UNION ALL SELECT 	1588140	--	4	,	B24T
UNION ALL SELECT 	1588145	--	4	,	B25T
UNION ALL SELECT 	2508822	--	4	,	B26T
UNION ALL SELECT 	2541779	--	4	,	B27T
UNION ALL SELECT 	7815141	--	4	,	B29T
UNION ALL SELECT 	1528410	--	4	,	B2T
UNION ALL SELECT 	8458736	--	4	,	B30T
UNION ALL SELECT 	9664861	--	4	,	B31T
UNION ALL SELECT 	9669693	--	4	,	B32T
UNION ALL SELECT 	9933863	--	4	,	B33T
UNION ALL SELECT 	9934001	--	4	,	B34T
UNION ALL SELECT 	9933940	--	4	,	B35T
UNION ALL SELECT 	9934027	--	4	,	B36T
UNION ALL SELECT 	17305980	--	4	,	B47T
UNION ALL SELECT 	17683729	--	4	,	B49T
UNION ALL SELECT 	1528413	--	4	,	B4T
UNION ALL SELECT 	18452186	--	4	,	B50T
UNION ALL SELECT 	18452187	--	4	,	B51T
UNION ALL SELECT 	1517951	--	4	,	B5T
UNION ALL SELECT 	1528414	--	4	,	B6T
UNION ALL SELECT 	1528418	--	4	,	B7T
UNION ALL SELECT 	1528419	--	4	,	B8T
UNION ALL SELECT 	1528420	--	4	,	B9T
UNION ALL SELECT 	1584509	--	4	,	BA
UNION ALL SELECT 	14635815	--	4	,	BGR
UNION ALL SELECT 	2221671	--	4	,	BHO
UNION ALL SELECT 	5780740	--	4	,	BHS
UNION ALL SELECT 	642291	--	4	,	BI
UNION ALL SELECT 	13934944	--	4	,	BJ
UNION ALL SELECT 	13876211	--	3	,	BPK
UNION ALL SELECT 	1517030	--	4	,	BT
UNION ALL SELECT 	10369357	--	4	,	C1
UNION ALL SELECT 	12070389	--	4	,	C12
UNION ALL SELECT 	12276215	--	4	,	C15
UNION ALL SELECT 	10560596	--	4	,	C2
UNION ALL SELECT 	10775412	--	4	,	C3
UNION ALL SELECT 	11639821	--	4	,	C8
UNION ALL SELECT 	17742	--	3	,	CHITB
UNION ALL SELECT 	5994	--	3	,	CHTB
UNION ALL SELECT 	19040588	--	4	,	CHU
UNION ALL SELECT 	1563928	--	4	,	CI
UNION ALL SELECT 	9579024	--	4	,	cks
UNION ALL SELECT 	4663772	--	4	,	CL
UNION ALL SELECT 	2083036	--	4	,	CO
UNION ALL SELECT 	2131553	--	4	,	CS
UNION ALL SELECT 	2103376	--	4	,	CU
UNION ALL SELECT 	7216279	--	4	,	CX
UNION ALL SELECT 	10792955	--	4	,	CY
UNION ALL SELECT 	2078394	--	4	,	DA
UNION ALL SELECT 	897588	--	4	,	DI
UNION ALL SELECT 	13338988	--	3	,	DJHK
UNION ALL SELECT 	17041176	--	4	,	DM
UNION ALL SELECT 	18777368	--	4	,	DRM
UNION ALL SELECT 	1372998	--	4	,	DW
UNION ALL SELECT 	11748799	--	4	,	E60
UNION ALL SELECT 	14393371	--	4	,	EEH
UNION ALL SELECT 	14392343	--	4	,	EEM
UNION ALL SELECT 	16057193	--	4	,	EGH
UNION ALL SELECT 	16057234	--	4	,	EGM
UNION ALL SELECT 	4505274	--	4	,	FA
UNION ALL SELECT 	6150551	--	4	,	FBB
UNION ALL SELECT 	4604381	--	4	,	FBH
UNION ALL SELECT 	2209358	--	3	,	FBM
UNION ALL SELECT 	1382183	--	3	,	FBR
UNION ALL SELECT 	1373748	--	4	,	FF
UNION ALL SELECT 	11566943	--	4	,	FJM
UNION ALL SELECT 	5969746	--	4	,	GA
UNION ALL SELECT 	8429220	--	4	,	GG
UNION ALL SELECT 	747037	--	4	,	GI
UNION ALL SELECT 	641918	--	4	,	HI
UNION ALL SELECT 	1029732	--	4	,	HJ
UNION ALL SELECT 	15689139	--	4	,	HK06
UNION ALL SELECT 	2882278	--	4	,	HM
UNION ALL SELECT 	6210213	--	4	,	HO
UNION ALL SELECT 	712439	--	4	,	HP
UNION ALL SELECT 	11173365	--	4	,	HPD
UNION ALL SELECT 	11241067	--	4	,	HPE
UNION ALL SELECT 	5215598	--	4	,	HPI
UNION ALL SELECT 	2251491	--	4	,	HPM
UNION ALL SELECT 	2138601	--	4	,	HPO
UNION ALL SELECT 	2895571	--	4	,	HPU
UNION ALL SELECT 	9931047	--	4	,	HT1
UNION ALL SELECT 	9933782	--	4	,	HT2
UNION ALL SELECT 	11306634	--	4	,	HT3
UNION ALL SELECT 	19378350	--	4	,	HT4
UNION ALL SELECT 	19380292	--	4	,	HT5
UNION ALL SELECT 	6465457	--	4	,	HU
UNION ALL SELECT 	7176459	--	4	,	HW
UNION ALL SELECT 	14011590	--	4	,	IA
UNION ALL SELECT 	3526034	--	4	,	ID
UNION ALL SELECT 	14308443	--	4	,	IE
UNION ALL SELECT 	5880048	--	4	,	IF
UNION ALL SELECT 	18546512	--	4	,	IG
UNION ALL SELECT 	689767	--	4	,	II
UNION ALL SELECT 	4802250	--	4	,	IK
UNION ALL SELECT 	4378806	--	4	,	IM
UNION ALL SELECT 	4404078	--	4	,	IN
UNION ALL SELECT 	1564982	--	4	,	IP
UNION ALL SELECT 	2831595	--	4	,	IR
UNION ALL SELECT 	6706058	--	4	,	IZ
UNION ALL SELECT 	4152553	--	4	,	JA
UNION ALL SELECT 	1220882	--	4	,	JAH
UNION ALL SELECT 	1603986	--	4	,	JAM
UNION ALL SELECT 	13469206	--	4	,	JARWRONG
UNION ALL SELECT 	11665608	--	4	,	FM
UNION ALL SELECT 	4649955	--	4	,	HK8
UNION ALL SELECT 	1248383	--	4	,	JAS
UNION ALL SELECT 	1220879	--	4	,	JAT
UNION ALL SELECT 	4404067	--	4	,	JB
UNION ALL SELECT 	4437168	--	4	,	JC
UNION ALL SELECT 	13653794	--	4	,	JCH
UNION ALL SELECT 	2302419	--	4	,	JJ
UNION ALL SELECT 	5484091	--	4	,	JJB
UNION ALL SELECT 	11760592	--	4	,	JJM
UNION ALL SELECT 	6855660	--	4	,	JK
UNION ALL SELECT 	9412566	--	4	,	JN
UNION ALL SELECT 	3144218	--	3	,	JPG
UNION ALL SELECT 	10064280	--	4	,	JT
UNION ALL SELECT 	14014232	--	4	,	KAA
UNION ALL SELECT 	16000766	--	4	,	KAC
UNION ALL SELECT 	18201422	--	4	,	KAG
UNION ALL SELECT 	726582	--	4	,	KAM
UNION ALL SELECT 	726562	--	4	,	KAR
UNION ALL SELECT 	938136	--	4	,	KAT
UNION ALL SELECT 	726571	--	4	,	KBR
UNION ALL SELECT 	726579	--	4	,	KCR
UNION ALL SELECT 	4792246	--	4	,	KD
UNION ALL SELECT 	1164457	--	4	,	KDR
UNION ALL SELECT 	1238537	--	4	,	KER
UNION ALL SELECT 	16594953	--	4	,	KGA
UNION ALL SELECT 	16595046	--	4	,	KGB
UNION ALL SELECT 	15927973	--	4	,	KGP
UNION ALL SELECT 	194355	--	4	,	KH
UNION ALL SELECT 	3589741	--	4	,	KH6
UNION ALL SELECT 	896708	--	4	,	KHAH
UNION ALL SELECT 	913628	--	4	,	KHBH
UNION ALL SELECT 	1069029	--	4	,	KHCH
UNION ALL SELECT 	2400612	--	4	,	KHDH
UNION ALL SELECT 	674248	--	4	,	KHH
UNION ALL SELECT 	712272	--	4	,	KHK
UNION ALL SELECT 	1537683	--	4	,	KHT
UNION ALL SELECT 	1574950	--	4	,	KJH
UNION ALL SELECT 	1865464	--	4	,	KJM
UNION ALL SELECT 	6525867	--	4	,	KJMD
UNION ALL SELECT 	7375633	--	4	,	KJME
UNION ALL SELECT 	15583251	--	4	,	KJMF
UNION ALL SELECT 	12334400	--	4	,	KKF
UNION ALL SELECT 	194354	--	4	,	KM
UNION ALL SELECT 	3589738	--	4	,	KM6
UNION ALL SELECT 	476776	--	4	,	KMA
UNION ALL SELECT 	727340	--	4	,	KMAM
UNION ALL SELECT 	877777	--	4	,	KMBM
UNION ALL SELECT 	395075	--	4	,	KMM
UNION ALL SELECT 	13856586	--	4	,	KP
UNION ALL SELECT 	4037357	--	4	,	KPM
UNION ALL SELECT 	12048828	--	4	,	KPW
UNION ALL SELECT 	194356	--	4	,	KR
UNION ALL SELECT 	391601	--	4	,	KRC
UNION ALL SELECT 	461767	--	4	,	KRR
UNION ALL SELECT 	15140611	--	4	,	KRW
UNION ALL SELECT 	3589744	--	4	,	KS6
UNION ALL SELECT 	394310	--	4	,	KSD
UNION ALL SELECT 	1088459	--	4	,	KYH
UNION ALL SELECT 	2026798	--	4	,	KYM
UNION ALL SELECT 	5771986	--	4	,	LA
UNION ALL SELECT 	3770553	--	4	,	LB
UNION ALL SELECT 	3810488	--	4	,	LC
UNION ALL SELECT 	3954915	--	4	,	LD
UNION ALL SELECT 	3973944	--	4	,	LE
UNION ALL SELECT 	4189499	--	4	,	LF
UNION ALL SELECT 	7680679	--	4	,	LG
UNION ALL SELECT 	2749224	--	4	,	LH
UNION ALL SELECT 	16639418	--	4	,	LHA
UNION ALL SELECT 	4374817	--	4	,	LHH
UNION ALL SELECT 	7753979	--	4	,	LHH1
UNION ALL SELECT 	7754066	--	4	,	LHH2
UNION ALL SELECT 	7754182	--	4	,	LHH3
UNION ALL SELECT 	7754251	--	4	,	LHH4
UNION ALL SELECT 	7754301	--	4	,	LHH5
UNION ALL SELECT 	8251316	--	4	,	LHH6
UNION ALL SELECT 	11449326	--	4	,	LHH8
UNION ALL SELECT 	8418095	--	4	,	LHHRMB
UNION ALL SELECT 	5281110	--	4	,	LHI
UNION ALL SELECT 	4445198	--	4	,	LHM
UNION ALL SELECT 	7753114	--	4	,	LHM1
UNION ALL SELECT 	17107778	--	4	,	LHM5
UNION ALL SELECT 	10044015	--	4	,	LHR
UNION ALL SELECT 	8103018	--	4	,	LHS 
UNION ALL SELECT 	4419739	--	4	,	LHU
UNION ALL SELECT 	643456	--	4	,	LI
UNION ALL SELECT 	2075688	--	4	,	LJ
UNION ALL SELECT 	4100631	--	4	,	LK
UNION ALL SELECT 	3556221	--	4	,	LL
UNION ALL SELECT 	3037128	--	3	,	LLKH
UNION ALL SELECT 	4181761	--	4	,	LLP
UNION ALL SELECT 	7680792	--	4	,	LM
UNION ALL SELECT 	5551373	--	4	,	LN
UNION ALL SELECT 	5473265	--	4	,	LS
UNION ALL SELECT 	4367748	--	4	,	LT
UNION ALL SELECT 	2835363	--	4	,	LU
UNION ALL SELECT 	4006796	--	4	,	LV
UNION ALL SELECT 	17681850	--	4	,	LW
UNION ALL SELECT 	3539862	--	4	,	LY
UNION ALL SELECT 	1870568	--	3	,	M033H
UNION ALL SELECT 	724768	--	3	,	M033R
UNION ALL SELECT 	1068024	--	3	,	M113H
UNION ALL SELECT 	3535160	--	3	,	M222M
UNION ALL SELECT 	861326	--	3	,	M252H
UNION ALL SELECT 	371646	--	3	,	M252RMB
UNION ALL SELECT 	2398557	--	4	,	M312T
UNION ALL SELECT 	37457	--	3	,	M318HK
UNION ALL SELECT 	664858	--	3	,	M318RMB
UNION ALL SELECT 	1132163	--	3	,	M32M
UNION ALL SELECT 	252605	--	3	,	M359ARMB
UNION ALL SELECT 	62834	--	3	,	M359RM
UNION ALL SELECT 	68899	--	3	,	M359SD
UNION ALL SELECT 	15515	--	3	,	M39IRMB
UNION ALL SELECT 	419150	--	3	,	M50RM
UNION ALL SELECT 	398333	--	3	,	M58SD
UNION ALL SELECT 	865472	--	3	,	M606HK
UNION ALL SELECT 	8546807	--	3	,	M62AH
UNION ALL SELECT 	4234220	--	3	,	M62H
UNION ALL SELECT 	8226535	--	3	,	M62R
UNION ALL SELECT 	9671179	--	3	,	m62rb
UNION ALL SELECT 	3080124	--	3	,	M62SD
UNION ALL SELECT 	15219	--	3	,	M6HK
UNION ALL SELECT 	947130	--	3	,	M6RM
UNION ALL SELECT 	47030	--	3	,	M6SD
UNION ALL SELECT 	1114738	--	3	,	M79CR
UNION ALL SELECT 	4712010	--	3	,	M7RRMB
UNION ALL SELECT 	905394	--	3	,	M818H
UNION ALL SELECT 	2002448	--	3	,	M818R
UNION ALL SELECT 	3686314	--	3	,	M818RA
UNION ALL SELECT 	449152	--	3	,	M83ARM
UNION ALL SELECT 	4012300	--	3	,	M83H
UNION ALL SELECT 	43272	--	3	,	M83RM
UNION ALL SELECT 	78703	--	3	,	M863HK
UNION ALL SELECT 	1111628	--	3	,	M8H
UNION ALL SELECT 	8009	--	3	,	M8HK
UNION ALL SELECT 	1336489	--	3	,	M922M
UNION ALL SELECT 	33903	--	3	,	M96RM
UNION ALL SELECT 	157597	--	3	,	M98HK
UNION ALL SELECT 	73166	--	3	,	M98RM
UNION ALL SELECT 	588296	--	3	,	M98ZR
UNION ALL SELECT 	854753	--	4	,	M99RMB
UNION ALL SELECT 	8266979	--	3	,	MALM
UNION ALL SELECT 	27026	--	3	,	MAMRM
UNION ALL SELECT 	1773803	--	4	,	MC
UNION ALL SELECT 	1773805	--	4	,	MC1
UNION ALL SELECT 	2308589	--	4	,	MC2
UNION ALL SELECT 	10506715	--	4	,	MC3
UNION ALL SELECT 	15805514	--	4	,	MC5
UNION ALL SELECT 	4144525	--	4	,	MCR
UNION ALL SELECT 	16737515	--	4	,	MD
UNION ALL SELECT 	11548722	--	4	,	MH
UNION ALL SELECT 	4339887	--	3	,	MHK8
UNION ALL SELECT 	4600902	--	3	,	MHK9
UNION ALL SELECT 	997137	--	4	,	MK1
UNION ALL SELECT 	1074882	--	4	,	MK10
UNION ALL SELECT 	1074884	--	4	,	MK11C
UNION ALL SELECT 	998346	--	4	,	MK4C
UNION ALL SELECT 	997155	--	4	,	MK6
UNION ALL SELECT 	17299936	--	4	,	MKHA
UNION ALL SELECT 	3715080	--	4	,	MKI
UNION ALL SELECT 	1606473	--	4	,	MKM1
UNION ALL SELECT 	1437908	--	4	,	MKS
UNION ALL SELECT 	12294019	--	4	,	MKS1
UNION ALL SELECT 	1539908	--	4	,	MKTB
UNION ALL SELECT 	2026854	--	3	,	MKYM
UNION ALL SELECT 	8550141	--	4	,	MLH
UNION ALL SELECT 	1581733	--	4	,	MM
UNION ALL SELECT 	5664	--	3	,	MMMRM
UNION ALL SELECT 	11674030	--	4	,	MP
UNION ALL SELECT 	3144085	--	3	,	MPH
UNION ALL SELECT 	561153	--	3	,	MPTRMB
UNION ALL SELECT 	214696	--	3	,	MPTUS
UNION ALL SELECT 	156071	--	3	,	MQARM
UNION ALL SELECT 	121951	--	3	,	MQRM
UNION ALL SELECT 	2486485	--	3	,	MSFR
UNION ALL SELECT 	6321	--	3	,	MSRMB
UNION ALL SELECT 	6032879	--	4	,	PPB
UNION ALL SELECT 	2394977	--	4	,	PPH
UNION ALL SELECT 	17568160	--	4	,	PPJ
UNION ALL SELECT 	3574705	--	4	,	PPM
UNION ALL SELECT 	6032912	--	4	,	PPR
UNION ALL SELECT 	17550987	--	4	,	PPS
UNION ALL SELECT 	3150153	--	4	,	PTM
UNION ALL SELECT 	1349398	--	4	,	QQ
UNION ALL SELECT 	12957917	--	4	,	QQBS
UNION ALL SELECT 	11884796	--	4	,	QQHK
UNION ALL SELECT 	7763719	--	4	,	QQK3
UNION ALL SELECT 	7756579	--	4	,	QQKA
UNION ALL SELECT 	15984489	--	4	,	QQKH
UNION ALL SELECT 	12573245	--	4	,	QQKY
UNION ALL SELECT 	7756637	--	4	,	QQMA
UNION ALL SELECT 	10848683	--	4	,	QQMR
UNION ALL SELECT 	7756603	--	4	,	QQMW
UNION ALL SELECT 	7756631	--	4	,	QQMY
UNION ALL SELECT 	7756563	--	4	,	QQMZ
UNION ALL SELECT 	9934169	--	4	,	QQTB
UNION ALL SELECT 	8243036	--	4	,	R312R
UNION ALL SELECT 	17787564	--	4	,	R313R
UNION ALL SELECT 	19485465	--	4	,	R313T
UNION ALL SELECT 	19466231	--	4	,	R313Y
UNION ALL SELECT 	15825686	--	4	,	RB168
UNION ALL SELECT 	18803268	--	4	,	RMB
UNION ALL SELECT 	1586764	--	4	,	RR
UNION ALL SELECT 	1867721	--	4	,	S09H
UNION ALL SELECT 	5005322	--	4	,	S09M
UNION ALL SELECT 	1435492	--	4	,	S120R
UNION ALL SELECT 	15682765	--	4	,	S120S
UNION ALL SELECT 	3391041	--	4	,	S121R
UNION ALL SELECT 	8145099	--	4	,	S122R
UNION ALL SELECT 	12545786	--	4	,	S123R
UNION ALL SELECT 	13885989	--	4	,	S124R
UNION ALL SELECT 	524760	--	4	,	S16RUP
UNION ALL SELECT 	15583137	--	4	,	S222N
UNION ALL SELECT 	560429	--	4	,	S222R
UNION ALL SELECT 	979900	--	4	,	S23H
UNION ALL SELECT 	17074641	--	4	,	S23M
UNION ALL SELECT 	2193103	--	4	,	S23S
UNION ALL SELECT 	17723529	--	4	,	S26M
UNION ALL SELECT 	3752852	--	4	,	S27A
UNION ALL SELECT 	1001999	--	4	,	S27HK
UNION ALL SELECT 	7945539	--	4	,	S27TK
UNION ALL SELECT 	356937	--	4	,	S305CRMB
UNION ALL SELECT 	752203	--	4	,	S305R
UNION ALL SELECT 	404941	--	4	,	S305RM
UNION ALL SELECT 	9672019	--	4	,	S312C
UNION ALL SELECT 	17520621	--	4	,	S312G
UNION ALL SELECT 	17469607	--	4	,	S312H
UNION ALL SELECT 	2969567	--	4	,	S312R
UNION ALL SELECT 	12589170	--	4	,	S312RMB
UNION ALL SELECT 	771942	--	4	,	S31ARMB
UNION ALL SELECT 	7754654	--	4	,	S31BRM
UNION ALL SELECT 	408317	--	4	,	S31RM
UNION ALL SELECT 	478396	--	4	,	S31RMB
UNION ALL SELECT 	987495	--	4	,	S32AH
UNION ALL SELECT 	1456420	--	4	,	S32AM
UNION ALL SELECT 	987497	--	4	,	S32BH
UNION ALL SELECT 	3654316	--	4	,	S32BM
UNION ALL SELECT 	987499	--	4	,	S32CH
UNION ALL SELECT 	17931860	--	4	,	S32CM
UNION ALL SELECT 	987501	--	4	,	S32DH
UNION ALL SELECT 	1366843	--	4	,	S32FH
UNION ALL SELECT 	857802	--	4	,	S32H
UNION ALL SELECT 	2284508	--	4	,	S32HH
UNION ALL SELECT 	5349816	--	4	,	S32HK
UNION ALL SELECT 	15657898	--	4	,	S32HKD
UNION ALL SELECT 	2838764	--	4	,	S32IH
UNION ALL SELECT 	3195166	--	4	,	S32JH
UNION ALL SELECT 	15548698	--	4	,	S32K
UNION ALL SELECT 	19075657	--	4	,	S32KK
UNION ALL SELECT 	1452602	--	4	,	S32M
UNION ALL SELECT 	753492	--	4	,	S32R
UNION ALL SELECT 	15657985	--	4	,	S32RM
UNION ALL SELECT 	324558	--	4	,	S32RMB
UNION ALL SELECT 	18393844	--	4	,	S33A
UNION ALL SELECT 	335748	--	4	,	S33AR
UNION ALL SELECT 	463659	--	4	,	S33BR
UNION ALL SELECT 	484809	--	4	,	S33CR
UNION ALL SELECT 	211567	--	4	,	S33E
UNION ALL SELECT 	211566	--	4	,	S33M
UNION ALL SELECT 	390561	--	4	,	S33MR
UNION ALL SELECT 	211568	--	4	,	S33R
UNION ALL SELECT 	431696	--	4	,	S33S
UNION ALL SELECT 	390567	--	4	,	S33SM
UNION ALL SELECT 	9934485	--	4	,	S33T
UNION ALL SELECT 	7753071	--	4	,	S359am
UNION ALL SELECT 	7772139	--	4	,	S359CM
UNION ALL SELECT 	6385611	--	4	,	S359M
UNION ALL SELECT 	7186058	--	4	,	S359S
UNION ALL SELECT 	344472	--	4	,	S39R
UNION ALL SELECT 	2601912	--	4	,	S39RR
UNION ALL SELECT 	972747	--	4	,	S3H
UNION ALL SELECT 	3560324	--	4	,	S3HH
UNION ALL SELECT 	7763508	--	4	,	S3HK
UNION ALL SELECT 	2926808	--	4	,	S41H
UNION ALL SELECT 	1690565	--	4	,	S41M
UNION ALL SELECT 	1690560	--	4	,	S41S
UNION ALL SELECT 	1036451	--	4	,	S42AH
UNION ALL SELECT 	2428032	--	4	,	S42ARM
UNION ALL SELECT 	1290422	--	4	,	S42BH
UNION ALL SELECT 	1652112	--	4	,	S42CH
UNION ALL SELECT 	4672707	--	4	,	S42D
UNION ALL SELECT 	1749600	--	4	,	S42DH
UNION ALL SELECT 	1022404	--	4	,	S42H
UNION ALL SELECT 	3513305	--	4	,	S42M
UNION ALL SELECT 	817188	--	4	,	S42RM
UNION ALL SELECT 	1207541	--	4	,	S42S
UNION ALL SELECT 	8270016	--	4	,	S43H
UNION ALL SELECT 	3019886	--	4	,	S43S
UNION ALL SELECT 	5831527	--	4	,	S49H
UNION ALL SELECT 	877004	--	4	,	S49R
UNION ALL SELECT 	426131	--	4	,	S49RM
UNION ALL SELECT 	4151114	--	4	,	S50R
UNION ALL SELECT 	528691	--	4	,	S50RMB
UNION ALL SELECT 	3592236	--	4	,	S51AH
UNION ALL SELECT 	3592237	--	4	,	S51BH
UNION ALL SELECT 	3592239	--	4	,	S51CH
UNION ALL SELECT 	3801635	--	4	,	S51DH
UNION ALL SELECT 	1349148	--	4	,	S51H
UNION ALL SELECT 	7301563	--	4	,	S51HA
UNION ALL SELECT 	835299	--	4	,	S51R
UNION ALL SELECT 	695131	--	4	,	S51SM
UNION ALL SELECT 	9933834	--	4	,	S51TB
UNION ALL SELECT 	1755451	--	4	,	S553H
UNION ALL SELECT 	4910597	--	4	,	S555
UNION ALL SELECT 	12785073	--	4	,	S56A
UNION ALL SELECT 	15689281	--	4	,	S56AE
UNION ALL SELECT 	838203	--	4	,	S56AH
UNION ALL SELECT 	8062488	--	4	,	S56AI
UNION ALL SELECT 	15904288	--	4	,	S56ASD
UNION ALL SELECT 	838210	--	4	,	S56BBH
UNION ALL SELECT 	550155	--	4	,	S56BRM
UNION ALL SELECT 	838370	--	4	,	S56CH
UNION ALL SELECT 	826317	--	4	,	S56CRM
UNION ALL SELECT 	3681857	--	4	,	S56D
UNION ALL SELECT 	877770	--	4	,	S56DRM
UNION ALL SELECT 	877768	--	4	,	S56EH
UNION ALL SELECT 	1031455	--	4	,	S56GH
UNION ALL SELECT 	838201	--	4	,	S56H
UNION ALL SELECT 	844818	--	4	,	S56HH
UNION ALL SELECT 	1219867	--	4	,	S56HK
UNION ALL SELECT 	1194960	--	4	,	S56KH
UNION ALL SELECT 	5311452	--	4	,	S56KK
UNION ALL SELECT 	3775566	--	4	,	S56NH
UNION ALL SELECT 	3775579	--	4	,	S56PH
UNION ALL SELECT 	4356717	--	4	,	S56QH
UNION ALL SELECT 	461775	--	4	,	S56R
UNION ALL SELECT 	405017	--	4	,	S56RM
UNION ALL SELECT 	1537688	--	4	,	S56TH
UNION ALL SELECT 	687425	--	4	,	S57R
UNION ALL SELECT 	461780	--	4	,	S58R
UNION ALL SELECT 	405422	--	4	,	S58RM
UNION ALL SELECT 	1576179	--	4	,	S60AR
UNION ALL SELECT 	510159	--	4	,	S60RUP
UNION ALL SELECT 	9727438	--	4	,	S62D
UNION ALL SELECT 	1720567	--	4	,	S62H
UNION ALL SELECT 	3149272	--	4	,	S62M
UNION ALL SELECT 	4910667	--	4	,	S666
UNION ALL SELECT 	901840	--	4	,	S688H
UNION ALL SELECT 	2509713	--	4	,	S688M
UNION ALL SELECT 	959157	--	4	,	S688T
UNION ALL SELECT 	17961935	--	4	,	S6AHK
UNION ALL SELECT 	835418	--	4	,	S6ARUP
UNION ALL SELECT 	5711971	--	4	,	S6BP
UNION ALL SELECT 	8539195	--	4	,	s6cn
UNION ALL SELECT 	527906	--	4	,	S6EU
UNION ALL SELECT 	3676675	--	4	,	S6H
UNION ALL SELECT 	9735627	--	4	,	S6KW
UNION ALL SELECT 	12665939	--	4	,	S6P
UNION ALL SELECT 	11660213	--	4	,	S6RMB
UNION ALL SELECT 	549191	--	4	,	S6RUP
UNION ALL SELECT 	17537176	--	4	,	S6T
UNION ALL SELECT 	706886	--	4	,	S6US
UNION ALL SELECT 	16189265	--	4	,	S777
UNION ALL SELECT 	914839	--	4	,	S788H
UNION ALL SELECT 	987102	--	4	,	S799H
UNION ALL SELECT 	900371	--	4	,	S79AHH
UNION ALL SELECT 	592998	--	4	,	S79AR
UNION ALL SELECT 	3360316	--	4	,	S79C
UNION ALL SELECT 	836410	--	4	,	S79H
UNION ALL SELECT 	1859089	--	4	,	S79HG
UNION ALL SELECT 	935097	--	4	,	S79HH
UNION ALL SELECT 	2775382	--	4	,	S79HS
UNION ALL SELECT 	2188063	--	4	,	S79hz
UNION ALL SELECT 	729244	--	4	,	S79R
UNION ALL SELECT 	356941	--	4	,	s79rrr
UNION ALL SELECT 	989898	--	4	,	S79SH
UNION ALL SELECT 	7374379	--	4	,	S7D
UNION ALL SELECT 	10910070	--	4	,	S7KW
UNION ALL SELECT 	18579015	--	4	,	S7RR
UNION ALL SELECT 	3671274	--	4	,	S80H
UNION ALL SELECT 	356942	--	4	,	S80R
UNION ALL SELECT 	16287301	--	4	,	S85A
UNION ALL SELECT 	882592	--	4	,	S85BR
UNION ALL SELECT 	15140845	--	4	,	S85GTH
UNION ALL SELECT 	1050206	--	4	,	S85H
UNION ALL SELECT 	843526	--	4	,	S85R
UNION ALL SELECT 	1108229	--	4	,	S85S
UNION ALL SELECT 	4138910	--	4	,	S863R
UNION ALL SELECT 	14663748	--	4	,	S88ML
UNION ALL SELECT 	1402421	--	4	,	S90AR
UNION ALL SELECT 	10507013	--	4	,	S90C
UNION ALL SELECT 	7923118	--	4	,	S90H
UNION ALL SELECT 	523974	--	4	,	S90R
UNION ALL SELECT 	1788033	--	4	,	S922K
UNION ALL SELECT 	1342397	--	4	,	S922M
UNION ALL SELECT 	4913546	--	4	,	S922MA
UNION ALL SELECT 	5519726	--	4	,	S922R
UNION ALL SELECT 	1266057	--	4	,	S96h
UNION ALL SELECT 	10599405	--	4	,	S989H
UNION ALL SELECT 	7817620	--	4	,	S989M
UNION ALL SELECT 	2869345	--	4	,	S989R
UNION ALL SELECT 	12515436	--	4	,	S98E
UNION ALL SELECT 	1008234	--	4	,	S98H
UNION ALL SELECT 	12653798	--	4	,	S98K
UNION ALL SELECT 	477659	--	4	,	S98R
UNION ALL SELECT 	4022510	--	4	,	S99ah
UNION ALL SELECT 	15229780	--	4	,	S99D
UNION ALL SELECT 	18929915	--	4	,	S99E
UNION ALL SELECT 	859594	--	4	,	S99H
UNION ALL SELECT 	7604170	--	4	,	S99HKD
UNION ALL SELECT 	11471646	--	4	,	S99K
UNION ALL SELECT 	1448199	--	4	,	S99M
UNION ALL SELECT 	912272	--	4	,	S99TB
UNION ALL SELECT 	9925322	--	4	,	S99TH
UNION ALL SELECT 	16026037	--	4	,	S99V
UNION ALL SELECT 	14084827	--	4	,	S99W
UNION ALL SELECT 	17200168	--	4	,	S9EU
UNION ALL SELECT 	4554012	--	4	,	S9H
UNION ALL SELECT 	18015222	--	4	,	S9KK
UNION ALL SELECT 	17583600	--	4	,	S9KS
UNION ALL SELECT 	15530229	--	4	,	S9KW
UNION ALL SELECT 	691884	--	4	,	S9M
UNION ALL SELECT 	2421122	--	4	,	SABT
UNION ALL SELECT 	4744473	--	4	,	SADA
UNION ALL SELECT 	970269	--	4	,	SALH
UNION ALL SELECT 	447479	--	4	,	SALR
UNION ALL SELECT 	1456925	--	4	,	SAMR
UNION ALL SELECT 	5283781	--	4	,	SATE
UNION ALL SELECT 	7781015	--	4	,	SATM
UNION ALL SELECT 	2229262	--	4	,	SATU
UNION ALL SELECT 	4320374	--	4	,	SB
UNION ALL SELECT 	955286	--	4	,	SB8R
UNION ALL SELECT 	1795270	--	4	,	SBBR
UNION ALL SELECT 	1558372	--	4	,	SBBT
UNION ALL SELECT 	805450	--	4	,	SBHK
UNION ALL SELECT 	595962	--	4	,	SBKH
UNION ALL SELECT 	324336	--	4	,	SBKHK
UNION ALL SELECT 	324557	--	4	,	SCHK
UNION ALL SELECT 	2285864	--	4	,	SCI
UNION ALL SELECT 	398615	--	4	,	SCM
UNION ALL SELECT 	398636	--	4	,	SCS
UNION ALL SELECT 	984549	--	4	,	SDH
UNION ALL SELECT 	6621107	--	4	,	SDHA
UNION ALL SELECT 	776702	--	4	,	SDR
UNION ALL SELECT 	410722	--	4	,	SDRM
UNION ALL SELECT 	479690	--	4	,	SDRMB
UNION ALL SELECT 	3139575	--	4	,	SF8
UNION ALL SELECT 	2327638	--	4	,	SFB
UNION ALL SELECT 	840993	--	4	,	SG1H
UNION ALL SELECT 	3237241	--	4	,	SG1R
UNION ALL SELECT 	4181669	--	4	,	SG21H
UNION ALL SELECT 	4383797	--	4	,	SG23H
UNION ALL SELECT 	4780138	--	4	,	SG25H
UNION ALL SELECT 	5334790	--	4	,	SG26H
UNION ALL SELECT 	6457243	--	4	,	SG28h
UNION ALL SELECT 	840999	--	4	,	SG2H
UNION ALL SELECT 	4487258	--	4	,	SG2M
UNION ALL SELECT 	10719518	--	4	,	SG33H
UNION ALL SELECT 	5334777	--	4	,	SG3M
UNION ALL SELECT 	1927603	--	4	,	SG6H
UNION ALL SELECT 	7680993	--	4	,	SG7M
UNION ALL SELECT 	8119630	--	4	,	SG8M
UNION ALL SELECT 	7939911	--	4	,	SGGT
UNION ALL SELECT 	832992	--	4	,	SGH
UNION ALL SELECT 	398437	--	4	,	SGM
UNION ALL SELECT 	399130	--	4	,	SGR
UNION ALL SELECT 	11314815	--	4	,	SGRD
UNION ALL SELECT 	324561	--	4	,	SGURMB
UNION ALL SELECT 	185849	--	4	,	SI
UNION ALL SELECT 	3451110	--	4	,	SJH
UNION ALL SELECT 	19240555	--	4	,	SJJM
UNION ALL SELECT 	787938	--	4	,	SJM
UNION ALL SELECT 	12575535	--	4	,	SJSD
UNION ALL SELECT 	506057	--	4	,	SKPRMB
UNION ALL SELECT 	5601008	--	4	,	SLD
UNION ALL SELECT 	7757274	--	4	,	SLG
UNION ALL SELECT 	2178402	--	4	,	SLH
UNION ALL SELECT 	3872549	--	4	,	SLJ
UNION ALL SELECT 	7768121	--	4	,	SLL
UNION ALL SELECT 	5473299	--	4	,	SLM
UNION ALL SELECT 	1265902	--	4	,	SMAMRMB
UNION ALL SELECT 	2278343	--	4	,	SMBH
UNION ALL SELECT 	13294314	--	4	,	SMCH
UNION ALL SELECT 	984745	--	4	,	SMH
UNION ALL SELECT 	398467	--	4	,	SMM
UNION ALL SELECT 	984746	--	4	,	SMMH
UNION ALL SELECT 	1211027	--	4	,	SMMS
UNION ALL SELECT 	7146892	--	4	,	SMOC
UNION ALL SELECT 	8330307	--	4	,	SMOCNY
UNION ALL SELECT 	15588279	--	4	,	SMOI
UNION ALL SELECT 	407649	--	4	,	SMORM
UNION ALL SELECT 	324564	--	4	,	SMORMB
UNION ALL SELECT 	15516774	--	4	,	SNI
UNION ALL SELECT 	32422	--	2	,	SORM
UNION ALL SELECT 	301152	--	4	,	SPH
UNION ALL SELECT 	261425	--	4	,	SPR
UNION ALL SELECT 	14210898	--	4	,	SQHH
UNION ALL SELECT 	837905	--	4	,	SSF1H
UNION ALL SELECT 	1013342	--	4	,	SSF2H
UNION ALL SELECT 	2332356	--	4	,	SSF3H
UNION ALL SELECT 	4362130	--	4	,	SSF5H
UNION ALL SELECT 	837904	--	4	,	SSFH
UNION ALL SELECT 	2823274	--	4	,	SSFK
UNION ALL SELECT 	1416231	--	4	,	SSS
UNION ALL SELECT 	2192160	--	4	,	SSSD
UNION ALL SELECT 	641144	--	4	,	ST2T
UNION ALL SELECT 	2388779	--	4	,	STEB
UNION ALL SELECT 	16645316	--	4	,	SVE
UNION ALL SELECT 	490037	--	4	,	SVM
UNION ALL SELECT 	7758309	--	4	,	SVP
UNION ALL SELECT 	490215	--	4	,	SVR
UNION ALL SELECT 	10933415	--	4	,	SVVG
UNION ALL SELECT 	867735	--	4	,	SW
UNION ALL SELECT 	4601030	--	4	,	SYI
UNION ALL SELECT 	16694213	--	4	,	TA
UNION ALL SELECT 	406808	--	4	,	TAS51S
UNION ALL SELECT 	13348258	--	3	,	TG1
UNION ALL SELECT 	13348483	--	3	,	TG2
UNION ALL SELECT 	13348378	--	3	,	TG3
UNION ALL SELECT 	13348559	--	3	,	TG4
UNION ALL SELECT 	4253518	--	4	,	TH28
UNION ALL SELECT 	5402188	--	4	,	THM
UNION ALL SELECT 	9727510	--	4	,	TP
UNION ALL SELECT 	17797342	--	4	,	TS1
UNION ALL SELECT 	17797400	--	4	,	TS2
UNION ALL SELECT 	17820768	--	4	,	TS3
UNION ALL SELECT 	14405674	--	4	,	TWS
UNION ALL SELECT 	4677011	--	4	,	UA
UNION ALL SELECT 	4677048	--	4	,	UB
UNION ALL SELECT 	6660386	--	4	,	UD
UNION ALL SELECT 	5773292	--	4	,	UE
UNION ALL SELECT 	10278914	--	4	,	UF
UNION ALL SELECT 	14118357	--	4	,	UG
UNION ALL SELECT 	11010588	--	4	,	UH
UNION ALL SELECT 	656135	--	4	,	UI
UNION ALL SELECT 	4048531	--	4	,	UK
UNION ALL SELECT 	4323575	--	4	,	UL
UNION ALL SELECT 	4253707	--	4	,	UM
UNION ALL SELECT 	4320399	--	4	,	UN
UNION ALL SELECT 	16787471	--	4	,	SVA
UNION ALL SELECT 	3965567	--	4	,	UT
UNION ALL SELECT 	3909347	--	4	,	UU
UNION ALL SELECT 	7277118	--	4	,	UV
UNION ALL SELECT 	7177766	--	4	,	UW
UNION ALL SELECT 	14956535	--	4	,	UY
UNION ALL SELECT 	10797628	--	4	,	UZ
UNION ALL SELECT 	15424123	--	4	,	VA
UNION ALL SELECT 	4548911	--	4	,	VC
UNION ALL SELECT 	14773243	--	4	,	VE
UNION ALL SELECT 	5957920	--	4	,	VF
UNION ALL SELECT 	15485426	--	4	,	VG
UNION ALL SELECT 	13478477	--	4	,	VI
UNION ALL SELECT 	17916695	--	4	,	VJ
UNION ALL SELECT 	10398791	--	4	,	VKH
UNION ALL SELECT 	5938255	--	4	,	VM
UNION ALL SELECT 	8284552	--	4	,	VO
UNION ALL SELECT 	9514014	--	4	,	VP
UNION ALL SELECT 	10927694	--	4	,	VQ
UNION ALL SELECT 	5778932	--	4	,	VVG
UNION ALL SELECT 	4739346	--	4	,	WB
UNION ALL SELECT 	3411725	--	3	,	WBR
UNION ALL SELECT 	4673332	--	3	,	WBRA
UNION ALL SELECT 	6853841	--	3	,	wbrf
UNION ALL SELECT 	11485599	--	3	,	WBRG
UNION ALL SELECT 	11485623	--	3	,	WBRH
UNION ALL SELECT 	11485641	--	3	,	WBRI
UNION ALL SELECT 	11485655	--	3	,	WBRJ
UNION ALL SELECT 	4348440	--	3	,	WBRR
UNION ALL SELECT 	3498094	--	4	,	WD1
UNION ALL SELECT 	5358729	--	4	,	WDR
UNION ALL SELECT 	18747621	--	4	,	WG
UNION ALL SELECT 	3919061	--	4	,	WH
UNION ALL SELECT 	1124040	--	4	,	WI
UNION ALL SELECT 	18364243	--	4	,	WJ
UNION ALL SELECT 	1457236	--	4	,	WKH
UNION ALL SELECT 	11761289	--	4	,	WPR
UNION ALL SELECT 	720475	--	4	,	WW
UNION ALL SELECT 	14015187	--	4	,	XCN
UNION ALL SELECT 	17058130	--	4	,	XKS
UNION ALL SELECT 	10529214	--	4	,	YHA
UNION ALL SELECT 	2270259	--	4	,	YI
UNION ALL SELECT 	16016306	--	4	,	YM
UNION ALL SELECT 	4622387	--	4	,	YN
UNION ALL SELECT 	5532706	--	4	,	ZZ		

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
-- END STEP 2: RUN THIS SCRIPT AT ALL REPLICATED SERVERS (06/DBTP) -----
-----------------------------------------------------------------------------------



---
-- BEGIN STEP 3: RUN THIS SCRIPT AT DBCUST -----
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

INSERT INTO ##tmpCust(custid)
		SELECT 	916947	--	2	,	02R
UNION ALL SELECT 	11237	--	2	,	1158RM
UNION ALL SELECT 	16252271	--	4	,	2BP
UNION ALL SELECT 	15848874	--	4	,	2CK
UNION ALL SELECT 	13083302	--	4	,	2CR
UNION ALL SELECT 	13344620	--	4	,	2CT
UNION ALL SELECT 	3800272	--	4	,	2DH
UNION ALL SELECT 	7772435	--	4	,	2EU
UNION ALL SELECT 	8281764	--	4	,	2MN
UNION ALL SELECT 	17045552	--	4	,	2MP
UNION ALL SELECT 	11733282	--	4	,	2NN
UNION ALL SELECT 	9670471	--	4	,	2RM
UNION ALL SELECT 	2831919	--	2	,	312BP
UNION ALL SELECT 	734658	--	2	,	3KHK
UNION ALL SELECT 	3290	--	2	,	6599RM
UNION ALL SELECT 	174095	--	2	,	6666AUD
UNION ALL SELECT 	3023	--	2	,	6666BP
UNION ALL SELECT 	9636	--	2	,	6666EU
UNION ALL SELECT 	2690	--	2	,	6666HK
UNION ALL SELECT 	7984	--	2	,	6666US
UNION ALL SELECT 	15267	--	2	,	6hk6601
UNION ALL SELECT 	16129	--	2	,	7899HK
UNION ALL SELECT 	4521616	--	2	,	789R
UNION ALL SELECT 	4204225	--	4	,	79AH
UNION ALL SELECT 	4204369	--	4	,	79AR
UNION ALL SELECT 	6249438	--	4	,	87R
UNION ALL SELECT 	15103340	--	2	,	A50RM
UNION ALL SELECT 	14737139	--	2	,	A688U
UNION ALL SELECT 	3080407	--	2	,	A7HK
UNION ALL SELECT 	1575555	--	4	,	AA
UNION ALL SELECT 	9905998	--	4	,	AC1
UNION ALL SELECT 	13290701	--	4	,	ACH
UNION ALL SELECT 	13562677	--	4	,	ACH1
UNION ALL SELECT 	13563191	--	4	,	ACH2
UNION ALL SELECT 	13863347	--	4	,	ACH3
UNION ALL SELECT 	18515475	--	4	,	ACH6
UNION ALL SELECT 	19310674	--	4	,	ACH7
UNION ALL SELECT 	12168675	--	4	,	ACK
UNION ALL SELECT 	17612940	--	4	,	AD
UNION ALL SELECT 	13744152	--	4	,	AG
UNION ALL SELECT 	13792957	--	4	,	AH
UNION ALL SELECT 	4115476	--	4	,	AHA
UNION ALL SELECT 	3780034	--	4	,	AHL
UNION ALL SELECT 	1628179	--	4	,	AHM
UNION ALL SELECT 	11028100	--	4	,	AHMA
UNION ALL SELECT 	1628290	--	4	,	AHN
UNION ALL SELECT 	2197674	--	4	,	AHO
UNION ALL SELECT 	3872491	--	4	,	AHT
UNION ALL SELECT 	5336854	--	4	,	AHV
UNION ALL SELECT 	13058363	--	4	,	AHZ
UNION ALL SELECT 	4404031	--	4	,	AJ
UNION ALL SELECT 	13892822	--	4	,	AKO1
UNION ALL SELECT 	13893053	--	4	,	AKO2
UNION ALL SELECT 	17120967	--	4	,	AKO3
UNION ALL SELECT 	15200915	--	4	,	ALR
UNION ALL SELECT 	5086616	--	4	,	AN
UNION ALL SELECT 	4314665	--	4	,	AP
UNION ALL SELECT 	17050644	--	4	,	AQ
UNION ALL SELECT 	4212172	--	4	,	AS
UNION ALL SELECT 	5528833	--	4	,	AT
UNION ALL SELECT 	1812820	--	4	,	AW
UNION ALL SELECT 	8066804	--	4	,	AZ
UNION ALL SELECT 	1528421	--	4	,	B10T
UNION ALL SELECT 	1528422	--	4	,	B11T
UNION ALL SELECT 	1536432	--	4	,	B12T
UNION ALL SELECT 	1538057	--	4	,	B13T
UNION ALL SELECT 	1538175	--	4	,	B14T
UNION ALL SELECT 	1538183	--	4	,	B15T
UNION ALL SELECT 	1538997	--	4	,	B16T
UNION ALL SELECT 	1539009	--	4	,	B17T
UNION ALL SELECT 	1539693	--	4	,	B18T
UNION ALL SELECT 	1539698	--	4	,	B19T
UNION ALL SELECT 	1523261	--	4	,	B1T
UNION ALL SELECT 	1539699	--	4	,	B20T
UNION ALL SELECT 	1539700	--	4	,	B21T
UNION ALL SELECT 	1540216	--	4	,	B22T
UNION ALL SELECT 	1540217	--	4	,	B23T
UNION ALL SELECT 	1588140	--	4	,	B24T
UNION ALL SELECT 	1588145	--	4	,	B25T
UNION ALL SELECT 	2508822	--	4	,	B26T
UNION ALL SELECT 	2541779	--	4	,	B27T
UNION ALL SELECT 	7815141	--	4	,	B29T
UNION ALL SELECT 	1528410	--	4	,	B2T
UNION ALL SELECT 	8458736	--	4	,	B30T
UNION ALL SELECT 	9664861	--	4	,	B31T
UNION ALL SELECT 	9669693	--	4	,	B32T
UNION ALL SELECT 	9933863	--	4	,	B33T
UNION ALL SELECT 	9934001	--	4	,	B34T
UNION ALL SELECT 	9933940	--	4	,	B35T
UNION ALL SELECT 	9934027	--	4	,	B36T
UNION ALL SELECT 	17305980	--	4	,	B47T
UNION ALL SELECT 	17683729	--	4	,	B49T
UNION ALL SELECT 	1528413	--	4	,	B4T
UNION ALL SELECT 	18452186	--	4	,	B50T
UNION ALL SELECT 	18452187	--	4	,	B51T
UNION ALL SELECT 	1517951	--	4	,	B5T
UNION ALL SELECT 	1528414	--	4	,	B6T
UNION ALL SELECT 	1528418	--	4	,	B7T
UNION ALL SELECT 	1528419	--	4	,	B8T
UNION ALL SELECT 	1528420	--	4	,	B9T
UNION ALL SELECT 	1584509	--	4	,	BA
UNION ALL SELECT 	14635815	--	4	,	BGR
UNION ALL SELECT 	2221671	--	4	,	BHO
UNION ALL SELECT 	5780740	--	4	,	BHS
UNION ALL SELECT 	642291	--	4	,	BI
UNION ALL SELECT 	13934944	--	4	,	BJ
UNION ALL SELECT 	13876211	--	3	,	BPK
UNION ALL SELECT 	1517030	--	4	,	BT
UNION ALL SELECT 	10369357	--	4	,	C1
UNION ALL SELECT 	12070389	--	4	,	C12
UNION ALL SELECT 	12276215	--	4	,	C15
UNION ALL SELECT 	10560596	--	4	,	C2
UNION ALL SELECT 	10775412	--	4	,	C3
UNION ALL SELECT 	11639821	--	4	,	C8
UNION ALL SELECT 	17742	--	3	,	CHITB
UNION ALL SELECT 	5994	--	3	,	CHTB
UNION ALL SELECT 	19040588	--	4	,	CHU
UNION ALL SELECT 	1563928	--	4	,	CI
UNION ALL SELECT 	9579024	--	4	,	cks
UNION ALL SELECT 	4663772	--	4	,	CL
UNION ALL SELECT 	2083036	--	4	,	CO
UNION ALL SELECT 	2131553	--	4	,	CS
UNION ALL SELECT 	2103376	--	4	,	CU
UNION ALL SELECT 	7216279	--	4	,	CX
UNION ALL SELECT 	10792955	--	4	,	CY
UNION ALL SELECT 	2078394	--	4	,	DA
UNION ALL SELECT 	897588	--	4	,	DI
UNION ALL SELECT 	13338988	--	3	,	DJHK
UNION ALL SELECT 	17041176	--	4	,	DM
UNION ALL SELECT 	18777368	--	4	,	DRM
UNION ALL SELECT 	1372998	--	4	,	DW
UNION ALL SELECT 	11748799	--	4	,	E60
UNION ALL SELECT 	14393371	--	4	,	EEH
UNION ALL SELECT 	14392343	--	4	,	EEM
UNION ALL SELECT 	16057193	--	4	,	EGH
UNION ALL SELECT 	16057234	--	4	,	EGM
UNION ALL SELECT 	4505274	--	4	,	FA
UNION ALL SELECT 	6150551	--	4	,	FBB
UNION ALL SELECT 	4604381	--	4	,	FBH
UNION ALL SELECT 	2209358	--	3	,	FBM
UNION ALL SELECT 	1382183	--	3	,	FBR
UNION ALL SELECT 	1373748	--	4	,	FF
UNION ALL SELECT 	11566943	--	4	,	FJM
UNION ALL SELECT 	5969746	--	4	,	GA
UNION ALL SELECT 	8429220	--	4	,	GG
UNION ALL SELECT 	747037	--	4	,	GI
UNION ALL SELECT 	641918	--	4	,	HI
UNION ALL SELECT 	1029732	--	4	,	HJ
UNION ALL SELECT 	15689139	--	4	,	HK06
UNION ALL SELECT 	2882278	--	4	,	HM
UNION ALL SELECT 	6210213	--	4	,	HO
UNION ALL SELECT 	712439	--	4	,	HP
UNION ALL SELECT 	11173365	--	4	,	HPD
UNION ALL SELECT 	11241067	--	4	,	HPE
UNION ALL SELECT 	5215598	--	4	,	HPI
UNION ALL SELECT 	2251491	--	4	,	HPM
UNION ALL SELECT 	2138601	--	4	,	HPO
UNION ALL SELECT 	2895571	--	4	,	HPU
UNION ALL SELECT 	9931047	--	4	,	HT1
UNION ALL SELECT 	9933782	--	4	,	HT2
UNION ALL SELECT 	11306634	--	4	,	HT3
UNION ALL SELECT 	19378350	--	4	,	HT4
UNION ALL SELECT 	19380292	--	4	,	HT5
UNION ALL SELECT 	6465457	--	4	,	HU
UNION ALL SELECT 	7176459	--	4	,	HW
UNION ALL SELECT 	14011590	--	4	,	IA
UNION ALL SELECT 	3526034	--	4	,	ID
UNION ALL SELECT 	14308443	--	4	,	IE
UNION ALL SELECT 	5880048	--	4	,	IF
UNION ALL SELECT 	18546512	--	4	,	IG
UNION ALL SELECT 	689767	--	4	,	II
UNION ALL SELECT 	4802250	--	4	,	IK
UNION ALL SELECT 	4378806	--	4	,	IM
UNION ALL SELECT 	4404078	--	4	,	IN
UNION ALL SELECT 	1564982	--	4	,	IP
UNION ALL SELECT 	2831595	--	4	,	IR
UNION ALL SELECT 	6706058	--	4	,	IZ
UNION ALL SELECT 	4152553	--	4	,	JA
UNION ALL SELECT 	1220882	--	4	,	JAH
UNION ALL SELECT 	1603986	--	4	,	JAM
UNION ALL SELECT 	13469206	--	4	,	JARWRONG
UNION ALL SELECT 	11665608	--	4	,	FM
UNION ALL SELECT 	4649955	--	4	,	HK8
UNION ALL SELECT 	1248383	--	4	,	JAS
UNION ALL SELECT 	1220879	--	4	,	JAT
UNION ALL SELECT 	4404067	--	4	,	JB
UNION ALL SELECT 	4437168	--	4	,	JC
UNION ALL SELECT 	13653794	--	4	,	JCH
UNION ALL SELECT 	2302419	--	4	,	JJ
UNION ALL SELECT 	5484091	--	4	,	JJB
UNION ALL SELECT 	11760592	--	4	,	JJM
UNION ALL SELECT 	6855660	--	4	,	JK
UNION ALL SELECT 	9412566	--	4	,	JN
UNION ALL SELECT 	3144218	--	3	,	JPG
UNION ALL SELECT 	10064280	--	4	,	JT
UNION ALL SELECT 	14014232	--	4	,	KAA
UNION ALL SELECT 	16000766	--	4	,	KAC
UNION ALL SELECT 	18201422	--	4	,	KAG
UNION ALL SELECT 	726582	--	4	,	KAM
UNION ALL SELECT 	726562	--	4	,	KAR
UNION ALL SELECT 	938136	--	4	,	KAT
UNION ALL SELECT 	726571	--	4	,	KBR
UNION ALL SELECT 	726579	--	4	,	KCR
UNION ALL SELECT 	4792246	--	4	,	KD
UNION ALL SELECT 	1164457	--	4	,	KDR
UNION ALL SELECT 	1238537	--	4	,	KER
UNION ALL SELECT 	16594953	--	4	,	KGA
UNION ALL SELECT 	16595046	--	4	,	KGB
UNION ALL SELECT 	15927973	--	4	,	KGP
UNION ALL SELECT 	194355	--	4	,	KH
UNION ALL SELECT 	3589741	--	4	,	KH6
UNION ALL SELECT 	896708	--	4	,	KHAH
UNION ALL SELECT 	913628	--	4	,	KHBH
UNION ALL SELECT 	1069029	--	4	,	KHCH
UNION ALL SELECT 	2400612	--	4	,	KHDH
UNION ALL SELECT 	674248	--	4	,	KHH
UNION ALL SELECT 	712272	--	4	,	KHK
UNION ALL SELECT 	1537683	--	4	,	KHT
UNION ALL SELECT 	1574950	--	4	,	KJH
UNION ALL SELECT 	1865464	--	4	,	KJM
UNION ALL SELECT 	6525867	--	4	,	KJMD
UNION ALL SELECT 	7375633	--	4	,	KJME
UNION ALL SELECT 	15583251	--	4	,	KJMF
UNION ALL SELECT 	12334400	--	4	,	KKF
UNION ALL SELECT 	194354	--	4	,	KM
UNION ALL SELECT 	3589738	--	4	,	KM6
UNION ALL SELECT 	476776	--	4	,	KMA
UNION ALL SELECT 	727340	--	4	,	KMAM
UNION ALL SELECT 	877777	--	4	,	KMBM
UNION ALL SELECT 	395075	--	4	,	KMM
UNION ALL SELECT 	13856586	--	4	,	KP
UNION ALL SELECT 	4037357	--	4	,	KPM
UNION ALL SELECT 	12048828	--	4	,	KPW
UNION ALL SELECT 	194356	--	4	,	KR
UNION ALL SELECT 	391601	--	4	,	KRC
UNION ALL SELECT 	461767	--	4	,	KRR
UNION ALL SELECT 	15140611	--	4	,	KRW
UNION ALL SELECT 	3589744	--	4	,	KS6
UNION ALL SELECT 	394310	--	4	,	KSD
UNION ALL SELECT 	1088459	--	4	,	KYH
UNION ALL SELECT 	2026798	--	4	,	KYM
UNION ALL SELECT 	5771986	--	4	,	LA
UNION ALL SELECT 	3770553	--	4	,	LB
UNION ALL SELECT 	3810488	--	4	,	LC
UNION ALL SELECT 	3954915	--	4	,	LD
UNION ALL SELECT 	3973944	--	4	,	LE
UNION ALL SELECT 	4189499	--	4	,	LF
UNION ALL SELECT 	7680679	--	4	,	LG
UNION ALL SELECT 	2749224	--	4	,	LH
UNION ALL SELECT 	16639418	--	4	,	LHA
UNION ALL SELECT 	4374817	--	4	,	LHH
UNION ALL SELECT 	7753979	--	4	,	LHH1
UNION ALL SELECT 	7754066	--	4	,	LHH2
UNION ALL SELECT 	7754182	--	4	,	LHH3
UNION ALL SELECT 	7754251	--	4	,	LHH4
UNION ALL SELECT 	7754301	--	4	,	LHH5
UNION ALL SELECT 	8251316	--	4	,	LHH6
UNION ALL SELECT 	11449326	--	4	,	LHH8
UNION ALL SELECT 	8418095	--	4	,	LHHRMB
UNION ALL SELECT 	5281110	--	4	,	LHI
UNION ALL SELECT 	4445198	--	4	,	LHM
UNION ALL SELECT 	7753114	--	4	,	LHM1
UNION ALL SELECT 	17107778	--	4	,	LHM5
UNION ALL SELECT 	10044015	--	4	,	LHR
UNION ALL SELECT 	8103018	--	4	,	LHS 
UNION ALL SELECT 	4419739	--	4	,	LHU
UNION ALL SELECT 	643456	--	4	,	LI
UNION ALL SELECT 	2075688	--	4	,	LJ
UNION ALL SELECT 	4100631	--	4	,	LK
UNION ALL SELECT 	3556221	--	4	,	LL
UNION ALL SELECT 	3037128	--	3	,	LLKH
UNION ALL SELECT 	4181761	--	4	,	LLP
UNION ALL SELECT 	7680792	--	4	,	LM
UNION ALL SELECT 	5551373	--	4	,	LN
UNION ALL SELECT 	5473265	--	4	,	LS
UNION ALL SELECT 	4367748	--	4	,	LT
UNION ALL SELECT 	2835363	--	4	,	LU
UNION ALL SELECT 	4006796	--	4	,	LV
UNION ALL SELECT 	17681850	--	4	,	LW
UNION ALL SELECT 	3539862	--	4	,	LY
UNION ALL SELECT 	1870568	--	3	,	M033H
UNION ALL SELECT 	724768	--	3	,	M033R
UNION ALL SELECT 	1068024	--	3	,	M113H
UNION ALL SELECT 	3535160	--	3	,	M222M
UNION ALL SELECT 	861326	--	3	,	M252H
UNION ALL SELECT 	371646	--	3	,	M252RMB
UNION ALL SELECT 	2398557	--	4	,	M312T
UNION ALL SELECT 	37457	--	3	,	M318HK
UNION ALL SELECT 	664858	--	3	,	M318RMB
UNION ALL SELECT 	1132163	--	3	,	M32M
UNION ALL SELECT 	252605	--	3	,	M359ARMB
UNION ALL SELECT 	62834	--	3	,	M359RM
UNION ALL SELECT 	68899	--	3	,	M359SD
UNION ALL SELECT 	15515	--	3	,	M39IRMB
UNION ALL SELECT 	419150	--	3	,	M50RM
UNION ALL SELECT 	398333	--	3	,	M58SD
UNION ALL SELECT 	865472	--	3	,	M606HK
UNION ALL SELECT 	8546807	--	3	,	M62AH
UNION ALL SELECT 	4234220	--	3	,	M62H
UNION ALL SELECT 	8226535	--	3	,	M62R
UNION ALL SELECT 	9671179	--	3	,	m62rb
UNION ALL SELECT 	3080124	--	3	,	M62SD
UNION ALL SELECT 	15219	--	3	,	M6HK
UNION ALL SELECT 	947130	--	3	,	M6RM
UNION ALL SELECT 	47030	--	3	,	M6SD
UNION ALL SELECT 	1114738	--	3	,	M79CR
UNION ALL SELECT 	4712010	--	3	,	M7RRMB
UNION ALL SELECT 	905394	--	3	,	M818H
UNION ALL SELECT 	2002448	--	3	,	M818R
UNION ALL SELECT 	3686314	--	3	,	M818RA
UNION ALL SELECT 	449152	--	3	,	M83ARM
UNION ALL SELECT 	4012300	--	3	,	M83H
UNION ALL SELECT 	43272	--	3	,	M83RM
UNION ALL SELECT 	78703	--	3	,	M863HK
UNION ALL SELECT 	1111628	--	3	,	M8H
UNION ALL SELECT 	8009	--	3	,	M8HK
UNION ALL SELECT 	1336489	--	3	,	M922M
UNION ALL SELECT 	33903	--	3	,	M96RM
UNION ALL SELECT 	157597	--	3	,	M98HK
UNION ALL SELECT 	73166	--	3	,	M98RM
UNION ALL SELECT 	588296	--	3	,	M98ZR
UNION ALL SELECT 	854753	--	4	,	M99RMB
UNION ALL SELECT 	8266979	--	3	,	MALM
UNION ALL SELECT 	27026	--	3	,	MAMRM
UNION ALL SELECT 	1773803	--	4	,	MC
UNION ALL SELECT 	1773805	--	4	,	MC1
UNION ALL SELECT 	2308589	--	4	,	MC2
UNION ALL SELECT 	10506715	--	4	,	MC3
UNION ALL SELECT 	15805514	--	4	,	MC5
UNION ALL SELECT 	4144525	--	4	,	MCR
UNION ALL SELECT 	16737515	--	4	,	MD
UNION ALL SELECT 	11548722	--	4	,	MH
UNION ALL SELECT 	4339887	--	3	,	MHK8
UNION ALL SELECT 	4600902	--	3	,	MHK9
UNION ALL SELECT 	997137	--	4	,	MK1
UNION ALL SELECT 	1074882	--	4	,	MK10
UNION ALL SELECT 	1074884	--	4	,	MK11C
UNION ALL SELECT 	998346	--	4	,	MK4C
UNION ALL SELECT 	997155	--	4	,	MK6
UNION ALL SELECT 	17299936	--	4	,	MKHA
UNION ALL SELECT 	3715080	--	4	,	MKI
UNION ALL SELECT 	1606473	--	4	,	MKM1
UNION ALL SELECT 	1437908	--	4	,	MKS
UNION ALL SELECT 	12294019	--	4	,	MKS1
UNION ALL SELECT 	1539908	--	4	,	MKTB
UNION ALL SELECT 	2026854	--	3	,	MKYM
UNION ALL SELECT 	8550141	--	4	,	MLH
UNION ALL SELECT 	1581733	--	4	,	MM
UNION ALL SELECT 	5664	--	3	,	MMMRM
UNION ALL SELECT 	11674030	--	4	,	MP
UNION ALL SELECT 	3144085	--	3	,	MPH
UNION ALL SELECT 	561153	--	3	,	MPTRMB
UNION ALL SELECT 	214696	--	3	,	MPTUS
UNION ALL SELECT 	156071	--	3	,	MQARM
UNION ALL SELECT 	121951	--	3	,	MQRM
UNION ALL SELECT 	2486485	--	3	,	MSFR
UNION ALL SELECT 	6321	--	3	,	MSRMB
UNION ALL SELECT 	6032879	--	4	,	PPB
UNION ALL SELECT 	2394977	--	4	,	PPH
UNION ALL SELECT 	17568160	--	4	,	PPJ
UNION ALL SELECT 	3574705	--	4	,	PPM
UNION ALL SELECT 	6032912	--	4	,	PPR
UNION ALL SELECT 	17550987	--	4	,	PPS
UNION ALL SELECT 	3150153	--	4	,	PTM
UNION ALL SELECT 	1349398	--	4	,	QQ
UNION ALL SELECT 	12957917	--	4	,	QQBS
UNION ALL SELECT 	11884796	--	4	,	QQHK
UNION ALL SELECT 	7763719	--	4	,	QQK3
UNION ALL SELECT 	7756579	--	4	,	QQKA
UNION ALL SELECT 	15984489	--	4	,	QQKH
UNION ALL SELECT 	12573245	--	4	,	QQKY
UNION ALL SELECT 	7756637	--	4	,	QQMA
UNION ALL SELECT 	10848683	--	4	,	QQMR
UNION ALL SELECT 	7756603	--	4	,	QQMW
UNION ALL SELECT 	7756631	--	4	,	QQMY
UNION ALL SELECT 	7756563	--	4	,	QQMZ
UNION ALL SELECT 	9934169	--	4	,	QQTB
UNION ALL SELECT 	8243036	--	4	,	R312R
UNION ALL SELECT 	17787564	--	4	,	R313R
UNION ALL SELECT 	19485465	--	4	,	R313T
UNION ALL SELECT 	19466231	--	4	,	R313Y
UNION ALL SELECT 	15825686	--	4	,	RB168
UNION ALL SELECT 	18803268	--	4	,	RMB
UNION ALL SELECT 	1586764	--	4	,	RR
UNION ALL SELECT 	1867721	--	4	,	S09H
UNION ALL SELECT 	5005322	--	4	,	S09M
UNION ALL SELECT 	1435492	--	4	,	S120R
UNION ALL SELECT 	15682765	--	4	,	S120S
UNION ALL SELECT 	3391041	--	4	,	S121R
UNION ALL SELECT 	8145099	--	4	,	S122R
UNION ALL SELECT 	12545786	--	4	,	S123R
UNION ALL SELECT 	13885989	--	4	,	S124R
UNION ALL SELECT 	524760	--	4	,	S16RUP
UNION ALL SELECT 	15583137	--	4	,	S222N
UNION ALL SELECT 	560429	--	4	,	S222R
UNION ALL SELECT 	979900	--	4	,	S23H
UNION ALL SELECT 	17074641	--	4	,	S23M
UNION ALL SELECT 	2193103	--	4	,	S23S
UNION ALL SELECT 	17723529	--	4	,	S26M
UNION ALL SELECT 	3752852	--	4	,	S27A
UNION ALL SELECT 	1001999	--	4	,	S27HK
UNION ALL SELECT 	7945539	--	4	,	S27TK
UNION ALL SELECT 	356937	--	4	,	S305CRMB
UNION ALL SELECT 	752203	--	4	,	S305R
UNION ALL SELECT 	404941	--	4	,	S305RM
UNION ALL SELECT 	9672019	--	4	,	S312C
UNION ALL SELECT 	17520621	--	4	,	S312G
UNION ALL SELECT 	17469607	--	4	,	S312H
UNION ALL SELECT 	2969567	--	4	,	S312R
UNION ALL SELECT 	12589170	--	4	,	S312RMB
UNION ALL SELECT 	771942	--	4	,	S31ARMB
UNION ALL SELECT 	7754654	--	4	,	S31BRM
UNION ALL SELECT 	408317	--	4	,	S31RM
UNION ALL SELECT 	478396	--	4	,	S31RMB
UNION ALL SELECT 	987495	--	4	,	S32AH
UNION ALL SELECT 	1456420	--	4	,	S32AM
UNION ALL SELECT 	987497	--	4	,	S32BH
UNION ALL SELECT 	3654316	--	4	,	S32BM
UNION ALL SELECT 	987499	--	4	,	S32CH
UNION ALL SELECT 	17931860	--	4	,	S32CM
UNION ALL SELECT 	987501	--	4	,	S32DH
UNION ALL SELECT 	1366843	--	4	,	S32FH
UNION ALL SELECT 	857802	--	4	,	S32H
UNION ALL SELECT 	2284508	--	4	,	S32HH
UNION ALL SELECT 	5349816	--	4	,	S32HK
UNION ALL SELECT 	15657898	--	4	,	S32HKD
UNION ALL SELECT 	2838764	--	4	,	S32IH
UNION ALL SELECT 	3195166	--	4	,	S32JH
UNION ALL SELECT 	15548698	--	4	,	S32K
UNION ALL SELECT 	19075657	--	4	,	S32KK
UNION ALL SELECT 	1452602	--	4	,	S32M
UNION ALL SELECT 	753492	--	4	,	S32R
UNION ALL SELECT 	15657985	--	4	,	S32RM
UNION ALL SELECT 	324558	--	4	,	S32RMB
UNION ALL SELECT 	18393844	--	4	,	S33A
UNION ALL SELECT 	335748	--	4	,	S33AR
UNION ALL SELECT 	463659	--	4	,	S33BR
UNION ALL SELECT 	484809	--	4	,	S33CR
UNION ALL SELECT 	211567	--	4	,	S33E
UNION ALL SELECT 	211566	--	4	,	S33M
UNION ALL SELECT 	390561	--	4	,	S33MR
UNION ALL SELECT 	211568	--	4	,	S33R
UNION ALL SELECT 	431696	--	4	,	S33S
UNION ALL SELECT 	390567	--	4	,	S33SM
UNION ALL SELECT 	9934485	--	4	,	S33T
UNION ALL SELECT 	7753071	--	4	,	S359am
UNION ALL SELECT 	7772139	--	4	,	S359CM
UNION ALL SELECT 	6385611	--	4	,	S359M
UNION ALL SELECT 	7186058	--	4	,	S359S
UNION ALL SELECT 	344472	--	4	,	S39R
UNION ALL SELECT 	2601912	--	4	,	S39RR
UNION ALL SELECT 	972747	--	4	,	S3H
UNION ALL SELECT 	3560324	--	4	,	S3HH
UNION ALL SELECT 	7763508	--	4	,	S3HK
UNION ALL SELECT 	2926808	--	4	,	S41H
UNION ALL SELECT 	1690565	--	4	,	S41M
UNION ALL SELECT 	1690560	--	4	,	S41S
UNION ALL SELECT 	1036451	--	4	,	S42AH
UNION ALL SELECT 	2428032	--	4	,	S42ARM
UNION ALL SELECT 	1290422	--	4	,	S42BH
UNION ALL SELECT 	1652112	--	4	,	S42CH
UNION ALL SELECT 	4672707	--	4	,	S42D
UNION ALL SELECT 	1749600	--	4	,	S42DH
UNION ALL SELECT 	1022404	--	4	,	S42H
UNION ALL SELECT 	3513305	--	4	,	S42M
UNION ALL SELECT 	817188	--	4	,	S42RM
UNION ALL SELECT 	1207541	--	4	,	S42S
UNION ALL SELECT 	8270016	--	4	,	S43H
UNION ALL SELECT 	3019886	--	4	,	S43S
UNION ALL SELECT 	5831527	--	4	,	S49H
UNION ALL SELECT 	877004	--	4	,	S49R
UNION ALL SELECT 	426131	--	4	,	S49RM
UNION ALL SELECT 	4151114	--	4	,	S50R
UNION ALL SELECT 	528691	--	4	,	S50RMB
UNION ALL SELECT 	3592236	--	4	,	S51AH
UNION ALL SELECT 	3592237	--	4	,	S51BH
UNION ALL SELECT 	3592239	--	4	,	S51CH
UNION ALL SELECT 	3801635	--	4	,	S51DH
UNION ALL SELECT 	1349148	--	4	,	S51H
UNION ALL SELECT 	7301563	--	4	,	S51HA
UNION ALL SELECT 	835299	--	4	,	S51R
UNION ALL SELECT 	695131	--	4	,	S51SM
UNION ALL SELECT 	9933834	--	4	,	S51TB
UNION ALL SELECT 	1755451	--	4	,	S553H
UNION ALL SELECT 	4910597	--	4	,	S555
UNION ALL SELECT 	12785073	--	4	,	S56A
UNION ALL SELECT 	15689281	--	4	,	S56AE
UNION ALL SELECT 	838203	--	4	,	S56AH
UNION ALL SELECT 	8062488	--	4	,	S56AI
UNION ALL SELECT 	15904288	--	4	,	S56ASD
UNION ALL SELECT 	838210	--	4	,	S56BBH
UNION ALL SELECT 	550155	--	4	,	S56BRM
UNION ALL SELECT 	838370	--	4	,	S56CH
UNION ALL SELECT 	826317	--	4	,	S56CRM
UNION ALL SELECT 	3681857	--	4	,	S56D
UNION ALL SELECT 	877770	--	4	,	S56DRM
UNION ALL SELECT 	877768	--	4	,	S56EH
UNION ALL SELECT 	1031455	--	4	,	S56GH
UNION ALL SELECT 	838201	--	4	,	S56H
UNION ALL SELECT 	844818	--	4	,	S56HH
UNION ALL SELECT 	1219867	--	4	,	S56HK
UNION ALL SELECT 	1194960	--	4	,	S56KH
UNION ALL SELECT 	5311452	--	4	,	S56KK
UNION ALL SELECT 	3775566	--	4	,	S56NH
UNION ALL SELECT 	3775579	--	4	,	S56PH
UNION ALL SELECT 	4356717	--	4	,	S56QH
UNION ALL SELECT 	461775	--	4	,	S56R
UNION ALL SELECT 	405017	--	4	,	S56RM
UNION ALL SELECT 	1537688	--	4	,	S56TH
UNION ALL SELECT 	687425	--	4	,	S57R
UNION ALL SELECT 	461780	--	4	,	S58R
UNION ALL SELECT 	405422	--	4	,	S58RM
UNION ALL SELECT 	1576179	--	4	,	S60AR
UNION ALL SELECT 	510159	--	4	,	S60RUP
UNION ALL SELECT 	9727438	--	4	,	S62D
UNION ALL SELECT 	1720567	--	4	,	S62H
UNION ALL SELECT 	3149272	--	4	,	S62M
UNION ALL SELECT 	4910667	--	4	,	S666
UNION ALL SELECT 	901840	--	4	,	S688H
UNION ALL SELECT 	2509713	--	4	,	S688M
UNION ALL SELECT 	959157	--	4	,	S688T
UNION ALL SELECT 	17961935	--	4	,	S6AHK
UNION ALL SELECT 	835418	--	4	,	S6ARUP
UNION ALL SELECT 	5711971	--	4	,	S6BP
UNION ALL SELECT 	8539195	--	4	,	s6cn
UNION ALL SELECT 	527906	--	4	,	S6EU
UNION ALL SELECT 	3676675	--	4	,	S6H
UNION ALL SELECT 	9735627	--	4	,	S6KW
UNION ALL SELECT 	12665939	--	4	,	S6P
UNION ALL SELECT 	11660213	--	4	,	S6RMB
UNION ALL SELECT 	549191	--	4	,	S6RUP
UNION ALL SELECT 	17537176	--	4	,	S6T
UNION ALL SELECT 	706886	--	4	,	S6US
UNION ALL SELECT 	16189265	--	4	,	S777
UNION ALL SELECT 	914839	--	4	,	S788H
UNION ALL SELECT 	987102	--	4	,	S799H
UNION ALL SELECT 	900371	--	4	,	S79AHH
UNION ALL SELECT 	592998	--	4	,	S79AR
UNION ALL SELECT 	3360316	--	4	,	S79C
UNION ALL SELECT 	836410	--	4	,	S79H
UNION ALL SELECT 	1859089	--	4	,	S79HG
UNION ALL SELECT 	935097	--	4	,	S79HH
UNION ALL SELECT 	2775382	--	4	,	S79HS
UNION ALL SELECT 	2188063	--	4	,	S79hz
UNION ALL SELECT 	729244	--	4	,	S79R
UNION ALL SELECT 	356941	--	4	,	s79rrr
UNION ALL SELECT 	989898	--	4	,	S79SH
UNION ALL SELECT 	7374379	--	4	,	S7D
UNION ALL SELECT 	10910070	--	4	,	S7KW
UNION ALL SELECT 	18579015	--	4	,	S7RR
UNION ALL SELECT 	3671274	--	4	,	S80H
UNION ALL SELECT 	356942	--	4	,	S80R
UNION ALL SELECT 	16287301	--	4	,	S85A
UNION ALL SELECT 	882592	--	4	,	S85BR
UNION ALL SELECT 	15140845	--	4	,	S85GTH
UNION ALL SELECT 	1050206	--	4	,	S85H
UNION ALL SELECT 	843526	--	4	,	S85R
UNION ALL SELECT 	1108229	--	4	,	S85S
UNION ALL SELECT 	4138910	--	4	,	S863R
UNION ALL SELECT 	14663748	--	4	,	S88ML
UNION ALL SELECT 	1402421	--	4	,	S90AR
UNION ALL SELECT 	10507013	--	4	,	S90C
UNION ALL SELECT 	7923118	--	4	,	S90H
UNION ALL SELECT 	523974	--	4	,	S90R
UNION ALL SELECT 	1788033	--	4	,	S922K
UNION ALL SELECT 	1342397	--	4	,	S922M
UNION ALL SELECT 	4913546	--	4	,	S922MA
UNION ALL SELECT 	5519726	--	4	,	S922R
UNION ALL SELECT 	1266057	--	4	,	S96h
UNION ALL SELECT 	10599405	--	4	,	S989H
UNION ALL SELECT 	7817620	--	4	,	S989M
UNION ALL SELECT 	2869345	--	4	,	S989R
UNION ALL SELECT 	12515436	--	4	,	S98E
UNION ALL SELECT 	1008234	--	4	,	S98H
UNION ALL SELECT 	12653798	--	4	,	S98K
UNION ALL SELECT 	477659	--	4	,	S98R
UNION ALL SELECT 	4022510	--	4	,	S99ah
UNION ALL SELECT 	15229780	--	4	,	S99D
UNION ALL SELECT 	18929915	--	4	,	S99E
UNION ALL SELECT 	859594	--	4	,	S99H
UNION ALL SELECT 	7604170	--	4	,	S99HKD
UNION ALL SELECT 	11471646	--	4	,	S99K
UNION ALL SELECT 	1448199	--	4	,	S99M
UNION ALL SELECT 	912272	--	4	,	S99TB
UNION ALL SELECT 	9925322	--	4	,	S99TH
UNION ALL SELECT 	16026037	--	4	,	S99V
UNION ALL SELECT 	14084827	--	4	,	S99W
UNION ALL SELECT 	17200168	--	4	,	S9EU
UNION ALL SELECT 	4554012	--	4	,	S9H
UNION ALL SELECT 	18015222	--	4	,	S9KK
UNION ALL SELECT 	17583600	--	4	,	S9KS
UNION ALL SELECT 	15530229	--	4	,	S9KW
UNION ALL SELECT 	691884	--	4	,	S9M
UNION ALL SELECT 	2421122	--	4	,	SABT
UNION ALL SELECT 	4744473	--	4	,	SADA
UNION ALL SELECT 	970269	--	4	,	SALH
UNION ALL SELECT 	447479	--	4	,	SALR
UNION ALL SELECT 	1456925	--	4	,	SAMR
UNION ALL SELECT 	5283781	--	4	,	SATE
UNION ALL SELECT 	7781015	--	4	,	SATM
UNION ALL SELECT 	2229262	--	4	,	SATU
UNION ALL SELECT 	4320374	--	4	,	SB
UNION ALL SELECT 	955286	--	4	,	SB8R
UNION ALL SELECT 	1795270	--	4	,	SBBR
UNION ALL SELECT 	1558372	--	4	,	SBBT
UNION ALL SELECT 	805450	--	4	,	SBHK
UNION ALL SELECT 	595962	--	4	,	SBKH
UNION ALL SELECT 	324336	--	4	,	SBKHK
UNION ALL SELECT 	324557	--	4	,	SCHK
UNION ALL SELECT 	2285864	--	4	,	SCI
UNION ALL SELECT 	398615	--	4	,	SCM
UNION ALL SELECT 	398636	--	4	,	SCS
UNION ALL SELECT 	984549	--	4	,	SDH
UNION ALL SELECT 	6621107	--	4	,	SDHA
UNION ALL SELECT 	776702	--	4	,	SDR
UNION ALL SELECT 	410722	--	4	,	SDRM
UNION ALL SELECT 	479690	--	4	,	SDRMB
UNION ALL SELECT 	3139575	--	4	,	SF8
UNION ALL SELECT 	2327638	--	4	,	SFB
UNION ALL SELECT 	840993	--	4	,	SG1H
UNION ALL SELECT 	3237241	--	4	,	SG1R
UNION ALL SELECT 	4181669	--	4	,	SG21H
UNION ALL SELECT 	4383797	--	4	,	SG23H
UNION ALL SELECT 	4780138	--	4	,	SG25H
UNION ALL SELECT 	5334790	--	4	,	SG26H
UNION ALL SELECT 	6457243	--	4	,	SG28h
UNION ALL SELECT 	840999	--	4	,	SG2H
UNION ALL SELECT 	4487258	--	4	,	SG2M
UNION ALL SELECT 	10719518	--	4	,	SG33H
UNION ALL SELECT 	5334777	--	4	,	SG3M
UNION ALL SELECT 	1927603	--	4	,	SG6H
UNION ALL SELECT 	7680993	--	4	,	SG7M
UNION ALL SELECT 	8119630	--	4	,	SG8M
UNION ALL SELECT 	7939911	--	4	,	SGGT
UNION ALL SELECT 	832992	--	4	,	SGH
UNION ALL SELECT 	398437	--	4	,	SGM
UNION ALL SELECT 	399130	--	4	,	SGR
UNION ALL SELECT 	11314815	--	4	,	SGRD
UNION ALL SELECT 	324561	--	4	,	SGURMB
UNION ALL SELECT 	185849	--	4	,	SI
UNION ALL SELECT 	3451110	--	4	,	SJH
UNION ALL SELECT 	19240555	--	4	,	SJJM
UNION ALL SELECT 	787938	--	4	,	SJM
UNION ALL SELECT 	12575535	--	4	,	SJSD
UNION ALL SELECT 	506057	--	4	,	SKPRMB
UNION ALL SELECT 	5601008	--	4	,	SLD
UNION ALL SELECT 	7757274	--	4	,	SLG
UNION ALL SELECT 	2178402	--	4	,	SLH
UNION ALL SELECT 	3872549	--	4	,	SLJ
UNION ALL SELECT 	7768121	--	4	,	SLL
UNION ALL SELECT 	5473299	--	4	,	SLM
UNION ALL SELECT 	1265902	--	4	,	SMAMRMB
UNION ALL SELECT 	2278343	--	4	,	SMBH
UNION ALL SELECT 	13294314	--	4	,	SMCH
UNION ALL SELECT 	984745	--	4	,	SMH
UNION ALL SELECT 	398467	--	4	,	SMM
UNION ALL SELECT 	984746	--	4	,	SMMH
UNION ALL SELECT 	1211027	--	4	,	SMMS
UNION ALL SELECT 	7146892	--	4	,	SMOC
UNION ALL SELECT 	8330307	--	4	,	SMOCNY
UNION ALL SELECT 	15588279	--	4	,	SMOI
UNION ALL SELECT 	407649	--	4	,	SMORM
UNION ALL SELECT 	324564	--	4	,	SMORMB
UNION ALL SELECT 	15516774	--	4	,	SNI
UNION ALL SELECT 	32422	--	2	,	SORM
UNION ALL SELECT 	301152	--	4	,	SPH
UNION ALL SELECT 	261425	--	4	,	SPR
UNION ALL SELECT 	14210898	--	4	,	SQHH
UNION ALL SELECT 	837905	--	4	,	SSF1H
UNION ALL SELECT 	1013342	--	4	,	SSF2H
UNION ALL SELECT 	2332356	--	4	,	SSF3H
UNION ALL SELECT 	4362130	--	4	,	SSF5H
UNION ALL SELECT 	837904	--	4	,	SSFH
UNION ALL SELECT 	2823274	--	4	,	SSFK
UNION ALL SELECT 	1416231	--	4	,	SSS
UNION ALL SELECT 	2192160	--	4	,	SSSD
UNION ALL SELECT 	641144	--	4	,	ST2T
UNION ALL SELECT 	2388779	--	4	,	STEB
UNION ALL SELECT 	16645316	--	4	,	SVE
UNION ALL SELECT 	490037	--	4	,	SVM
UNION ALL SELECT 	7758309	--	4	,	SVP
UNION ALL SELECT 	490215	--	4	,	SVR
UNION ALL SELECT 	10933415	--	4	,	SVVG
UNION ALL SELECT 	867735	--	4	,	SW
UNION ALL SELECT 	4601030	--	4	,	SYI
UNION ALL SELECT 	16694213	--	4	,	TA
UNION ALL SELECT 	406808	--	4	,	TAS51S
UNION ALL SELECT 	13348258	--	3	,	TG1
UNION ALL SELECT 	13348483	--	3	,	TG2
UNION ALL SELECT 	13348378	--	3	,	TG3
UNION ALL SELECT 	13348559	--	3	,	TG4
UNION ALL SELECT 	4253518	--	4	,	TH28
UNION ALL SELECT 	5402188	--	4	,	THM
UNION ALL SELECT 	9727510	--	4	,	TP
UNION ALL SELECT 	17797342	--	4	,	TS1
UNION ALL SELECT 	17797400	--	4	,	TS2
UNION ALL SELECT 	17820768	--	4	,	TS3
UNION ALL SELECT 	14405674	--	4	,	TWS
UNION ALL SELECT 	4677011	--	4	,	UA
UNION ALL SELECT 	4677048	--	4	,	UB
UNION ALL SELECT 	6660386	--	4	,	UD
UNION ALL SELECT 	5773292	--	4	,	UE
UNION ALL SELECT 	10278914	--	4	,	UF
UNION ALL SELECT 	14118357	--	4	,	UG
UNION ALL SELECT 	11010588	--	4	,	UH
UNION ALL SELECT 	656135	--	4	,	UI
UNION ALL SELECT 	4048531	--	4	,	UK
UNION ALL SELECT 	4323575	--	4	,	UL
UNION ALL SELECT 	4253707	--	4	,	UM
UNION ALL SELECT 	4320399	--	4	,	UN
UNION ALL SELECT 	16787471	--	4	,	SVA
UNION ALL SELECT 	3965567	--	4	,	UT
UNION ALL SELECT 	3909347	--	4	,	UU
UNION ALL SELECT 	7277118	--	4	,	UV
UNION ALL SELECT 	7177766	--	4	,	UW
UNION ALL SELECT 	14956535	--	4	,	UY
UNION ALL SELECT 	10797628	--	4	,	UZ
UNION ALL SELECT 	15424123	--	4	,	VA
UNION ALL SELECT 	4548911	--	4	,	VC
UNION ALL SELECT 	14773243	--	4	,	VE
UNION ALL SELECT 	5957920	--	4	,	VF
UNION ALL SELECT 	15485426	--	4	,	VG
UNION ALL SELECT 	13478477	--	4	,	VI
UNION ALL SELECT 	17916695	--	4	,	VJ
UNION ALL SELECT 	10398791	--	4	,	VKH
UNION ALL SELECT 	5938255	--	4	,	VM
UNION ALL SELECT 	8284552	--	4	,	VO
UNION ALL SELECT 	9514014	--	4	,	VP
UNION ALL SELECT 	10927694	--	4	,	VQ
UNION ALL SELECT 	5778932	--	4	,	VVG
UNION ALL SELECT 	4739346	--	4	,	WB
UNION ALL SELECT 	3411725	--	3	,	WBR
UNION ALL SELECT 	4673332	--	3	,	WBRA
UNION ALL SELECT 	6853841	--	3	,	wbrf
UNION ALL SELECT 	11485599	--	3	,	WBRG
UNION ALL SELECT 	11485623	--	3	,	WBRH
UNION ALL SELECT 	11485641	--	3	,	WBRI
UNION ALL SELECT 	11485655	--	3	,	WBRJ
UNION ALL SELECT 	4348440	--	3	,	WBRR
UNION ALL SELECT 	3498094	--	4	,	WD1
UNION ALL SELECT 	5358729	--	4	,	WDR
UNION ALL SELECT 	18747621	--	4	,	WG
UNION ALL SELECT 	3919061	--	4	,	WH
UNION ALL SELECT 	1124040	--	4	,	WI
UNION ALL SELECT 	18364243	--	4	,	WJ
UNION ALL SELECT 	1457236	--	4	,	WKH
UNION ALL SELECT 	11761289	--	4	,	WPR
UNION ALL SELECT 	720475	--	4	,	WW
UNION ALL SELECT 	14015187	--	4	,	XCN
UNION ALL SELECT 	17058130	--	4	,	XKS
UNION ALL SELECT 	10529214	--	4	,	YHA
UNION ALL SELECT 	2270259	--	4	,	YI
UNION ALL SELECT 	16016306	--	4	,	YM
UNION ALL SELECT 	4622387	--	4	,	YN
UNION ALL SELECT 	5532706	--	4	,	ZZ		



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
 

