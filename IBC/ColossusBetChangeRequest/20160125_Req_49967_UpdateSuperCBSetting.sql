/*
	Created: Helen
	Date: 2016-01-20
	Task: Update LockUpd = 0 
	DB: 
*/ 

--STEP 1: DEPLOY THIS SP @DBCUST.CustDB -----
-----------------------------------------------
ALTER PROCEDURE [dbo].[Acc_ExecRep_Cust_09]
  @target     VARCHAR(20)
  , @maxcustid int
 
AS
BEGIN	
	SET NOCOUNT ON
	
	IF (@target = 'REPLICATED' AND @@SERVERNAME = 'DBCUST') RETURN	-- run at all replicated servers
	IF (@target = 'DBCUST' AND @@SERVERNAME <> 'DBCUST') RETURN -- run at DBCUST only
	
	IF dbo.f_CheckRepTable('Custinfo') = 0 
		OR dbo.f_CheckRepTable('Acc_CustDirect') = 0
		OR dbo.f_CheckRepTable('AgentCommRate') = 0
		RETURN		

	CREATE TABLE #Super_tmp (custid INT)
	
	INSERT INTO #Super_tmp
    SELECT custid
	FROM custInfo (NOLOCK)
	WHERE roleid = 4 AND custid <= @maxcustid AND custid NOT IN (SELECT custid FROM Dep_custSuper WITH (NOLOCK))
	
	UNION 
	-- Dummy Account
	SELECT custid
	FROM Acc_CustDirect (NOLOCK) 
	WHERE roleid IN (4,3,2) AND custid <= @maxcustid
	-- Direct Master
	UNION
	
	SELECT ci.custid
	FROM custInfo ci WITH (NOLOCK)
		INNER JOIN Acc_CustDirect cd WITH (NOLOCK)  ON ci.srecommend = cd.custid AND ci.roleid = 3
	WHERE NOT EXISTS (SELECT 1 FROM Acc_CustDirect cd1 WITH (NOLOCK) WHERE cd1.custid = ci.custid)	AND ci.custid <= @maxcustid
	
	-- Direct Agent
	UNION
	
	SELECT ci.custid
	FROM custInfo ci WITH (NOLOCK)
		INNER JOIN Acc_CustDirect cd WITH (NOLOCK)  ON ci.mrecommend = cd.custid AND ci.roleid = 2
	WHERE NOT EXISTS (SELECT 1 FROM Acc_CustDirect cd1 WITH (NOLOCK) WHERE cd1.custid = ci.custid) AND ci.custid <= @maxcustid	
	
	
	UPDATE A 
		SET CommRate = 0.10
	FROM AgentCommRate A WITH(ROWLOCK,UPDLOCK)
		INNER JOIN 	#Super_tmp B ON A.CustId = B.custid
	WHERE A.Sporttype = 204 AND Bettype = 18001

	UPDATE A 
		SET CommRate = 0.375000
	FROM AgentCommRate A WITH(ROWLOCK,UPDLOCK)
		INNER JOIN 	#Super_tmp B ON A.CustId = B.custid
	WHERE A.Sporttype = 204 AND Bettype = 18002

    DROP TABLE #Super_tmp
	   
END
GO
-- END STEP 1: DEPLOY THIS SP @ DBCUST.CustDB -------
------------------------------------------------------	
-- BEGIN STEP 2: RUN THIS SCRIPT AT ALL REPLICATED SERVERS (06/DBTP) -----
--------------------------------------------------------------------------------------
DECLARE @srecommend INT, @maxcustid int
SELECT @maxcustid=xxx   ---input maxcustid here

EXEC dbo.Acc_ExecRep_Cust_09
	   @target = 'REPLICATED'
	   , @maxcustid=@maxcustid
GO		
-- END STEP 2: RUN THIS SCRIPT AT ALL REPLICATED SERVERS (06/DBTP) -----
-----------------------------------------------------------------------------------

---
-- BEGIN STEP 3: RUN THIS SCRIPT AT DBCUST -----
-------------------------------------------------
DECLARE @srecommend INT, @maxcustid int
SELECT @maxcustid=xxx   ---input maxcustid here

EXEC dbo.Acc_ExecRep_Cust_09
	   @target = 'DBCUST'
	  , @maxcustid=@maxcustid
GO	

-- END STEP 3: RUN THIS SCRIPT AT DBCUST -------
-------------------------------------------------