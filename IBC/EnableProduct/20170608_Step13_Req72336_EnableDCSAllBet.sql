

/*
	Created: Winnie	
	Task: Enable and UnHide AllBet for SMA
	DB: DBCUST/CustDB
	Date: 20170608
	Deployed Date: 20170608 04:57PM
*/ 
ALTER PROCEDURE [dbo].[Acc_DynamicCustomerInfo_09]
	@srecommend INT	
	,@maxcustid INT
	,@target VARCHAR(20)	
AS
BEGIN
	SET NOCOUNT ON
	
	IF (@target = 'REPLICATED' AND @@SERVERNAME = 'DBCUST') RETURN	-- run at all replicated servers
	IF (@target = 'DBCUST' AND @@SERVERNAME <> 'DBCUST') RETURN -- run at dbtrans only
	
	IF NOT (dbo.f_CheckRepTable('Custinfo') = 1 
	   AND dbo.f_CheckRepTable('CustProductStatus') = 1	  
	   )
		RETURN	
	
	-- Allbet
	CREATE TABLE #temp (CustID INT PRIMARY KEY)
	INSERT INTO #temp(CustID)
	SELECT cs.CustID
	FROM [dbo].[CustProductStatus] cs WITH(NOLOCK)
	INNER JOIN custInfo CI WITH (NOLOCK) ON cs.CustID = ci.CustID
	WHERE cs.CustID<=@maxcustid AND 
	ci.srecommend = @srecommend AND ci.roleid BETWEEN 2 AND 4	AND ci.Enabled=1
	AND (SELECT * FROM dbo.f_CustSetting_ProductStatusSel  (cs.bitmapHasSynced,6) )= 1 AND (SELECT * FROM dbo.f_CustSetting_ProductStatusSel  (cs.bitmapIsDisabled,6)) = 1
	AND  (SELECT * FROM dbo.f_CustSetting_ProductStatusSel  (cs.bitmapIsHidden,6) )= 0	

	UPDATE cs
	SET				
			bitmapIsDisabled = dbo.f_GenerateProductStatus (cs.bitmapIsDisabled,6,0) 		
	FROM [dbo].[CustProductStatus] cs WITH(ROWLOCK,UPDLOCK)
	INNER JOIN #temp t ON cs.CustID=t.CustID

	DROP TABLE #temp
END
GO
-- END STEP 1: DEPLOY THIS SP @DBCUST.CustDB --------
------------------------------------------------------	

-- BEGIN STEP 2: RUN THIS SCRIPT AT ALL REPLICATED SERVERS (06/DBTP) -----
--------------------------------------------------------------------------------------
CREATE TABLE #supers (custid int,isfinished bit default(0))

DECLARE  @srecommend INT,@max_custid INT
SELECT @max_custid = xxx

INSERT INTO #supers(custid)
SELECT ci.custid
FROM dbo.Customer ci WITH(NOLOCK)
WHERE username IN('2AA','2CH','2DH','2MQ','2RH','AC12','AC14','AHX','B30T','BC8','BC9','BL','BP','BV11','BV29','BV8','CAT11','CAT12','CG13','CG27','CG34','D77','DTB55','DTB82','DTB92','DTB95','DTB97','DTC1','DTC11','DTC15','DTC27',
'DTC29','DTC30','DTC31','DTC37','DTC43','DTC47','DTC48','DTC56','DTC57','DTC59','DTC6','DTC63','DTC67','DTC70','DTC71','DTC78','DTC79','DTC8','DTC81','DTC85','DTC86','DX58','ES','EW','HD','HK07','HK10','HK27','KP31','KP32','KP39',
'KP6','KP67','KP71','KP79','KPD','KPH','KY1','KY19','KY58','KY9','LHH','MC2','MC5','MEB','MK1','NC2','NC9','NW20','NW21','NW22','NW24','NW34','NW52','NW72','OP40','OP41','OP47','OP5','OP62','OP79','OP8','PKC','PKD','PKP','PPS',
'PPU','PS13','PS30','Q11','Q15','Q17','Q3','Q4','QM','QQQ3','R312R','RRL2','S09','S222DH','S222X','S2M','S312G','S312RMB','S32CH','S33M','S42CH','S56AE','S56DRM','S56H','S56JH','S56RM','S688H','S69R','S922M','S99ah','SBTL','SBZB',
'SD31','SG45H','SMY','SS89','SSYR','SWH','TD','TY09','TY18','TY28','TY33','TY67','TY78','TY81','TY83','WKR','XM','YSM','ZA41','ZA43','ZA71','ZA72','ZA74','ZA93')

WHILE (1 = 1)
BEGIN
	UPDATE TOP (1) #Supers
	SET isfinished = 1
		,@srecommend = custid	
	WHERE isfinished = 0
	
	IF @@ROWCOUNT = 0 BREAK
			
	EXEC dbo.Acc_DynamicCustomerInfo_09 @srecommend = @srecommend
			,@maxcustid = @max_custid
			,@target = 'REPLICATED'	
			
	waitfor delay '00:00:0.280'
END

-- BEGIN STEP 3: RUN THIS SCRIPT AT DBCUST -----
--------------------------------------------------------------------------------------
CREATE TABLE #supers (custid int,isfinished bit default(0))

DECLARE  @srecommend INT,@max_custid INT
SELECT @max_custid = xxx

INSERT INTO #supers(custid)
SELECT ci.custid
FROM dbo.Customer ci WITH(NOLOCK)
WHERE username IN('2AA','2CH','2DH','2MQ','2RH','AC12','AC14','AHX','B30T','BC8','BC9','BL','BP','BV11','BV29','BV8','CAT11','CAT12','CG13','CG27','CG34','D77','DTB55','DTB82','DTB92','DTB95','DTB97','DTC1','DTC11','DTC15','DTC27',
'DTC29','DTC30','DTC31','DTC37','DTC43','DTC47','DTC48','DTC56','DTC57','DTC59','DTC6','DTC63','DTC67','DTC70','DTC71','DTC78','DTC79','DTC8','DTC81','DTC85','DTC86','DX58','ES','EW','HD','HK07','HK10','HK27','KP31','KP32','KP39',
'KP6','KP67','KP71','KP79','KPD','KPH','KY1','KY19','KY58','KY9','LHH','MC2','MC5','MEB','MK1','NC2','NC9','NW20','NW21','NW22','NW24','NW34','NW52','NW72','OP40','OP41','OP47','OP5','OP62','OP79','OP8','PKC','PKD','PKP','PPS',
'PPU','PS13','PS30','Q11','Q15','Q17','Q3','Q4','QM','QQQ3','R312R','RRL2','S09','S222DH','S222X','S2M','S312G','S312RMB','S32CH','S33M','S42CH','S56AE','S56DRM','S56H','S56JH','S56RM','S688H','S69R','S922M','S99ah','SBTL','SBZB',
'SD31','SG45H','SMY','SS89','SSYR','SWH','TD','TY09','TY18','TY28','TY33','TY67','TY78','TY81','TY83','WKR','XM','YSM','ZA41','ZA43','ZA71','ZA72','ZA74','ZA93')


WHILE (1 = 1)
BEGIN
	UPDATE TOP (1) #Supers
	SET isfinished = 1
		,@srecommend = custid	
	WHERE isfinished = 0
	
	IF @@ROWCOUNT = 0 BREAK

	EXEC dbo.Acc_DynamicCustomerInfo_09 @srecommend = @srecommend
			,@maxcustid = @max_custid
			,@target = 'DBCUST'		
						
	waitfor delay '00:00:0.280'
END

