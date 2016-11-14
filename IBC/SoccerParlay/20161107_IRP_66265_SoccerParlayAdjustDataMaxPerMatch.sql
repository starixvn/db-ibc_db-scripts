
/*
	Created by: Winnie
	Date: 2016-11-07
	Task:  Adjust data MaxPerMatch for Parlay Soccer credit customer[Redmine:#66265]
*/ 
ALTER PROCEDURE [dbo].Acc_CustomerInfo_Execrep_09
	@srecommend INT	
	,@target VARCHAR(30)	
AS
BEGIN	
	SET NOCOUNT ON
	
	IF (@target = 'REPLICATED' AND @@SERVERNAME = 'DBCUST') RETURN	-- run at all replicated servers
	IF (@target = 'DBCUST' AND @@SERVERNAME <> 'DBCUST') RETURN -- run at DBCUST only
	
	IF NOT (dbo.f_CheckRepTable('Custinfo') = 1 			
			)
		RETURN		
	UPDATE custInfo WITH(UPDLOCK,ROWLOCK)
	SET MaxPerMatch1MP=Maxpermatch
	WHERE srecommend=@srecommend AND MaxPerMatch1MP<>Maxpermatch
END
GO
-- END STEP 1: DEPLOY THIS SP @ DBCUST.CustDB -------
------------------------------------------------------
---
---
-- BEGIN STEP 2: RUN THIS SCRIPT AT ALL REPLICATED SERVERS (DB06/DBTP/DB05x) -----
--------------------------------------------------------------------------------------

CREATE TABLE #supers (custid int, isfinished bit default(0))

DECLARE @srecommend INT

INSERT INTO #supers(custid)
SELECT custid
FROM customer WITH(NOLOCK)
WHERE custid NOT IN (SELECT custid FROM Dep_CustSuper WITH(NOLOCK))
	AND roleid = 4

WHILE (1 = 1)
BEGIN
	UPDATE TOP (1) #Supers
	SET isfinished = 1
		,@srecommend = custid			
	WHERE isfinished = 0
	
	IF @@ROWCOUNT = 0 BREAK

	EXEC dbo.Acc_CustomerInfo_Execrep_09 @srecommend = @srecommend			
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
FROM customer WITH(NOLOCK)
WHERE custid NOT IN (SELECT custid FROM Dep_CustSuper WITH(NOLOCK))
	AND roleid = 4

WHILE (1 = 1)
BEGIN
	UPDATE TOP (1) #Supers
	SET isfinished = 1
		,@srecommend = custid			
	WHERE isfinished = 0
	
	IF @@ROWCOUNT = 0 BREAK

	EXEC dbo.Acc_CustomerInfo_Execrep_09 @srecommend = @srecommend			
			,@target = 'DBCUST'			
	WAITFOR DELAY '00:00:00.280'			
END			
GO		
