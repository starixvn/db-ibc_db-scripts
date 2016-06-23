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
			SET bitmapIsDisabled = CASE WHEN ci.SyncCasino = 1 THEN dbo.f_GenerateProductStatus(bitmapIsDisabled, 5, 0) ELSE bitmapIsDisabled END
			FROM [dbo].[CustProductStatus] cs WITH(ROWLOCK,UPDLOCK)
				INNER JOIN dbo.custInfo ci WITH(NOLOCK) ON cs.CustID = ci.CustID
			WHERE ci.srecommend = @Custid
		END
		ELSE IF @roleid = 3
		BEGIN
			UPDATE cs
			SET bitmapIsDisabled = CASE WHEN ci.SyncCasino = 1 THEN dbo.f_GenerateProductStatus(bitmapIsDisabled, 5, 0) ELSE bitmapIsDisabled END
			FROM [dbo].[CustProductStatus] cs WITH(ROWLOCK,UPDLOCK)
				INNER JOIN dbo.custInfo ci WITH(NOLOCK) ON cs.CustID = ci.CustID
			WHERE ci.mrecommend = @Custid

			UPDATE cs
			SET bitmapIsDisabled = CASE WHEN ci.SyncCasino = 1 THEN dbo.f_GenerateProductStatus(bitmapIsDisabled, 5, 0) ELSE bitmapIsDisabled END
			FROM [dbo].[CustProductStatus] cs WITH(ROWLOCK,UPDLOCK)
				INNER JOIN dbo.custInfo ci WITH(NOLOCK) ON cs.CustID = ci.CustID
			WHERE ci.custid = @srecommend
		END
		ELSE IF @roleid = 2
		BEGIN
			UPDATE cs
			SET bitmapIsDisabled = CASE WHEN ci.SyncCasino = 1 THEN dbo.f_GenerateProductStatus(bitmapIsDisabled, 5, 0) ELSE bitmapIsDisabled END
			FROM [dbo].[CustProductStatus] cs WITH(ROWLOCK,UPDLOCK)
				INNER JOIN dbo.custInfo ci WITH(NOLOCK) ON cs.CustID = ci.CustID
			WHERE ci.recommend = @Custid

			UPDATE cs
			SET bitmapIsDisabled = CASE WHEN ci.SyncCasino = 1 THEN dbo.f_GenerateProductStatus(bitmapIsDisabled, 5, 0) ELSE bitmapIsDisabled END
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
			SET bitmapIsDisabled = CASE WHEN ci.SyncCasino = 1 AND ci.DisableCasino = 0 THEN dbo.f_GenerateProductStatus(bitmapIsDisabled, 5, 0) ELSE bitmapIsDisabled END
			FROM [dbo].[CustProductStatus] cs WITH(ROWLOCK,UPDLOCK)
				INNER JOIN dbo.custInfo ci WITH(NOLOCK) ON cs.CustID = ci.CustID
			WHERE ci.srecommend = @Custid
		END
		ELSE IF @roleid = 3
		BEGIN
			UPDATE cs
			SET bitmapIsDisabled = CASE WHEN ci.SyncCasino = 1 AND ci.DisableCasino = 0 THEN dbo.f_GenerateProductStatus(bitmapIsDisabled, 5, 0) ELSE bitmapIsDisabled END
			FROM [dbo].[CustProductStatus] cs WITH(ROWLOCK,UPDLOCK)
				INNER JOIN dbo.custInfo ci WITH(NOLOCK) ON cs.CustID = ci.CustID
			WHERE ci.mrecommend = @Custid

			UPDATE cs
			SET bitmapIsDisabled = CASE WHEN ci.SyncCasino = 1 AND ci.DisableCasino = 0 THEN dbo.f_GenerateProductStatus(bitmapIsDisabled, 5, 0) ELSE bitmapIsDisabled END
			FROM [dbo].[CustProductStatus] cs WITH(ROWLOCK,UPDLOCK)
				INNER JOIN dbo.custInfo ci WITH(NOLOCK) ON cs.CustID = ci.CustID
			WHERE ci.custid = @srecommend
		END
		ELSE IF @roleid = 2
		BEGIN
			UPDATE cs
			SET bitmapIsDisabled = CASE WHEN ci.SyncCasino = 1 AND ci.DisableCasino = 0 THEN dbo.f_GenerateProductStatus(bitmapIsDisabled, 5, 0) ELSE bitmapIsDisabled END
			FROM [dbo].[CustProductStatus] cs WITH(ROWLOCK,UPDLOCK)
				INNER JOIN dbo.custInfo ci WITH(NOLOCK) ON cs.CustID = ci.CustID
			WHERE ci.recommend = @Custid

			UPDATE cs
			SET bitmapIsDisabled = CASE WHEN ci.SyncCasino = 1 AND ci.DisableCasino = 0 THEN dbo.f_GenerateProductStatus(bitmapIsDisabled, 5, 0) ELSE bitmapIsDisabled END
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
FROM customer ci WITH(NOLOCK)
WHERE ci.site IN ('789y', '733333')
	AND ci.username IN (--733333 site
						'S922H','M922M','S922M','S922N','S922L','S922P','S922W','S922G','S922MA','S922A','SKKM','S09H','S09M','MMYBRM','PTM','S69R','S47R',
						'S47M','S53M','S49RM','S49H','SSTMR','SSTMH','SSTMJ','SSTMM','SSTMK','SSTMI','S3ARM','S3AR','S3AH','S3AAH','S3EH','S3BH','S3AB',
						'M83RM','M83RMB','M83ARM','RM8','M553R','M553AR','M553BR','M553H','M553AH','M553BH','M553CH','M553M','M553DH','S553H','S553M','SEH',
						'SEK','SEMA','MJRMB','SJM','SJJM','S2AR','S2BR','SAKM','HJ','HM','SWM','S42H','S42AH','S42CH','M42M','S42ARM','S88ML','S42EH','JAM',
						'JAHP','JAHB','S120M','S99H','S99M','S99ah','S99HK','S99HKK','S99BH','S99MHK','S99HA','AHM','AHN','AHO','BHO','AHP','AHQ','AHR','BHN',
						'AHH','AHE','bhu','AHF','AHG','AHJ','AHL','AHT','AHA','AHC','AHY','AHU','AHV','BHS','AHZ','AHX','AKK','DDD','DDA','GM1','DDB','GM2',
						'GMG','BKK','GMM','GAA','GBB','GCC','BHB','HPP','HPO','HPM','HPU','HPV','HPW','HPQ','HPK','HPN','HPX','HPY','HPMM','HPZ','HPR','SX3',
						'SX1','SX2','SZZ','SMY','HPC','HPD','HPB','HPF','SX5','SX6','HP2','SX7','SX8','HPS','HPM2','HP1','HPT','HP3','SX9','HMN','HSS','SX10',
						'SX11','SATM','JM','JS5','JS6','JS7','JS8','JSB','SYSM','SYSHK','JSR','JMA','JSE','JSQ','JSF','JSG','JST','JSL','JSM','JSZ','SHG',
						'JSN','JSP','JSU','JSV','JSW','JSX','JSY','JSO','JSI','JMJ','JHA','JHB','JMK','JML','JHC','S95RMB','M95RM','S95AH','S95BH','S95CH',
						'S95M','S95RM','S95DH','S95AM','PPH','PPM','SER','SSK','SSM','SSMA','SSKA','SSKB','SSKC','SCLH','SCLM','SKHH','SKMM','SKPRMB','KPM',
						'S9M','S9H','XKS','S555','S666','S777','JJB','JJM','S359BH','S359M','S359CH','S359HH','S359am','S359bm','SLP','SLI','SLN','SLO','SLG',
						'SLQ','SLW','SLB','SLL','SLR','LGA','SLY','SLE','SLF','SLV','ALR','ALM','ALH','ALA','ALB','ALC','ALD','ALK','ALF','ALG','ALL','ALJ',
						'ALE','ALO','TP','TH','KKM','KKH','KKMA','KKC','KKD','KKE','KKJ','KKN','KKY','KKF','KKG','KKK','KKL','KKI','KKR','KAB','KGK','KGL',
						'KGM','KGN','SRS','KAD','KGA','KGB','KBA','KBB','KBC','KGE','KBD','KBE','KAG','KAH','KAJ','KAK','KBG','KBH','KBJ','KBK ','KBU','XKM',
						'XKH','TLM','TLN','D71','cks','C1','C2','C3','C5','C7','TLH','C8','C9','C10','C11','C12',',C13','C15','H9','H1','C6','H2','H3','HZ',
						'H5','CV','9H','1C','EPL','KP','H8','S1','S2','S3','S6','S7','S9','SR','CM','ZS','CN','JD','JG','A6','R8','A1','A2','A3','A5','US','J1',
						'ZJ','VKH','AHMA','21A','HG9','HGG','HG8','HG7','HG6','HG88','HG101','HG102','HG71','HG81','HG29','HG39','HA8','VVY','VBY','VCY','RG1',
						'RG2','RG3','RG5','RG6','RG7','RG9','RG10','TS1','TS2','TS3','TS4','TS5','TS6','HK8','S7RR','MEA','MEB','DK','DM','JBK','JBM','SHKK',
						'SHHK2','SHHK7','hhma','HHN','HHK4','SBHK','S95RMB','M95RM','S95AH','S95BH','S95CH','S95M','S95RM','S95DH','S95AM','S12HK','S12M',
						'S12MM','MQRM','SLH','SLJ','SLM','D79','D83','D66','DRP',
						--789y site
						'SJU','S99U','SLA','KKU','KKU1','KKV','KKP','KKQ','KKX','KKZ','KKA','KKW','KKO','K1K','K2K','S88US','SCC','VIP','SKKS','SKS','SKT',
						'VID','SKD','SKV','SKX','SKF','SKG','SKY','SKZ','SKI','SKJ','SKB','SKQ','SKK','VIU','skn','skp','SKAC','SKAD','SKAE','SKAF','SKAG',
						'SKAH','SKAI','SKAJ','SKKA','QHN','QVN','SKAN','SHB','SKAO','SKAP','SHD','SKAR','SKAS','SKAT','skau','skav','skaw','skax','skay',
						'skba','skbb','SKBF','skbg','SKBI','SKBL','SKBM','skbn','skbp','SKBR','SKBT','SKTB','SKTA','sktc','SKBQ','SKBV','SKBW','SKBX','skby',
						'skbz','SKCA','skcb','SKCC','SKCD','SKCE','SKCF','SKCG','SKCI','SKCH','SKCJ','SKCK')

INSERT INTO #Cust(custid, srecommend, mrecommend, roleid, Mode)
SELECT ci.custid, ci.srecommend, ci.mrecommend, ci.roleid, 0 AS mode
FROM customer ci WITH(NOLOCK)
WHERE ci.site IN ('789y', '733333')
	AND ci.username IN (--789y site
						'AZ1','AZ13','AZ15','AZ3','AZ4','AZ5','AZ6','AZ7','BC5','BC7','BC8','BC9','BCA','BE','BK','BL','BM','BN','BP','BX1','BX11','BX14',
						'BX15','BX16','BX17','BX19','BX21','BX22','BX26','BX27','BX3','BX32','BX34','BX35','BX37','BX38','BX4','BX41','BX43','BX45','BX46',
						'BX48','BX50','BX54','BX55','BX56','BX60','BX61','BX62','BX64','BX65','BX76','BX77','BX79','BX80','BX81','BX83','BX84','BX85','BX86',
						'BX87','BX88','BX92','BX98','BY','CG1','CG13','CG15','CG27','CG29','CG33','CG34','CG38','CG43','CG44','CG46','CG48','CG60','DT1',
						'DT12','DT14','DT16','DT18','DT2','DT20','DT21','DT22','DT23','DT24','DT25','DT26','DT27','DT28','DT29','DT30','DT31','DT32','DT34',
						'DT35','DT36','DT37','DT38','DT39','DT40','DT41','DT42','DT43','DT44','DT45','DT46','DT47','DT48','DT49','DT50','DT51','DT8','DT80',
						'DT81','DT82','DT83','DT84','DT85','DT87','DT89','DT91','DT92','DT96','DT97','DT98','DX1','DX13','DX14','DX15','DX16','DX18','DX19',
						'DX2','DX21','DX22','DX23','DX24','DX25','DX26','DX27','DX29','DX3','DX34','DX36','DX38','DX39','DX4','DX43','DX44',',X45','DX46',
						'DX47','DX48','DX52','DX53','DX54','DX57','DX58','DX60','DX7','DX8','EA','EB','EB2','EB3','EG1','EH','EH1','EH2','EJ1','EN','ET1',
						'ET5','EW','HC','QC','QH','QM','QO','QR','qs','QV','S01','S02','S04','S09','S10','S12','S15','S17','S18','S19','SC','SD1','SD11',
						'SD13','SD14','SD17','SD19','SD20','SD22','SD23','SD29','SD31','SD32','SD38','SD40','SD44','SD45','SD47','SD48','SD53','SD55','SD56',
						'SD57','SD59','SD60','SD61','SD66','SD68','SD70','SD71','SD72','SD9','SG','SH','SK8','SS2','SS4','SS82','SS83','SS87','SS88','SS89',
						'SS9','SS90','SU3','SU6','SU7','SU8','SU9','XJ','XK1','XK2','XS','XXA','XXB','AZ14','AZ8','BD1','BD2','BD4','BR','BX10','BX12','BX13',
						'BX18','BX2','BX20','BX29','BX30','BX31','BX33','BX39','BX42','BX44','BX47','BX49','BX5','BX51','BX52','BX53','BX57','BX58','BX59','BX6',
						'BX82','BX91','BX94','BX95','BX96','BX97','CG18','CG19','CG23','CG24','CG25','CG26','CG28','CG31','CG32','CG36','CG40','CG41','CG5',
						'CG50','CG52','CG55','CG56','CG57','CG58','CG59','DT10','DT11','DT13','DT15','DT17','DT19','DT3','DT4','DT5','DT6','DT7',',DT9','DT90',
						'DT93','DT95','DT99','DX10','DX12','DX28','DX30','DX31','DX33','DX35','DX37','DX40','DX41','DX42','DX5','DX50','DX51','DX55','DX56',
						'DX59','DX6','DX9','EG3','EG5','EH3','EH9','EQ','ET3','QA','QI','S08','S13','S16','SD10','SD12','SD16','SD18','SD24','SD33','SD35',
						'SD36','SD39','SD49','SD50','SD51','SD52','SD54','SD63','SD65','SD67','SD69','SS01','SS1','SS3','SS81','SS84','SS85','SS86','SU1','SU10',
						'SU4','SU5','XH','XK','XK4','XK5','BC2','BX36','BX93','CG17','CG21','CG45','DT94','DX17','DX49','QK','QP','SD8','SU2','AZ10','AZ11',
						'AZ2','AZ9','BC','BC1','BC3','BC6','BD','BD3','BD5','BG','BH','BO','BX','BX23','BX24','BX25','BX28','BX40','BX63','BX7','BX75','BX78',
						'BX8','BX89','BX9','BX90','BX99','BZ','CG16','CG2','CG20','CG22','CG3','CG30','CG35','CG37','CG39','CG4','CG42','CG47','CG49','CG51',
						'CG53','CG54','CG6','CG7','CG8','CG9','DT86','DT88','DX11','DX20','DX32','EB1','EB5','EB6','EG2','EG6','EH7','EH8','EJ2','EK','EM',
						'EO','ET2','ET4','EX','QB','QL','QN','QT','QU','S03','S06','S07','S20','S21','S22','SD15','SD2','SD21','SD25','SD26',',D27','SD28',
						'SD3','SD30','SD34','SD37','SD41','SD42','SD43','SD46','SD5','SD58','SD6','SD62','SD64','SD7','SS5','SS6','SS7','SS8','XK3','DT66',
						'DT67','DT68','DT69','DT70','DT63','DT64','DT65','DT61','DT62','DT71','DT72','DT73','DT74','DT75','DT76','DT77','DT78','DT79','DTA1',
						'DTA2','DTA3','DTA4','DTA5','DTA6','DTA7','DTA8','DTA9','DTA10','DTA18','DTA19','DTA20','DTA12','DTA13','DTA14','DTA15','DTA16','DTA17',
						'DTA11','DTA27','DTA28','DTA29','DTA30','DTA22','DTA23','DTA24','DTA25','DTA26','DTA21')

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
FROM customer ci WITH(NOLOCK)
WHERE ci.site IN ('789y', '733333')
	AND ci.username IN (--733333 site
						'S922H','M922M','S922M','S922N','S922L','S922P','S922W','S922G','S922MA','S922A','SKKM','S09H','S09M','MMYBRM','PTM','S69R','S47R',
						'S47M','S53M','S49RM','S49H','SSTMR','SSTMH','SSTMJ','SSTMM','SSTMK','SSTMI','S3ARM','S3AR','S3AH','S3AAH','S3EH','S3BH','S3AB',
						'M83RM','M83RMB','M83ARM','RM8','M553R','M553AR','M553BR','M553H','M553AH','M553BH','M553CH','M553M','M553DH','S553H','S553M','SEH',
						'SEK','SEMA','MJRMB','SJM','SJJM','S2AR','S2BR','SAKM','HJ','HM','SWM','S42H','S42AH','S42CH','M42M','S42ARM','S88ML','S42EH','JAM',
						'JAHP','JAHB','S120M','S99H','S99M','S99ah','S99HK','S99HKK','S99BH','S99MHK','S99HA','AHM','AHN','AHO','BHO','AHP','AHQ','AHR','BHN',
						'AHH','AHE','bhu','AHF','AHG','AHJ','AHL','AHT','AHA','AHC','AHY','AHU','AHV','BHS','AHZ','AHX','AKK','DDD','DDA','GM1','DDB','GM2',
						'GMG','BKK','GMM','GAA','GBB','GCC','BHB','HPP','HPO','HPM','HPU','HPV','HPW','HPQ','HPK','HPN','HPX','HPY','HPMM','HPZ','HPR','SX3',
						'SX1','SX2','SZZ','SMY','HPC','HPD','HPB','HPF','SX5','SX6','HP2','SX7','SX8','HPS','HPM2','HP1','HPT','HP3','SX9','HMN','HSS','SX10',
						'SX11','SATM','JM','JS5','JS6','JS7','JS8','JSB','SYSM','SYSHK','JSR','JMA','JSE','JSQ','JSF','JSG','JST','JSL','JSM','JSZ','SHG',
						'JSN','JSP','JSU','JSV','JSW','JSX','JSY','JSO','JSI','JMJ','JHA','JHB','JMK','JML','JHC','S95RMB','M95RM','S95AH','S95BH','S95CH',
						'S95M','S95RM','S95DH','S95AM','PPH','PPM','SER','SSK','SSM','SSMA','SSKA','SSKB','SSKC','SCLH','SCLM','SKHH','SKMM','SKPRMB','KPM',
						'S9M','S9H','XKS','S555','S666','S777','JJB','JJM','S359BH','S359M','S359CH','S359HH','S359am','S359bm','SLP','SLI','SLN','SLO','SLG',
						'SLQ','SLW','SLB','SLL','SLR','LGA','SLY','SLE','SLF','SLV','ALR','ALM','ALH','ALA','ALB','ALC','ALD','ALK','ALF','ALG','ALL','ALJ',
						'ALE','ALO','TP','TH','KKM','KKH','KKMA','KKC','KKD','KKE','KKJ','KKN','KKY','KKF','KKG','KKK','KKL','KKI','KKR','KAB','KGK','KGL',
						'KGM','KGN','SRS','KAD','KGA','KGB','KBA','KBB','KBC','KGE','KBD','KBE','KAG','KAH','KAJ','KAK','KBG','KBH','KBJ','KBK ','KBU','XKM',
						'XKH','TLM','TLN','D71','cks','C1','C2','C3','C5','C7','TLH','C8','C9','C10','C11','C12',',C13','C15','H9','H1','C6','H2','H3','HZ',
						'H5','CV','9H','1C','EPL','KP','H8','S1','S2','S3','S6','S7','S9','SR','CM','ZS','CN','JD','JG','A6','R8','A1','A2','A3','A5','US','J1',
						'ZJ','VKH','AHMA','21A','HG9','HGG','HG8','HG7','HG6','HG88','HG101','HG102','HG71','HG81','HG29','HG39','HA8','VVY','VBY','VCY','RG1',
						'RG2','RG3','RG5','RG6','RG7','RG9','RG10','TS1','TS2','TS3','TS4','TS5','TS6','HK8','S7RR','MEA','MEB','DK','DM','JBK','JBM','SHKK',
						'SHHK2','SHHK7','hhma','HHN','HHK4','SBHK','S95RMB','M95RM','S95AH','S95BH','S95CH','S95M','S95RM','S95DH','S95AM','S12HK','S12M',
						'S12MM','MQRM','SLH','SLJ','SLM','D79','D83','D66','DRP',
						--789y site
						'SJU','S99U','SLA','KKU','KKU1','KKV','KKP','KKQ','KKX','KKZ','KKA','KKW','KKO','K1K','K2K','S88US','SCC','VIP','SKKS','SKS','SKT',
						'VID','SKD','SKV','SKX','SKF','SKG','SKY','SKZ','SKI','SKJ','SKB','SKQ','SKK','VIU','skn','skp','SKAC','SKAD','SKAE','SKAF','SKAG',
						'SKAH','SKAI','SKAJ','SKKA','QHN','QVN','SKAN','SHB','SKAO','SKAP','SHD','SKAR','SKAS','SKAT','skau','skav','skaw','skax','skay',
						'skba','skbb','SKBF','skbg','SKBI','SKBL','SKBM','skbn','skbp','SKBR','SKBT','SKTB','SKTA','sktc','SKBQ','SKBV','SKBW','SKBX','skby',
						'skbz','SKCA','skcb','SKCC','SKCD','SKCE','SKCF','SKCG','SKCI','SKCH','SKCJ','SKCK')

INSERT INTO #Cust(custid, srecommend, mrecommend, roleid, Mode)
SELECT ci.custid, ci.srecommend, ci.mrecommend, ci.roleid, 0 AS mode
FROM customer ci WITH(NOLOCK)
WHERE ci.site IN ('789y', '733333')
	AND ci.username IN (--789y site
						'AZ1','AZ13','AZ15','AZ3','AZ4','AZ5','AZ6','AZ7','BC5','BC7','BC8','BC9','BCA','BE','BK','BL','BM','BN','BP','BX1','BX11','BX14',
						'BX15','BX16','BX17','BX19','BX21','BX22','BX26','BX27','BX3','BX32','BX34','BX35','BX37','BX38','BX4','BX41','BX43','BX45','BX46',
						'BX48','BX50','BX54','BX55','BX56','BX60','BX61','BX62','BX64','BX65','BX76','BX77','BX79','BX80','BX81','BX83','BX84','BX85','BX86',
						'BX87','BX88','BX92','BX98','BY','CG1','CG13','CG15','CG27','CG29','CG33','CG34','CG38','CG43','CG44','CG46','CG48','CG60','DT1',
						'DT12','DT14','DT16','DT18','DT2','DT20','DT21','DT22','DT23','DT24','DT25','DT26','DT27','DT28','DT29','DT30','DT31','DT32','DT34',
						'DT35','DT36','DT37','DT38','DT39','DT40','DT41','DT42','DT43','DT44','DT45','DT46','DT47','DT48','DT49','DT50','DT51','DT8','DT80',
						'DT81','DT82','DT83','DT84','DT85','DT87','DT89','DT91','DT92','DT96','DT97','DT98','DX1','DX13','DX14','DX15','DX16','DX18','DX19',
						'DX2','DX21','DX22','DX23','DX24','DX25','DX26','DX27','DX29','DX3','DX34','DX36','DX38','DX39','DX4','DX43','DX44',',X45','DX46',
						'DX47','DX48','DX52','DX53','DX54','DX57','DX58','DX60','DX7','DX8','EA','EB','EB2','EB3','EG1','EH','EH1','EH2','EJ1','EN','ET1',
						'ET5','EW','HC','QC','QH','QM','QO','QR','qs','QV','S01','S02','S04','S09','S10','S12','S15','S17','S18','S19','SC','SD1','SD11',
						'SD13','SD14','SD17','SD19','SD20','SD22','SD23','SD29','SD31','SD32','SD38','SD40','SD44','SD45','SD47','SD48','SD53','SD55','SD56',
						'SD57','SD59','SD60','SD61','SD66','SD68','SD70','SD71','SD72','SD9','SG','SH','SK8','SS2','SS4','SS82','SS83','SS87','SS88','SS89',
						'SS9','SS90','SU3','SU6','SU7','SU8','SU9','XJ','XK1','XK2','XS','XXA','XXB','AZ14','AZ8','BD1','BD2','BD4','BR','BX10','BX12','BX13',
						'BX18','BX2','BX20','BX29','BX30','BX31','BX33','BX39','BX42','BX44','BX47','BX49','BX5','BX51','BX52','BX53','BX57','BX58','BX59','BX6',
						'BX82','BX91','BX94','BX95','BX96','BX97','CG18','CG19','CG23','CG24','CG25','CG26','CG28','CG31','CG32','CG36','CG40','CG41','CG5',
						'CG50','CG52','CG55','CG56','CG57','CG58','CG59','DT10','DT11','DT13','DT15','DT17','DT19','DT3','DT4','DT5','DT6','DT7',',DT9','DT90',
						'DT93','DT95','DT99','DX10','DX12','DX28','DX30','DX31','DX33','DX35','DX37','DX40','DX41','DX42','DX5','DX50','DX51','DX55','DX56',
						'DX59','DX6','DX9','EG3','EG5','EH3','EH9','EQ','ET3','QA','QI','S08','S13','S16','SD10','SD12','SD16','SD18','SD24','SD33','SD35',
						'SD36','SD39','SD49','SD50','SD51','SD52','SD54','SD63','SD65','SD67','SD69','SS01','SS1','SS3','SS81','SS84','SS85','SS86','SU1','SU10',
						'SU4','SU5','XH','XK','XK4','XK5','BC2','BX36','BX93','CG17','CG21','CG45','DT94','DX17','DX49','QK','QP','SD8','SU2','AZ10','AZ11',
						'AZ2','AZ9','BC','BC1','BC3','BC6','BD','BD3','BD5','BG','BH','BO','BX','BX23','BX24','BX25','BX28','BX40','BX63','BX7','BX75','BX78',
						'BX8','BX89','BX9','BX90','BX99','BZ','CG16','CG2','CG20','CG22','CG3','CG30','CG35','CG37','CG39','CG4','CG42','CG47','CG49','CG51',
						'CG53','CG54','CG6','CG7','CG8','CG9','DT86','DT88','DX11','DX20','DX32','EB1','EB5','EB6','EG2','EG6','EH7','EH8','EJ2','EK','EM',
						'EO','ET2','ET4','EX','QB','QL','QN','QT','QU','S03','S06','S07','S20','S21','S22','SD15','SD2','SD21','SD25','SD26',',D27','SD28',
						'SD3','SD30','SD34','SD37','SD41','SD42','SD43','SD46','SD5','SD58','SD6','SD62','SD64','SD7','SS5','SS6','SS7','SS8','XK3','DT66',
						'DT67','DT68','DT69','DT70','DT63','DT64','DT65','DT61','DT62','DT71','DT72','DT73','DT74','DT75','DT76','DT77','DT78','DT79','DTA1',
						'DTA2','DTA3','DTA4','DTA5','DTA6','DTA7','DTA8','DTA9','DTA10','DTA18','DTA19','DTA20','DTA12','DTA13','DTA14','DTA15','DTA16','DTA17',
						'DTA11','DTA27','DTA28','DTA29','DTA30','DTA22','DTA23','DTA24','DTA25','DTA26','DTA21')

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