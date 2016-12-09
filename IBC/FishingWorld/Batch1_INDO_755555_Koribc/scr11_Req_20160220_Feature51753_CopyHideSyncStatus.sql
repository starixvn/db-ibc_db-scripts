/*
	Created: Helen	
	Task: Initialize Product Status of Fishing World for Credit customers
	DB: DBCUST/CustDB
	Date: 20160820
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
	   AND dbo.f_CheckRepTable('ProductSettingDetail') = 1
	   AND dbo.f_CheckRepTable('ProductStatusProfile') = 1
	   )
		RETURN
	
	DECLARE @bitmapOrder INT
	SET @bitmapOrder = (SELECT bitmapOrder FROM ProductStatusProfile (NOLOCK) WHERE Sporttype = 219 AND Bettype = 1011)
	
	IF @srecommend IN (2,4,13,15)
	BEGIN
		
		CREATE TABLE #DirectMaster (CustID INT PRIMARY KEY,roleid INT)
		CREATE TABLE #DirectAgent (CustID INT PRIMARY KEY,mrecommend INT,roleid INT)
			
		INSERT INTO #DirectMaster (CustID,roleid)
		SELECT custid, roleid
		FROM Customer with(nolock)
		WHERE SITE in ('INDO','755555','Koribc')
			and custid NOT IN (SELECT custid from Acc_CustDirect WITH(NOLOCK))
			and srecommend IN (SELECT custid from Acc_CustDirect WITH(NOLOCK))
			and roleid=3 AND srecommend = @srecommend AND custid <= @maxcustid 
			
		--- get direct agent
		INSERT INTO #DirectAgent (CustID,mrecommend,roleid)
		SELECT custid, mrecommend,roleid
		FROM Customer WITH(NOLOCK)
		WHERE site in ('INDO','755555','Koribc')
			and custid NOT IN (SELECT custid from Acc_CustDirect WITH(NOLOCK))
			and mrecommend IN (SELECT custid from Acc_CustDirect WITH(NOLOCK))
			and roleid=2 AND srecommend = @srecommend AND custid <= @maxcustid
		
		IF EXISTS (SELECT 1 FROM #DirectMaster)
		BEGIN
			UPDATE cs
				SET bitmapIsHidden =  dbo.f_GenerateProductStatus(bitmapIsHidden, @bitmapOrder, 0) 
			FROM [dbo].[CustProductStatus] cs WITH(ROWLOCK,UPDLOCK)
				INNER JOIN dbo.custInfo ci WITH(NOLOCK) ON cs.CustID = ci.CustID
			WHERE (ci.mrecommend IN (SELECT custid FROM #DirectMaster) /*AND ci.recommend NOT IN (16129,59308,68531)*/) OR ci.custid = @srecommend
		END
		
		IF EXISTS (SELECT 1 FROM #DirectAgent)
		BEGIN
			UPDATE cs
				SET bitmapIsHidden =  dbo.f_GenerateProductStatus(bitmapIsHidden, @bitmapOrder, 0) 
			FROM [dbo].[CustProductStatus] cs WITH(ROWLOCK,UPDLOCK)
				INNER JOIN dbo.custInfo ci WITH(NOLOCK) ON cs.CustID = ci.CustID
			
			WHERE ci.recommend IN (SELECT custid FROM #DirectAgent) 
				OR ci.custid = @srecommend 
				OR ci.custid IN (SELECT mrecommend FROM #DirectAgent) 
		END
	END
	ELSE
	BEGIN
		UPDATE cs
		SET bitmapIsHidden =  dbo.f_GenerateProductStatus(bitmapIsHidden, @bitmapOrder, 0) 
		FROM [dbo].[CustProductStatus] cs WITH(ROWLOCK,UPDLOCK)
			INNER JOIN custInfo CI WITH (NOLOCK) ON cs.CustID = ci.CustID
		WHERE ci.srecommend = @srecommend 
	END
	
END
GO
-- END STEP 1: DEPLOY THIS SP @DBCUST.CustDB --------
------------------------------------------------------	

-- BEGIN STEP 2: RUN THIS SCRIPT AT ALL REPLICATED SERVERS (06/DBTP) -----
--------------------------------------------------------------------------------------
CREATE TABLE #supers (custid int,isfinished bit default(0))

DECLARE @max_custid INT, @srecommend INT

SELECT @max_custid = xxx

INSERT INTO #supers(custid)
SELECT ci.custid
FROM dbo.Customer ci WITH(NOLOCK)
WHERE (ci.roleid = 4 	
		AND ci.custid NOT IN (SELECT custid FROM Dep_CustSuper WITH(NOLOCK))
		AND ci.custid <= @max_custid 
		-- Production
		AND ci.site in ('INDO','755555','Koribc')
		AND ci.custid <> 72)
	OR ci.custid IN (2,4,13,15)

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

DECLARE @max_custid INT, @srecommend INT

SELECT @max_custid = xxx

INSERT INTO #supers(custid)
SELECT ci.custid
FROM dbo.Customer ci WITH(NOLOCK)
WHERE (ci.roleid = 4 	
		AND ci.custid NOT IN (SELECT custid FROM Dep_CustSuper WITH(NOLOCK))
		-- Production
		AND ci.site in ('INDO','755555','Koribc')
		AND ci.custid <> 72)
		OR ci.custid IN (2,4,13,15)

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