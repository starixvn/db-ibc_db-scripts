/*
	Created: Elodie
	Date: 2015-10-05
	Task: Copy Colossus Bet settings for credit customers - [Redmine: #41264]
	DB: DBCUST/CustDB
*/ 
--Step 1: add customer settings into AgentCommRate, CustCommRate
-- DEPLOY THIS SP @DBCUST.CustDB -----
------------------------------------------------------
ALTER PROCEDURE [dbo].[Acc_CustSetting3rd_19]
	@srecommend INT	
	,@maxcustid INT
	,@target VARCHAR(20)
AS
BEGIN	
	SET NOCOUNT ON
	IF (@target = 'REPLICATED' AND @@SERVERNAME = 'DBCUST') RETURN	-- run at all replicated servers
	IF (@target = 'DBCUST' AND @@SERVERNAME <> 'DBCUST') RETURN -- run at DBCUST only
	
	IF NOT (dbo.f_CheckRepTable('AgentCommRate') = 1 
			AND dbo.f_CheckRepTable('CustCommRate') = 1
			)
		RETURN		
		
	INSERT INTO dbo.AgentCommRate WITH (ROWLOCK) (CustID,SportType,BetType,CommRate) 
	SELECT custid,204,18001,0 FROM CustInfo WITH (NOLOCK) WHERE srecommend = @srecommend and roleid IN (2,3,4) AND custid <= @maxcustid
	UNION ALL 
	SELECT custid,204,18002,0 FROM CustInfo WITH (NOLOCK) WHERE srecommend = @srecommend and roleid IN (2,3,4) AND custid <= @maxcustid

	INSERT INTO dbo.CustCommRate WITH (ROWLOCK) (CustID,SportType,BetType,sdiscount,adiscount,discount,playerdiscount) 
	SELECT custid,204,18001,0,0,0,0 FROM CustInfo WITH (NOLOCK) WHERE srecommend = @srecommend and roleid = 1 AND custid <= @maxcustid
	UNION ALL 
	SELECT custid,204,18002,0,0,0,0 FROM CustInfo WITH (NOLOCK) WHERE srecommend = @srecommend and roleid = 1 AND custid <= @maxcustid
		
END
GO
-- END STEP 1: DEPLOY THIS SP @ DBCUST.CustDB -------
------------------------------------------------------
---
---
-- BEGIN STEP 2: RUN THIS SCRIPT AT ALL REPLICATED SERVERS (DB06/DBTP) -----
--------------------------------------------------------------------------------------
 
CREATE TABLE #supers (custid int, isfinished bit default(0))

DECLARE @max_custid INT, @srecommend INT

SELECT @max_custid= xx

INSERT INTO #supers(custid)
SELECT custid
FROM custinfo WITH(NOLOCK)
WHERE custid NOT IN (SELECT custid FROM Dep_CustSuper WITH(NOLOCK))
	AND roleid = 4
	AND custid <= @max_custid


WHILE (1 = 1)
BEGIN
	UPDATE TOP (1) #Supers
	SET isfinished = 1
		,@srecommend = custid			
	WHERE isfinished = 0
	
	IF @@ROWCOUNT = 0 BREAK

	EXEC dbo.[Acc_CustSetting3rd_19] @srecommend = @srecommend
			,@maxcustid = @max_custid
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

DECLARE @max_custid INT, @srecommend INT

SELECT @max_custid= xx

INSERT INTO #supers(custid)
SELECT custid
FROM custinfo WITH(NOLOCK)
WHERE custid NOT IN (SELECT custid FROM Dep_CustSuper WITH(NOLOCK))
	AND roleid = 4
	AND custid <= @max_custid


WHILE (1 = 1)
BEGIN
	UPDATE TOP (1) #Supers
	SET isfinished = 1
		,@srecommend = custid			
	WHERE isfinished = 0
	
	IF @@ROWCOUNT = 0 BREAK

	EXEC dbo.[Acc_CustSetting3rd_19] @srecommend = @srecommend
			,@maxcustid = @max_custid
			,@target = 'DBCUST'
	
	WAITFOR DELAY '00:00:00.280'			
END			
GO		
-- END STEP 3: RUN THIS SCRIPT AT DBCUST -----
-------------------------------------------------