/*
	Created: Helen	
	Task: Initialize Product Status of Fishing World for Credit customers
	DB: DBCUST/CustDB
	Date: 20160820
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
	
	DECLARE @bitmapOrder INT
	SET @bitmapOrder = (SELECT bitmapOrder FROM ProductStatusProfile WHERE Sporttype = 219)
	
	/*******************************CUST PRODUCT STATUS TABLE*******************************/	
	IF @Mode = 1 -- NOT reply on LC
	BEGIN
		IF @roleid = 4
		BEGIN
			UPDATE cs
			SET bitmapIsDisabled = CASE WHEN ci.SyncLiveCasino = 1 THEN dbo.f_GenerateProductStatus(bitmapIsDisabled, @bitmapOrder, 0) ELSE bitmapIsDisabled END
			FROM [dbo].[CustProductStatus] cs WITH(ROWLOCK,UPDLOCK)
				INNER JOIN dbo.custInfo ci WITH(NOLOCK) ON cs.CustID = ci.CustID
			WHERE ci.srecommend = @Custid
		END
		ELSE IF @roleid = 3
		BEGIN
			UPDATE cs
			SET bitmapIsDisabled = CASE WHEN ci.SyncLiveCasino = 1 THEN dbo.f_GenerateProductStatus(bitmapIsDisabled, @bitmapOrder, 0) ELSE bitmapIsDisabled END
			FROM [dbo].[CustProductStatus] cs WITH(ROWLOCK,UPDLOCK)
				INNER JOIN dbo.custInfo ci WITH(NOLOCK) ON cs.CustID = ci.CustID
			WHERE ci.mrecommend = @Custid

			UPDATE cs
			SET bitmapIsDisabled = CASE WHEN ci.SyncLiveCasino = 1 THEN dbo.f_GenerateProductStatus(bitmapIsDisabled, @bitmapOrder, 0) ELSE bitmapIsDisabled END
			FROM [dbo].[CustProductStatus] cs WITH(ROWLOCK,UPDLOCK)
				INNER JOIN dbo.custInfo ci WITH(NOLOCK) ON cs.CustID = ci.CustID
			WHERE ci.custid = @srecommend
		END
		ELSE IF @roleid = 2
		BEGIN
			UPDATE cs
			SET bitmapIsDisabled = CASE WHEN ci.SyncLiveCasino = 1 THEN dbo.f_GenerateProductStatus(bitmapIsDisabled, @bitmapOrder, 0) ELSE bitmapIsDisabled END
			FROM [dbo].[CustProductStatus] cs WITH(ROWLOCK,UPDLOCK)
				INNER JOIN dbo.custInfo ci WITH(NOLOCK) ON cs.CustID = ci.CustID
			WHERE ci.recommend = @Custid

			UPDATE cs
			SET bitmapIsDisabled = CASE WHEN ci.SyncLiveCasino = 1 THEN dbo.f_GenerateProductStatus(bitmapIsDisabled, @bitmapOrder, 0) ELSE bitmapIsDisabled END
			FROM [dbo].[CustProductStatus] cs WITH(ROWLOCK,UPDLOCK)
				INNER JOIN dbo.custInfo ci WITH(NOLOCK) ON cs.CustID = ci.CustID
			WHERE ci.custid = @srecommend OR ci.custid = @mrecommend
		END
	END

	IF @Mode = 0 -- reply on LC
	BEGIN
		IF @roleid = 4
		BEGIN
			UPDATE cs
			SET bitmapIsDisabled = CASE WHEN ci.SyncLiveCasino = 1 AND ci.DisableLiveCasino = 0 THEN dbo.f_GenerateProductStatus(bitmapIsDisabled, @bitmapOrder, 0) ELSE bitmapIsDisabled END
			FROM [dbo].[CustProductStatus] cs WITH(ROWLOCK,UPDLOCK)
				INNER JOIN dbo.custInfo ci WITH(NOLOCK) ON cs.CustID = ci.CustID
			WHERE ci.srecommend = @Custid
		END
		ELSE IF @roleid = 3
		BEGIN
			UPDATE cs
			SET bitmapIsDisabled = CASE WHEN ci.SyncLiveCasino = 1 AND ci.DisableLiveCasino = 0 THEN dbo.f_GenerateProductStatus(bitmapIsDisabled, @bitmapOrder, 0) ELSE bitmapIsDisabled END
			FROM [dbo].[CustProductStatus] cs WITH(ROWLOCK,UPDLOCK)
				INNER JOIN dbo.custInfo ci WITH(NOLOCK) ON cs.CustID = ci.CustID
			WHERE ci.mrecommend = @Custid

			UPDATE cs
			SET bitmapIsDisabled = CASE WHEN ci.SyncLiveCasino = 1 AND ci.DisableLiveCasino = 0 THEN dbo.f_GenerateProductStatus(bitmapIsDisabled, @bitmapOrder, 0) ELSE bitmapIsDisabled END
			FROM [dbo].[CustProductStatus] cs WITH(ROWLOCK,UPDLOCK)
				INNER JOIN dbo.custInfo ci WITH(NOLOCK) ON cs.CustID = ci.CustID
			WHERE ci.custid = @srecommend
		END
		ELSE IF @roleid = 2
		BEGIN
			UPDATE cs
			SET bitmapIsDisabled = CASE WHEN ci.SyncLiveCasino = 1 AND ci.DisableLiveCasino = 0 THEN dbo.f_GenerateProductStatus(bitmapIsDisabled, @bitmapOrder, 0) ELSE bitmapIsDisabled END
			FROM [dbo].[CustProductStatus] cs WITH(ROWLOCK,UPDLOCK)
				INNER JOIN dbo.custInfo ci WITH(NOLOCK) ON cs.CustID = ci.CustID
			WHERE ci.recommend = @Custid

			UPDATE cs
			SET bitmapIsDisabled = CASE WHEN ci.SyncLiveCasino = 1 AND ci.DisableLiveCasino = 0 THEN dbo.f_GenerateProductStatus(bitmapIsDisabled, @bitmapOrder, 0) ELSE bitmapIsDisabled END
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


CREATE TABLE #Cust (custid int, srecommend INT, mrecommend INT, roleid TINYINT, Mode BIT,IsDownLine BIT, isfinished bit default(0)) --Mode 0: depend on disable LC, 1: enable all
DECLARE @custid int, @srecommend INT, @mrecommend INT, @roleid TINYINT, @Mode BIT, @IsDownLine BIT = 0

INSERT INTO #Cust(custid, srecommend, mrecommend, roleid, Mode)
SELECT ci.custid, ci.srecommend, ci.mrecommend, ci.roleid, 1 AS mode
FROM dbo.Customer ci WITH(NOLOCK)
WHERE ci.custid NOT IN (SELECT custid FROM Dep_CustSuper WITH(NOLOCK))
	AND ci.site in ('INDO','755555','Koribc')
	AND ci.roleid = 4
/*	
	AND ci.username IN ('WW',
'JJ',
'II')
*/


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
FROM dbo.Customer ci WITH(NOLOCK)
WHERE ci.custid NOT IN (SELECT custid FROM Dep_CustSuper WITH(NOLOCK))
	AND ci.site in ('INDO','755555','Koribc')
		AND ci.roleid = 4
/*	
	AND ci.username IN ('WW',
'JJ',
'II')
*/
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