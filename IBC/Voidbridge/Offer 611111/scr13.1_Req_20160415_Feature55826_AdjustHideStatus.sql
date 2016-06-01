/*
	Created: Elodie	
	Task: Initialize Product Status of AllBet for Credit customers
	DB: DBCUST/CustDB
	Date: 20160301
*/ 
ALTER PROCEDURE [dbo].[Acc_DynamicCustomerInfo_09]
	@srecommend INT	
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

	DECLARE @BitmapOrder TINYINT

	SELECT @BitmapOrder = PSP.bitmapOrder
	FROM dbo.ProductSettingDetail psd WITH(NOLOCK)  
		INNER JOIN dbo.ProductStatusProfile psp WITH (NOLOCK) ON psp.Sporttype = psd.SportType AND psp.Bettype = psd.BetType
	WHERE psd.SettingType = 4 AND psd.ProductID = 22

	/*******************************CUST PRODUCTSTATUS TABLE*******************************/	
	UPDATE cs
    SET
			bitmapHasSynced = CASE WHEN ci.SyncCasino = 1 THEN dbo.f_GenerateProductStatus(bitmapHasSynced, @BitmapOrder, 1) ELSE dbo.f_GenerateProductStatus(bitmapHasSynced, @BitmapOrder, 0) END,
			bitmapIsHidden = CASE WHEN ci.SyncCasino = 1 THEN dbo.f_GenerateProductStatus(bitmapIsHidden, @BitmapOrder, 0) ELSE dbo.f_GenerateProductStatus(bitmapIsHidden, @BitmapOrder, 1) END
	FROM [dbo].[CustProductStatus] cs WITH(ROWLOCK,UPDLOCK)
		INNER JOIN dbo.custInfo ci WITH(NOLOCK) ON cs.CustID = ci.CustID
	WHERE ci.srecommend = @srecommend 
END
GO
-- END STEP 1: DEPLOY THIS SP @DBCUST.CustDB --------
------------------------------------------------------	

-- BEGIN STEP 2: RUN THIS SCRIPT AT ALL REPLICATED SERVERS (06/DBTP) -----
--------------------------------------------------------------------------------------
CREATE TABLE #supers (custid int,isfinished bit default(0))

DECLARE @srecommend INT


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
		 AND ci.site IN ('611111'))
	OR ci.custid IN (5,42,13) --Dummy account

WHILE (1 = 1)
BEGIN
	UPDATE TOP (1) #Supers
	SET isfinished = 1
		,@srecommend = custid	
	WHERE isfinished = 0
	
	IF @@ROWCOUNT = 0 BREAK
			
	EXEC dbo.Acc_DynamicCustomerInfo_09 @srecommend = @srecommend, @target = 'REPLICATED'
			
			
	waitfor delay '00:00:0.280'
END

-- BEGIN STEP 3: RUN THIS SCRIPT AT DBCUST -----
--------------------------------------------------------------------------------------
CREATE TABLE #supers (custid int,isfinished bit default(0))

DECLARE @srecommend INT

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
		 AND ci.site IN ('611111'))
	OR ci.custid IN (5,42,13) --Dummy account

WHILE (1 = 1)
BEGIN
	UPDATE TOP (1) #Supers
	SET isfinished = 1
		,@srecommend = custid	
	WHERE isfinished = 0
	
	IF @@ROWCOUNT = 0 BREAK

	EXEC dbo.Acc_DynamicCustomerInfo_09 @srecommend = @srecommend, @target = 'DBCUST'
						
	waitfor delay '00:00:0.280'
END