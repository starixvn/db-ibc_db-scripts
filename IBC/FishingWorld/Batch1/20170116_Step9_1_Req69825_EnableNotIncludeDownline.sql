	/*
	Created: Winnie
	Task: Enable Fishing World not using execrep [RedmineID: 69825]
	DB: DBCUST/CustDB
	Date: 20170116
	*/ 
	CREATE TABLE #tempcusts (custid INT PRIMARY KEY, roleId INT,AllLine BIT,IsSM BIT)
	INSERT INTO #tempcusts(custid,roleId,AllLine,IsSM)
	SELECT custid,roleid,0,0
	FROM Customer WITH(NOLOCK) WHERE username 	
	IN('S32RMB','M32RM','S32R','S32AR','S32H','S32AH','S32BH','S32CH','S32DH','M32M','S32EH','S32FH','S32GH','S32M','S32AM','S32HH','S32IH','S32JH','S32BM','S32HK','S32K','S32HKD'
	,'S32RM','S32KH','S32LH','S32CM','S32DM','S32MH','S32NH')	
	UNION
	SELECT custid,roleid,0,0
	FROM Customer WITH(NOLOCK) WHERE username IN('S999RM','SHK','SPHM','SPK','SPKM','SPKR','SQK')	
	UNION
	SELECT custid,roleid,0,0
	FROM Customer WITH(NOLOCK) WHERE username IN ('MAMRM','SMAMRMB','SAMR')
	UNION
	SELECT custid,roleid,0,0
	FROM Customer WITH(NOLOCK) WHERE username IN ('M25RM','M25ARMB','M25BRMB','S25R','M25HK','S25RM','L25RM')
	
	UNION
	SELECT custid,roleid,0,0
	FROM Customer WITH(NOLOCK) WHERE username IN ('S33M','S33MR','S33A')
	
	UNION
	SELECT custid,roleid,0,0
	FROM Customer WITH(NOLOCK) WHERE username IN ('SCHK','SCM','SCAI','SCI','SCDH','SCDK')
	UNION
	SELECT custid,roleid,0,0
	FROM Customer WITH(NOLOCK) WHERE username IN ('HIF','S69R')
	UNION
	SELECT custid,roleid,0,0
	FROM Customer WITH(NOLOCK) WHERE username IN ('S56RM','S56R','S556R','S556AR','S56BBH','S56EH','S56DRM','S56FH','S56GH','S56JH','S56KH','S56LH','S56MH','S56NH','S56PH','s56rh','S56SH',
	'S56AA','S56AB','S56UH','S56VH','HKD','HKD01','HKD02','HK01','HK02','HK03','HK05','HK07','HK10','HK11','S56ERM','HK12','HK13','HK15','HK16','HK17','HK18','HK19','HK20','HK21','HK22',
	'HK23','HK25','HK26','HK27','HK28','HK29','HK30','S56FRM','HK31','HK32','HK33','HK34','HK35','HK36','HK37','HK56','HK38')
	UNION
	SELECT custid,roleid,0,0
	FROM Customer WITH(NOLOCK) WHERE username IN ('s79rrr','S79RM','S79AR','S79H','S79HH','S79HK','S799H','S79SH','M79H','S79HG','S79hz','S79HS','WD1','WD2','WD3','WDD','WDE','WDH',
	'WDI','WDJ','WDK','WDL')
	UNION
	SELECT custid,roleid,0,0
	FROM Customer WITH(NOLOCK) WHERE username IN ('WC','WD7','WD8','WD9','DJA','DJB','DJC','DJD','DJE','DJ27','D27','RM27')
	
	UNION
	SELECT custid,roleid,0,0
	FROM Customer WITH(NOLOCK) WHERE username IN ('S305CRMB','S305RM','S31RM','S31RMB','S305R','S31ARMB','SSFH','SSF1H','S3H','SSF2H','SSF3H','S3HH','SSF5H','S3HK','S305M','S3HG','S3HJ','S3HP'
	,'SSF6H','SSF7H')
	
	UNION
	SELECT custid,roleid,0,0
	FROM Customer WITH(NOLOCK) WHERE username IN ('S222R','S222HK','S222AH','S222BH','S222CH','S222DH','2EH','S222FH','S222GH','2KH','S222MH','2AH','2BH','2CH','2DH','2LH','2MH','2NH','2PH'
	,'2MM','2YH','2FH','2GH','2MN','2WH','S222JH','2HH','2RM','2NN','2HK','2RR','2JH','S222N','S222ZH','2XX','2WW','2RH','2IH','2QH','2OH','2SH','2AA','2AB','2MP','2HA','2MY','2MQ','2UH','2HB')
	
	UNION
	SELECT custid,roleid,0,0
	FROM Customer WITH(NOLOCK) WHERE username IN ('HJ','HM')
	
	UNION
	SELECT custid,roleid,0,1
	FROM Customer WITH(NOLOCK) WHERE username IN ('SWM')
	UNION
	SELECT custid,roleid,0,0
	FROM Customer WITH(NOLOCK) WHERE username IN ('S42H','S42AH','S42CH','M42M','S42ARM','S88ML','S42EH','S42F','S2M','S2HH','S2MM','S2MN','S2HY','ACD','JMC')
	UNION
	SELECT custid,roleid,0,0
	FROM Customer WITH(NOLOCK) WHERE username IN ('MKWRM','SRRMB','SKWRMB','SRARMB','SRH','SRHK','SRMA','SRHKA','SRJ','SRKH','SRHH','SRK','SRHD','SRMC','SRQ','SRHC','JAM','JAHP','JAHB')
	
	UNION
	SELECT custid,roleid,0,0
	FROM Customer WITH(NOLOCK) WHERE username IN ('S120M','S99H','S99M','S99ah','S99HK','S99HKK','S99BH','S99MHK','S99HA')
	
	UNION
	SELECT custid,roleid,0,0
	FROM Customer WITH(NOLOCK) WHERE username IN ('KJH','KJHB','KJM','KJD','KJMB','KJE','KJB','KJC','KJF','KJMC','KJMA','KJG','KJMD','KJL','KJO','KJME','KJMF','KJMG','CYKM','YKM'
	,'M822M','S822R','GEH','GFH','S822M','S822MA','GFJ','D5M')
	
	UNION
	SELECT custid,roleid,0,0
	FROM Customer WITH(NOLOCK) WHERE username IN ('SLH','SLK','SLJ','SLM')
	
	UNION
	SELECT custid,roleid,0,0
	FROM Customer WITH(NOLOCK) WHERE username IN ('M71RMB','M71ARMB','M71BRMB','M71CRMB','S71RM','M71DRMB','S71H','S71AH','S71M','S71BH','S71MA','S71CH','S71DH','S71MB')
	
	UNION
	SELECT custid,roleid,0,0
	FROM Customer WITH(NOLOCK) WHERE username IN ('S62H','KM6','KH6','SKHH','SKMM')
	
	UNION
	SELECT custid,roleid,0,0
	FROM Customer WITH(NOLOCK) WHERE username IN ('LHH','LHM','LHM1','LHM2','LHH1','LHH2','LHH3','LHH4','LHH5','LHH6','LHR','LHH7','LHH8','LHH9','LHH10','LHH11','LHH12','LHA','LHM3','LHM5'
	,'LHM6','LHM7','LHM8','S9M','S9H','XKS','S555','S666','S777')
	
	UNION
	SELECT custid,roleid,0,0
	FROM Customer WITH(NOLOCK) WHERE username IN ('TP','TH','TC','TF','KKM','KKH','KKMA','KKC','KKD','KKE','KKJ','KKN','KKY','KKF','KKG','KKK','KKL','KKI','KKR','KAB','KGK','KGL'
	,'KGM','KGN','SRS','KAD','KGA','KGB','KBA','KBB','KBC','KGE','KBD','KBE','KAG','KAH','KAJ','KAK','KBG','KBH','KBJ','KBK','KBU','KBL','KBV','KBW','KAI')
	
	UNION
	SELECT custid,roleid,0,0
	FROM Customer WITH(NOLOCK) WHERE username IN ('EEM','EEH','EEK','HG9','HGG','HG8','HG7','HG6','HG88','HG101','HG102','HG71','HG81','HG29','HA8','H39','HGA','H7','HG3','HGB','HG5')
	
	UNION
	SELECT custid,roleid,0,0
	FROM Customer WITH(NOLOCK) WHERE username IN ('RG1','RG2','RG3','RG5','RG6','RG7','RG9','RG10','RG11','RG12','RG13','RG8','PPS','PPJ','PPN','PPQ','PPZ','PPP','PPT','PPA')
	
	UNION
	SELECT custid,roleid,0,0
	FROM Customer WITH(NOLOCK) WHERE username IN ('RC')
	
	UNION
	SELECT custid,roleid,0,0
	FROM Customer WITH(NOLOCK) WHERE username IN ('MEA','MEB','DK','DM','JBK','JBM','JBJ','FNM','WKH')
	
	DECLARE @Sporttype INT
	SELECT @Sporttype=219
	DECLARE @BitOrder INT
	SELECT @BitOrder= bitmapOrder from ProductStatusProfile WITH(NOLOCK) where SportType=@Sporttype
	
	UPDATE cs
	SET								
		 bitmapIsDisabled =  dbo.f_GenerateProductStatus (cs.bitmapIsDisabled,@BitOrder,0)
	FROM [dbo].[CustProductStatus] cs WITH(ROWLOCK,UPDLOCK)
	INNER JOIN #tempcusts t ON cs.CustID=t.CustID
	WHERE AllLine=0
	
	UPDATE cs
	SET								
		 bitmapIsDisabled =  dbo.f_GenerateProductStatus (cs.bitmapIsDisabled,@BitOrder,0)
	FROM [dbo].[CustProductStatus] cs WITH(ROWLOCK,UPDLOCK)
	WHERE cs.CustID IN(
	SELECT DISTINCT c.srecommend FROM #tempcusts t 
	INNER JOIN CustInfo c WITH(NOLOCK) ON t.custid=c.custid
	WHERE t.roleid=3)
	
	UPDATE cs
	SET								
		 bitmapIsDisabled =  dbo.f_GenerateProductStatus (cs.bitmapIsDisabled,@BitOrder,0)
	FROM [dbo].[CustProductStatus] cs WITH(ROWLOCK,UPDLOCK)
	WHERE cs.CustID IN
	(SELECT c.custid FROM #tempcusts t 
	INNER JOIN CustInfo c WITH(NOLOCK) ON t.custid=c.srecommend
	WHERE IsSM=1 AND c.roleid=3)
	
	drop table #tempcusts







	