/*
	Created: Elodie	
	Task: Initialize Synced Status of NG2
	DB: DBCUST/CustDB
	Date: 20161010
*/ 
ALTER PROCEDURE [dbo].[Acc_DynamicCustomerInfo_09]
	@srecommend INT	
	,@HasSynced BIT
	,@MaxCustID INT
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

	/*******************************CUST PRODUCTSTATUS TABLE*******************************/	
	UPDATE cs
	SET
			bitmapHasSynced = dbo.f_GenerateProductStatus(bitmapHasSynced, @BitmapOrder, @HasSynced)
	FROM [dbo].[CustProductStatus] cs WITH(ROWLOCK,UPDLOCK)
		INNER JOIN dbo.custInfo ci WITH(NOLOCK) ON cs.CustID = ci.CustID
	WHERE ci.srecommend = @srecommend AND ci.custid <= @MaxCustID
END
GO
-- END STEP 1: DEPLOY THIS SP @DBCUST.CustDB --------
------------------------------------------------------	

-- BEGIN STEP 2: RUN THIS SCRIPT AT ALL REPLICATED SERVERS (06/DBTP) -----
--------------------------------------------------------------------------------------
CREATE TABLE #supers (custid int, HasSynced BIT, isfinished bit default(0))

DECLARE @srecommend INT, @HasSynced BIT, @MaxCustID INT
SELECT @MaxCustID = xxx

INSERT INTO #supers(custid, HasSynced)
SELECT ci.custid, 
	CASE WHEN ci.site = '789y' THEN 1 ELSE 0 END
FROM customer ci WITH(NOLOCK)
	INNER JOIN site s WITH (NOLOCK) ON ci.site = s.site
	LEFT JOIN custsuper cs WITH (NOLOCK) ON ci.custid = cs.custid
WHERE ci.roleid = 4  
		 AND ci.username NOT LIKE '3rdSuper%'
		 AND cs.isinternal = 0
		 AND ci.custid NOT IN (SELECT custid FROM Dep_CustSuper WITH(NOLOCK))
		 AND s.islicensee = 0
		 AND ci.custid <= @MaxCustID

WHILE (1 = 1)
BEGIN
	UPDATE TOP (1) #Supers
	SET isfinished = 1
		,@srecommend = custid	
		,@HasSynced = HasSynced
	WHERE isfinished = 0
	
	IF @@ROWCOUNT = 0 BREAK
			
	EXEC dbo.Acc_DynamicCustomerInfo_09 @srecommend = @srecommend, @target = 'REPLICATED', @HasSynced = @HasSynced, @MaxCustID = @MaxCustID
			
			
	waitfor delay '00:00:0.100'
END

-- BEGIN STEP 3: RUN THIS SCRIPT AT DBCUST -----
--------------------------------------------------------------------------------------
CREATE TABLE #supers (custid int, HasSynced BIT, isfinished bit default(0))

DECLARE @srecommend INT, @HasSynced BIT, @MaxCustID INT
SELECT @MaxCustID = xxx

INSERT INTO #supers(custid, HasSynced)
SELECT ci.custid, 
	CASE WHEN ci.site = '789y' THEN 1 ELSE 0 END
FROM customer ci WITH(NOLOCK)
	INNER JOIN site s WITH (NOLOCK) ON ci.site = s.site
	LEFT JOIN custsuper cs WITH (NOLOCK) ON ci.custid = cs.custid
WHERE ci.roleid = 4  
		 AND ci.username NOT LIKE '3rdSuper%'
		 AND cs.isinternal = 0
		 AND ci.custid NOT IN (SELECT custid FROM Dep_CustSuper WITH(NOLOCK))
		 AND s.islicensee = 0
		 AND ci.custid <= @MaxCustID

WHILE (1 = 1)
BEGIN
	UPDATE TOP (1) #Supers
	SET isfinished = 1
		,@srecommend = custid	
		,@HasSynced = HasSynced
	WHERE isfinished = 0
	
	IF @@ROWCOUNT = 0 BREAK
			
	EXEC dbo.Acc_DynamicCustomerInfo_09 @srecommend = @srecommend, @target = 'DBCUST', @HasSynced = @HasSynced, @MaxCustID = @MaxCustID
			
			
	waitfor delay '00:00:0.100'
END