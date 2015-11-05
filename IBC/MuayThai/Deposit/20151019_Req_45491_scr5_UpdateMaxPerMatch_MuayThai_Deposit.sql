/*
	Created: Elodie
	Date: 2015-10-19
	Task: Copy Muay Thai settings from Other Sports for deposit customer
	DB: DBCUST/CustDB
*/ 

--STEP 1: DEPLOY THIS SP @DBCUST.CustDB -----
-----------------------------------------------
ALTER PROCEDURE [dbo].[Acc_ExecRep_Cust_09]
	@srecommend INT
  , @target     VARCHAR(20)
AS
BEGIN	
	SET NOCOUNT ON
	
	IF (@target = 'REPLICATED' AND @@SERVERNAME = 'DBCUST') RETURN	-- run at all replicated servers
	IF (@target = 'DBCUST' AND @@SERVERNAME <> 'DBCUST') RETURN -- run at DBCUST only
	
	IF dbo.f_CheckRepTable('Custinfo') = 0
		RETURN		

    --custInfo
	UPDATE ci 
	   SET ci.MaxPerMatch44 = ci.maxpermatch99
	FROM custInfo ci WITH(ROWLOCK, UPDLOCK)
	 WHERE srecommend = @srecommend
	   
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

INSERT INTO #CustSuper(srecommend)
SELECT ci.custid
  FROM custinfo ci WITH(NOLOCK)
 WHERE custid IN (SELECT custid FROM Dep_CustSuper WITH(NOLOCK))	
	AND currency = 20

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

INSERT INTO #CustSuper(srecommend)
SELECT ci.custid
  FROM custinfo ci WITH(NOLOCK)
 WHERE custid IN (SELECT custid FROM Dep_CustSuper WITH(NOLOCK) WHERE site <> '12Bet')	
	AND currency = 20

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
	  
	WAITFOR DELAY '00:00:00.280'
END

DROP TABLE #CustSuper

GO	

-- END STEP 3: RUN THIS SCRIPT AT DBCUST -------
-------------------------------------------------