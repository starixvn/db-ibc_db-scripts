

/*
	Created: Winnie	
	Task: Enable Fishing World for Credit customers
	DB: DBCUST/CustDB
	Date: 20170313
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
		INNER JOIN custInfo CI WITH (NOLOCK) ON cs.CustID = ci.CustID
	WHERE ci.srecommend = @srecommend AND roleid IN(2,3,4) AND ci.Enabled=1

END
GO
-- END STEP 1: DEPLOY THIS SP @DBCUST.CustDB --------
------------------------------------------------------	

-- BEGIN STEP 2: RUN THIS SCRIPT AT ALL REPLICATED SERVERS (06/DBTP) -----
--------------------------------------------------------------------------------------
CREATE TABLE #supers (custid int,isfinished bit default(0))

DECLARE  @srecommend INT
INSERT INTO #supers(custid)
SELECT ci.custid
FROM dbo.Customer ci WITH(NOLOCK)
INNER JOIN custInfo c WITH(NOLOCK) ON ci.custid=c.custid
WHERE (ci.roleid = 4 	
AND ci.custid NOT IN (SELECT custid FROM Dep_CustSuper WITH(NOLOCK)) 
AND c.Enabled=1	
AND ci.site IN ('611111','722222','766666','789y', '7aa666', 'XYZbet', 'Best-odds')	)
-- CROSS-SITE
OR  ci.custid IN (674248,395075,1164457,1016771,17721601,1016771,324561,1127269,938136)		

WHILE (1 = 1)
BEGIN
	UPDATE TOP (1) #Supers
	SET isfinished = 1
		,@srecommend = custid	
	WHERE isfinished = 0
	
	IF @@ROWCOUNT = 0 BREAK
			
	EXEC dbo.Acc_DynamicCustomerInfo_09 @srecommend = @srecommend
			--,@maxcustid = @max_custid
			,@target = 'REPLICATED'
			
			
	waitfor delay '00:00:0.280'
END

-- BEGIN STEP 3: RUN THIS SCRIPT AT DBCUST -----
--------------------------------------------------------------------------------------
CREATE TABLE #supers (custid int,isfinished bit default(0))

DECLARE  @srecommend INT
INSERT INTO #supers(custid)
SELECT ci.custid
FROM dbo.Customer ci WITH(NOLOCK)
INNER JOIN custInfo c WITH(NOLOCK) ON ci.custid=c.custid
WHERE (ci.roleid = 4 	
AND ci.custid NOT IN (SELECT custid FROM Dep_CustSuper WITH(NOLOCK)) 
AND c.Enabled=1	
AND ci.site IN ('611111','722222','766666','789y', '7aa666', 'XYZbet', 'Best-odds')	)
-- CROSS-SITE
OR  ci.custid IN (674248,395075,1164457,1016771,17721601,1016771,324561,1127269,938136)		
	
WHILE (1 = 1)
BEGIN
	UPDATE TOP (1) #Supers
	SET isfinished = 1
		,@srecommend = custid	
	WHERE isfinished = 0
	
	IF @@ROWCOUNT = 0 BREAK

	EXEC dbo.Acc_DynamicCustomerInfo_09 @srecommend = @srecommend
			--,@maxcustid = @max_custid
			,@target = 'DBCUST'
						
	waitfor delay '00:00:0.280'
END

