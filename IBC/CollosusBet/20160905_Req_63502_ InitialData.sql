/*
	Created: Winnie
	Date: 2016-09-05
	Task: Insert colossus settings for deposit customers
	DB: DBCUST/CustDB
*/ 

------------------------------------------------------

ALTER PROCEDURE [dbo].[Acc_CustSetting3rd_19]
	@srecommend INT	
	,@target VARCHAR(30)
	,@maxcustid INT
AS
BEGIN	
	SET NOCOUNT ON
	
	IF (@target = 'REPLICATED' AND @@SERVERNAME = 'DBCUST') RETURN	-- run at all replicated servers
	IF (@target = 'DBCUST' AND @@SERVERNAME <> 'DBCUST') RETURN -- run at DBCUST only
	
	IF NOT (dbo.f_CheckRepTable('Custinfo') = 1 
			AND dbo.f_CheckRepTable('DEP_AgentCommRate') = 1
			AND dbo.f_CheckRepTable('DEP_CustCommRate') = 1
			)
		RETURN		
	
		
	INSERT INTO DEP_AgentCommRate 
			   ([CustID]
			   ,[SportType]
			   ,[BetType]
			   ,[CommRate])
	SELECT DISTINCT custid,204,18001,0.1215 FROM custInfo a WITH(NOLOCK) 
	WHERE a.srecommend = @srecommend AND  a.custid <= @maxcustid AND a.roleid IN(2,3,4)
	AND NOT EXISTS (SELECT TOP 1 1 FROM DEP_AgentCommRate b WHERE a.custid=b.CustID AND b.SportType=204 AND b.BetType=18001 )
	UNION ALL
	SELECT DISTINCT custid,204,18002,0.45 FROM custInfo a WITH(NOLOCK) 
	WHERE a.srecommend = @srecommend AND  a.custid <= @maxcustid AND a.roleid IN(2,3,4)
	AND NOT EXISTS (SELECT TOP 1 1 FROM DEP_AgentCommRate b WHERE a.custid=b.CustID AND b.SportType=204 AND b.BetType=18002 )


	INSERT INTO [DEP_CustCommRate]
			   ([CustId]
			   ,[Sporttype]
			   ,[Bettype]
			   ,[sdiscount]
			   ,[adiscount]
			   ,[discount]
			   ,[playerdiscount])    
	SELECT DISTINCT a.custid,204,18001,0.1215,0.1215,0.1215,0 FROM custInfo a WITH(NOLOCK) 
	 WHERE srecommend = @srecommend AND  custid <= @maxcustid AND a.roleid =1
	AND NOT EXISTS (SELECT TOP 1 1 FROM [DEP_CustCommRate] b WHERE a.custid=b.CustID AND b.SportType=204 AND b.BetType=18001 )
	UNION ALL
	SELECT DISTINCT a.custid,204,18002,0.45,0.45,0.45,0 FROM custInfo a WITH(NOLOCK) 
	 WHERE srecommend = @srecommend AND  custid <= @maxcustid AND a.roleid =1
	AND NOT EXISTS (SELECT TOP 1 1 FROM [DEP_CustCommRate] b WHERE a.custid=b.CustID AND b.SportType=204 AND b.BetType=18002 )		
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
FROM customer WITH(NOLOCK)
WHERE custid IN (SELECT custid FROM Dep_CustSuper WITH(NOLOCK))
	AND custid <= @max_custid	
	AND site in ('spondemo','12bet')

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
FROM customer WITH(NOLOCK)
WHERE custid IN (SELECT custid FROM Dep_CustSuper WITH(NOLOCK))
	AND custid <= @max_custid	
	AND site in ('spondemo','12bet')

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

