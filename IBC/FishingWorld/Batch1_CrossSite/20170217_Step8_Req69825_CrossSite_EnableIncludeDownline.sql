/*
	Created: Winnie
	Task: Enable Fishing World  using execrep [RedmineID: 69825]
	DB: DBCUST/CustDB
	Date: 20170217
*/ 

ALTER PROCEDURE [dbo].[Acc_DynamicCustomerInfo_09]
	@target VARCHAR(20),
	@CustId INT,	
	@RoleID TINYINT,
	@maxcustid INT
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

	UPDATE cs
	SET								
		 bitmapIsDisabled =  dbo.f_GenerateProductStatus (cs.bitmapIsDisabled,@BitOrder,0)
	FROM [dbo].[CustProductStatus] cs WITH(ROWLOCK,UPDLOCK)
	INNER JOIN CustInfo c WITH(NOLOCK) ON c.custid=cs.custid
	WHERE c.custid<=@maxcustid AND c.srecommend=@CustId	and c.mrecommend NOT IN(60349,167860,63971) AND c.recommend <>104769

END
GO
-- END STEP 1: DEPLOY THIS SP @DBCUST.CustDB --------
------------------------------------------------------	

-- BEGIN STEP 2: RUN THIS SCRIPT AT ALL REPLICATED SERVERS (06/DBTP) -----
--------------------------------------------------------------------------------------
	DECLARE  @RoleID TINYINT,@CustID INT
	DECLARE @maxcustID INT
	SELECT @maxcustID=xxx
	
	CREATE TABLE #tempcusts (custid INT PRIMARY KEY, roleId INT,isfinished bit default(0))
	INSERT INTO #tempcusts(custid,roleId)
	
	SELECT custid,roleid
	FROM Customer WITH(NOLOCK) WHERE username  IN('SKPRMB','SYLM','S09M')
	
	WHILE (1 = 1)
BEGIN
	UPDATE TOP (1) #tempcusts
	SET isfinished = 1
		,@CustId = custid	
		,@RoleID = RoleId 
	WHERE isfinished = 0
	
	IF @@ROWCOUNT = 0 BREAK
			
	EXEC dbo.Acc_DynamicCustomerInfo_09 @Custid = @Custid , @RoleID = @RoleID,@maxcustID=@maxcustid		
			,@target = 'REPLICATED'
			
			
	waitfor delay '00:00:0.280'
END

-- BEGIN STEP 3: RUN THIS SCRIPT AT DBCUST -----
--------------------------------------------------------------------------------------

	DECLARE  @RoleID TINYINT,@CustID INT
	DECLARE @maxcustID INT
	SELECT @maxcustID=xxx	
	
	CREATE TABLE #tempcusts (custid INT PRIMARY KEY, roleId INT,isfinished bit default(0))
	INSERT INTO #tempcusts(custid,roleId)
	
	SELECT custid,roleid
	FROM Customer WITH(NOLOCK) WHERE username  IN('SKPRMB','SYLM','S09M')
		
	WHILE (1 = 1)
BEGIN
	UPDATE TOP (1) #tempcusts
	SET isfinished = 1
		,@CustId = custid	
		,@RoleID = RoleId 
	WHERE isfinished = 0
	
	IF @@ROWCOUNT = 0 BREAK
			
	EXEC dbo.Acc_DynamicCustomerInfo_09 @Custid = @Custid , @RoleID = @RoleID,@maxcustID=@maxcustid			
			,@target = 'DBCUST'
			
			
	waitfor delay '00:00:0.280'
END

