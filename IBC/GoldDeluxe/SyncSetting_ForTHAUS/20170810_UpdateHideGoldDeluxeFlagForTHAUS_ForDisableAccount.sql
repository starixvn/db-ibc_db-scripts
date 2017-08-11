/*
	Created: 20170810@Helen
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
	IF (@target = 'DBCUST' AND @@SERVERNAME <> 'DBCUST') RETURN -- run at dbcust only
	
	IF NOT (dbo.f_CheckRepTable('Custinfo') = 1 )
		RETURN
		
	UPDATE custinfo WITH(UPDLOCK,ROWLOCK)
		SET HideGoldDeluxe = 0		
	WHERE srecommend = @srecommend	
		AND enabled = 0
		AND HideGoldDeluxe = 1
END	
GO
-- END STEP 1: DEPLOY THIS SP @DBCUST.CustDB --------
------------------------------------------------------	

-- BEGIN STEP 2: RUN THIS SCRIPT AT ALL REPLICATED SERVERS (052/053/054/06/DBTP) -----
--------------------------------------------------------------------------------------
DECLARE @srecommend INT

CREATE TABLE #UnSyncSuper (custid INT, isfinished BIT DEFAULT(0))

SELECT ca.custid 
INTO #super
FROM custAccount ca WITH (NOLOCK)
	INNER JOIN custInfo ci WITH (NOLOCK) ON ci.custid = ca.custid
WHERE groupID = 515 AND roleid = 4

INSERT INTO #UnSyncSuper (custid)
SELECT DISTINCT s.custid
FROM custInfo ci WITH (NOLOCK) 
	INNER JOIN #super s ON ci.srecommend = s.custid
WHERE ci.HideGoldDeluxe = 1

-- For deployer info
DECLARE @super_cnt INT, @index INT = 0

SET @super_cnt = (SELECT COUNT(*) FROM #UnSyncSuper )

DECLARE @msg NVARCHAR(200) = 'Currently at order %d, SuperID: %d.'

DECLARE @msg_total NVARCHAR(200) = 'Total of supers: %d.'

RAISERROR (@msg_total, 0, 1, @super_cnt) WITH NOWAIT

WHILE (1 = 1)
BEGIN
	UPDATE TOP (1) #UnSyncSuper
	SET isfinished = 1
		,@srecommend = custid			
	WHERE isfinished = 0
	
	IF @@ROWCOUNT = 0 BREAK
	
	SET @index = @index + 1
	
	RAISERROR (@msg, 0, 1,@index, @srecommend) WITH NOWAIT


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
FROM custAccount ca WITH (NOLOCK)
	INNER JOIN custInfo ci WITH (NOLOCK) ON ci.custid = ca.custid
WHERE groupID = 515 AND roleid = 4

CREATE TABLE #UnSyncSuper (custid INT, isfinished BIT DEFAULT(0))

INSERT INTO #UnSyncSuper (custid)
SELECT DISTINCT s.custid
FROM custInfo ci WITH (NOLOCK) 
	INNER JOIN #super s ON ci.srecommend = s.custid
WHERE ci.HideGoldDeluxe = 1

-- For deployer info
DECLARE @super_cnt INT, @index INT = 0

SET @super_cnt = (SELECT COUNT(*) FROM #UnSyncSuper )

DECLARE @msg NVARCHAR(200) = 'Currently at order %d, SuperID: %d.'

DECLARE @msg_total NVARCHAR(200) = 'Total of supers: %d.'

RAISERROR (@msg_total, 0, 1, @super_cnt) WITH NOWAIT

	
WHILE (1 = 1)
BEGIN
	UPDATE TOP (1) #UnSyncSuper
	SET isfinished = 1
		,@srecommend = custid			
	WHERE isfinished = 0
	
	IF @@ROWCOUNT = 0 BREAK
	
	SET @index = @index + 1
	
	RAISERROR (@msg, 0, 1,@index, @srecommend) WITH NOWAIT
	
	EXEC dbo.[Acc_ExecRep_Cust_09] @srecommend = @srecommend			
			,@target = 'DBCUST'
	
	waitfor delay '00:00:0.280'
END			
GO	
-- END STEP 3: RUN THIS SCRIPT AT DBCUST -----
-----------------------------------------------------------------------------------

	
	