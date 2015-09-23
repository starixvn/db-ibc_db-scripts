  /*
	Created: Johnson
	Task: set hideGoldDeluxe = 0 for all customers exclude 897y & WON currency
	DB: DBCUST/CustDB
	Date: 20150923
*/ 

 ALTER PROCEDURE [dbo].[Acc_ExecRep_Cust_09]
	@srecommend INT		
	,@target VARCHAR(20)	
AS
BEGIN
	SET NOCOUNT ON
	
	IF (@target = 'REPLICATED' AND @@SERVERNAME = 'DBCUST') RETURN	-- run at all replicated servers
	IF (@target = 'DBCUST' AND @@SERVERNAME <> 'DBCUST') RETURN -- run at dbtrans only
	
	IF ( SELECT COUNT(1) FROM sys.objects WHERE NAME IN ('Custinfo','customer')) <> 1
		RETURN
	
	--exclude customers from site 789y 
	CREATE #tmp789y TABLE (custid INT, roleid INT)
	
	INSERT INTO #tmp789y(custid,roleid)
	SELECT custid, roleid
	FROM customer WITH(NOLOCK)
	WHERE srecommend = @srecommend 
		AND roleid IN (2,3)
		AND site = '789y'
	
	UPDATE custinfo WITH(UPDLOCK,ROWLOCK)
	SET HideGoldDeluxe = 0
	WHERE srecommend = @srecommend 
		AND mrecommend NOT IN (SELECT custid FROM #tmp789y WHERE roleid = 3)
		AND recommend NOT IN (SELECT custid FROM #tmp789y WHERE roleid = 2)
	
	DROP TABLE #tmp789y		
END		
GO

-- END STEP 1: DEPLOY THIS SP @DBCUST.CustDB --------
------------------------------------------------------	


---
-- BEGIN STEP 2: RUN THIS SCRIPT AT ALL REPLICATED SERVERS (052/053/054/06/DBTP) -----
--------------------------------------------------------------------------------------
CREATE TABLE #supers (custid int, isfinished bit default(0))
DECLARE @srecommend INT

INSERT INTO #supers(custid)
SELECT ci.custid
FROM Customer c WITH(NOLOCK)	
	INNER JOIN site s WITH (NOLOCK) ON c.site = s.site
	LEFT JOIN custsuper cs WITH (NOLOCK) ON c.custid = cs.custid
WHERE c.roleid = 4 	
	AND c.custid NOT IN (SELECT custid FROM Dep_CustSuper WITH(NOLOCK))
	AND c.site <> '789y'
	AND currency NOT IN (44,45,62) 
	AND ci.username NOT LIKE '3rdSuper%'
	AND cs.isinternal = 0
	and s.islicensee = 0
	
	
WHILE (1 = 1)
BEGIN
	UPDATE TOP (1) #Supers
	SET isfinished = 1
		,@srecommend = custid				
	WHERE isfinished = 0
	
	IF @@ROWCOUNT = 0 BREAK

	EXEC dbo.[Acc_ExecRep_Cust_09] @srecommend = @srecommend			
			,@target = 'REPLICATED'
				
	waitfor delay '00:00:0.280'
END			
GO		
-- END STEP 2: RUN THIS SCRIPT AT ALL REPLICATED SERVERS (052/053/054/06/DBTP) -----
-----------------------------------------------------------------------------------
 
 

---
-- BEGIN STEP 3: RUN THIS SCRIPT AT DBCUST -----
--------------------------------------------------------------------------------------
CREATE TABLE #supers (custid int, isfinished bit default(0))
DECLARE @srecommend INT

INSERT INTO #supers(custid)
SELECT ci.custid
FROM Customer c WITH(NOLOCK)	
	INNER JOIN site s WITH (NOLOCK) ON c.site = s.site
	LEFT JOIN custsuper cs WITH (NOLOCK) ON c.custid = cs.custid
WHERE c.roleid = 4 	
	AND c.custid NOT IN (SELECT custid FROM Dep_CustSuper WITH(NOLOCK))
	AND c.site <> '789y'
	AND currency NOT IN (44,45,62) 
	AND ci.username NOT LIKE '3rdSuper%'
	AND cs.isinternal = 0
	and s.islicensee = 0
	
	
WHILE (1 = 1)
BEGIN
	UPDATE TOP (1) #Supers
	SET isfinished = 1
		,@srecommend = custid				
	WHERE isfinished = 0
	
	IF @@ROWCOUNT = 0 BREAK

	EXEC dbo.[Acc_ExecRep_Cust_09] @srecommend = @srecommend			
			,@target = 'DBCUST'
				
	waitfor delay '00:00:0.280'
END			
GO		

-- END STEP 3: RUN THIS SCRIPT AT DBCUST -----
-----------------------------------------------------------------------------------
 
 