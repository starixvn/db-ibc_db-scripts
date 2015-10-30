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

--677 customers
INSERT INTO ##tmpCust(custid)
		select 	16129	--	2	7899HK
union all select 	4204369	--	4	79AR
union all select 	1528422	--	4	B11T
union all select 	1538183	--	4	B15T
union all select 	1539009	--	4	B17T
union all select 	1539698	--	4	B19T
union all select 	1539699	--	4	B20T
union all select 	1539700	--	4	B21T
union all select 	1540216	--	4	B22T
union all select 	1540217	--	4	B23T
union all select 	1588145	--	4	B25T
union all select 	2508822	--	4	B26T
union all select 	1528410	--	4	B2T
union all select 	9934001	--	4	B34T
union all select 	9933940	--	4	B35T
union all select 	1528413	--	4	B4T
union all select 	1528414	--	4	B6T
union all select 	1528418	--	4	B7T
union all select 	1528419	--	4	B8T
union all select 	1528420	--	4	B9T
union all select 	2221671	--	4	BHO
union all select 	642291	--	4	BI
union all select 	5994	--	3	CHTB
union all select 	1373748	--	4	FF
union all select 	641918	--	4	HI
union all select 	1029732	--	4	HJ
union all select 	9931047	--	4	HT1
union all select 	9933782	--	4	HT2
union all select 	1220879	--	4	JAT
union all select 	726582	--	4	KAM
union all select 	726562	--	4	KAR
union all select 	726571	--	4	KBR
union all select 	726579	--	4	KCR
union all select 	712272	--	4	KHK
union all select 	1537683	--	4	KHT
union all select 	194354	--	4	KM
union all select 	3589738	--	4	KM6
union all select 	727340	--	4	KMAM
union all select 	194356	--	4	KR
union all select 	3589744	--	4	KS6
union all select 	394310	--	4	KSD
union all select 	7754251	--	4	LHH4
union all select 	7754301	--	4	LHH5
union all select 	1068024	--	3	M113H
union all select 	664858	--	3	M318RMB
union all select 	15515	--	3	M39IRMB
union all select 	865472	--	3	M606HK
union all select 	1074884	--	4	MK11C
union all select 	997155	--	4	MK6
union all select 	1539908	--	4	MKTB
union all select 	2026854	--	3	MKYM
union all select 	5664	--	3	MMMRM
union all select 	561153	--	3	MPTRMB
union all select 	156071	--	3	MQARM
union all select 	6321	--	3	MSRMB
union all select 	12573245	--	4	QQKY
union all select 	7756603	--	4	QQMW
union all select 	7756631	--	4	QQMY
union all select 	7756563	--	4	QQMZ
union all select 	9934169	--	4	QQTB
union all select 	356937	--	4	S305CRMB
union all select 	752203	--	4	S305R
union all select 	404941	--	4	S305RM
union all select 	7754654	--	4	S31BRM
union all select 	478396	--	4	S31RMB
union all select 	987495	--	4	S32AH
union all select 	987497	--	4	S32BH
union all select 	987499	--	4	S32CH
union all select 	987501	--	4	S32DH
union all select 	753492	--	4	S32R
union all select 	324558	--	4	S32RMB
union all select 	211567	--	4	S33E
union all select 	211566	--	4	S33M
union all select 	390561	--	4	S33MR
union all select 	211568	--	4	S33R
union all select 	390567	--	4	S33SM
union all select 	9934485	--	4	S33T
union all select 	7753071	--	4	S359am
union all select 	972747	--	4	S3H
union all select 	3560324	--	4	S3HH
union all select 	1207541	--	4	S42S
union all select 	3592236	--	4	S51AH
union all select 	3592237	--	4	S51BH
union all select 	3592239	--	4	S51CH
union all select 	9933834	--	4	S51TB
union all select 	838203	--	4	S56AH
union all select 	550155	--	4	S56BRM
union all select 	838370	--	4	S56CH
union all select 	877770	--	4	S56DRM
union all select 	877768	--	4	S56EH
union all select 	838201	--	4	S56H
union all select 	3775579	--	4	S56PH
union all select 	461775	--	4	S56R
union all select 	405017	--	4	S56RM
union all select 	1537688	--	4	S56TH
union all select 	405422	--	4	S58RM
union all select 	356942	--	4	S80R
union all select 	882592	--	4	S85BR
union all select 	843526	--	4	S85R
union all select 	4138910	--	4	S863R
union all select 	1108229	--	4	S85S
union all select 	1050206	--	4	S85H
union all select 	3671274	--	4	S80H
union all select 	7374379	--	4	S7D
union all select 	914839	--	4	S788H
union all select 	959157	--	4	S688T
union all select 	2509713	--	4	S688M
union all select 	901840	--	4	S688H
union all select 	4910667	--	4	S666
union all select 	3149272	--	4	S62M
union all select 	1720567	--	4	S62H
union all select 	510159	--	4	S60RUP
union all select 	1576179	--	4	S60AR
union all select 	461780	--	4	S58R
union all select 	687425	--	4	S57R
union all select 	4356717	--	4	S56QH
union all select 	477659	--	4	S98R
union all select 	3775566	--	4	S56NH
union all select 	1194960	--	4	S56KH
union all select 	1219867	--	4	S56HK
union all select 	859594	--	4	S99H
union all select 	844818	--	4	S56HH
union all select 	1031455	--	4	S56GH
union all select 	3681857	--	4	S56D
union all select 	826317	--	4	S56CRM
union all select 	9925322	--	4	S99TH
union all select 	838210	--	4	S56BBH
union all select 	8062488	--	4	S56AI
union all select 	4554012	--	4	S9H
union all select 	15689281	--	4	S56AE
union all select 	4910597	--	4	S555
union all select 	1755451	--	4	S553H
union all select 	695131	--	4	S51SM
union all select 	835299	--	4	S51R
union all select 	1349148	--	4	S51H
union all select 	3801635	--	4	S51DH
union all select 	528691	--	4	S50RMB
union all select 	4151114	--	4	S50R
union all select 	426131	--	4	S49RM
union all select 	877004	--	4	S49R
union all select 	3019886	--	4	S43S
union all select 	817188	--	4	S42RM
union all select 	1022404	--	4	S42H
union all select 	1749600	--	4	S42DH
union all select 	324336	--	4	SBKHK
union all select 	324557	--	4	SCHK
union all select 	4672707	--	4	S42D
union all select 	398615	--	4	SCM
union all select 	398636	--	4	SCS
union all select 	1652112	--	4	S42CH
union all select 	1290422	--	4	S42BH
union all select 	776702	--	4	SDR
union all select 	410722	--	4	SDRM
union all select 	479690	--	4	SDRMB
union all select 	1036451	--	4	S42AH
union all select 	1690560	--	4	S41S
union all select 	1690565	--	4	S41M
union all select 	2926808	--	4	S41H
union all select 	4181669	--	4	SG21H
union all select 	7763508	--	4	S3HK
union all select 	2601912	--	4	S39RR
union all select 	5334790	--	4	SG26H
union all select 	344472	--	4	S39R
union all select 	840999	--	4	SG2H
union all select 	431696	--	4	S33S
union all select 	484809	--	4	S33CR
union all select 	5334777	--	4	SG3M
union all select 	463659	--	4	S33BR
union all select 	7680993	--	4	SG7M
union all select 	335748	--	4	S33AR
union all select 	15657985	--	4	S32RM
union all select 	1452602	--	4	S32M
union all select 	398437	--	4	SGM
union all select 	399130	--	4	SGR
union all select 	19075657	--	4	S32KK
union all select 	324561	--	4	SGURMB
union all select 	2838764	--	4	S32IH
union all select 	2284508	--	4	S32HH
union all select 	857802	--	4	S32H
union all select 	1366843	--	4	S32FH
union all select 	3654316	--	4	S32BM
union all select 	1456420	--	4	S32AM
union all select 	408317	--	4	S31RM
union all select 	771942	--	4	S31ARMB
union all select 	9672019	--	4	S312C
union all select 	3872549	--	4	SLJ
union all select 	1001999	--	4	S27HK
union all select 	5473299	--	4	SLM
union all select 	3752852	--	4	S27A
union all select 	17723529	--	4	S26M
union all select 	2193103	--	4	S23S
union all select 	984745	--	4	SMH
union all select 	398467	--	4	SMM
union all select 	984746	--	4	SMMH
union all select 	1211027	--	4	SMMS
union all select 	979900	--	4	S23H
union all select 	524760	--	4	S16RUP
union all select 	8145099	--	4	S122R
union all select 	1435492	--	4	S120R
union all select 	324564	--	4	SMORMB
union all select 	1867721	--	4	S09H
union all select 	32422	--	2	SORM
union all select 	1586764	--	4	RR
union all select 	8243036	--	4	R312R
union all select 	10848683	--	4	QQMR
union all select 	837905	--	4	SSF1H
union all select 	7756637	--	4	QQMA
union all select 	7756579	--	4	QQKA
union all select 	12957917	--	4	QQBS
union all select 	837904	--	4	SSFH
union all select 	1349398	--	4	QQ
union all select 	6032912	--	4	PPR
union all select 	3574705	--	4	PPM
union all select 	2394977	--	4	PPH
union all select 	2486485	--	3	MSFR
union all select 	121951	--	3	MQRM
union all select 	214696	--	3	MPTUS
union all select 	1581733	--	4	MM
union all select 	8550141	--	4	MLH
union all select 	1606473	--	4	MKM1
union all select 	3715080	--	4	MKI
union all select 	998346	--	4	MK4C
union all select 	1074882	--	4	MK10
union all select 	997137	--	4	MK1
union all select 	406808	--	4	TAS51S
union all select 	11548722	--	4	MH
union all select 	4144525	--	4	MCR
union all select 	2308589	--	4	MC2
union all select 	1773805	--	4	MC1
union all select 	1773803	--	4	MC
union all select 	5402188	--	4	THM
union all select 	27026	--	3	MAMRM
union all select 	17797342	--	4	TS1
union all select 	854753	--	4	M99RMB
union all select 	588296	--	3	M98ZR
union all select 	73166	--	3	M98RM
union all select 	157597	--	3	M98HK
union all select 	33903	--	3	M96RM
union all select 	1336489	--	3	M922M
union all select 	8009	--	3	M8HK
union all select 	1111628	--	3	M8H
union all select 	78703	--	3	M863HK
union all select 	43272	--	3	M83RM
union all select 	4012300	--	3	M83H
union all select 	449152	--	3	M83ARM
union all select 	3686314	--	3	M818RA
union all select 	2002448	--	3	M818R
union all select 	4320399	--	4	UN
union all select 	905394	--	3	M818H
union all select 	1114738	--	3	M79CR
union all select 	3080124	--	3	M62SD
union all select 	9671179	--	3	m62rb
union all select 	398333	--	3	M58SD
union all select 	419150	--	3	M50RM
union all select 	68899	--	3	M359SD
union all select 	62834	--	3	M359RM
union all select 	252605	--	3	M359ARMB
union all select 	1132163	--	3	M32M
union all select 	4673332	--	3	WBRA
union all select 	37457	--	3	M318HK
union all select 	2398557	--	4	M312T
union all select 	371646	--	3	M252RMB
union all select 	861326	--	3	M252H
union all select 	724768	--	3	M033R
union all select 	1870568	--	3	M033H
union all select 	3539862	--	4	LY
union all select 	4006796	--	4	LV
union all select 	2835363	--	4	LU
union all select 	4367748	--	4	LT
union all select 	1457236	--	4	WKH
union all select 	7680792	--	4	LM
union all select 	4181761	--	4	LLP
union all select 	3037128	--	3	LLKH
union all select 	3556221	--	4	LL
union all select 	4100631	--	4	LK
union all select 	2075688	--	4	LJ
union all select 	643456	--	4	LI
union all select 	8103018	--	4	LHS 
union all select 	7753114	--	4	LHM1
union all select 	5281110	--	4	LHI
union all select 	7754182	--	4	LHH3
union all select 	7754066	--	4	LHH2
union all select 	7753979	--	4	LHH1
union all select 	4374817	--	4	LHH
union all select 	2749224	--	4	LH
union all select 	4189499	--	4	LF
union all select 	3973944	--	4	LE
union all select 	3954915	--	4	LD
union all select 	3810488	--	4	LC
union all select 	3770553	--	4	LB
union all select 	2026798	--	4	KYM
union all select 	1088459	--	4	KYH
union all select 	461767	--	4	KRR
union all select 	391601	--	4	KRC
union all select 	4037357	--	4	KPM
union all select 	395075	--	4	KMM
union all select 	877777	--	4	KMBM
union all select 	476776	--	4	KMA
union all select 	1574950	--	4	KJH
union all select 	674248	--	4	KHH
union all select 	2400612	--	4	KHDH
union all select 	1069029	--	4	KHCH
union all select 	913628	--	4	KHBH
union all select 	896708	--	4	KHAH
union all select 	3589741	--	4	KH6
union all select 	194355	--	4	KH
union all select 	1238537	--	4	KER
union all select 	1164457	--	4	KDR
union all select 	4792246	--	4	KD
union all select 	938136	--	4	KAT
union all select 	14014232	--	4	KAA
union all select 	10064280	--	4	JT
union all select 	2302419	--	4	JJ
union all select 	13653794	--	4	JCH
union all select 	4437168	--	4	JC
union all select 	4404067	--	4	JB
union all select 	1248383	--	4	JAS
union all select 	1603986	--	4	JAM
union all select 	1220882	--	4	JAH
union all select 	4152553	--	4	JA
union all select 	2831595	--	4	IR
union all select 	1564982	--	4	IP
union all select 	4404078	--	4	IN
union all select 	4378806	--	4	IM
union all select 	689767	--	4	II
union all select 	5880048	--	4	IF
union all select 	3526034	--	4	ID
union all select 	2895571	--	4	HPU
union all select 	2138601	--	4	HPO
union all select 	2251491	--	4	HPM
union all select 	712439	--	4	HP
union all select 	2882278	--	4	HM
union all select 	747037	--	4	GI
union all select 	1382183	--	3	FBR
union all select 	2209358	--	3	FBM
union all select 	14392343	--	4	EEM
union all select 	14393371	--	4	EEH
union all select 	1372998	--	4	DW
union all select 	17041176	--	4	DM
union all select 	13338988	--	3	DJHK
union all select 	897588	--	4	DI
union all select 	10792955	--	4	CY
union all select 	2103376	--	4	CU
union all select 	2131553	--	4	CS
union all select 	2083036	--	4	CO
union all select 	1563928	--	4	CI
union all select 	17742	--	3	CHITB
union all select 	1517030	--	4	BT
union all select 	1517951	--	4	B5T
union all select 	18452187	--	4	B51T
union all select 	18452186	--	4	B50T
union all select 	9934027	--	4	B36T
union all select 	9933863	--	4	B33T
union all select 	2541779	--	4	B27T
union all select 	1588140	--	4	B24T
union all select 	1523261	--	4	B1T
union all select 	1539693	--	4	B18T
union all select 	1538997	--	4	B16T
union all select 	1538175	--	4	B14T
union all select 	1538057	--	4	B13T
union all select 	1536432	--	4	B12T
union all select 	1528421	--	4	B10T
union all select 	1812820	--	4	AW
union all select 	5528833	--	4	AT
union all select 	4212172	--	4	AS
union all select 	4404031	--	4	AJ
union all select 	13058363	--	4	AHZ
union all select 	3872491	--	4	AHT
union all select 	2197674	--	4	AHO
union all select 	1628290	--	4	AHN
union all select 	1628179	--	4	AHM
union all select 	4115476	--	4	AHA
union all select 	18515475	--	4	ACH6
union all select 	13863347	--	4	ACH3
union all select 	9905998	--	4	AC1
union all select 	3080407	--	2	A7HK
union all select 	15103340	--	2	A50RM
union all select 	4204225	--	4	79AH
union all select 	3290	--	2	6599RM
union all select 	734658	--	2	3KHK
union all select 	2831919	--	2	312BP
union all select 	11237	--	2	1158RM
union all select 	916947	--	2	02R
union all select 	1402421	--	4	S90AR
union all select 	10507013	--	4	S90C
union all select 	15140845	--	4	S85GTH
union all select 	16287301	--	4	S85A
union all select 	18579015	--	4	S7RR
union all select 	523974	--	4	S90R
union all select 	1788033	--	4	S922K
union all select 	16189265	--	4	S777
union all select 	1342397	--	4	S922M
union all select 	4913546	--	4	S922MA
union all select 	1266057	--	4	S96h
union all select 	7817620	--	4	S989M
union all select 	9727438	--	4	S62D
union all select 	2869345	--	4	S989R
union all select 	1008234	--	4	S98H
union all select 	4022510	--	4	S99ah
union all select 	5311452	--	4	S56KK
union all select 	11471646	--	4	S99K
union all select 	1448199	--	4	S99M
union all select 	912272	--	4	S99TB
union all select 	15904288	--	4	S56ASD
union all select 	691884	--	4	S9M
union all select 	2421122	--	4	SABT
union all select 	12785073	--	4	S56A
union all select 	970269	--	4	SALH
union all select 	447479	--	4	SALR
union all select 	1456925	--	4	SAMR
union all select 	7301563	--	4	S51HA
union all select 	5283781	--	4	SATE
union all select 	2229262	--	4	SATU
union all select 	4320374	--	4	SB
union all select 	955286	--	4	SB8R
union all select 	1795270	--	4	SBBR
union all select 	5831527	--	4	S49H
union all select 	1558372	--	4	SBBT
union all select 	8270016	--	4	S43H
union all select 	805450	--	4	SBHK
union all select 	3513305	--	4	S42M
union all select 	595962	--	4	SBKH
union all select 	2285864	--	4	SCI
union all select 	984549	--	4	SDH
union all select 	3139575	--	4	SF8
union all select 	2428032	--	4	S42ARM
union all select 	2327638	--	4	SFB
union all select 	840993	--	4	SG1H
union all select 	3237241	--	4	SG1R
union all select 	7186058	--	4	S359S
union all select 	6385611	--	4	S359M
union all select 	7772139	--	4	S359CM
union all select 	18393844	--	4	S33A
union all select 	832992	--	4	SGH
union all select 	185849	--	4	SI
union all select 	15548698	--	4	S32K
union all select 	3195166	--	4	S32JH
union all select 	15657898	--	4	S32HKD
union all select 	5349816	--	4	S32HK
union all select 	787938	--	4	SJM
union all select 	17931860	--	4	S32CM
union all select 	506057	--	4	SKPRMB
union all select 	7757274	--	4	SLG
union all select 	2178402	--	4	SLH
union all select 	12589170	--	4	S312RMB
union all select 	2969567	--	4	S312R
union all select 	17469607	--	4	S312H
union all select 	17520621	--	4	S312G
union all select 	7768121	--	4	SLL
union all select 	7945539	--	4	S27TK
union all select 	1265902	--	4	SMAMRMB
union all select 	2278343	--	4	SMBH
union all select 	13294314	--	4	SMCH
union all select 	17074641	--	4	S23M
union all select 	13885989	--	4	S124R
union all select 	12545786	--	4	S123R
union all select 	407649	--	4	SMORM
union all select 	3391041	--	4	S121R
union all select 	15682765	--	4	S120S
union all select 	5005322	--	4	S09M
union all select 	301152	--	4	SPH
union all select 	261425	--	4	SPR
union all select 	18803268	--	4	RMB
union all select 	15825686	--	4	RB168
union all select 	19466231	--	4	R313Y
union all select 	19485465	--	4	R313T
union all select 	17787564	--	4	R313R
union all select 	1013342	--	4	SSF2H
union all select 	2332356	--	4	SSF3H
union all select 	15984489	--	4	QQKH
union all select 	7763719	--	4	QQK3
union all select 	11884796	--	4	QQHK
union all select 	2823274	--	4	SSFK
union all select 	1416231	--	4	SSS
union all select 	3150153	--	4	PTM
union all select 	17550987	--	4	PPS
union all select 	2192160	--	4	SSSD
union all select 	641144	--	4	ST2T
union all select 	17568160	--	4	PPJ
union all select 	2388779	--	4	STEB
union all select 	6032879	--	4	PPB
union all select 	16787471	--	4	SVA
union all select 	490037	--	4	SVM
union all select 	11674030	--	4	MP
union all select 	7758309	--	4	SVP
union all select 	490215	--	4	SVR
union all select 	12294019	--	4	MKS1
union all select 	1437908	--	4	MKS
union all select 	867735	--	4	SW
union all select 	17299936	--	4	MKHA
union all select 	4601030	--	4	SYI
union all select 	4600902	--	3	MHK9
union all select 	4339887	--	3	MHK8
union all select 	15805514	--	4	MC5
union all select 	10506715	--	4	MC3
union all select 	4253518	--	4	TH28
union all select 	9727510	--	4	TP
union all select 	17797400	--	4	TS2
union all select 	8266979	--	3	MALM
union all select 	14405674	--	4	TWS
union all select 	4677011	--	4	UA
union all select 	4677048	--	4	UB
union all select 	5773292	--	4	UE
union all select 	11010588	--	4	UH
union all select 	656135	--	4	UI
union all select 	4048531	--	4	UK
union all select 	4323575	--	4	UL
union all select 	4253707	--	4	UM
union all select 	3965567	--	4	UT
union all select 	3909347	--	4	UU
union all select 	4712010	--	3	M7RRMB
union all select 	7177766	--	4	UW
union all select 	8226535	--	3	M62R
union all select 	4234220	--	3	M62H
union all select 	8546807	--	3	M62AH
union all select 	5778932	--	4	VVG
union all select 	3411725	--	3	WBR
union all select 	11485599	--	3	WBRG
union all select 	11485623	--	3	WBRH
union all select 	11485641	--	3	WBRI
union all select 	11485655	--	3	WBRJ
union all select 	3919061	--	4	WH
union all select 	17681850	--	4	LW
union all select 	1124040	--	4	WI
union all select 	11761289	--	4	WPR
union all select 	5473265	--	4	LS
union all select 	5551373	--	4	LN
union all select 	720475	--	4	WW
union all select 	14015187	--	4	XCN
union all select 	2270259	--	4	YI
union all select 	4622387	--	4	YN
union all select 	4419739	--	4	LHU
union all select 	5532706	--	4	ZZ
union all select 	10044015	--	4	LHR
union all select 	17107778	--	4	LHM5
union all select 	4445198	--	4	LHM
union all select 	8418095	--	4	LHHRMB
union all select 	11449326	--	4	LHH8
union all select 	8251316	--	4	LHH6
union all select 	16639418	--	4	LHA
union all select 	7680679	--	4	LG
union all select 	5771986	--	4	LA
union all select 	12048828	--	4	KPW
union all select 	13856586	--	4	KP
union all select 	12334400	--	4	KKF
union all select 	15583251	--	4	KJMF
union all select 	7375633	--	4	KJME
union all select 	6525867	--	4	KJMD
union all select 	1865464	--	4	KJM
union all select 	15927973	--	4	KGP
union all select 	16595046	--	4	KGB
union all select 	16594953	--	4	KGA
union all select 	18201422	--	4	KAG
union all select 	16000766	--	4	KAC
union all select 	9412566	--	4	JN
union all select 	6855660	--	4	JK
union all select 	11760592	--	4	JJM
union all select 	5484091	--	4	JJB
union all select 	13469206	--	4	JARWRONG
union all select 	6706058	--	4	IZ
union all select 	4802250	--	4	IK
union all select 	18546512	--	4	IG
union all select 	14308443	--	4	IE
union all select 	14011590	--	4	IA
union all select 	7176459	--	4	HW
union all select 	6465457	--	4	HU
union all select 	19380292	--	4	HT5
union all select 	19378350	--	4	HT4
union all select 	11306634	--	4	HT3
union all select 	5215598	--	4	HPI
union all select 	11241067	--	4	HPE
union all select 	11173365	--	4	HPD
union all select 	6210213	--	4	HO
union all select 	4649955	--	4	HK8
union all select 	15689139	--	4	HK06
union all select 	11566943	--	4	FJM
union all select 	4604381	--	4	FBH
union all select 	6150551	--	4	FBB
union all select 	16057234	--	4	EGM
union all select 	16057193	--	4	EGH
union all select 	11748799	--	4	E60
union all select 	18777368	--	4	DRM
union all select 	7216279	--	4	CX
union all select 	4663772	--	4	CL
union all select 	9579024	--	4	cks
union all select 	19040588	--	4	CHU
union all select 	11639821	--	4	C8
union all select 	10775412	--	4	C3
union all select 	10560596	--	4	C2
union all select 	12276215	--	4	C15
union all select 	12070389	--	4	C12
union all select 	10369357	--	4	C1
union all select 	13876211	--	3	BPK
union all select 	13934944	--	4	BJ
union all select 	5780740	--	4	BHS
union all select 	14635815	--	4	BGR
union all select 	17683729	--	4	B49T
union all select 	17305980	--	4	B47T
union all select 	9669693	--	4	B32T
union all select 	9664861	--	4	B31T
union all select 	8458736	--	4	B30T
union all select 	7815141	--	4	B29T
union all select 	8066804	--	4	AZ
union all select 	17050644	--	4	AQ
union all select 	4314665	--	4	AP
union all select 	5086616	--	4	AN
union all select 	15200915	--	4	ALR
union all select 	5336854	--	4	AHV
union all select 	11028100	--	4	AHMA
union all select 	3780034	--	4	AHL
union all select 	13792957	--	4	AH
union all select 	13744152	--	4	AG
union all select 	17612940	--	4	AD
union all select 	12168675	--	4	ACK
union all select 	19310674	--	4	ACH7
union all select 	13563191	--	4	ACH2
union all select 	13562677	--	4	ACH1
union all select 	13290701	--	4	ACH
union all select 	14737139	--	2	A688U
union all select 	6249438	--	4	87R
union all select 	4521616	--	2	789R
union all select 	14663748	--	4	S88ML
union all select 	7923118	--	4	S90H
union all select 	5519726	--	4	S922R
union all select 	10599405	--	4	S989H
union all select 	12515436	--	4	S98E
union all select 	12653798	--	4	S98K
union all select 	15229780	--	4	S99D
union all select 	18929915	--	4	S99E
union all select 	7604170	--	4	S99HKD
union all select 	16026037	--	4	S99V
union all select 	14084827	--	4	S99W
union all select 	4744473	--	4	SADA
union all select 	7781015	--	4	SATM
union all select 	6621107	--	4	SDHA
union all select 	4383797	--	4	SG23H
union all select 	4780138	--	4	SG25H
union all select 	6457243	--	4	SG28h
union all select 	4487258	--	4	SG2M
union all select 	10719518	--	4	SG33H
union all select 	1927603	--	4	SG6H
union all select 	8119630	--	4	SG8M
union all select 	7939911	--	4	SGGT
union all select 	11314815	--	4	SGRD
union all select 	3451110	--	4	SJH
union all select 	19240555	--	4	SJJM
union all select 	12575535	--	4	SJSD
union all select 	5601008	--	4	SLD
union all select 	7146892	--	4	SMOC
union all select 	8330307	--	4	SMOCNY
union all select 	15588279	--	4	SMOI
union all select 	15516774	--	4	SNI
union all select 	14210898	--	4	SQHH
union all select 	4362130	--	4	SSF5H
union all select 	16645316	--	4	SVE
union all select 	10933415	--	4	SVVG
union all select 	16694213	--	4	TA
union all select 	13348258	--	3	TG1
union all select 	13348483	--	3	TG2
union all select 	13348378	--	3	TG3
union all select 	13348559	--	3	TG4
union all select 	17820768	--	4	TS3
union all select 	6660386	--	4	UD
union all select 	10278914	--	4	UF
union all select 	14118357	--	4	UG
union all select 	7277118	--	4	UV
union all select 	14956535	--	4	UY
union all select 	10797628	--	4	UZ
union all select 	10398791	--	4	VKH
union all select 	4739346	--	4	WB
union all select 	6853841	--	3	wbrf
union all select 	4348440	--	3	WBRR
union all select 	18747621	--	4	WG
union all select 	18364243	--	4	WJ
union all select 	17058130	--	4	XKS
union all select 	10529214	--	4	YHA
union all select 	16016306	--	4	YM


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
		select 	16129	--	2	7899HK
union all select 	4204369	--	4	79AR
union all select 	1528422	--	4	B11T
union all select 	1538183	--	4	B15T
union all select 	1539009	--	4	B17T
union all select 	1539698	--	4	B19T
union all select 	1539699	--	4	B20T
union all select 	1539700	--	4	B21T
union all select 	1540216	--	4	B22T
union all select 	1540217	--	4	B23T
union all select 	1588145	--	4	B25T
union all select 	2508822	--	4	B26T
union all select 	1528410	--	4	B2T
union all select 	9934001	--	4	B34T
union all select 	9933940	--	4	B35T
union all select 	1528413	--	4	B4T
union all select 	1528414	--	4	B6T
union all select 	1528418	--	4	B7T
union all select 	1528419	--	4	B8T
union all select 	1528420	--	4	B9T
union all select 	2221671	--	4	BHO
union all select 	642291	--	4	BI
union all select 	5994	--	3	CHTB
union all select 	1373748	--	4	FF
union all select 	641918	--	4	HI
union all select 	1029732	--	4	HJ
union all select 	9931047	--	4	HT1
union all select 	9933782	--	4	HT2
union all select 	1220879	--	4	JAT
union all select 	726582	--	4	KAM
union all select 	726562	--	4	KAR
union all select 	726571	--	4	KBR
union all select 	726579	--	4	KCR
union all select 	712272	--	4	KHK
union all select 	1537683	--	4	KHT
union all select 	194354	--	4	KM
union all select 	3589738	--	4	KM6
union all select 	727340	--	4	KMAM
union all select 	194356	--	4	KR
union all select 	3589744	--	4	KS6
union all select 	394310	--	4	KSD
union all select 	7754251	--	4	LHH4
union all select 	7754301	--	4	LHH5
union all select 	1068024	--	3	M113H
union all select 	664858	--	3	M318RMB
union all select 	15515	--	3	M39IRMB
union all select 	865472	--	3	M606HK
union all select 	1074884	--	4	MK11C
union all select 	997155	--	4	MK6
union all select 	1539908	--	4	MKTB
union all select 	2026854	--	3	MKYM
union all select 	5664	--	3	MMMRM
union all select 	561153	--	3	MPTRMB
union all select 	156071	--	3	MQARM
union all select 	6321	--	3	MSRMB
union all select 	12573245	--	4	QQKY
union all select 	7756603	--	4	QQMW
union all select 	7756631	--	4	QQMY
union all select 	7756563	--	4	QQMZ
union all select 	9934169	--	4	QQTB
union all select 	356937	--	4	S305CRMB
union all select 	752203	--	4	S305R
union all select 	404941	--	4	S305RM
union all select 	7754654	--	4	S31BRM
union all select 	478396	--	4	S31RMB
union all select 	987495	--	4	S32AH
union all select 	987497	--	4	S32BH
union all select 	987499	--	4	S32CH
union all select 	987501	--	4	S32DH
union all select 	753492	--	4	S32R
union all select 	324558	--	4	S32RMB
union all select 	211567	--	4	S33E
union all select 	211566	--	4	S33M
union all select 	390561	--	4	S33MR
union all select 	211568	--	4	S33R
union all select 	390567	--	4	S33SM
union all select 	9934485	--	4	S33T
union all select 	7753071	--	4	S359am
union all select 	972747	--	4	S3H
union all select 	3560324	--	4	S3HH
union all select 	1207541	--	4	S42S
union all select 	3592236	--	4	S51AH
union all select 	3592237	--	4	S51BH
union all select 	3592239	--	4	S51CH
union all select 	9933834	--	4	S51TB
union all select 	838203	--	4	S56AH
union all select 	550155	--	4	S56BRM
union all select 	838370	--	4	S56CH
union all select 	877770	--	4	S56DRM
union all select 	877768	--	4	S56EH
union all select 	838201	--	4	S56H
union all select 	3775579	--	4	S56PH
union all select 	461775	--	4	S56R
union all select 	405017	--	4	S56RM
union all select 	1537688	--	4	S56TH
union all select 	405422	--	4	S58RM
union all select 	356942	--	4	S80R
union all select 	882592	--	4	S85BR
union all select 	843526	--	4	S85R
union all select 	4138910	--	4	S863R
union all select 	1108229	--	4	S85S
union all select 	1050206	--	4	S85H
union all select 	3671274	--	4	S80H
union all select 	7374379	--	4	S7D
union all select 	914839	--	4	S788H
union all select 	959157	--	4	S688T
union all select 	2509713	--	4	S688M
union all select 	901840	--	4	S688H
union all select 	4910667	--	4	S666
union all select 	3149272	--	4	S62M
union all select 	1720567	--	4	S62H
union all select 	510159	--	4	S60RUP
union all select 	1576179	--	4	S60AR
union all select 	461780	--	4	S58R
union all select 	687425	--	4	S57R
union all select 	4356717	--	4	S56QH
union all select 	477659	--	4	S98R
union all select 	3775566	--	4	S56NH
union all select 	1194960	--	4	S56KH
union all select 	1219867	--	4	S56HK
union all select 	859594	--	4	S99H
union all select 	844818	--	4	S56HH
union all select 	1031455	--	4	S56GH
union all select 	3681857	--	4	S56D
union all select 	826317	--	4	S56CRM
union all select 	9925322	--	4	S99TH
union all select 	838210	--	4	S56BBH
union all select 	8062488	--	4	S56AI
union all select 	4554012	--	4	S9H
union all select 	15689281	--	4	S56AE
union all select 	4910597	--	4	S555
union all select 	1755451	--	4	S553H
union all select 	695131	--	4	S51SM
union all select 	835299	--	4	S51R
union all select 	1349148	--	4	S51H
union all select 	3801635	--	4	S51DH
union all select 	528691	--	4	S50RMB
union all select 	4151114	--	4	S50R
union all select 	426131	--	4	S49RM
union all select 	877004	--	4	S49R
union all select 	3019886	--	4	S43S
union all select 	817188	--	4	S42RM
union all select 	1022404	--	4	S42H
union all select 	1749600	--	4	S42DH
union all select 	324336	--	4	SBKHK
union all select 	324557	--	4	SCHK
union all select 	4672707	--	4	S42D
union all select 	398615	--	4	SCM
union all select 	398636	--	4	SCS
union all select 	1652112	--	4	S42CH
union all select 	1290422	--	4	S42BH
union all select 	776702	--	4	SDR
union all select 	410722	--	4	SDRM
union all select 	479690	--	4	SDRMB
union all select 	1036451	--	4	S42AH
union all select 	1690560	--	4	S41S
union all select 	1690565	--	4	S41M
union all select 	2926808	--	4	S41H
union all select 	4181669	--	4	SG21H
union all select 	7763508	--	4	S3HK
union all select 	2601912	--	4	S39RR
union all select 	5334790	--	4	SG26H
union all select 	344472	--	4	S39R
union all select 	840999	--	4	SG2H
union all select 	431696	--	4	S33S
union all select 	484809	--	4	S33CR
union all select 	5334777	--	4	SG3M
union all select 	463659	--	4	S33BR
union all select 	7680993	--	4	SG7M
union all select 	335748	--	4	S33AR
union all select 	15657985	--	4	S32RM
union all select 	1452602	--	4	S32M
union all select 	398437	--	4	SGM
union all select 	399130	--	4	SGR
union all select 	19075657	--	4	S32KK
union all select 	324561	--	4	SGURMB
union all select 	2838764	--	4	S32IH
union all select 	2284508	--	4	S32HH
union all select 	857802	--	4	S32H
union all select 	1366843	--	4	S32FH
union all select 	3654316	--	4	S32BM
union all select 	1456420	--	4	S32AM
union all select 	408317	--	4	S31RM
union all select 	771942	--	4	S31ARMB
union all select 	9672019	--	4	S312C
union all select 	3872549	--	4	SLJ
union all select 	1001999	--	4	S27HK
union all select 	5473299	--	4	SLM
union all select 	3752852	--	4	S27A
union all select 	17723529	--	4	S26M
union all select 	2193103	--	4	S23S
union all select 	984745	--	4	SMH
union all select 	398467	--	4	SMM
union all select 	984746	--	4	SMMH
union all select 	1211027	--	4	SMMS
union all select 	979900	--	4	S23H
union all select 	524760	--	4	S16RUP
union all select 	8145099	--	4	S122R
union all select 	1435492	--	4	S120R
union all select 	324564	--	4	SMORMB
union all select 	1867721	--	4	S09H
union all select 	32422	--	2	SORM
union all select 	1586764	--	4	RR
union all select 	8243036	--	4	R312R
union all select 	10848683	--	4	QQMR
union all select 	837905	--	4	SSF1H
union all select 	7756637	--	4	QQMA
union all select 	7756579	--	4	QQKA
union all select 	12957917	--	4	QQBS
union all select 	837904	--	4	SSFH
union all select 	1349398	--	4	QQ
union all select 	6032912	--	4	PPR
union all select 	3574705	--	4	PPM
union all select 	2394977	--	4	PPH
union all select 	2486485	--	3	MSFR
union all select 	121951	--	3	MQRM
union all select 	214696	--	3	MPTUS
union all select 	1581733	--	4	MM
union all select 	8550141	--	4	MLH
union all select 	1606473	--	4	MKM1
union all select 	3715080	--	4	MKI
union all select 	998346	--	4	MK4C
union all select 	1074882	--	4	MK10
union all select 	997137	--	4	MK1
union all select 	406808	--	4	TAS51S
union all select 	11548722	--	4	MH
union all select 	4144525	--	4	MCR
union all select 	2308589	--	4	MC2
union all select 	1773805	--	4	MC1
union all select 	1773803	--	4	MC
union all select 	5402188	--	4	THM
union all select 	27026	--	3	MAMRM
union all select 	17797342	--	4	TS1
union all select 	854753	--	4	M99RMB
union all select 	588296	--	3	M98ZR
union all select 	73166	--	3	M98RM
union all select 	157597	--	3	M98HK
union all select 	33903	--	3	M96RM
union all select 	1336489	--	3	M922M
union all select 	8009	--	3	M8HK
union all select 	1111628	--	3	M8H
union all select 	78703	--	3	M863HK
union all select 	43272	--	3	M83RM
union all select 	4012300	--	3	M83H
union all select 	449152	--	3	M83ARM
union all select 	3686314	--	3	M818RA
union all select 	2002448	--	3	M818R
union all select 	4320399	--	4	UN
union all select 	905394	--	3	M818H
union all select 	1114738	--	3	M79CR
union all select 	3080124	--	3	M62SD
union all select 	9671179	--	3	m62rb
union all select 	398333	--	3	M58SD
union all select 	419150	--	3	M50RM
union all select 	68899	--	3	M359SD
union all select 	62834	--	3	M359RM
union all select 	252605	--	3	M359ARMB
union all select 	1132163	--	3	M32M
union all select 	4673332	--	3	WBRA
union all select 	37457	--	3	M318HK
union all select 	2398557	--	4	M312T
union all select 	371646	--	3	M252RMB
union all select 	861326	--	3	M252H
union all select 	724768	--	3	M033R
union all select 	1870568	--	3	M033H
union all select 	3539862	--	4	LY
union all select 	4006796	--	4	LV
union all select 	2835363	--	4	LU
union all select 	4367748	--	4	LT
union all select 	1457236	--	4	WKH
union all select 	7680792	--	4	LM
union all select 	4181761	--	4	LLP
union all select 	3037128	--	3	LLKH
union all select 	3556221	--	4	LL
union all select 	4100631	--	4	LK
union all select 	2075688	--	4	LJ
union all select 	643456	--	4	LI
union all select 	8103018	--	4	LHS 
union all select 	7753114	--	4	LHM1
union all select 	5281110	--	4	LHI
union all select 	7754182	--	4	LHH3
union all select 	7754066	--	4	LHH2
union all select 	7753979	--	4	LHH1
union all select 	4374817	--	4	LHH
union all select 	2749224	--	4	LH
union all select 	4189499	--	4	LF
union all select 	3973944	--	4	LE
union all select 	3954915	--	4	LD
union all select 	3810488	--	4	LC
union all select 	3770553	--	4	LB
union all select 	2026798	--	4	KYM
union all select 	1088459	--	4	KYH
union all select 	461767	--	4	KRR
union all select 	391601	--	4	KRC
union all select 	4037357	--	4	KPM
union all select 	395075	--	4	KMM
union all select 	877777	--	4	KMBM
union all select 	476776	--	4	KMA
union all select 	1574950	--	4	KJH
union all select 	674248	--	4	KHH
union all select 	2400612	--	4	KHDH
union all select 	1069029	--	4	KHCH
union all select 	913628	--	4	KHBH
union all select 	896708	--	4	KHAH
union all select 	3589741	--	4	KH6
union all select 	194355	--	4	KH
union all select 	1238537	--	4	KER
union all select 	1164457	--	4	KDR
union all select 	4792246	--	4	KD
union all select 	938136	--	4	KAT
union all select 	14014232	--	4	KAA
union all select 	10064280	--	4	JT
union all select 	2302419	--	4	JJ
union all select 	13653794	--	4	JCH
union all select 	4437168	--	4	JC
union all select 	4404067	--	4	JB
union all select 	1248383	--	4	JAS
union all select 	1603986	--	4	JAM
union all select 	1220882	--	4	JAH
union all select 	4152553	--	4	JA
union all select 	2831595	--	4	IR
union all select 	1564982	--	4	IP
union all select 	4404078	--	4	IN
union all select 	4378806	--	4	IM
union all select 	689767	--	4	II
union all select 	5880048	--	4	IF
union all select 	3526034	--	4	ID
union all select 	2895571	--	4	HPU
union all select 	2138601	--	4	HPO
union all select 	2251491	--	4	HPM
union all select 	712439	--	4	HP
union all select 	2882278	--	4	HM
union all select 	747037	--	4	GI
union all select 	1382183	--	3	FBR
union all select 	2209358	--	3	FBM
union all select 	14392343	--	4	EEM
union all select 	14393371	--	4	EEH
union all select 	1372998	--	4	DW
union all select 	17041176	--	4	DM
union all select 	13338988	--	3	DJHK
union all select 	897588	--	4	DI
union all select 	10792955	--	4	CY
union all select 	2103376	--	4	CU
union all select 	2131553	--	4	CS
union all select 	2083036	--	4	CO
union all select 	1563928	--	4	CI
union all select 	17742	--	3	CHITB
union all select 	1517030	--	4	BT
union all select 	1517951	--	4	B5T
union all select 	18452187	--	4	B51T
union all select 	18452186	--	4	B50T
union all select 	9934027	--	4	B36T
union all select 	9933863	--	4	B33T
union all select 	2541779	--	4	B27T
union all select 	1588140	--	4	B24T
union all select 	1523261	--	4	B1T
union all select 	1539693	--	4	B18T
union all select 	1538997	--	4	B16T
union all select 	1538175	--	4	B14T
union all select 	1538057	--	4	B13T
union all select 	1536432	--	4	B12T
union all select 	1528421	--	4	B10T
union all select 	1812820	--	4	AW
union all select 	5528833	--	4	AT
union all select 	4212172	--	4	AS
union all select 	4404031	--	4	AJ
union all select 	13058363	--	4	AHZ
union all select 	3872491	--	4	AHT
union all select 	2197674	--	4	AHO
union all select 	1628290	--	4	AHN
union all select 	1628179	--	4	AHM
union all select 	4115476	--	4	AHA
union all select 	18515475	--	4	ACH6
union all select 	13863347	--	4	ACH3
union all select 	9905998	--	4	AC1
union all select 	3080407	--	2	A7HK
union all select 	15103340	--	2	A50RM
union all select 	4204225	--	4	79AH
union all select 	3290	--	2	6599RM
union all select 	734658	--	2	3KHK
union all select 	2831919	--	2	312BP
union all select 	11237	--	2	1158RM
union all select 	916947	--	2	02R
union all select 	1402421	--	4	S90AR
union all select 	10507013	--	4	S90C
union all select 	15140845	--	4	S85GTH
union all select 	16287301	--	4	S85A
union all select 	18579015	--	4	S7RR
union all select 	523974	--	4	S90R
union all select 	1788033	--	4	S922K
union all select 	16189265	--	4	S777
union all select 	1342397	--	4	S922M
union all select 	4913546	--	4	S922MA
union all select 	1266057	--	4	S96h
union all select 	7817620	--	4	S989M
union all select 	9727438	--	4	S62D
union all select 	2869345	--	4	S989R
union all select 	1008234	--	4	S98H
union all select 	4022510	--	4	S99ah
union all select 	5311452	--	4	S56KK
union all select 	11471646	--	4	S99K
union all select 	1448199	--	4	S99M
union all select 	912272	--	4	S99TB
union all select 	15904288	--	4	S56ASD
union all select 	691884	--	4	S9M
union all select 	2421122	--	4	SABT
union all select 	12785073	--	4	S56A
union all select 	970269	--	4	SALH
union all select 	447479	--	4	SALR
union all select 	1456925	--	4	SAMR
union all select 	7301563	--	4	S51HA
union all select 	5283781	--	4	SATE
union all select 	2229262	--	4	SATU
union all select 	4320374	--	4	SB
union all select 	955286	--	4	SB8R
union all select 	1795270	--	4	SBBR
union all select 	5831527	--	4	S49H
union all select 	1558372	--	4	SBBT
union all select 	8270016	--	4	S43H
union all select 	805450	--	4	SBHK
union all select 	3513305	--	4	S42M
union all select 	595962	--	4	SBKH
union all select 	2285864	--	4	SCI
union all select 	984549	--	4	SDH
union all select 	3139575	--	4	SF8
union all select 	2428032	--	4	S42ARM
union all select 	2327638	--	4	SFB
union all select 	840993	--	4	SG1H
union all select 	3237241	--	4	SG1R
union all select 	7186058	--	4	S359S
union all select 	6385611	--	4	S359M
union all select 	7772139	--	4	S359CM
union all select 	18393844	--	4	S33A
union all select 	832992	--	4	SGH
union all select 	185849	--	4	SI
union all select 	15548698	--	4	S32K
union all select 	3195166	--	4	S32JH
union all select 	15657898	--	4	S32HKD
union all select 	5349816	--	4	S32HK
union all select 	787938	--	4	SJM
union all select 	17931860	--	4	S32CM
union all select 	506057	--	4	SKPRMB
union all select 	7757274	--	4	SLG
union all select 	2178402	--	4	SLH
union all select 	12589170	--	4	S312RMB
union all select 	2969567	--	4	S312R
union all select 	17469607	--	4	S312H
union all select 	17520621	--	4	S312G
union all select 	7768121	--	4	SLL
union all select 	7945539	--	4	S27TK
union all select 	1265902	--	4	SMAMRMB
union all select 	2278343	--	4	SMBH
union all select 	13294314	--	4	SMCH
union all select 	17074641	--	4	S23M
union all select 	13885989	--	4	S124R
union all select 	12545786	--	4	S123R
union all select 	407649	--	4	SMORM
union all select 	3391041	--	4	S121R
union all select 	15682765	--	4	S120S
union all select 	5005322	--	4	S09M
union all select 	301152	--	4	SPH
union all select 	261425	--	4	SPR
union all select 	18803268	--	4	RMB
union all select 	15825686	--	4	RB168
union all select 	19466231	--	4	R313Y
union all select 	19485465	--	4	R313T
union all select 	17787564	--	4	R313R
union all select 	1013342	--	4	SSF2H
union all select 	2332356	--	4	SSF3H
union all select 	15984489	--	4	QQKH
union all select 	7763719	--	4	QQK3
union all select 	11884796	--	4	QQHK
union all select 	2823274	--	4	SSFK
union all select 	1416231	--	4	SSS
union all select 	3150153	--	4	PTM
union all select 	17550987	--	4	PPS
union all select 	2192160	--	4	SSSD
union all select 	641144	--	4	ST2T
union all select 	17568160	--	4	PPJ
union all select 	2388779	--	4	STEB
union all select 	6032879	--	4	PPB
union all select 	16787471	--	4	SVA
union all select 	490037	--	4	SVM
union all select 	11674030	--	4	MP
union all select 	7758309	--	4	SVP
union all select 	490215	--	4	SVR
union all select 	12294019	--	4	MKS1
union all select 	1437908	--	4	MKS
union all select 	867735	--	4	SW
union all select 	17299936	--	4	MKHA
union all select 	4601030	--	4	SYI
union all select 	4600902	--	3	MHK9
union all select 	4339887	--	3	MHK8
union all select 	15805514	--	4	MC5
union all select 	10506715	--	4	MC3
union all select 	4253518	--	4	TH28
union all select 	9727510	--	4	TP
union all select 	17797400	--	4	TS2
union all select 	8266979	--	3	MALM
union all select 	14405674	--	4	TWS
union all select 	4677011	--	4	UA
union all select 	4677048	--	4	UB
union all select 	5773292	--	4	UE
union all select 	11010588	--	4	UH
union all select 	656135	--	4	UI
union all select 	4048531	--	4	UK
union all select 	4323575	--	4	UL
union all select 	4253707	--	4	UM
union all select 	3965567	--	4	UT
union all select 	3909347	--	4	UU
union all select 	4712010	--	3	M7RRMB
union all select 	7177766	--	4	UW
union all select 	8226535	--	3	M62R
union all select 	4234220	--	3	M62H
union all select 	8546807	--	3	M62AH
union all select 	5778932	--	4	VVG
union all select 	3411725	--	3	WBR
union all select 	11485599	--	3	WBRG
union all select 	11485623	--	3	WBRH
union all select 	11485641	--	3	WBRI
union all select 	11485655	--	3	WBRJ
union all select 	3919061	--	4	WH
union all select 	17681850	--	4	LW
union all select 	1124040	--	4	WI
union all select 	11761289	--	4	WPR
union all select 	5473265	--	4	LS
union all select 	5551373	--	4	LN
union all select 	720475	--	4	WW
union all select 	14015187	--	4	XCN
union all select 	2270259	--	4	YI
union all select 	4622387	--	4	YN
union all select 	4419739	--	4	LHU
union all select 	5532706	--	4	ZZ
union all select 	10044015	--	4	LHR
union all select 	17107778	--	4	LHM5
union all select 	4445198	--	4	LHM
union all select 	8418095	--	4	LHHRMB
union all select 	11449326	--	4	LHH8
union all select 	8251316	--	4	LHH6
union all select 	16639418	--	4	LHA
union all select 	7680679	--	4	LG
union all select 	5771986	--	4	LA
union all select 	12048828	--	4	KPW
union all select 	13856586	--	4	KP
union all select 	12334400	--	4	KKF
union all select 	15583251	--	4	KJMF
union all select 	7375633	--	4	KJME
union all select 	6525867	--	4	KJMD
union all select 	1865464	--	4	KJM
union all select 	15927973	--	4	KGP
union all select 	16595046	--	4	KGB
union all select 	16594953	--	4	KGA
union all select 	18201422	--	4	KAG
union all select 	16000766	--	4	KAC
union all select 	9412566	--	4	JN
union all select 	6855660	--	4	JK
union all select 	11760592	--	4	JJM
union all select 	5484091	--	4	JJB
union all select 	13469206	--	4	JARWRONG
union all select 	6706058	--	4	IZ
union all select 	4802250	--	4	IK
union all select 	18546512	--	4	IG
union all select 	14308443	--	4	IE
union all select 	14011590	--	4	IA
union all select 	7176459	--	4	HW
union all select 	6465457	--	4	HU
union all select 	19380292	--	4	HT5
union all select 	19378350	--	4	HT4
union all select 	11306634	--	4	HT3
union all select 	5215598	--	4	HPI
union all select 	11241067	--	4	HPE
union all select 	11173365	--	4	HPD
union all select 	6210213	--	4	HO
union all select 	4649955	--	4	HK8
union all select 	15689139	--	4	HK06
union all select 	11566943	--	4	FJM
union all select 	4604381	--	4	FBH
union all select 	6150551	--	4	FBB
union all select 	16057234	--	4	EGM
union all select 	16057193	--	4	EGH
union all select 	11748799	--	4	E60
union all select 	18777368	--	4	DRM
union all select 	7216279	--	4	CX
union all select 	4663772	--	4	CL
union all select 	9579024	--	4	cks
union all select 	19040588	--	4	CHU
union all select 	11639821	--	4	C8
union all select 	10775412	--	4	C3
union all select 	10560596	--	4	C2
union all select 	12276215	--	4	C15
union all select 	12070389	--	4	C12
union all select 	10369357	--	4	C1
union all select 	13876211	--	3	BPK
union all select 	13934944	--	4	BJ
union all select 	5780740	--	4	BHS
union all select 	14635815	--	4	BGR
union all select 	17683729	--	4	B49T
union all select 	17305980	--	4	B47T
union all select 	9669693	--	4	B32T
union all select 	9664861	--	4	B31T
union all select 	8458736	--	4	B30T
union all select 	7815141	--	4	B29T
union all select 	8066804	--	4	AZ
union all select 	17050644	--	4	AQ
union all select 	4314665	--	4	AP
union all select 	5086616	--	4	AN
union all select 	15200915	--	4	ALR
union all select 	5336854	--	4	AHV
union all select 	11028100	--	4	AHMA
union all select 	3780034	--	4	AHL
union all select 	13792957	--	4	AH
union all select 	13744152	--	4	AG
union all select 	17612940	--	4	AD
union all select 	12168675	--	4	ACK
union all select 	19310674	--	4	ACH7
union all select 	13563191	--	4	ACH2
union all select 	13562677	--	4	ACH1
union all select 	13290701	--	4	ACH
union all select 	14737139	--	2	A688U
union all select 	6249438	--	4	87R
union all select 	4521616	--	2	789R
union all select 	14663748	--	4	S88ML
union all select 	7923118	--	4	S90H
union all select 	5519726	--	4	S922R
union all select 	10599405	--	4	S989H
union all select 	12515436	--	4	S98E
union all select 	12653798	--	4	S98K
union all select 	15229780	--	4	S99D
union all select 	18929915	--	4	S99E
union all select 	7604170	--	4	S99HKD
union all select 	16026037	--	4	S99V
union all select 	14084827	--	4	S99W
union all select 	4744473	--	4	SADA
union all select 	7781015	--	4	SATM
union all select 	6621107	--	4	SDHA
union all select 	4383797	--	4	SG23H
union all select 	4780138	--	4	SG25H
union all select 	6457243	--	4	SG28h
union all select 	4487258	--	4	SG2M
union all select 	10719518	--	4	SG33H
union all select 	1927603	--	4	SG6H
union all select 	8119630	--	4	SG8M
union all select 	7939911	--	4	SGGT
union all select 	11314815	--	4	SGRD
union all select 	3451110	--	4	SJH
union all select 	19240555	--	4	SJJM
union all select 	12575535	--	4	SJSD
union all select 	5601008	--	4	SLD
union all select 	7146892	--	4	SMOC
union all select 	8330307	--	4	SMOCNY
union all select 	15588279	--	4	SMOI
union all select 	15516774	--	4	SNI
union all select 	14210898	--	4	SQHH
union all select 	4362130	--	4	SSF5H
union all select 	16645316	--	4	SVE
union all select 	10933415	--	4	SVVG
union all select 	16694213	--	4	TA
union all select 	13348258	--	3	TG1
union all select 	13348483	--	3	TG2
union all select 	13348378	--	3	TG3
union all select 	13348559	--	3	TG4
union all select 	17820768	--	4	TS3
union all select 	6660386	--	4	UD
union all select 	10278914	--	4	UF
union all select 	14118357	--	4	UG
union all select 	7277118	--	4	UV
union all select 	14956535	--	4	UY
union all select 	10797628	--	4	UZ
union all select 	10398791	--	4	VKH
union all select 	4739346	--	4	WB
union all select 	6853841	--	3	wbrf
union all select 	4348440	--	3	WBRR
union all select 	18747621	--	4	WG
union all select 	18364243	--	4	WJ
union all select 	17058130	--	4	XKS
union all select 	10529214	--	4	YHA
union all select 	16016306	--	4	YM


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
 

