/*
	Created: Elodie	
	Task: Disable Product Status of NG2 for THAUS Headline
	DB: DBCUST/CustDB
	Date: 20161117
*/ 
ALTER PROCEDURE [dbo].[Acc_DynamicCustomerInfo_09]
	@Custid INT
	,@roleid TINYINT
	,@srecommend INT
	,@mrecommend INT	
	,@recommend INT
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
		SET bitmapIsDisabled = dbo.f_GenerateProductStatus(bitmapIsDisabled, @BitmapOrder, 1)
		FROM [dbo].[CustProductStatus] cs WITH(ROWLOCK,UPDLOCK)
			INNER JOIN dbo.custInfo ci WITH(NOLOCK) ON cs.CustID = ci.CustID
		WHERE ci.srecommend = @Custid AND ci.custid <= @maxcustid
	END
	ELSE IF @roleid = 3
	BEGIN
		UPDATE cs
		SET bitmapIsDisabled = dbo.f_GenerateProductStatus(bitmapIsDisabled, @BitmapOrder, 1)
		FROM [dbo].[CustProductStatus] cs WITH(ROWLOCK,UPDLOCK)
			INNER JOIN dbo.custInfo ci WITH(NOLOCK) ON cs.CustID = ci.CustID
		WHERE ci.mrecommend = @Custid AND ci.custid <= @maxcustid

		UPDATE cs
		SET bitmapIsDisabled = dbo.f_GenerateProductStatus(bitmapIsDisabled, @BitmapOrder, 1)
		FROM [dbo].[CustProductStatus] cs WITH(ROWLOCK,UPDLOCK)
		WHERE cs.custid = @srecommend AND cs.custid <= @maxcustid
	END
	ELSE IF @roleid = 2
	BEGIN
		UPDATE cs
		SET bitmapIsDisabled = dbo.f_GenerateProductStatus(bitmapIsDisabled, @BitmapOrder, 1)
		FROM [dbo].[CustProductStatus] cs WITH(ROWLOCK,UPDLOCK)
			INNER JOIN dbo.custInfo ci WITH(NOLOCK) ON cs.CustID = ci.CustID
		WHERE ci.recommend = @Custid AND ci.custid <= @maxcustid

		UPDATE cs
		SET bitmapIsDisabled = dbo.f_GenerateProductStatus(bitmapIsDisabled, @BitmapOrder, 1)
		FROM [dbo].[CustProductStatus] cs WITH(ROWLOCK,UPDLOCK)
		WHERE (cs.custid = @srecommend OR cs.custid = @mrecommend) AND cs.custid <= @maxcustid
	END
	ELSE IF @roleid = 1
	BEGIN
		UPDATE cs
		SET bitmapIsDisabled = dbo.f_GenerateProductStatus(bitmapIsDisabled, @BitmapOrder, 1)
		FROM [dbo].[CustProductStatus] cs WITH(ROWLOCK,UPDLOCK)
		WHERE (cs.CustID = @Custid OR cs.custid = @srecommend OR cs.custid = @mrecommend OR cs.CustID = @recommend) AND cs.custid <= @maxcustid
	END
END
GO
-- END STEP 1: DEPLOY THIS SP @DBCUST.CustDB --------
------------------------------------------------------	

-- BEGIN STEP 2: RUN THIS SCRIPT AT ALL REPLICATED SERVERS (06/DBTP) -----
--------------------------------------------------------------------------------------
CREATE TABLE #Cust (custid int, srecommend INT, mrecommend INT, recommend INT, roleid TINYINT, isfinished bit default(0)) 

DECLARE @custid int, @srecommend INT, @mrecommend INT, @recommend INT, @roleid TINYINT, @max_custid INT

SELECT @max_custid = xxx

INSERT INTO #Cust(custid, srecommend, mrecommend, recommend, roleid)
SELECT ci.custid, ci.srecommend, ci.mrecommend, ci.recommend, ci.roleid
FROM customer ci WITH(NOLOCK)
	INNER JOIN dbo.custAccount ca WITH (NOLOCK) ON ca.custid = ci.custid
WHERE ca.groupID = 515 AND ci.custid <= @max_custid

WHILE (1 = 1)
BEGIN
	UPDATE TOP (1) #Cust
	SET isfinished = 1
		,@custid = custid	
		,@srecommend = srecommend	
		,@mrecommend = mrecommend
		,@recommend = recommend
		,@roleid = roleid
	WHERE isfinished = 0
	
	IF @@ROWCOUNT = 0 BREAK
			
	EXEC dbo.Acc_DynamicCustomerInfo_09 
			@custid = @custid			
			,@srecommend = @srecommend
			,@mrecommend = @mrecommend
			,@recommend = @recommend
			,@roleid = @roleid
			,@maxcustid = @max_custid
			,@target = 'REPLICATED'
			
			
	waitfor delay '00:00:0.100'
END

-- BEGIN STEP 3: RUN THIS SCRIPT AT DBCUST -----
--------------------------------------------------------------------------------------
CREATE TABLE #Cust (custid int, srecommend INT, mrecommend INT, recommend INT, roleid TINYINT, isfinished bit default(0)) 

DECLARE @custid int, @srecommend INT, @mrecommend INT, @recommend INT, @roleid TINYINT, @max_custid INT

SELECT @max_custid = xxx

INSERT INTO #Cust(custid, srecommend, mrecommend, recommend, roleid)
SELECT ci.custid, ci.srecommend, ci.mrecommend, ci.recommend, ci.roleid
FROM customer ci WITH(NOLOCK)
	INNER JOIN dbo.custAccount ca WITH (NOLOCK) ON ca.custid = ci.custid
WHERE ca.groupID = 515 AND ci.custid <= @max_custid

WHILE (1 = 1)
BEGIN
	UPDATE TOP (1) #Cust
	SET isfinished = 1
		,@custid = custid	
		,@srecommend = srecommend	
		,@mrecommend = mrecommend
		,@recommend = recommend
		,@roleid = roleid
	WHERE isfinished = 0
	
	IF @@ROWCOUNT = 0 BREAK
			
	EXEC dbo.Acc_DynamicCustomerInfo_09 
			@custid = @custid			
			,@srecommend = @srecommend
			,@mrecommend = @mrecommend
			,@recommend = @recommend
			,@roleid = @roleid
			,@maxcustid = @max_custid
			,@target = 'DBCUST'
			
			
	waitfor delay '00:00:0.100'
END