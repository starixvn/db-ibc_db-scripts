/*
	Created: Winnie
	Date: 2016-09-13
	Task: Insert colossus settings for credit customers
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
			AND dbo.f_CheckRepTable('AgentCommRate') = 1
			AND dbo.f_CheckRepTable('CustCommRate') = 1
			)
		RETURN		
	
		
	INSERT INTO AgentCommRate 
			   ([CustID]
			   ,[SportType]
			   ,[BetType]
			   ,[CommRate])
	SELECT  custid,204,18001,0.045 FROM custInfo a WITH(NOLOCK) 
	WHERE a.srecommend = @srecommend AND  a.custid <= @maxcustid AND a.roleid =3 AND Enabled=1

	UNION ALL
	SELECT  custid,204,18002,0.14 FROM custInfo a WITH(NOLOCK) 
	WHERE a.srecommend = @srecommend AND  a.custid <= @maxcustid AND a.roleid =3 AND Enabled=1

			
	INSERT INTO AgentCommRate 
			   ([CustID]
			   ,[SportType]
			   ,[BetType]
			   ,[CommRate])
	SELECT  custid,204,18001,0.02 FROM custInfo a WITH(NOLOCK) 
	WHERE a.srecommend = @srecommend AND  a.custid <= @maxcustid AND a.roleid =2 AND Enabled=1

	UNION ALL
	SELECT  custid,204,18002,0.08 FROM custInfo a WITH(NOLOCK) 
	WHERE a.srecommend = @srecommend AND  a.custid <= @maxcustid AND a.roleid =2 AND Enabled=1
	
				
	INSERT INTO AgentCommRate 
			   ([CustID]
			   ,[SportType]
			   ,[BetType]
			   ,[CommRate])
	SELECT  custid,204,18001,0.06075 FROM custInfo a WITH(NOLOCK) 
	WHERE a.custid = @srecommend AND  a.custid <= @maxcustid AND Enabled=1

	UNION ALL
	SELECT  custid,204,18002,0.225 FROM custInfo a WITH(NOLOCK) 
	WHERE a.custid = @srecommend AND  a.custid <= @maxcustid  AND Enabled=1

	INSERT INTO [CustCommRate]
			   ([CustId]
			   ,[Sporttype]
			   ,[Bettype]
			   ,[sdiscount]
			   ,[adiscount]
			   ,[discount]
			   ,[playerdiscount])    
	SELECT  a.custid,204,18001,0.06075,0.045,0.02,0 FROM custInfo a WITH(NOLOCK) 
	 WHERE srecommend = @srecommend AND  custid <= @maxcustid AND a.roleid =1	AND Enabled=1
	UNION ALL
	SELECT  a.custid,204,18002,0.225,0.14,0.08,0 FROM custInfo a WITH(NOLOCK) 
	 WHERE srecommend = @srecommend AND  custid <= @maxcustid AND a.roleid =1	AND Enabled=1
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
WHERE custid NOT IN (SELECT custid FROM Dep_CustSuper WITH(NOLOCK))
	AND roleid = 4 AND currency=20

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
WHERE custid NOT IN (SELECT custid FROM Dep_CustSuper WITH(NOLOCK))
	AND roleid = 4 AND currency=20

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

