/*
	Created: Winnie
	Date: 2016-11-11
	Task: Copy Soccer parlay settings (minbet,maxbet) from Soccer for credit customer RedmineID: #66265
	DB: DBCUST/CustDB
*/ 
--Step 1: update customer settings in Custsetting
-- DEPLOY THIS SP @ DBCUST.CustDB -----
------------------------------------------------------
ALTER PROCEDURE [dbo].[Acc_CustSetting3rd_19]
	@srecommend INT		
	,@target VARCHAR(20)
AS
BEGIN	
	SET NOCOUNT ON
	IF (@target = 'REPLICATED' AND @@SERVERNAME = 'DBCUST') RETURN	-- run at all replicated servers
	IF (@target = 'DBCUST' AND @@SERVERNAME <> 'DBCUST') RETURN -- run at DBCUST only
	
	IF NOT (dbo.f_CheckRepTable('Custinfo') = 1 
			AND dbo.f_CheckRepTable('CustSetting') = 1
			)
		RETURN		
		
	CREATE TABLE #tmp (CustID INT  PRIMARY KEY,minbet MONEY, maxbet MONEY)	
	INSERT INTO #tmp(CustID,minbet , maxbet )
	SELECT 	a.custid ,minbet , maxbet 
	FROM CustSetting a WITH(NOLOCK) 
	INNER JOIN custinfo ci WITH(NOLOCK) ON a.custid = ci.custid
	WHERE  Sporttype=1 AND bettype=1 AND ci.srecommend = @srecommend	
	
	UPDATE a
	SET a.minbet=b.minbet,a.maxbet=b.maxbet
	FROM CustSetting a  WITH(ROWLOCK,UPDLOCK)
	INNER JOIN #tmp b ON a.custid=b.CustID 
	INNER JOIN custinfo ci WITH(NOLOCK) ON a.custid = ci.custid
	WHERE ci.srecommend = @srecommend		
	AND Sporttype=1 AND bettype=9   
		
END
GO
-- END STEP 1: DEPLOY THIS SP @ DBCUST.CustDB -------
------------------------------------------------------
---
---
-- BEGIN STEP 2: RUN THIS SCRIPT AT ALL REPLICATED SERVERS (DB06/DBTP) -----
--------------------------------------------------------------------------------------
 
CREATE TABLE #supers (custid int, isfinished bit default(0))

DECLARE @srecommend INT

INSERT INTO #supers(custid)
SELECT custid
FROM custinfo WITH(NOLOCK)
WHERE custid NOT IN (SELECT custid FROM Dep_CustSuper WITH(NOLOCK))
	AND roleid = 4

WHILE (1 = 1)
BEGIN
	UPDATE TOP (1) #Supers
	SET isfinished = 1
		,@srecommend = custid			
	WHERE isfinished = 0
	
	IF @@ROWCOUNT = 0 BREAK

	EXEC dbo.[Acc_CustSetting3rd_19] @srecommend = @srecommend			
			,@target = 'REPLICATED'
	
	WAITFOR DELAY '00:00:00.280'			
END			
GO		
-- END STEP 2: RUN THIS SCRIPT AT ALL REPLICATED SERVERS (DB06/DBTP) -----
-----------------------------------------------------------------------------------

---
-- BEGIN STEP 3: RUN THIS SCRIPT AT DBCUST -----
-------------------------------------------------
CREATE TABLE #supers (custid int, isfinished bit default(0))

DECLARE  @srecommend INT

INSERT INTO #supers(custid)
SELECT custid
FROM custinfo WITH(NOLOCK)
WHERE custid NOT IN (SELECT custid FROM Dep_CustSuper WITH(NOLOCK))
	AND roleid = 4

WHILE (1 = 1)
BEGIN
	UPDATE TOP (1) #Supers
	SET isfinished = 1
		,@srecommend = custid			
	WHERE isfinished = 0
	
	IF @@ROWCOUNT = 0 BREAK

	EXEC dbo.[Acc_CustSetting3rd_19] @srecommend = @srecommend		
			,@target = 'DBCUST'
	
	WAITFOR DELAY '00:00:00.280'			
END			
GO		
-- END STEP 3: RUN THIS SCRIPT AT DBCUST -----