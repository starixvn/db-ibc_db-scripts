

/*
	Created: Winnie
	Task: Enable Fishing World for direct accounts
	DB: DBCUST/CustDB
	Date: 20170117
*/ 

ALTER PROCEDURE [dbo].[Acc_DynamicCustSetting3rd_09]
	@srecommend INT	
	,@target VARCHAR(20)
AS
BEGIN
	SET NOCOUNT ON
	
	IF (@target = 'REPLICATED' AND @@SERVERNAME = 'DBCUST') RETURN	-- run at all replicated servers
	IF (@target = 'DBCUST' AND @@SERVERNAME <> 'DBCUST') RETURN -- run at dbtrans only
	
	IF dbo.f_CheckRepTable('CustInfo') = 0 RETURN
	IF dbo.f_CheckRepTable('CustProductStatus') = 0 RETURN
	IF dbo.f_CheckRepTable('ProductStatusProfile') = 0 RETURN

	CREATE TABLE #CustTemp
	(
		CustID INT PRIMARY KEY CLUSTERED
	)
	
	CREATE TABLE #DirectMaster (CustID INT PRIMARY KEY,roleid INT)
	CREATE TABLE #DirectAgent (CustID INT PRIMARY KEY,mrecommend INT,roleid INT)
	CREATE TABLE #DirectMember (CustID INT PRIMARY KEY,recommend INT,mrecommend INT,roleid INT)			
	--- get direct master
	INSERT INTO #DirectMaster (CustID,roleid)
	SELECT custid, roleid
	FROM Customer with(nolock)
	WHERE  site in ('733333','222223', '222225', '222227', '222229')
		and custid NOT IN (SELECT custid from Acc_CustDirect WITH(NOLOCK))
		and srecommend IN (SELECT custid from Acc_CustDirect WITH(NOLOCK))
		and roleid=3 AND srecommend = @srecommend 
		
	--- get direct agent
	INSERT INTO #DirectAgent (CustID,mrecommend,roleid)
	SELECT custid, mrecommend,roleid
	FROM Customer WITH(NOLOCK)
	WHERE site in ('733333','222223', '222225', '222227', '222229')
		and custid NOT IN (SELECT custid from Acc_CustDirect WITH(NOLOCK))
		and mrecommend IN (SELECT custid from Acc_CustDirect WITH(NOLOCK))
		and roleid=2 AND srecommend = @srecommend 

	INSERT INTO #DirectMember(CustID,recommend,mrecommend,roleid)
	SELECT c.custid, c.recommend,c.mrecommend,c.roleid
	FROM Customer c WITH(NOLOCK)
	INNER JOIN Customer ca (nolock) on c.recommend=ca.custid 
	WHERE c.custid NOT IN (SELECT custid from Acc_CustDirect WITH(NOLOCK))
		AND c.recommend IN (SELECT custid from Acc_CustDirect WITH(NOLOCK))
		AND c.roleid=1 AND c.srecommend = @srecommend 
		AND  ca.site in ('733333','222223', '222225', '222227', '222229')
	----------- For SMA  -----------
	INSERT INTO #CustTemp (CustID)
	--SELECT @srecommend -- Super
	--UNION ALL
	 
	SELECT ci.srecommend -- super of Direct Master 
	FROM custInfo CI WITH (NOLOCK)
		INNER JOIN #DirectMaster D ON CI.custid = D.CustID 
	UNION	
	SELECT CI.CustID -- Direct Master 
	FROM custInfo CI WITH (NOLOCK)
		INNER JOIN #DirectMaster D ON CI.custid = D.CustID 
	UNION 
	SELECT DISTINCT CI.srecommend -- super of direct agent
	FROM custInfo CI WITH (NOLOCK)
		INNER JOIN #DirectAgent D ON CI.custid = d.CustID
	
	UNION 
	SELECT DISTINCT CI.CustID -- Master of direct agent
	FROM custInfo CI WITH (NOLOCK)
		INNER JOIN #DirectAgent D ON CI.custid = D.mrecommend 	
	
	UNION 

	SELECT CI.CustID -- Agent of direct master
	FROM custInfo CI WITH (NOLOCK)
		INNER JOIN #DirectMaster D ON CI.mrecommend = D.CustID 
	WHERE CI.roleid = 2
				
	UNION 
	SELECT CI.CustID -- Direct Agent
	FROM custInfo CI WITH (NOLOCK)
		INNER JOIN #DirectAgent D ON CI.custid = D.CustID 
	
	UNION 
	SELECT DISTINCT CI.srecommend -- super of direct member
	FROM custInfo CI WITH (NOLOCK)
		INNER JOIN #DirectMember D ON CI.custid = D.CustID 
	WHERE  ci.Enabled = 1
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
	
	
	UPDATE cs
	SET								
		 bitmapIsDisabled =  dbo.f_GenerateProductStatus (cs.bitmapIsDisabled, 8,0)
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

DECLARE  @srecommend INT

INSERT INTO #supers(custid,exchangeid)
SELECT ci.custid,ci.currency
FROM dbo.Customer ci WITH(NOLOCK)
WHERE ci.custid IN (
			-- dummy account
			2,3,4,5,12,13,15
		)

WHILE (1 = 1)
BEGIN
	UPDATE TOP (1) #Supers
	SET isfinished = 1
		,@srecommend = custid			
	WHERE isfinished = 0
	
	IF @@ROWCOUNT = 0 BREAK
			
	EXEC dbo.Acc_DynamicCustSetting3rd_09 @srecommend = @srecommend			
			,@target = 'REPLICATED'
			
			
	waitfor delay '00:00:0.280'
END

-- BEGIN STEP 3: RUN THIS SCRIPT AT DBCUST -----
--------------------------------------------------------------------------------------
CREATE TABLE #supers (custid int,exchangeid INT,isfinished bit default(0))

DECLARE @srecommend INT


INSERT INTO #supers(custid,exchangeid)
SELECT ci.custid,ci.currency
FROM dbo.Customer ci WITH(NOLOCK)
WHERE ci.custid IN (
			-- dummy account
			2,3,4,5,12,13,15
		)


WHILE (1 = 1)
BEGIN
	UPDATE TOP (1) #Supers
	SET isfinished = 1
		,@srecommend = custid			
	WHERE isfinished = 0
	
	IF @@ROWCOUNT = 0 BREAK

	EXEC dbo.Acc_DynamicCustSetting3rd_09 @srecommend = @srecommend			
			,@target = 'DBCUST'
						
	waitfor delay '00:00:0.280'
END

