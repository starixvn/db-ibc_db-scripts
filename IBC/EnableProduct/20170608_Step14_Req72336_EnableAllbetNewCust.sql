
/*
	Created: Winnie	
	Task:  Enable and UnHid AllBet for new SMA
	DB: DBCUST/CustDB
	Date: 20170515
	Deployed Date: 20170608 04:57PM
*/ 
DECLARE	
	@maxcustid INT	
	,@Site VARCHAR(10)
	
CREATE TABLE #tempCusts (custid int,site varchar(10))
SELECT @maxcustid = xxx

CREATE TABLE #tempSuper(CUSTID INT PRIMARY KEY)
INSERT INTO #tempSuper(CUSTID)
SELECT Custid FROM Customer WITH(NOLOCK) WHERE username IN(
'2AA','2CH','2DH','2MQ','2RH','AC12','AC14','AHX','B30T','BC8','BC9','BL','BP','BV11','BV29','BV8','CAT11','CAT12','CG13','CG27','CG34','D77','DTB55','DTB82','DTB92','DTB95','DTB97','DTC1','DTC11','DTC15','DTC27',
'DTC29','DTC30','DTC31','DTC37','DTC43','DTC47','DTC48','DTC56','DTC57','DTC59','DTC6','DTC63','DTC67','DTC70','DTC71','DTC78','DTC79','DTC8','DTC81','DTC85','DTC86','DX58','ES','EW','HD','HK07','HK10','HK27','KP31','KP32','KP39',
'KP6','KP67','KP71','KP79','KPD','KPH','KY1','KY19','KY58','KY9','LHH','MC2','MC5','MEB','MK1','NC2','NC9','NW20','NW21','NW22','NW24','NW34','NW52','NW72','OP40','OP41','OP47','OP5','OP62','OP79','OP8','PKC','PKD','PKP','PPS',
'PPU','PS13','PS30','Q11','Q15','Q17','Q3','Q4','QM','QQQ3','R312R','RRL2','S09','S222DH','S222X','S2M','S312G','S312RMB','S32CH','S33M','S42CH','S56AE','S56DRM','S56H','S56JH','S56RM','S688H','S69R','S922M','S99ah','SBTL','SBZB',
'SD31','SG45H','SMY','SS89','SSYR','SWH','TD','TY09','TY18','TY28','TY33','TY67','TY78','TY81','TY83','WKR','XM','YSM','ZA41','ZA43','ZA71','ZA72','ZA74','ZA93')



INSERT INTO #tempCusts(custid,site)
SELECT c.custid,s.site
FROM dbo.Customer s WITH(NOLOCK)
INNER JOIN custInfo c WITH(NOLOCK) ON c.srecommend=s.custid
WHERE (s.roleid = 4 	
AND s.custid IN (SELECT custid FROM #tempSuper) 
AND c.Enabled=1	
AND c.custid>@maxcustid
AND c.roleid BETWEEN 2 AND 4
)
	-- Allbet
	UPDATE cs
	SET				
		 bitmapIsDisabled = dbo.f_GenerateProductStatus (cs.bitmapIsDisabled,6,0) 		
	FROM [dbo].[CustProductStatus] cs WITH(ROWLOCK,UPDLOCK)
	INNER JOIN #tempCusts t ON cs.custid=t.custid
	WHERE dbo.f_getProductStatus (cs.bitmapHasSynced,6) = 1 AND dbo.f_getProductStatus (cs.bitmapIsDisabled,6) = 1 AND dbo.f_getProductStatus (cs.bitmapIsHidden,6) = 0	
