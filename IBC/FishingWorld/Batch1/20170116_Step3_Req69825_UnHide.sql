

/*
	Created: Winnie	
	Task: UnHide Fishing World for Credit customers
	DB: DBCUST/CustDB
	Date: 20170117
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
	   AND dbo.f_CheckRepTable('ProductStatusProfile') = 1
	   )
		RETURN	
	DECLARE @Sporttype INT
	SELECT @Sporttype=219	
	DECLARE @BitOrder INT
	SELECT @BitOrder= bitmapOrder from ProductStatusProfile WITH(NOLOCK) where SportType=@Sporttype
	
	UPDATE cs
	SET								
		 bitmapIsHidden =  dbo.f_GenerateProductStatus (cs.bitmapIsHidden,@BitOrder,0)
	FROM [dbo].[CustProductStatus] cs WITH(ROWLOCK,UPDLOCK)
		INNER JOIN custInfo CI WITH (NOLOCK) ON cs.CustID = ci.CustID
	WHERE ci.srecommend = @srecommend AND ci.custid<=@maxcustid AND ci.Enabled=1

END
GO
-- END STEP 1: DEPLOY THIS SP @DBCUST.CustDB --------
------------------------------------------------------	

-- BEGIN STEP 2: RUN THIS SCRIPT AT ALL REPLICATED SERVERS (06/DBTP) -----
--------------------------------------------------------------------------------------
CREATE TABLE #supers (custid int,isfinished bit default(0))

DECLARE @max_custid INT, @srecommend INT
SELECT @max_custid=xxx
INSERT INTO #supers(custid)
SELECT ci.custid
FROM dbo.Customer ci WITH(NOLOCK)
INNER JOIN custInfo c WITH(NOLOCK) ON ci.custid=c.custid
WHERE ci.roleid = 4 	
		AND ci.custid NOT IN (SELECT custid FROM Dep_CustSuper WITH(NOLOCK))
		AND ci.custid <= @max_custid	AND c.Enabled=1	
		AND ((ci.site in ('733333','222223', '222225', '222227', '222229')	
		-- CROSS-SITE
		AND ci.custid NOT IN (674248,395075,1164457,1016771,993226,2453866,1156957,1156957,17721601,1156957,1036451,993226,1016771,324561,506057,2453866,1127269,1036451,1036451,2042873
		,2042873,1036451,796555,5005322))
		OR (ci.currency=20 AND ci.custid NOT IN(23003140,14771858,15323100,15744710,17996464,18002026,18011327,18012360,18012400,18012427,18012473,18012480,18012482,18012484,18012696
											,18362423,18524451,18829945,19000014,19295126,19392121,19562449,19562472,20269385,20660425,20669162,20786437,21005407,21005647,21005670
											,21005685,21005748,21005851,21005868,21005888,21305783,21984259,23715203,24338704,1176070)))	
		
	
		

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
SELECT @max_custid=xxx
INSERT INTO #supers(custid)
SELECT ci.custid
FROM dbo.Customer ci WITH(NOLOCK)
INNER JOIN custInfo c WITH(NOLOCK) ON ci.custid=c.custid
WHERE (ci.roleid = 4 	
		AND ci.custid NOT IN (SELECT custid FROM Dep_CustSuper WITH(NOLOCK))
		AND ci.custid <= @max_custid AND c.Enabled=1
		AND(( ci.site in ('733333','222223', '222225', '222227', '222229')	
		-- CROSS-SITE
		AND ci.custid NOT IN (674248,395075,1164457,1016771,993226,2453866,1156957,1156957,17721601,1156957,1036451,993226,1016771,324561,506057,2453866,1127269,1036451,1036451,2042873
		,2042873,1036451,796555,5005322))
		OR (ci.currency=20 AND ci.custid NOT IN(23003140,14771858,15323100,15744710,17996464,18002026,18011327,18012360,18012400,18012427,18012473,18012480,18012482,18012484,18012696
											,18362423,18524451,18829945,19000014,19295126,19392121,19562449,19562472,20269385,20660425,20669162,20786437,21005407,21005647,21005670
											,21005685,21005748,21005851,21005868,21005888,21305783,21984259,23715203,24338704,1176070)))	
		)	

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

