/*
	Created: Elodie
	Date: 2015-27-28
	Task: Update DisableSuperLive = 0 for real accounts
	DB: DBCUST/CustDB
*/ 

--STEP 1: DEPLOY THIS SP @ DBCUST.CustDB -----
-----------------------------------------------
ALTER PROCEDURE [dbo].[Acc_ExecRep_Cust_09]
	@srecommend INT
  , @max_custid INT
  , @target     VARCHAR(20)
AS
BEGIN	
	SET NOCOUNT ON
	
	IF (@target = 'REPLICATED' AND @@SERVERNAME = 'DBCUST') RETURN	-- run at all replicated servers
	IF (@target = 'DBCUST' AND @@SERVERNAME <> 'DBCUST') RETURN -- run at DBCUST only
	
	IF dbo.f_CheckRepTable('Custinfo') = 0
		RETURN		

    --custInfo
	UPDATE custInfo WITH(ROWLOCK, UPDLOCK)
	   SET DisableSuperLive = 0
	 WHERE srecommend = @srecommend
	   AND custid <= @max_custid
	   AND DisableSuperLive IS NULL
END
GO
-- END STEP 1: DEPLOY THIS SP @ DBCUST.CustDB -------
------------------------------------------------------	

---
---
-- BEGIN STEP 2: RUN THIS SCRIPT AT ALL REPLICATED SERVERS (DB052/053/054/06/DBTP -----
--------------------------------------------------------------------------------------
CREATE TABLE #CustSuper(srecommend INT , isfinished BIT DEFAULT(0))	

DECLARE @max_custid INT, @srecommend INT

SELECT @max_custid = xx

INSERT INTO #CustSuper(srecommend)
SELECT ci.custid
  FROM custinfo ci WITH(NOLOCK)
 WHERE ci.custid <= @max_custid
   AND roleid = 4


WHILE (1 = 1)
BEGIN
	UPDATE TOP (1) #CustSuper
	   SET isfinished = 1
		 , @srecommend = srecommend
	 WHERE isfinished = 0
	
	IF @@ROWCOUNT = 0 BREAK

	EXEC dbo.Acc_ExecRep_Cust_09
	    @srecommend = @srecommend
	  , @max_custid = @max_custid
	  , @target = 'REPLICATED'

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

DECLARE @max_custid INT, @srecommend INT

SELECT @max_custid = xx

INSERT INTO #CustSuper(srecommend)
SELECT ci.custid
  FROM custinfo ci WITH(NOLOCK)
 WHERE ci.custid <= @max_custid
   AND roleid = 4


WHILE (1 = 1)
BEGIN
	UPDATE TOP (1) #CustSuper
	   SET isfinished = 1
		 , @srecommend = srecommend			
	 WHERE isfinished = 0
	
	IF @@ROWCOUNT = 0 BREAK

	EXEC dbo.Acc_ExecRep_Cust_09
	    @srecommend = @srecommend
	  , @max_custid = @max_custid
	  , @target = 'DBCUST'
	  
	WAITFOR DELAY '00:00:00.280'
END

DROP TABLE #CustSuper

GO	

-- END STEP 3: RUN THIS SCRIPT AT DBCUST -------
-------------------------------------------------