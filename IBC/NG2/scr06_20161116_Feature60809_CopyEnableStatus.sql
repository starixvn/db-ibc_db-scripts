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
	,@maxcustid INT
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

	DECLARE @BitmapOrder TINYINT = 4

	/*******************************CUST PRODUCT STATUS TABLE*******************************/	
	IF @roleid = 4
	BEGIN
		UPDATE cs
		SET bitmapIsDisabled = dbo.f_GenerateProductStatus(bitmapIsDisabled, @BitmapOrder, 0)
		FROM [dbo].[CustProductStatus] cs WITH(ROWLOCK,UPDLOCK)
			INNER JOIN dbo.custInfo ci WITH(NOLOCK) ON cs.CustID = ci.CustID
		WHERE ci.srecommend = @Custid AND ci.custid <= @maxcustid
	END
	ELSE IF @roleid = 3
	BEGIN
		UPDATE cs
		SET bitmapIsDisabled = dbo.f_GenerateProductStatus(bitmapIsDisabled, @BitmapOrder, 0)
		FROM [dbo].[CustProductStatus] cs WITH(ROWLOCK,UPDLOCK)
			INNER JOIN dbo.custInfo ci WITH(NOLOCK) ON cs.CustID = ci.CustID
		WHERE ci.mrecommend = @Custid AND ci.custid <= @maxcustid

		UPDATE cs
		SET bitmapIsDisabled = dbo.f_GenerateProductStatus(bitmapIsDisabled, @BitmapOrder, 0)
		FROM [dbo].[CustProductStatus] cs WITH(ROWLOCK,UPDLOCK)
		WHERE cs.custid = @srecommend AND cs.custid <= @maxcustid
	END
	ELSE IF @roleid = 2
	BEGIN
		UPDATE cs
		SET bitmapIsDisabled = dbo.f_GenerateProductStatus(bitmapIsDisabled, @BitmapOrder, 0)
		FROM [dbo].[CustProductStatus] cs WITH(ROWLOCK,UPDLOCK)
			INNER JOIN dbo.custInfo ci WITH(NOLOCK) ON cs.CustID = ci.CustID
		WHERE ci.recommend = @Custid AND ci.custid <= @maxcustid

		UPDATE cs
		SET bitmapIsDisabled = dbo.f_GenerateProductStatus(bitmapIsDisabled, @BitmapOrder, 0)
		FROM [dbo].[CustProductStatus] cs WITH(ROWLOCK,UPDLOCK)
		WHERE cs.custid = @srecommend OR cs.custid = @mrecommend AND cs.custid <= @maxcustid
	END
END
GO
-- END STEP 1: DEPLOY THIS SP @DBCUST.CustDB --------
------------------------------------------------------	

-- BEGIN STEP 2: RUN THIS SCRIPT AT ALL REPLICATED SERVERS (06/DBTP) -----
--------------------------------------------------------------------------------------
CREATE TABLE #Cust (custid int, srecommend INT, mrecommend INT, roleid TINYINT, isfinished bit default(0)) --Mode 0: depend on disable OneRNG, 1: enable all

DECLARE @custid int, @srecommend INT, @mrecommend INT, @roleid TINYINT, @max_custid INT

SELECT @max_custid = xxx

INSERT INTO #Cust(custid, srecommend, mrecommend, roleid)
SELECT ci.custid, ci.srecommend, ci.mrecommend, ci.roleid
FROM customer ci WITH(NOLOCK)
WHERE ci.site IN ('789y')
	AND ci.custid <= @max_custid
	AND ci.username IN (				'SHJ'				,'M789H'				,'MPTRMB'				,'S69H'				,'S69HD'				,'S69G'				,'S90R'				,'S90AR'				,'S90H'				,'S90C'				,'s6cn'				,'S6HK'				,'S6RMB'				,'S6P'				,'S6AHK'				,'SJH'				,'SSFK'				,'SB8R'				,'SWK'				,'JARWRONG'				,'JAR'				,'S120R'				,'S121R'				,'S122R'				,'S120H'				,'S123R'				,'S124R'				,'S120S'				,'S125R'				,'S99R'				,'S99E'				,'SWW'				,'JR'				,'JRA'				,'JHH'				,'JHJ'				,'JKK'				,'RMB'				,'P9'				,'RG8H'				,'MHK8'				,'M7RRMB')

WHILE (1 = 1)
BEGIN
	UPDATE TOP (1) #Cust
	SET isfinished = 1
		,@custid = custid	
		,@srecommend = srecommend	
		,@mrecommend = mrecommend
		,@roleid = roleid
	WHERE isfinished = 0
	
	IF @@ROWCOUNT = 0 BREAK
			
	EXEC dbo.Acc_DynamicCustomerInfo_09 
			@custid = @custid			
			,@srecommend = @srecommend
			,@mrecommend = @mrecommend
			,@roleid = @roleid
			,@maxcustid = @max_custid
			,@target = 'REPLICATED'
			
			
	waitfor delay '00:00:0.280'
END

-- BEGIN STEP 3: RUN THIS SCRIPT AT DBCUST -----
--------------------------------------------------------------------------------------
CREATE TABLE #Cust (custid int, srecommend INT, mrecommend INT, roleid TINYINT, isfinished bit default(0)) --Mode 0: depend on disable OneRNG, 1: enable all

DECLARE @custid int, @srecommend INT, @mrecommend INT, @roleid TINYINT, @max_custid INT

SELECT @max_custid = xxx

INSERT INTO #Cust(custid, srecommend, mrecommend, roleid)
SELECT ci.custid, ci.srecommend, ci.mrecommend, ci.roleid
FROM customer ci WITH(NOLOCK)
WHERE ci.site IN ('789y')
	AND ci.custid <= @max_custid
	AND ci.username IN (				'SHJ'				,'M789H'				,'MPTRMB'				,'S69H'				,'S69HD'				,'S69G'				,'S90R'				,'S90AR'				,'S90H'				,'S90C'				,'s6cn'				,'S6HK'				,'S6RMB'				,'S6P'				,'S6AHK'				,'SJH'				,'SSFK'				,'SB8R'				,'SWK'				,'JARWRONG'				,'JAR'				,'S120R'				,'S121R'				,'S122R'				,'S120H'				,'S123R'				,'S124R'				,'S120S'				,'S125R'				,'S99R'				,'S99E'				,'SWW'				,'JR'				,'JRA'				,'JHH'				,'JHJ'				,'JKK'				,'RMB'				,'P9'				,'RG8H'				,'MHK8'				,'M7RRMB')
		

WHILE (1 = 1)
BEGIN
	UPDATE TOP (1) #Cust
	SET isfinished = 1
		,@custid = custid	
		,@srecommend = srecommend	
		,@mrecommend = mrecommend
		,@roleid = roleid
	WHERE isfinished = 0
	
	IF @@ROWCOUNT = 0 BREAK
			
	EXEC dbo.Acc_DynamicCustomerInfo_09 
			@custid = @custid			
			,@srecommend = @srecommend
			,@mrecommend = @mrecommend
			,@roleid = @roleid
			,@maxcustid = @max_custid
			,@target = 'DBCUST'
			
			
	waitfor delay '00:00:0.280'
END