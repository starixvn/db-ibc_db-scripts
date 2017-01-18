/*
	Created: Johnson
	Date: 2017-01-17
	Task: update hideGoldDeluxe = 0
	DBCust/CustDB
*/


 ALTER PROCEDURE [dbo].[Acc_ExecRep_Cust_09]
	@srecommend INT		
	,@DisableGoldDeluxe BIT
	,@target VARCHAR(20)
AS
BEGIN
	SET NOCOUNT ON
	
	IF (@target = 'REPLICATED' AND @@SERVERNAME = 'DBCUST') RETURN	-- run at all replicated servers
	IF (@target = 'DBCUST' AND @@SERVERNAME <> 'DBCUST') RETURN -- run at dbtrans only
	
	IF NOT (dbo.f_CheckRepTable('Custinfo') = 1 )
		RETURN
		
	UPDATE custinfo WITH(UPDLOCK,ROWLOCK)
	SET HideGoldDeluxe = CASE WHEN syncLiveCasino = 1 THEN 0 ELSE 1 END,
		DisableGoldDeluxe = CASE WHEN syncLiveCasino = 1 AND roleid IN (2,3,4) THEN @DisableGoldDeluxe ELSE 1 END
	WHERE srecommend = @srecommend	
		AND enabled = 1
END	
GO
-- END STEP 1: DEPLOY THIS SP @DBCUST.CustDB --------
------------------------------------------------------	


---
---
-- BEGIN STEP 2: RUN THIS SCRIPT AT ALL REPLICATED SERVERS (052/053/054/06/DBTP) -----
--------------------------------------------------------------------------------------
CREATE TABLE #supers (custid int, DisableGoldDeluxe BIT, isfinished bit default(0))
DECLARE @srecommend INT, @DisableGoldDeluxe BIT

--disable supers list
INSERT INTO #supers(custid, DisableGoldDeluxe)
SELECT ci.custid, 0
FROM Customer ci WITH(NOLOCK)
WHERE site = '789y'
	AND roleid =4 
	
WHILE (1 = 1)
BEGIN
	UPDATE TOP (1) #Supers
	SET isfinished = 1
		,@srecommend = custid
		,@DisableGoldDeluxe = DisableGoldDeluxe		
	WHERE isfinished = 0
	
	IF @@ROWCOUNT = 0 BREAK

	EXEC dbo.[Acc_ExecRep_Cust_09] @srecommend = @srecommend
			,@DisableGoldDeluxe = @DisableGoldDeluxe
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
CREATE TABLE #supers (custid int, DisableGoldDeluxe BIT, isfinished bit default(0))
DECLARE @srecommend INT, @DisableGoldDeluxe BIT

--disable supers list
INSERT INTO #supers(custid, DisableGoldDeluxe)
SELECT ci.custid, 0
FROM Customer ci WITH(NOLOCK)
WHERE site = '789y'
	AND roleid =4 
	
WHILE (1 = 1)
BEGIN
	UPDATE TOP (1) #Supers
	SET isfinished = 1
		,@srecommend = custid
		,@DisableGoldDeluxe = DisableGoldDeluxe		
	WHERE isfinished = 0
	
	IF @@ROWCOUNT = 0 BREAK

	EXEC dbo.[Acc_ExecRep_Cust_09] @srecommend = @srecommend	
			,@DisableGoldDeluxe = @DisableGoldDeluxe
			,@target = 'DBCUST'
	
	waitfor delay '00:00:0.280'
END			
GO	
-- END STEP 3: RUN THIS SCRIPT AT DBCUST -----
-----------------------------------------------------------------------------------

	
	
