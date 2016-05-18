/*
	Created: Elodie	
	Task: Initialize Product Status of Voidbridge for Credit customers
	DB: DBCUST/CustDB
	Date: 20160301
*/ 
ALTER PROCEDURE [dbo].[Acc_DynamicCustomerInfo_09]
	@Custid INT
	,@roleid TINYINT
	,@srecommend INT
	,@mrecommend INT	
	,@Mode BIT	
	,@target VARCHAR(20)
AS
BEGIN
	SET NOCOUNT ON
	
	IF (@target = 'REPLICATED' AND @@SERVERNAME = 'DBCUST') RETURN	-- run at all replicated servers
	IF (@target = 'DBCUST' AND @@SERVERNAME <> 'DBCUST') RETURN -- run at dbtrans only
	
	IF NOT (dbo.f_CheckRepTable('Custinfo') = 1 
	   AND dbo.f_CheckRepTable('CustProductStatus') = 1
	   AND dbo.f_CheckRepTable('ProductSettingDetail') = 1
	   AND dbo.f_CheckRepTable('ProductStatusProfile') = 1
	   )
		RETURN	

	/*******************************CUST PRODUCT STATUS TABLE*******************************/	
	IF @Mode = 1
	BEGIN
		IF @roleid = 4
		BEGIN
			UPDATE cs
			SET bitmapIsDisabled = CASE WHEN ci.SyncCasino = 1 THEN dbo.f_GenerateProductStatus(bitmapIsDisabled, 5, 0) END
			FROM [dbo].[CustProductStatus] cs WITH(ROWLOCK,UPDLOCK)
				INNER JOIN dbo.custInfo ci WITH(NOLOCK) ON cs.CustID = ci.CustID
			WHERE ci.srecommend = @Custid
		END
		ELSE IF @roleid = 3
		BEGIN
			UPDATE cs
			SET bitmapIsDisabled = CASE WHEN ci.SyncCasino = 1 THEN dbo.f_GenerateProductStatus(bitmapIsDisabled, 5, 0) END
			FROM [dbo].[CustProductStatus] cs WITH(ROWLOCK,UPDLOCK)
				INNER JOIN dbo.custInfo ci WITH(NOLOCK) ON cs.CustID = ci.CustID
			WHERE ci.mrecommend = @Custid

			UPDATE cs
			SET bitmapIsDisabled = CASE WHEN ci.SyncCasino = 1 THEN dbo.f_GenerateProductStatus(bitmapIsDisabled, 5, 0) END
			FROM [dbo].[CustProductStatus] cs WITH(ROWLOCK,UPDLOCK)
				INNER JOIN dbo.custInfo ci WITH(NOLOCK) ON cs.CustID = ci.CustID
			WHERE ci.custid = @srecommend
		END
		ELSE IF @roleid = 2
		BEGIN
			UPDATE cs
			SET bitmapIsDisabled = CASE WHEN ci.SyncCasino = 1 THEN dbo.f_GenerateProductStatus(bitmapIsDisabled, 5, 0) END
			FROM [dbo].[CustProductStatus] cs WITH(ROWLOCK,UPDLOCK)
				INNER JOIN dbo.custInfo ci WITH(NOLOCK) ON cs.CustID = ci.CustID
			WHERE ci.recommend = @Custid

			UPDATE cs
			SET bitmapIsDisabled = CASE WHEN ci.SyncCasino = 1 THEN dbo.f_GenerateProductStatus(bitmapIsDisabled, 5, 0) END
			FROM [dbo].[CustProductStatus] cs WITH(ROWLOCK,UPDLOCK)
				INNER JOIN dbo.custInfo ci WITH(NOLOCK) ON cs.CustID = ci.CustID
			WHERE ci.custid = @srecommend OR ci.custid = @mrecommend
		END
	END

	IF @Mode = 0
	BEGIN
		IF @roleid = 4
		BEGIN
			UPDATE cs
			SET bitmapIsDisabled = CASE WHEN ci.SyncCasino = 1 AND ci.DisableCasino = 0 THEN dbo.f_GenerateProductStatus(bitmapIsDisabled, 5, 0) END
			FROM [dbo].[CustProductStatus] cs WITH(ROWLOCK,UPDLOCK)
				INNER JOIN dbo.custInfo ci WITH(NOLOCK) ON cs.CustID = ci.CustID
			WHERE ci.srecommend = @Custid
		END
		ELSE IF @roleid = 3
		BEGIN
			UPDATE cs
			SET bitmapIsDisabled = CASE WHEN ci.SyncCasino = 1 AND ci.DisableCasino = 0 THEN dbo.f_GenerateProductStatus(bitmapIsDisabled, 5, 0) END
			FROM [dbo].[CustProductStatus] cs WITH(ROWLOCK,UPDLOCK)
				INNER JOIN dbo.custInfo ci WITH(NOLOCK) ON cs.CustID = ci.CustID
			WHERE ci.mrecommend = @Custid

			UPDATE cs
			SET bitmapIsDisabled = CASE WHEN ci.SyncCasino = 1 AND ci.DisableCasino = 0 THEN dbo.f_GenerateProductStatus(bitmapIsDisabled, 5, 0) END
			FROM [dbo].[CustProductStatus] cs WITH(ROWLOCK,UPDLOCK)
				INNER JOIN dbo.custInfo ci WITH(NOLOCK) ON cs.CustID = ci.CustID
			WHERE ci.custid = @srecommend
		END
		ELSE IF @roleid = 2
		BEGIN
			UPDATE cs
			SET bitmapIsDisabled = CASE WHEN ci.SyncCasino = 1 AND ci.DisableCasino = 0 THEN dbo.f_GenerateProductStatus(bitmapIsDisabled, 5, 0) END
			FROM [dbo].[CustProductStatus] cs WITH(ROWLOCK,UPDLOCK)
				INNER JOIN dbo.custInfo ci WITH(NOLOCK) ON cs.CustID = ci.CustID
			WHERE ci.recommend = @Custid

			UPDATE cs
			SET bitmapIsDisabled = CASE WHEN ci.SyncCasino = 1 AND ci.DisableCasino = 0 THEN dbo.f_GenerateProductStatus(bitmapIsDisabled, 5, 0) END
			FROM [dbo].[CustProductStatus] cs WITH(ROWLOCK,UPDLOCK)
				INNER JOIN dbo.custInfo ci WITH(NOLOCK) ON cs.CustID = ci.CustID
			WHERE ci.custid = @srecommend OR ci.custid = @mrecommend
		END
	END
END
GO
-- END STEP 1: DEPLOY THIS SP @DBCUST.CustDB --------
------------------------------------------------------	

-- BEGIN STEP 2: RUN THIS SCRIPT AT ALL REPLICATED SERVERS (06/DBTP) -----
--------------------------------------------------------------------------------------
CREATE TABLE #Cust (custid int, srecommend INT, mrecommend INT, roleid TINYINT, Mode BIT, isfinished bit default(0)) --Mode 0: depend on disable OneRNG, 1: enable all

DECLARE @custid int, @srecommend INT, @mrecommend INT, @roleid TINYINT, @Mode BIT

INSERT INTO #Cust(custid, srecommend, mrecommend, roleid, Mode)
SELECT ci.custid, ci.srecommend, ci.mrecommend, ci.roleid, 1 AS mode
FROM CustInfo ci WITH(NOLOCK)
 INNER JOIN customer c WITH (NOLOCK) ON ci.custid = c.custid
WHERE ci.currency IN (20, 4, 15, 22, 33, 34, 43, 44, 45, 47, 62) --'KRW', 'IDR', 'THB'
	AND c.site IN ('755555', 'INDO', 'KORIBC')
	AND ci.username IN ('S922H','M922U','M922M','S922M','M922T','S922T','S922K','S922N','S922U','S922L','S922P','S922W','S922G','S922US','S922MA','S922Y','S922R','S922C','S922V','S922B','S922O','S922S',
						'S922A','M359RM','M359SD','M359EU','M359ARM','M359ASD','M359RMB','M359ARMB','S359AH','HD','HE','S359HK','S359CM','HF','HG','HDN','HDQ','HH','DAA','DAB','DAC','DAD','HB','DAU','DAE',
						'DAF','HX','DAM','HN','HQ','S359RM','S359HL','DAH','MGTB','MGBTB','MGCTB','SGS','SGTB','SGATB','SGI','SGT','SGAT','SGBT','SGCT','SGAR','TEH','TEC','THR','SGSM','SGSN','TEK','SGMM',
						'TED','THH','THS','TEG','SGKB','THT','THD','SI','UU','WH','UT','D8G','UK','IB','LK','JA','AS','UM','AP','SB','UN','UL','IM','AJ','JB','IN','JC','YN','CL','UA','UB','WB','IJ','AN',
						'WU','AT','ZZ','UC','LN','KK','VB','YY','UE','IF','BB','HO','HU','SL','UD','IZ','JK','HW','UW','CX','UV','AK','AZ','JN','AI','JT','UF','CY','UZ','UH','MH','AH','UG','UY','YM','TA',
						'AQ','AD','WJ','WG','WA','CP','HI','BI','BJ','LI','LW','UI','HP','GI','SW','DI','WI','QQ','DW','FF','TI','CI','IP','RR','IC','CO','CU','CS','YI','JJ','IR','VV','ID','WW','MW','MM',
						'AL','DB','SD','LR','II','IK','IA','IE','IG','IO','IU','69SD','S69SD','S69RM','S7RM','S69R','M69U','M69H','S69H','S69RD','S69E','S69TB','S69W','S69K','S69BP','S69HD','S69RP','S69M',
						'S69NT','S56RM','S56R','S56ARM','S56BRM','S556R','S556AR','S56CRM','S56H','S56AH','S56BBH','S56CH','S56DH','S56HH','S56EH','S56DRM','S56FH','S56TB','S56GH','S56JH','S56KH','S56HK',
						'S56T','S56TC','S56LH','S56MH','S56TH','S56TA','S56TD','S56TT','S56I','S56D','S56NH','S56PH','S56QH','s56rh','S56SH','S56KK','S56SD','S56AA','S56AB','S56AC','S56AD','S56AI','S56II',
						'S56US','S56UH','S56AU','S56BU','S56VH','S56A','HKD','S56K','HKD01','HKD02','HK01','HK02','HK03','HK05','HK06','S56AE','S56CU','HK07','S56DU','S56ASD','HK09','HK10','HK11','S56ERM',
						'HK12','HK13','HK15','HK16','HK17','HK18','HK19','HK20','HK21','HK22','TM01','TM02','TM03','TM04','TM05','TM06','TM07','TM08','TM09','TM10','TM11','HK23','HK25','VV00','VV01','VV02',
						'VV03','VV04','VV05','VV06','VV07','VV08','VV09','VV10','VV11','VV12','VV22','VV33','VV39','VV55','VV66','VV77','VV88','VV99','VV13','HK26','HK27','TBB01','HK28','S60RUP','S60AR',
						'D60','E60','S16RUP','S88D','SEM','SEI','SEH','SED','SEK','SEMA','S222R','S222H','S222HK','S222T','S222AH','S222BH','S222TH','S222TA','S222CH','S222DH','2EH','S222FH','S222GH',
						'2KH','S222MH','S222NH','M222M','2AH','2BH','2CH','2DH','2LH','2MH','2ZH','2ID','2NH','2PH','2MM','2YH','2FH','2GH','2EU','2DD','2MN','2WH','S222JH','2HH','2RM','2DE','S222X',
						'2NN','2HK','2RR','2CR','2CT','S222K','2JH','S222W','S222N','S222ZH','2XX','2WW','2CK','2RH','2KR','2IH','2BP','2QH','2OH','2SH','2AA','2AB','2AC','2MP','2HA','2MY','2MQ','2UA',
						'2UH','2UB','2HB','2IE','2RA','SORM','MK1','MK2','MK3','MK5','MK6','MK4C','TH7','MK8','MK9','MK10','MK11C','CKT','CKT1','CKT2','MKM','MK12','TH88','MKS','MK17','CK18','MKTB','MK13',
						'CKU','MKM1','MK19','MK20','MK21','MK16','MK15','TH25','MK22','MK30','TH26','MK23','JC1','JC7','JC2','JC8','MKI','JC6','JC81','JC3','JC9','MK27','TH28','TH29','THM','JCM','JC10',
						'TH89','MK31','MKM2','JC5','JC82','MKS1','JCH','GAX','MK32','JC83','MKH','AK1','AKM1','MK33','MK35','MKHA','MK36','M99RMB','S99H','S99TB','S99M','S99T','S99R','S99ah','S99HK',
						'S99HKK','S99HKD','S99BH','S99TH','S99K','S99RMB','S999TB','S99W','S99C','S99THB','S99A','S99D','S99MHK','S99CH','S99V','S99BT','S99U','S99HA','S99TC','S99E','S99BA','S99BB',
						'S99BC','S99BD','FN1','FN2','FN3','FN4','FN5','FN6','FN7','FN8','FN9','FN10','NK1','NK2','NK3','NK4','NK5','NK6','NK7','NK8','NK9','NK10','G33M','G99MK','GMK9','FN11','FN12',
						'SLH','SLK','SLJ','SLM','SLD','SAS','ASA','SAE','SAI','ASB','SER','SSK','SSM','SSMA','SSKA','SSKB','SSKC','SSN','SSI','GN','GX','GC','GL','GO','SEA','SEB','SEC','SYI','SNI',
						'K9','K8','K3','S359BH','S359M','S359CH','S359S','S359HH','S359am','S359bm','SLP','SLI','SLN','SLO','SLG','SLQ','SLW','SLB','SLL','SLR','SLT','SLA','LGA','SLY','SLS','SLE','SLF',
						'SLV','SLU','ALR','ALM','ALH','ALA','ALB','ALC','ALD','RMB','ALK','ALF','ALG','ALL','ALJ','HT1','HT2','HT3','HT4','HT5','KKT','KKM','KKH','KKMA','KKS','KKB','KKC','KKD','KKE',
						'KKJ','KKN','KKU','KKU1','KKV','KKP','KKQ','KKX','KKY','KKZ','KKA','KKW','KKF','KKO','KKG','KKK','KKL','KKI','KKR','KAA','K1K','KAB','KGK','KGL','KGM','KGN','KGO','KGP','KAC',
						'K2K','KGD','SRS','KAD','KGA','KGB','KAE','KAF','KBA','KBB','KBC','KGE','KBD','KBE','KAG','KAH','KAJ','KAK','KBF','KAO','KBT','KCT','KDT','KET','KBG','KBH','KBJ','KND','TLM',
						'TLN','D71','cks','C1','C2','C3','C5','C7','TLH','C8','C9','C10','C11','C12','C13','C15','H9','H1','JK6','C6','H2','H3','HZ','H5','CV','9H','1C','EPL','MMS','KP','H8','S1','S2',
						'S3','S6','S7','S8','S9','S11','SR','CM','ZS','CN','JD','JG','U8','A6','R8','A1','A2','A3','A5','US','P9','A7HK','MHK8','MHK9','HK8','M7RRMB','S7D','S7RR','S7W','TU1','TU2','TU3',
						'PK','P11','P12','P15','P13','P14','P16','P17','P18','P19','P22','P20','P21','WINA','WINB','WINC','WINZ','WINE','WINS','WINF','WING','WINH','WINJ','WINI','WINO','WINP','ACE','FAT',
						'DON','BAT','AW','AG','AF','AWTA','AWTB','KID','ZTA','ZTB','D66','D83','DRP','D79')
		
INSERT INTO #Cust(custid, srecommend, mrecommend, roleid, Mode)
SELECT ci.custid, ci.srecommend, ci.mrecommend, ci.roleid, 0 AS Mode
FROM CustInfo ci WITH(NOLOCK)
 INNER JOIN customer c WITH (NOLOCK) ON ci.custid = c.custid
WHERE ci.currency IN (20, 4, 15, 22, 33, 34, 43, 44, 45, 47, 62) --'KRW', 'IDR', 'THB'
	AND c.site IN ('755555', 'INDO', 'KORIBC')
	AND ci.username IN ('CHTB','CHITB','ST','STT','ST1T','ST2T','ST3T','ST4T','ST5T','ST6T','ST7T','ST8T','ST9T','BT','B5T','B1T','B2T','B3T','B4T','B6T','B7T','B8T','B9T','B10T',
						'B11T','B12T','B13T','B14T','B15T','B16T','B17T','B18T','B19T','B20T','B21T','B22T','B23T','B24T','B25T','STEB','SABT','B26T','B27T','B28t','B29T','B30T',
						'B31T','B32T','B33T','B35T','B34T','B36T','B37T','B38T','B39T','B40T','B41T','B42T','B43T','B44T','B45T','B46T','B47T','B48T','B49T','B50T','B51T','B52T',
						'B53T','B54T')

WHILE (1 = 1)
BEGIN
	UPDATE TOP (1) #Cust
	SET isfinished = 1
		,@custid = custid	
		,@srecommend = srecommend	
		,@mrecommend = mrecommend
		,@roleid = roleid
		,@Mode = Mode
	WHERE isfinished = 0
	
	IF @@ROWCOUNT = 0 BREAK
			
	EXEC dbo.Acc_DynamicCustomerInfo_09 
			@custid = @custid			
			,@srecommend = @srecommend
			,@mrecommend = @mrecommend
			,@roleid = @roleid
			,@Mode = @Mode
			,@target = 'REPLICATED'
			
			
	waitfor delay '00:00:0.280'
END

-- BEGIN STEP 3: RUN THIS SCRIPT AT DBCUST -----
--------------------------------------------------------------------------------------
CREATE TABLE #Cust (custid int, srecommend INT, mrecommend INT, roleid TINYINT, Mode BIT, isfinished bit default(0)) --Mode 0: depend on disable OneRNG, 1: enable all

DECLARE @custid int, @srecommend INT, @mrecommend INT, @roleid TINYINT, @Mode BIT

INSERT INTO #Cust(custid, srecommend, mrecommend, roleid, Mode)
SELECT ci.custid, ci.srecommend, ci.mrecommend, ci.roleid, 1 AS mode
FROM CustInfo ci WITH(NOLOCK)
 INNER JOIN customer c WITH (NOLOCK) ON ci.custid = c.custid
WHERE ci.currency IN (20, 4, 15, 22, 33, 34, 43, 44, 45, 47, 62) --'KRW', 'IDR', 'THB'
	AND c.site IN ('755555', 'INDO', 'KORIBC')
	AND ci.username IN ('S922H','M922U','M922M','S922M','M922T','S922T','S922K','S922N','S922U','S922L','S922P','S922W','S922G','S922US','S922MA','S922Y','S922R','S922C','S922V','S922B','S922O','S922S',
						'S922A','M359RM','M359SD','M359EU','M359ARM','M359ASD','M359RMB','M359ARMB','S359AH','HD','HE','S359HK','S359CM','HF','HG','HDN','HDQ','HH','DAA','DAB','DAC','DAD','HB','DAU','DAE',
						'DAF','HX','DAM','HN','HQ','S359RM','S359HL','DAH','MGTB','MGBTB','MGCTB','SGS','SGTB','SGATB','SGI','SGT','SGAT','SGBT','SGCT','SGAR','TEH','TEC','THR','SGSM','SGSN','TEK','SGMM',
						'TED','THH','THS','TEG','SGKB','THT','THD','SI','UU','WH','UT','D8G','UK','IB','LK','JA','AS','UM','AP','SB','UN','UL','IM','AJ','JB','IN','JC','YN','CL','UA','UB','WB','IJ','AN',
						'WU','AT','ZZ','UC','LN','KK','VB','YY','UE','IF','BB','HO','HU','SL','UD','IZ','JK','HW','UW','CX','UV','AK','AZ','JN','AI','JT','UF','CY','UZ','UH','MH','AH','UG','UY','YM','TA',
						'AQ','AD','WJ','WG','WA','CP','HI','BI','BJ','LI','LW','UI','HP','GI','SW','DI','WI','QQ','DW','FF','TI','CI','IP','RR','IC','CO','CU','CS','YI','JJ','IR','VV','ID','WW','MW','MM',
						'AL','DB','SD','LR','II','IK','IA','IE','IG','IO','IU','69SD','S69SD','S69RM','S7RM','S69R','M69U','M69H','S69H','S69RD','S69E','S69TB','S69W','S69K','S69BP','S69HD','S69RP','S69M',
						'S69NT','S56RM','S56R','S56ARM','S56BRM','S556R','S556AR','S56CRM','S56H','S56AH','S56BBH','S56CH','S56DH','S56HH','S56EH','S56DRM','S56FH','S56TB','S56GH','S56JH','S56KH','S56HK',
						'S56T','S56TC','S56LH','S56MH','S56TH','S56TA','S56TD','S56TT','S56I','S56D','S56NH','S56PH','S56QH','s56rh','S56SH','S56KK','S56SD','S56AA','S56AB','S56AC','S56AD','S56AI','S56II',
						'S56US','S56UH','S56AU','S56BU','S56VH','S56A','HKD','S56K','HKD01','HKD02','HK01','HK02','HK03','HK05','HK06','S56AE','S56CU','HK07','S56DU','S56ASD','HK09','HK10','HK11','S56ERM',
						'HK12','HK13','HK15','HK16','HK17','HK18','HK19','HK20','HK21','HK22','TM01','TM02','TM03','TM04','TM05','TM06','TM07','TM08','TM09','TM10','TM11','HK23','HK25','VV00','VV01','VV02',
						'VV03','VV04','VV05','VV06','VV07','VV08','VV09','VV10','VV11','VV12','VV22','VV33','VV39','VV55','VV66','VV77','VV88','VV99','VV13','HK26','HK27','TBB01','HK28','S60RUP','S60AR',
						'D60','E60','S16RUP','S88D','SEM','SEI','SEH','SED','SEK','SEMA','S222R','S222H','S222HK','S222T','S222AH','S222BH','S222TH','S222TA','S222CH','S222DH','2EH','S222FH','S222GH',
						'2KH','S222MH','S222NH','M222M','2AH','2BH','2CH','2DH','2LH','2MH','2ZH','2ID','2NH','2PH','2MM','2YH','2FH','2GH','2EU','2DD','2MN','2WH','S222JH','2HH','2RM','2DE','S222X',
						'2NN','2HK','2RR','2CR','2CT','S222K','2JH','S222W','S222N','S222ZH','2XX','2WW','2CK','2RH','2KR','2IH','2BP','2QH','2OH','2SH','2AA','2AB','2AC','2MP','2HA','2MY','2MQ','2UA',
						'2UH','2UB','2HB','2IE','2RA','SORM','MK1','MK2','MK3','MK5','MK6','MK4C','TH7','MK8','MK9','MK10','MK11C','CKT','CKT1','CKT2','MKM','MK12','TH88','MKS','MK17','CK18','MKTB','MK13',
						'CKU','MKM1','MK19','MK20','MK21','MK16','MK15','TH25','MK22','MK30','TH26','MK23','JC1','JC7','JC2','JC8','MKI','JC6','JC81','JC3','JC9','MK27','TH28','TH29','THM','JCM','JC10',
						'TH89','MK31','MKM2','JC5','JC82','MKS1','JCH','GAX','MK32','JC83','MKH','AK1','AKM1','MK33','MK35','MKHA','MK36','M99RMB','S99H','S99TB','S99M','S99T','S99R','S99ah','S99HK',
						'S99HKK','S99HKD','S99BH','S99TH','S99K','S99RMB','S999TB','S99W','S99C','S99THB','S99A','S99D','S99MHK','S99CH','S99V','S99BT','S99U','S99HA','S99TC','S99E','S99BA','S99BB',
						'S99BC','S99BD','FN1','FN2','FN3','FN4','FN5','FN6','FN7','FN8','FN9','FN10','NK1','NK2','NK3','NK4','NK5','NK6','NK7','NK8','NK9','NK10','G33M','G99MK','GMK9','FN11','FN12',
						'SLH','SLK','SLJ','SLM','SLD','SAS','ASA','SAE','SAI','ASB','SER','SSK','SSM','SSMA','SSKA','SSKB','SSKC','SSN','SSI','GN','GX','GC','GL','GO','SEA','SEB','SEC','SYI','SNI',
						'K9','K8','K3','S359BH','S359M','S359CH','S359S','S359HH','S359am','S359bm','SLP','SLI','SLN','SLO','SLG','SLQ','SLW','SLB','SLL','SLR','SLT','SLA','LGA','SLY','SLS','SLE','SLF',
						'SLV','SLU','ALR','ALM','ALH','ALA','ALB','ALC','ALD','RMB','ALK','ALF','ALG','ALL','ALJ','HT1','HT2','HT3','HT4','HT5','KKT','KKM','KKH','KKMA','KKS','KKB','KKC','KKD','KKE',
						'KKJ','KKN','KKU','KKU1','KKV','KKP','KKQ','KKX','KKY','KKZ','KKA','KKW','KKF','KKO','KKG','KKK','KKL','KKI','KKR','KAA','K1K','KAB','KGK','KGL','KGM','KGN','KGO','KGP','KAC',
						'K2K','KGD','SRS','KAD','KGA','KGB','KAE','KAF','KBA','KBB','KBC','KGE','KBD','KBE','KAG','KAH','KAJ','KAK','KBF','KAO','KBT','KCT','KDT','KET','KBG','KBH','KBJ','KND','TLM',
						'TLN','D71','cks','C1','C2','C3','C5','C7','TLH','C8','C9','C10','C11','C12','C13','C15','H9','H1','JK6','C6','H2','H3','HZ','H5','CV','9H','1C','EPL','MMS','KP','H8','S1','S2',
						'S3','S6','S7','S8','S9','S11','SR','CM','ZS','CN','JD','JG','U8','A6','R8','A1','A2','A3','A5','US','P9','A7HK','MHK8','MHK9','HK8','M7RRMB','S7D','S7RR','S7W','TU1','TU2','TU3',
						'PK','P11','P12','P15','P13','P14','P16','P17','P18','P19','P22','P20','P21','WINA','WINB','WINC','WINZ','WINE','WINS','WINF','WING','WINH','WINJ','WINI','WINO','WINP','ACE','FAT',
						'DON','BAT','AW','AG','AF','AWTA','AWTB','KID','ZTA','ZTB','D66','D83','DRP','D79')
		
INSERT INTO #Cust(custid, srecommend, mrecommend, roleid, Mode)
SELECT ci.custid, ci.srecommend, ci.mrecommend, ci.roleid, 0 AS Mode
FROM CustInfo ci WITH(NOLOCK)
 INNER JOIN customer c WITH (NOLOCK) ON ci.custid = c.custid
WHERE ci.currency IN (20, 4, 15, 22, 33, 34, 43, 44, 45, 47, 62) --'KRW', 'IDR', 'THB'
	AND c.site IN ('755555', 'INDO', 'KORIBC')
	AND ci.username IN ('CHTB','CHITB','ST','STT','ST1T','ST2T','ST3T','ST4T','ST5T','ST6T','ST7T','ST8T','ST9T','BT','B5T','B1T','B2T','B3T','B4T','B6T','B7T','B8T','B9T','B10T',
						'B11T','B12T','B13T','B14T','B15T','B16T','B17T','B18T','B19T','B20T','B21T','B22T','B23T','B24T','B25T','STEB','SABT','B26T','B27T','B28t','B29T','B30T',
						'B31T','B32T','B33T','B35T','B34T','B36T','B37T','B38T','B39T','B40T','B41T','B42T','B43T','B44T','B45T','B46T','B47T','B48T','B49T','B50T','B51T','B52T',
						'B53T','B54T')

WHILE (1 = 1)
BEGIN
	UPDATE TOP (1) #Cust
	SET isfinished = 1
		,@custid = custid	
		,@srecommend = srecommend	
		,@mrecommend = mrecommend
		,@roleid = roleid
		,@Mode = Mode
	WHERE isfinished = 0
	
	IF @@ROWCOUNT = 0 BREAK
			
	EXEC dbo.Acc_DynamicCustomerInfo_09 
			@custid = @custid			
			,@srecommend = @srecommend
			,@mrecommend = @mrecommend
			,@roleid = @roleid
			,@Mode = @Mode
			,@target = 'DBCUST'
			
			
	waitfor delay '00:00:0.280'
END