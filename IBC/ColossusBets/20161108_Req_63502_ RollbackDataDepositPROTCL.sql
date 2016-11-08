/*
	Created: Winnie
	Date: 2016-11-08
	Task: colossus settings for deposit customers rollback TCL
	DB: DBCUST/CustDB
*/ 

------------------------------------------------------

ALTER PROCEDURE [dbo].[Acc_CustSetting3rd_19]
	@srecommend INT	
	,@target VARCHAR(30)	
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
	
		
	
	DELETE b
	FROM Dep_AgentCommRate b
	INNER JOIN custInfo a WITH(NOLOCK) ON b.custid=a.custid
	WHERE a.srecommend = @srecommend AND   a.roleid IN(2,3,4) AND Enabled=1 AND b.sporttype=204
	
	DELETE b
	FROM [Dep_CustCommRate] b
	INNER JOIN custInfo a WITH(NOLOCK) ON b.custid=a.custid
	WHERE a.srecommend = @srecommend AND   a.roleid =1 AND Enabled=1 AND b.sporttype=204

END
GO
-- END STEP 1: DEPLOY THIS SP @ DBCUST.CustDB -------
------------------------------------------------------
---
---
-- BEGIN STEP 2: RUN THIS SCRIPT AT ALL REPLICATED SERVERS (DB06/DBTP) -----
--------------------------------------------------------------------------------------

CREATE TABLE #supers (custid int, isfinished bit default(0))

DECLARE  @srecommend INT

INSERT INTO #supers(custid)
SELECT custid
FROM customer WITH(NOLOCK)
WHERE custid IN (SELECT custid FROM Dep_CustSuper WITH(NOLOCK))	
	AND site ='TCL'

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

DECLARE @srecommend INT

INSERT INTO #supers(custid)
SELECT custid
FROM customer WITH(NOLOCK)
WHERE custid IN (SELECT custid FROM Dep_CustSuper WITH(NOLOCK))
	AND site ='TLC'
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
-------------------------------------------------

