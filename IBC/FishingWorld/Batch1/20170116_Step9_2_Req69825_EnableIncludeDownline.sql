/*
	Created: Winnie
	Task: Enable Fishing World  using execrep [RedmineID: 69825]
	DB: DBCUST/CustDB
	Date: 20170116
*/ 

ALTER PROCEDURE [dbo].[Acc_DynamicCustSetting3rd_09]
	@target VARCHAR(20),
	@CustId INT,	
	@RoleID TINYINT
AS
BEGIN
	SET NOCOUNT ON
	
	IF (@target = 'REPLICATED' AND @@SERVERNAME = 'DBCUST') RETURN	-- run at all replicated servers
	IF (@target = 'DBCUST' AND @@SERVERNAME <> 'DBCUST') RETURN -- run at dbtrans only
	
	IF NOT (dbo.f_CheckRepTable('Custinfo') = 1 
	   AND dbo.f_CheckRepTable('CustProductStatus') = 1
	   AND dbo.f_CheckRepTable('ProductStatusProfile') = 1
	   )
	RETURN	

	
	
	
	DECLARE @Sporttype INT
	SELECT @Sporttype=219
	DECLARE @BitOrder INT
	SELECT @BitOrder= bitmapOrder from ProductStatusProfile WITH(NOLOCK) where SportType=@Sporttype
	
	IF(@RoleID=4)
	BEGIN
		UPDATE cs
		SET								
			 bitmapIsDisabled =  dbo.f_GenerateProductStatus (cs.bitmapIsDisabled,@BitOrder,0)
		FROM [dbo].[CustProductStatus] cs WITH(ROWLOCK,UPDLOCK)
		INNER JOIN CustInfo c WITH(NOLOCK) ON c.custid=cs.custid
		WHERE c.srecommend=@CustId	
	END
	ELSE IF(@RoleID=3)	
	BEGIN
		UPDATE cs
		SET								
			 bitmapIsDisabled =  dbo.f_GenerateProductStatus (cs.bitmapIsDisabled,@BitOrder,0)
		FROM [dbo].[CustProductStatus] cs WITH(ROWLOCK,UPDLOCK)
		INNER JOIN CustInfo c WITH(NOLOCK) ON c.custid=cs.custid
		WHERE c.mrecommend=@CustId
		
		UPDATE cs
		SET								
			 bitmapIsDisabled =  dbo.f_GenerateProductStatus (cs.bitmapIsDisabled,@BitOrder,0)
		FROM [dbo].[CustProductStatus] cs WITH(ROWLOCK,UPDLOCK)
		WHERE cs.CustID IN(
		SELECT c.srecommend FROM 
		CustInfo c WITH(NOLOCK) 
		WHERE CustID=@CustId)
	
	END
	
END
GO
-- END STEP 1: DEPLOY THIS SP @DBCUST.CustDB --------
------------------------------------------------------	

-- BEGIN STEP 2: RUN THIS SCRIPT AT ALL REPLICATED SERVERS (06/DBTP) -----
--------------------------------------------------------------------------------------
	DECLARE  @RoleID TINYINT,@CustID INT
	
	CREATE TABLE #tempcusts (custid INT PRIMARY KEY, roleId INT,isfinished bit default(0))
	INSERT INTO #tempcusts(custid,roleId)
	
	SELECT custid,roleid
	FROM Customer WITH(NOLOCK) WHERE username  IN ('SKKM','S09H','S09M','PTM'
	,'S47R','S47M','S49RM','S49H','SSTMR','SSTMH','SSTMJ','SSTMM','SSTMK','SSTMI','S3ARM','S3AR','S3AH','S3AAH','S3EH','S3BH','S3AB','MJRMB'
	,'SJM','SJJM','SJHK'
	,'SHKK','SHHK2','SHHK7','hhma','HHN','HHK4'
	,'S688R','S788H','S688AH','S688M','LP','LLP','SAKM','KYH','KYM','SMQARMB','S45H','S45BH','S45HK','S45BM'
	,'HPP','HPO','HPM','HPU','HPV','HPW','HPQ','HPK','HPN','HPX','HPY','HPMM','HPZ','HPR','SX3','SX1','SX2','SZZ','SMY','HPC','HPD','HPB','HPF','SX5'
	,'SX6','HP2','SX7','SX8','HPS','HPM2','HP1','HPT','HP3','SX9','HMN','HSS','SX10','SX11'
	,'SLLM','SATM','JM','JS5','JS6','JS7','JS8','JSB','SYSM','SYSHK','JSR','JMA','JSE','JSQ','JSF','JSG','JST','JSL','JSM','JSZ','SHG','JSN','JSP'
	,'JSU','JSV','JSW','JSX','JSY','JSO','JSI','JMJ','JHA','JHB','JMK','JML','JHC','JHD','SYLHK','SYLM','SYLH','SYLHZ','SYLK','SYCN','SYLL'
	,'SSK','SSM','SSMA','SSKA','SSKB','SSKC','SKPRMB','KPM','JJB','JJM'
	,'XKM','XKH','YUM','FJM','21A','BPM'
	,'D77','D78','D79','D80','D81','D82','D83','D85','D66','DRN','DRP','BB1','D96','BB9','VVY','VCY','VBY','VDY','VEY','VFY','VVM'
	,'TS1','TS2','TS3','TS4','TS5','TS6','JYT','JYG','JYU','JYY','YSM','LWW'
	)
	
	DELETE t
	FROM #tempcusts t
	INNER JOIN Customer  c WITH(NOLOCK) ON t.custid=c.custid
	WHERE username IN('S42AH','S71H','S822M','SKHH','SKPRMB','SYLM','S09M','SPHM')
		
	WHILE (1 = 1)
BEGIN
	UPDATE TOP (1) #tempcusts
	SET isfinished = 1
		,@CustId = custid	
		,@RoleID = RoleId 
	WHERE isfinished = 0
	
	IF @@ROWCOUNT = 0 BREAK
			
	EXEC dbo.Acc_DynamicCustSetting3rd_09 @Custid = @Custid , @RoleID = @RoleID		
			,@target = 'REPLICATED'
			
			
	waitfor delay '00:00:0.280'
END

-- BEGIN STEP 3: RUN THIS SCRIPT AT DBCUST -----
--------------------------------------------------------------------------------------

	DECLARE  @RoleID TINYINT,@CustID INT
	
	CREATE TABLE #tempcusts (custid INT PRIMARY KEY, roleId INT,isfinished bit default(0))
	INSERT INTO #tempcusts(custid,roleId)
	
	SELECT custid,roleid
	FROM Customer WITH(NOLOCK) WHERE username IN ('SKKM','S09H','S09M','PTM'
	,'S47R','S47M','S49RM','S49H','SSTMR','SSTMH','SSTMJ','SSTMM','SSTMK','SSTMI','S3ARM','S3AR','S3AH','S3AAH','S3EH','S3BH','S3AB','MJRMB'
	,'SJM','SJJM','SJHK'
	,'SHKK','SHHK2','SHHK7','hhma','HHN','HHK4'
	,'S688R','S788H','S688AH','S688M','LP','LLP','SAKM','KYH','KYM','SMQARMB','S45H','S45BH','S45HK','S45BM'
	,'HPP','HPO','HPM','HPU','HPV','HPW','HPQ','HPK','HPN','HPX','HPY','HPMM','HPZ','HPR','SX3','SX1','SX2','SZZ','SMY','HPC','HPD','HPB','HPF','SX5'
	,'SX6','HP2','SX7','SX8','HPS','HPM2','HP1','HPT','HP3','SX9','HMN','HSS','SX10','SX11'
	,'SLLM','SATM','JM','JS5','JS6','JS7','JS8','JSB','SYSM','SYSHK','JSR','JMA','JSE','JSQ','JSF','JSG','JST','JSL','JSM','JSZ','SHG','JSN','JSP'
	,'JSU','JSV','JSW','JSX','JSY','JSO','JSI','JMJ','JHA','JHB','JMK','JML','JHC','JHD','SYLHK','SYLM','SYLH','SYLHZ','SYLK','SYCN','SYLL'
	,'SSK','SSM','SSMA','SSKA','SSKB','SSKC','SKPRMB','KPM','JJB','JJM'
	,'XKM','XKH','YUM','FJM','21A','BPM'
	,'D77','D78','D79','D80','D81','D82','D83','D85','D66','DRN','DRP','BB1','D96','BB9','VVY','VCY','VBY','VDY','VEY','VFY','VVM'
	,'TS1','TS2','TS3','TS4','TS5','TS6','JYT','JYG','JYU','JYY','YSM','LWW'
	)
	
	DELETE t
	FROM #tempcusts t
	INNER JOIN Customer  c WITH(NOLOCK) ON t.custid=c.custid
	WHERE username IN('S42AH','S71H','S822M','SKHH','SKPRMB','SYLM','S09M','SPHM')
		
		
	WHILE (1 = 1)
BEGIN
	UPDATE TOP (1) #tempcusts
	SET isfinished = 1
		,@CustId = custid	
		,@RoleID = RoleId 
	WHERE isfinished = 0
	
	IF @@ROWCOUNT = 0 BREAK
			
	EXEC dbo.Acc_DynamicCustSetting3rd_09 @Custid = @Custid , @RoleID = @RoleID		
			,@target = 'DBCUST'
			
			
	waitfor delay '00:00:0.280'
END

