

/*
	Created: Winnie
	Task: Un Hide for direct accounts
	DB: DBCUST/CustDB
	Date: 20170313
*/ 

ALTER PROCEDURE [dbo].[Acc_DynamicCustomerInfo_09]
	@srecommend INT	
	,@ExchangeID INT	
	,@maxcustid INT
	,@target VARCHAR(20)
AS
BEGIN
	SET NOCOUNT ON
	
	IF (@target = 'REPLICATED' AND @@SERVERNAME = 'DBCUST') RETURN	-- run at all replicated servers
	IF (@target = 'DBCUST' AND @@SERVERNAME <> 'DBCUST') RETURN -- run at dbtrans only
	
	IF dbo.f_CheckRepTable('CustInfo') = 0 RETURN
	IF dbo.f_CheckRepTable('Customer') = 0 RETURN
	IF dbo.f_CheckRepTable('CustProductStatus') = 0 RETURN
	IF dbo.f_CheckRepTable('ProductStatusProfile') = 0 RETURN

	CREATE TABLE #CustTemp
	(
		CustID INT PRIMARY KEY CLUSTERED
	)
	
	CREATE TABLE #DirectMaster (CustID INT PRIMARY KEY,roleid INT)
	CREATE TABLE #DirectAgent (CustID INT PRIMARY KEY,mrecommend INT,roleid INT)
	CREATE TABLE #DirectMember (CustID INT PRIMARY KEY,recommend INT,mrecommend INT,roleid INT)		
	DECLARE @Sporttype INT
	SELECT @Sporttype=219	
	--- get direct master
	INSERT INTO #DirectMaster (CustID,roleid)
	SELECT ci.custid, ci.roleid
	FROM Customer ci with(nolock)
	INNER JOIN custInfo c WITH(NOLOCK) ON ci.custid=c.custid
	WHERE  site in  ('611111','722222','766666','789y', '7aa666', 'XYZbet', 'Best-odds')	
		and ci.custid NOT IN (SELECT custid from Acc_CustDirect WITH(NOLOCK))
		and ci.srecommend IN (SELECT custid from Acc_CustDirect WITH(NOLOCK))
		and ci.roleid=3 AND ci.srecommend = @srecommend AND ci.custid <= @maxcustid AND c.Enabled=1
		
	--- get direct agent
	INSERT INTO #DirectAgent (CustID,mrecommend,roleid)
	SELECT ci.custid, ci.mrecommend,ci.roleid
	FROM Customer ci WITH(NOLOCK)
	INNER JOIN custInfo c WITH(NOLOCK) ON ci.custid=c.custid
	WHERE site in  ('611111','722222','766666','789y', '7aa666', 'XYZbet', 'Best-odds')		
		and ci.custid NOT IN (SELECT custid from Acc_CustDirect WITH(NOLOCK))
		and ci.mrecommend IN (SELECT custid from Acc_CustDirect WITH(NOLOCK))
		and ci.roleid=2 AND ci.srecommend = @srecommend AND ci.custid <= @maxcustid AND c.Enabled=1

	INSERT INTO #DirectMember(CustID,recommend,mrecommend,roleid)
	SELECT c.custid, c.recommend,c.mrecommend,c.roleid
	FROM Customer c WITH(NOLOCK)
	INNER JOIN Customer ca (nolock) on c.recommend=ca.custid 
	INNER JOIN custInfo ci WITH(NOLOCK) ON ci.custid=c.custid
	WHERE c.custid NOT IN (SELECT custid from Acc_CustDirect WITH(NOLOCK))
		AND c.recommend IN (SELECT custid from Acc_CustDirect WITH(NOLOCK))
		AND c.roleid=1 AND c.srecommend = @srecommend AND C.custid <= @maxcustid 
		AND  ca.site in  ('611111','722222','766666','789y', '7aa666', 'XYZbet', 'Best-odds')	
		AND ci.Enabled=1
	----------- For SMA  -----------
	INSERT INTO #CustTemp (CustID)
	SELECT @srecommend -- Super
	UNION ALL
	SELECT CI.CustID -- Direct Master 
	FROM custInfo CI WITH (NOLOCK)
		INNER JOIN #DirectMaster D ON CI.custid = D.CustID 
	UNION 
	SELECT DISTINCT CI.CustID -- Master of direct agent
	FROM custInfo CI WITH (NOLOCK)
		INNER JOIN #DirectAgent D ON CI.custid = D.mrecommend 
	WHERE CI.custid <= @maxcustid 	
	
	UNION 

	SELECT CI.CustID -- Agent of direct master
	FROM custInfo CI WITH (NOLOCK)
		INNER JOIN #DirectMaster D ON CI.mrecommend = D.CustID 
	WHERE CI.roleid = 2 AND CI.custid <= @maxcustid 
				
	UNION 
	SELECT CI.CustID -- Direct Agent
	FROM custInfo CI WITH (NOLOCK)
		INNER JOIN #DirectAgent D ON CI.custid = D.CustID 
	
	UNION 

	SELECT DISTINCT CI.CustID -- Master of direct member
	FROM custInfo CI WITH (NOLOCK)
		INNER JOIN #DirectMember D ON CI.custid = D.mrecommend 
	WHERE  ci.Enabled = 1

	UNION 
	SELECT DISTINCT CI.CustID -- agent of direct member
	FROM custInfo CI WITH (NOLOCK)
		INNER JOIN #DirectMember D ON CI.custid = D.recommend 
	WHERE  ci.Enabled = 1 	
	---------- For members ---------
	INSERT INTO #CustTemp (CustID)
	SELECT CI.custid
	FROM Custinfo CI WITH (NOLOCK)
		INNER JOIN #DirectMaster M ON CI.mrecommend = M.CustID
	WHERE CI.roleid = 1	AND CI.custid <= @maxcustid AND ci.Enabled=1			

	UNION 
	SELECT CI.custid
	FROM Custinfo CI WITH (NOLOCK)
		INNER JOIN #DirectAgent M ON CI.recommend = M.CustID
	WHERE CI.roleid = 1 AND CI.custid <= @maxcustid AND ci.Enabled=1			
	-- Direct member		
	UNION 
	SELECT CI.custid
	FROM Custinfo CI WITH (NOLOCK)
		INNER JOIN #DirectMember M ON CI.custid = M.CustID AND CI.custid <= @maxcustid 	
	
	DECLARE @BitOrder INT
	SELECT @BitOrder= bitmapOrder from ProductStatusProfile WITH(NOLOCK) where SportType=@Sporttype
	
	UPDATE cs
	SET								
		 bitmapIsHidden =  dbo.f_GenerateProductStatus (cs.bitmapIsHidden, @BitOrder,0)
	FROM [dbo].[CustProductStatus] cs WITH(ROWLOCK,UPDLOCK)
		INNER JOIN #CustTemp CI WITH (NOLOCK) ON cs.CustID = ci.CustID	

	---------------------------------------------------------------------------------------

END
GO
-- END STEP 1: DEPLOY THIS SP @DBCUST.CustDB --------
------------------------------------------------------	

-- BEGIN STEP 2: RUN THIS SCRIPT AT ALL REPLICATED SERVERS (06/DBTP) -----
--------------------------------------------------------------------------------------
CREATE TABLE #supers (custid int,exchangeid INT,isfinished bit default(0))

DECLARE @max_custid INT, @srecommend INT, @exchangeid INT

SELECT @max_custid = xxx

INSERT INTO #supers(custid,exchangeid)
SELECT ci.custid,ci.currency
FROM dbo.Customer ci WITH(NOLOCK)
WHERE ci.custid IN (1,2,3,4,5,6,9,12,13,15,16,22,30,32,33,34,35,36,41,42,1469577,3259509,3259514,3259527,3259546,3259599,3259606,3259614,4042341,4054997,6911902,7178173,7178174,7178175
		,7178176,7178177,7178178,7178179,7178180,7178181,7205490,7216595,7662761,14174238,17996553,18906414,19354890,21278849,21278858) 

WHILE (1 = 1)
BEGIN
	UPDATE TOP (1) #Supers
	SET isfinished = 1
		,@srecommend = custid	
		,@exchangeid = exchangeid 
	WHERE isfinished = 0
	
	IF @@ROWCOUNT = 0 BREAK
			
	EXEC dbo.Acc_DynamicCustomerInfo_09 @srecommend = @srecommend , @Exchangeid = @exchangeid
			,@maxcustid = @max_custid
			,@target = 'REPLICATED'
			
			
	waitfor delay '00:00:0.280'
END

-- BEGIN STEP 3: RUN THIS SCRIPT AT DBCUST -----
--------------------------------------------------------------------------------------
CREATE TABLE #supers (custid int,exchangeid INT,isfinished bit default(0))

DECLARE @max_custid INT, @srecommend INT, @exchangeid INT

SELECT @max_custid = xxx

INSERT INTO #supers(custid,exchangeid)
SELECT ci.custid,ci.currency
FROM dbo.Customer ci WITH(NOLOCK)
WHERE ci.custid IN (1,2,3,4,5,6,9,12,13,15,16,22,30,32,33,34,35,36,41,42,1469577,3259509,3259514,3259527,3259546,3259599,3259606,3259614,4042341,4054997,6911902,7178173,7178174,7178175
		,7178176,7178177,7178178,7178179,7178180,7178181,7205490,7216595,7662761,14174238,17996553,18906414,19354890,21278849,21278858) 

WHILE (1 = 1)
BEGIN
	UPDATE TOP (1) #Supers
	SET isfinished = 1
		,@srecommend = custid	
		,@exchangeid = exchangeid 
	WHERE isfinished = 0
	
	IF @@ROWCOUNT = 0 BREAK

	EXEC dbo.Acc_DynamicCustomerInfo_09 @srecommend = @srecommend, @Exchangeid = @exchangeid
			,@maxcustid = @max_custid
			,@target = 'DBCUST'
						
	waitfor delay '00:00:0.280'
END

