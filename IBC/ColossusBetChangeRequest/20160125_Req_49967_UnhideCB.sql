/*
	Created: Helen
	Date: 2016-01-25
	Task: Unhide the Colossus Bet setting page for all SMA, except 789y and SMA that use HKK currency. [Redmine: #51387]
	
*/ 


--STEP 1: DEPLOY THIS SP @DBCUST.CustDB -----
-----------------------------------------------
ALTER PROCEDURE [dbo].[Acc_ExecRep_Cust_09]
	@srecommend INT
  , @target     VARCHAR(20)
  , @max_custid INT
AS
BEGIN	
	SET NOCOUNT ON
	
	IF (@target = 'REPLICATED' AND @@SERVERNAME = 'DBCUST') RETURN	-- run at all replicated servers
	IF (@target = 'DBCUST' AND @@SERVERNAME <> 'DBCUST') RETURN -- run at DBCUST only
	
	IF dbo.f_CheckRepTable('Custinfo') = 0
		RETURN		

	UPDATE custInfo WITH(ROWLOCK, UPDLOCK)
	   SET HideColossusBet = 0, DisableColossusBet = 0
	 WHERE srecommend = @srecommend AND custid <= @max_custid
	
END
GO
-- END STEP 1: DEPLOY THIS SP @ DBCUST.CustDB -------
------------------------------------------------------	

---
---
-- BEGIN STEP 2: RUN THIS SCRIPT AT ALL REPLICATED SERVERS (DB052/053/054/06/DBTP -----
--------------------------------------------------------------------------------------
CREATE TABLE #CustSuper(srecommend INT , isfinished BIT DEFAULT(0))	

DECLARE @srecommend INT

DECLARE @max_custid INT
SELECT @max_custid = xxx

INSERT INTO #CustSuper(srecommend)
SELECT custid
 FROM Customer  WITH (NOLOCK) 
 WHERE custid NOT IN (SELECT custid FROM Dep_CustSuper WITH(NOLOCK))
	AND roleid = 4
	AND (currency <> 67 OR [site] <> '789y')
	AND custid <= @max_custid
	

WHILE (1 = 1)
BEGIN
	UPDATE TOP (1) #CustSuper
	   SET isfinished = 1
		 , @srecommend = srecommend
	 WHERE isfinished = 0
	
	IF @@ROWCOUNT = 0 BREAK

	EXEC dbo.Acc_ExecRep_Cust_09
	    @srecommend = @srecommend
	  , @target = 'REPLICATED'
	  , @max_custid = @max_custid

    WAITFOR DELAY '00:00:00.280'
END

DROP TABLE #CustSuper

GO		
-- END STEP 2: RUN THIS SCRIPT AT ALL REPLICATED SERVERS (DB052/053/054/06/DBTP -----
-----------------------------------------------------------------------------------

---
-- BEGIN STEP 3: RUN THIS SCRIPT AT DBCUST -----
-------------------------------------------------
CREATE TABLE #CustSuper(srecommend INT , isfinished BIT DEFAULT(0))	

DECLARE @srecommend INT

DECLARE @max_custid INT
SELECT @max_custid = xxx

INSERT INTO #CustSuper(srecommend)
SELECT custid
 FROM Customer  WITH (NOLOCK) 
 WHERE custid NOT IN (SELECT custid FROM Dep_CustSuper WITH(NOLOCK))
	AND roleid = 4
	AND (currency <> 67 OR [site] <> '789y')
	AND custid <= @max_custid

WHILE (1 = 1)
BEGIN
	UPDATE TOP (1) #CustSuper
	   SET isfinished = 1
		 , @srecommend = srecommend			
	 WHERE isfinished = 0
	
	IF @@ROWCOUNT = 0 BREAK

	EXEC dbo.Acc_ExecRep_Cust_09
	    @srecommend = @srecommend
	  , @target = 'DBCUST'
	  , @max_custid = @max_custid
	  
	WAITFOR DELAY '00:00:00.280'
END

DROP TABLE #CustSuper

GO	

-- END STEP 3: RUN THIS SCRIPT AT DBCUST -------
-------------------------------------------------