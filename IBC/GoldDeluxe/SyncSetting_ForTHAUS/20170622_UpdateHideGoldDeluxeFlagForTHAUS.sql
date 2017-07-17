/*
	Created: 20170622@Johnson
	Task : Update HideGoldDeluxe=0 for THAUS headline
	DB:  DBCUST/CustDB
*/

---Update HideGoldDeluxe flag off to show GD
 ALTER PROCEDURE [dbo].[Acc_ExecRep_Cust_09]
	@srecommend INT			
	,@target VARCHAR(20)
AS
BEGIN
	SET NOCOUNT ON
	
	IF (@target = 'REPLICATED' AND @@SERVERNAME = 'DBCUST') RETURN	-- run at all replicated servers
	IF (@target = 'DBCUST' AND @@SERVERNAME <> 'DBCUST') RETURN -- run at dbtrans only
	
	IF NOT (dbo.f_CheckRepTable('Custinfo') = 1 )
		RETURN
		
	UPDATE custinfo WITH(UPDLOCK,ROWLOCK)
	SET HideGoldDeluxe = 0		
	WHERE srecommend = @srecommend	
		AND enabled = 1
		AND HideGoldDeluxe = 1
END	
GO
-- END STEP 1: DEPLOY THIS SP @DBCUST.CustDB --------
------------------------------------------------------	


---
---
-- BEGIN STEP 2: RUN THIS SCRIPT AT ALL REPLICATED SERVERS (052/053/054/06/DBTP) -----
--------------------------------------------------------------------------------------
DECLARE @srecommend INT

SELECT ca.custid 
INTO #super
FROM custAccount ca with (Nolock)
	INNER JOIN custInfo ci with (Nolock) on ci.custid = ca.custid
WHERE groupID = 515 AND roleid = 4

SELECT DISTINCT s.custid, 0 AS IsFinished
INTO #UnSyncSuper
FROM custInfo ci WITH (NOLOCK) 
	INNER JOIN #super s ON ci.srecommend = s.custid
WHERE ci.HideGoldDeluxe = 1

	
WHILE (1 = 1)
BEGIN
	UPDATE TOP (1) #UnSyncSuper
	SET isfinished = 1
		,@srecommend = custid			
	WHERE isfinished = 0
	
	IF @@ROWCOUNT = 0 BREAK

	EXEC dbo.[Acc_ExecRep_Cust_09] @srecommend = @srecommend			
			,@target = 'REPLICATED'
	
	waitfor delay '00:00:0.280'
END			
GO	
-- END STEP 2: RUN THIS SCRIPT AT ALL REPLICATED SERVERS (052/053/054/06/DBTP) -----
-----------------------------------------------------------------------------------	

---
---
-- BEGIN STEP 3: RUN THIS SCRIPT AT DBCUST -----
--------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------	
DECLARE @srecommend INT

SELECT ca.custid 
INTO #super
FROM custAccount ca with (Nolock)
	INNER JOIN custInfo ci with (Nolock) on ci.custid = ca.custid
WHERE groupID = 515 AND roleid = 4

SELECT DISTINCT s.custid, 0 AS IsFinished
INTO #UnSyncSuper
FROM custInfo ci WITH (NOLOCK) 
	INNER JOIN #super s ON ci.srecommend = s.custid
WHERE ci.HideGoldDeluxe = 1

	
WHILE (1 = 1)
BEGIN
	UPDATE TOP (1) #UnSyncSuper
	SET isfinished = 1
		,@srecommend = custid			
	WHERE isfinished = 0
	
	IF @@ROWCOUNT = 0 BREAK

	EXEC dbo.[Acc_ExecRep_Cust_09] @srecommend = @srecommend			
			,@target = 'DBCUST'
	
	waitfor delay '00:00:0.280'
END			
GO	
-- END STEP 3: RUN THIS SCRIPT AT DBCUST -----
-----------------------------------------------------------------------------------

	
	