/*
	Created: Elodie
	Date: 2015-07-28
	Task: Update DisableSuperLive = 1 for real accounts
	DB: DBCUST/CustDB
*/ 

--STEP 1: DEPLOY THIS SP @DBCUST.CustDB -----
-----------------------------------------------
ALTER PROCEDURE [dbo].[Acc_ExecRep_Cust_09]
	@srecommend INT
	,@DisableSuperLive BIT
	,@max_custid INT
	,@target     VARCHAR(30)
AS
BEGIN	
	SET NOCOUNT ON
	
	IF (@target = 'REPLICATED' AND @@SERVERNAME = 'DBCUST') RETURN	-- run at all replicated servers
	IF (@target = 'DBCUST' AND @@SERVERNAME <> 'DBCUST') RETURN -- run at DBCUST only
	
	IF dbo.f_CheckRepTable('Custinfo') = 0
		RETURN		

    --custInfo
	UPDATE custInfo WITH(ROWLOCK, UPDLOCK)
	   SET DisableSuperLive = @DisableSuperLive
	 WHERE srecommend = @srecommend
	   AND custid <= @max_custid
END
GO
-- END STEP 1: DEPLOY THIS SP @DBCUST.CustDB -------
------------------------------------------------------	
---
---
-- BEGIN STEP 2: RUN THIS SCRIPT AT ALL REPLICATED SERVERS (DB052/053/054/06/DBTP)----
--------------------------------------------------------------------------------------
CREATE TABLE #CustSuper(srecommend INT , isfinished BIT DEFAULT(0))	
CREATE TABLE #CustEnableSuperLive(srecommend INT)	

DECLARE @max_custid INT, @srecommend INT

SELECT @max_custid = xx

INSERT INTO #CustSuper(srecommend)
SELECT ci.custid
FROM Customer ci WITH(NOLOCK)
WHERE ci.custid <= @max_custid
	AND roleid = 4
	AND ci.custid NOT IN (SELECT custid FROM Dep_CustSuper WITH(NOLOCK))

INSERT INTO #CustEnableSuperLive(srecommend)
SELECT ci.custid
FROM Customer ci WITH(NOLOCK)
WHERE ci.custid <= @max_custid
	AND roleid = 4
	AND ci.custid NOT IN (SELECT custid FROM Dep_CustSuper WITH(NOLOCK))
	AND site IN ('KORIBC','INDO')

WHILE (1 = 1)
BEGIN
	UPDATE TOP (1) #CustSuper
	   SET isfinished = 1
		 , @srecommend = srecommend
	 WHERE isfinished = 0
	
	IF @@ROWCOUNT = 0 BREAK
	
	IF EXISTS (SELECT 1 FROM #CustEnableSuperLive WHERE srecommend = @srecommend)
		EXEC dbo.Acc_ExecRep_Cust_09
			@srecommend = @srecommend
			,@DisableSuperLive = 0
			,@max_custid = @max_custid
			,@target = 'REPLICATED'
	ELSE
		EXEC dbo.Acc_ExecRep_Cust_09
			@srecommend = @srecommend
			,@DisableSuperLive = 1
			,@max_custid = @max_custid
			,@target = 'REPLICATED'

    WAITFOR DELAY '00:00:00.280'
END

DROP TABLE #CustSuper
DROP TABLE #CustEnableSuperLive

GO		
-- END STEP 2: RUN THIS SCRIPT AT ALL REPLICATED SERVERS (DB052/053/054/06/DBTP -----
-----------------------------------------------------------------------------------

---
-- BEGIN STEP 3: RUN THIS SCRIPT AT DBCUST -----
-------------------------------------------------
CREATE TABLE #CustSuper(srecommend INT , isfinished BIT DEFAULT(0))	
CREATE TABLE #CustEnableSuperLive(srecommend INT)	

DECLARE @max_custid INT, @srecommend INT

SELECT @max_custid = xx

INSERT INTO #CustSuper(srecommend)
SELECT ci.custid
FROM custinfo ci WITH(NOLOCK)
WHERE ci.custid <= @max_custid
	AND roleid = 4
	AND ci.custid NOT IN (SELECT custid FROM Dep_CustSuper WITH(NOLOCK))

INSERT INTO #CustEnableSuperLive(srecommend)
SELECT ci.custid
FROM Customer ci WITH(NOLOCK)
WHERE ci.custid <= @max_custid
	AND roleid = 4
	AND ci.custid NOT IN (SELECT custid FROM Dep_CustSuper WITH(NOLOCK))
	AND site IN ('KORIBC','INDO')

WHILE (1 = 1)
BEGIN
	UPDATE TOP (1) #CustSuper
	   SET isfinished = 1
		 , @srecommend = srecommend			
	 WHERE isfinished = 0
	
	IF @@ROWCOUNT = 0 BREAK

	IF EXISTS (SELECT 1 FROM #CustEnableSuperLive WHERE srecommend = @srecommend)
		EXEC dbo.Acc_ExecRep_Cust_09
			@srecommend = @srecommend
			,@DisableSuperLive = 0
			,@max_custid = @max_custid
			,@target = 'DBCUST'
	ELSE
		EXEC dbo.Acc_ExecRep_Cust_09
			@srecommend = @srecommend
			,@DisableSuperLive = 1
			,@max_custid = @max_custid
			,@target = 'DBCUST'
	  
	WAITFOR DELAY '00:00:00.280'
END

DROP TABLE #CustSuper

GO	

-- END STEP 3: RUN THIS SCRIPT AT DBCUST -------
-------------------------------------------------