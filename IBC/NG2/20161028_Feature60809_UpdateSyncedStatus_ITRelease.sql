/*
	Created: Elodie	
	Task: Update Synced Status of NG2 = 0 for all customer (NOT (ci.site IN ('789y')  AND (ci.currency = 20 OR ci.custid = 2454112))--STESTUS$)
	DB: DBCUST/CustDB
	Date: 20161010
*/ 
ALTER PROCEDURE [dbo].[Acc_DynamicCustomerInfo_09]
	@srecommend INT	
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
			bitmapHasSynced = dbo.f_GenerateProductStatus(bitmapHasSynced, @BitmapOrder, 0)
	FROM [dbo].[CustProductStatus] cs WITH(ROWLOCK,UPDLOCK)
		INNER JOIN dbo.custInfo ci WITH(NOLOCK) ON cs.CustID = ci.CustID
	WHERE ci.srecommend = @srecommend AND ci.custid <= @MaxCustID 
END
GO
-- END STEP 1: DEPLOY THIS SP @DBCUST.CustDB --------
------------------------------------------------------	

-- BEGIN STEP 2: RUN THIS SCRIPT AT ALL REPLICATED SERVERS (06/DBTP) -----
--------------------------------------------------------------------------------------
CREATE TABLE #supers (custid int, isfinished bit default(0))

DECLARE @srecommend INT, @MaxCustID INT
SELECT @MaxCustID = xxx

INSERT INTO #supers(custid)
SELECT ci.custid
FROM customer ci WITH(NOLOCK)
	INNER JOIN site s WITH (NOLOCK) ON ci.site = s.site
	LEFT JOIN custsuper cs WITH (NOLOCK) ON ci.custid = cs.custid
WHERE (ci.roleid = 4  
			AND ci.username NOT LIKE '3rdSuper%'
			AND cs.isinternal = 0
			AND ci.custid NOT IN (SELECT custid FROM Dep_CustSuper WITH(NOLOCK))
			AND s.islicensee = 0
			AND ci.custid <= @MaxCustID)
		AND NOT (ci.site IN ('789y')  AND (ci.currency = 20 OR ci.custid = 2454112))--STESTUS$

WHILE (1 = 1)
BEGIN
	UPDATE TOP (1) #Supers
	SET isfinished = 1
		,@srecommend = custid	
	WHERE isfinished = 0
	
	IF @@ROWCOUNT = 0 BREAK
			
	EXEC dbo.Acc_DynamicCustomerInfo_09 @srecommend = @srecommend, @target = 'REPLICATED', @MaxCustID = @MaxCustID
			
	waitfor delay '00:00:0.100'
END

-- BEGIN STEP 3: RUN THIS SCRIPT AT DBCUST -----
--------------------------------------------------------------------------------------
CREATE TABLE #supers (custid int, isfinished bit default(0))

DECLARE @srecommend INT, @MaxCustID INT
SELECT @MaxCustID = xxx

INSERT INTO #supers(custid)
SELECT ci.custid
FROM customer ci WITH(NOLOCK)
	INNER JOIN site s WITH (NOLOCK) ON ci.site = s.site
	LEFT JOIN custsuper cs WITH (NOLOCK) ON ci.custid = cs.custid
WHERE (ci.roleid = 4  
			AND ci.username NOT LIKE '3rdSuper%'
			AND cs.isinternal = 0
			AND ci.custid NOT IN (SELECT custid FROM Dep_CustSuper WITH(NOLOCK))
			AND s.islicensee = 0
			AND ci.custid <= @MaxCustID)
		AND NOT (ci.site IN ('789y')  AND (ci.currency = 20 OR ci.custid = 2454112))--STESTUS$

WHILE (1 = 1)
BEGIN
	UPDATE TOP (1) #Supers
	SET isfinished = 1
		,@srecommend = custid	
	WHERE isfinished = 0
	
	IF @@ROWCOUNT = 0 BREAK
			
	EXEC dbo.Acc_DynamicCustomerInfo_09 @srecommend = @srecommend, @target = 'DBCUST', @MaxCustID = @MaxCustID
			
	waitfor delay '00:00:0.100'
END