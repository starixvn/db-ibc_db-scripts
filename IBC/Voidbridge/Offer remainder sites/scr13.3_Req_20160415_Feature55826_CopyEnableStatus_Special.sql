/*
	Created: Elodie	
	Task: Initialize Product Status of Voidbridge for special customers
	DB: DBCUST/CustDB
	Date: 20160420
*/ 
	
CREATE TABLE #supers (custid INT, SyncCasino BIT, DisableCasino BIT)
	
INSERT INTO #supers(custid, SyncCasino, DisableCasino)
SELECT ci.custid, SyncCasino, DisableCasino
FROM custInfo ci WITH(NOLOCK)
	INNER JOIN Customer c WITH (NOLOCK) ON c.custid = ci.custid
WHERE c.site IN ('789y', '733333')
	AND ci.username IN ('SHK','SPHM','SPK','SPKM','SPKR','SQK','S56RM','S56R','S556R','S556AR','S56BBH','S56EH','S56DRM','S56FH','S56GH','S56JH','S56KH',
						'S56LH','S56MH','S56NH','S56PH','s56rh','S56SH','S56AA','S56AB','S56UH','S56VH','HKD','HKD01','HKD02','HK01','HK02','HK03','HK05',
						'HK07','HK10','HK11','S56ERM','HK12','HK13','HK15','HK16','HK17','HK18','HK19','HK20','HK21','HK22','HK23','HK25','HK26','HK27','HK28',
						'HK29','HK30','S56US','S56AU','S56BU','S56CU','S56DU','BV1','BV10','BV11','BV12','BV13','BV14','BV15','BV16','BV17','BV18','BV19','BV2',
						'BV20','BV21','BV22','BV23','BV24','BV25','BV26','BV27','BV28','BV29','BV3','BV30','BV31','BV32','BV33','BV34','BV35','BV36','BV37',
						'BV38','BV39','BV4','BV40','BV5','BV6','BV7','BV8','BV9','CAT1','CAT10','CAT11','CAT12','CAT14','CAT15','CAT16','CAT2','CAT3','CAT4',
						'CAT5','CAT6','CAT7','CAT8','CAT9','CP1','CP10','CP2','CP3','CP4','CP5','CP6','CP7','CP8','CP9','EA1','EA2','EA3','EA4','EA5','EA6',
						'EA7','EA8','EA9','EAA','EAB','EAC','EAD','EAE','EAF','EAG','EAH','EAI','EAJ','EAK','EBA','EBB','EBC','EBD','EBE','EBF','EBG','EBH',
						',EBI','EBJ','EBK','EBL','EBM','EC','EEA','EF','EG','EI','EJ','EJA','EL','EP','ER','ES','ET10','ET6','ET7','ET8','ET9','EU','EV','EY',
						'FC1','FC10','FC11','FC12','FC13','FC14','FC15','FC16','FC17','FC18','FC19','FC2','FC20','FC21','FC22','FC23','FC24','FC25','FC26',
						'FC27','FC28','FC29','FC3','FC30','FC4','FC5','FC6','FC7','FC8','FC9','KX1','KX10','KX2','KX3','KX4','KX5','KX6','KX7','KX8','KX9',
						'KY1','KY10','KY11','KY12','KY13','KY14','KY15','KY16','KY17','KY18','KY19','KY2','KY20','KY21','KY22','KY23','KY24','KY25','KY26',
						'KY27','KY28','KY29','KY3','KY30','KY31','KY32','KY33','KY34','KY35','KY36','KY37','KY38','KY39','KY4','KY40','KY41','KY42','KY43',
						'KY44','KY45','KY46','KY47','KY5','KY50','KY51','KY52','KY53','KY54','KY55','KY56','KY57','KY58','KY59','KY6','KY60','KY61','KY62',
						'KY63','KY64','KY65','KY66','KY67','KY68','KY69','KY7','KY70','KY71','KY72','KY73','KY74','KY75','KY76','KY77','KY78','KY79','KY8',
						'KY80','KY81','KY82','KY83','KY84','KY85','KY86','KY87','KY88','KY89','KY9','KY90','KY91','KY92','KY93','KY94','KY95','KY96','KY97',
						',Y98','KY99','NC1','NC10','NC2','NC3','NC4','NC5','NC6','NC7','NC8','NC9','NW1','NW10','NW11','NW12','NW13','NW14','NW15','NW16',
						'NW17','NW18','NW19','NW2','NW20','NW21','NW22','NW23','NW24','NW25','NW26','NW27','NW28','NW29','NW3','NW30','NW31','NW32','NW33',
						'NW34','NW35','NW36','NW37','NW38','NW39','NW4','NW40','NW41','NW42','NW43','NW44','NW45','NW46','NW47','NW48','NW49','NW5','NW50',
						'NW51','NW52','NW53','NW54','NW55','NW56','NW57','NW58','NW59','NW6','NW60','NW61','NW62','NW63','NW64','NW65','NW66','NW67','NW68',
						'NW69','NW7','NW70','NW71','NW72','NW73','NW74','NW75','NW76','NW77','NW78','NW79','NW8','NW80','NW9','PS1','PS10','PS11','PS12','PS13',
						'PS14','PS15','PS16','PS17','PS18','PS19','PS2','PS20','PS21','PS22','PS23','PS24',
						'PS25','PS26','PS27','PS28','PS29','PS3','PS30','PS4','PS5','PS6','PS7','PS8','PS9','Q1','Q10','Q11','Q12','Q13','Q14','Q15','Q16',
						'Q17','Q18','Q19','Q2','Q20','Q3','Q4','Q5','Q6','Q7','Q8','Q9','QD','QE','QF','QG','QJ','RRL1','RRL10','RRL11','RRL12',',RL13','RRL14',
						'RRL15','RRL16','RRL17','RRL18','RRL19','RRL2','RRL20','RRL21','RRL22','RRL23','RRL24','RRL25','RRL26','RRL27','RRL28','RRL29','RRL3',
						'RRL30','RRL4','RRL5','RRL6','RRL7','RRL8','RRL9','SSA','SSB','SSC','SSE','TY01','TY02','TY03','TY04','TY05','TY06','TY07','TY08',
						'TY09','TY10','TY11','TY12','TY13','TY14','TY15','TY16','TY17','TY18','TY19','TY20','TY21','TY22','TY23','TY24','TY25','TY26','TY27',
						'TY28','TY29','TY30','TY31','TY32','TY33','TY34','TY35','TY36','TY37','TY38','TY39','TY40','TY41','TY42','TY43','TY44','TY45','TY46',
						'TY47','TY48','TY49','TY50','TY51','TY52','TY53','TY54','TY55','TY56','TY57','TY58','TY59','TY60','TY61','TY62','TY63','TY64','TY65',
						'TY66','TY67','TY68','TY69','TY70','TY71','TY72','TY73','TY74','TY75','TY76','TY77','TY78','TY79','TY80','TY81','TY82','TY83','TY84',
						'TY85','TY86','TY87','TY88','TY89','TY90','TY91','TY92','TY93','TY94','TY95','TY96','TY97','TY98','TY99','XA','XB','XC','XD','XG','XM',
						'XN','XO','XP','XQ','XR','XX','XXD','XXE','XXG','XXH','XXJ','XXK','XXO','XXP',',XXQ','XXR','XXS','xxt','XY','XZ','ZA1','ZA10','ZA11',
						'ZA12','ZA13','ZA14','ZA15','ZA16','ZA17','ZA18','ZA19','ZA2','ZA20','ZA21','ZA22','ZA23','ZA24','ZA25','ZA26','ZA27','ZA28','ZA29',
						'ZA3','ZA30','ZA31','ZA32','ZA33','ZA34','ZA35','ZA36','ZA37','ZA38','ZA39','ZA4','ZA40','ZA41','ZA42','ZA43','ZA44','ZA45','ZA46',
						'ZA47','ZA48','ZA49','ZA5','ZA50','ZA51','ZA52','ZA53','ZA54','ZA55','ZA56','ZA57','ZA58','ZA59','ZA6','ZA60','ZA7','ZA8','ZA9')

/*******************************CUST PRODUCTSTATUS TABLE*******************************/	
UPDATE cs
SET bitmapIsDisabled = CASE WHEN ci.SyncCasino = 1 AND ci.DisableCasino = 0 THEN dbo.f_GenerateProductStatus(bitmapIsDisabled, 5, 0) ELSE bitmapIsDisabled END
FROM [dbo].[CustProductStatus] cs WITH(ROWLOCK,UPDLOCK)	
	INNER JOIN #supers ci WITH(NOLOCK) ON cs.CustID = ci.CustID

UPDATE cs
SET bitmapIsDisabled = CASE WHEN ci.SyncCasino = 1 THEN dbo.f_GenerateProductStatus(bitmapIsDisabled, 5, 0) ELSE bitmapIsDisabled END
FROM [dbo].[CustProductStatus] cs WITH(ROWLOCK,UPDLOCK)	
	INNER JOIN CustInfo ci WITH(NOLOCK) ON cs.CustID = ci.CustID
WHERE ci.username IN ('SLLM')
	 
