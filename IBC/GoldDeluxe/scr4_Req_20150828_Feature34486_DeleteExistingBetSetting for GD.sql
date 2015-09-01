 /*
	Created: Johnson
	Date: 2015-08-28
	Task: Delete existing bet settings for GD
	DB: DBCUST/CustDB
 */
 
 
 -- BEGIN STEP 1: DEPLOY THIS SP @DBCUST.CustDB ------
------------------------------------------------------
 
  ALTER PROCEDURE [dbo].[Acc_CustSetting3rd_19]
	@maxcustid INT
	,@target VARCHAR(20)
AS
BEGIN
	SET NOCOUNT ON
	
	IF (@target = 'REPLICATED' AND @@SERVERNAME = 'DBCUST') RETURN	-- run at all replicated servers
	IF (@target = 'DBCUST' AND @@SERVERNAME <> 'DBCUST') RETURN -- run at dbtrans only
	
	IF ( SELECT COUNT(1) FROM sys.objects WHERE NAME IN ('Custinfo','CustGameType')) <> 2
		RETURN
	
	DELETE cg
	FROM custGameType cg WITH(UPDLOCK,ROWLOCK)		
	WHERE custid <= @maxcustid		
		AND GameTypeID IN (1701,1702)
END	
GO
-- END STEP 1: DEPLOY THIS SP @DBTRANS.CustDB --------
------------------------------------------------------	



---
---
-- BEGIN STEP 2: RUN THIS SCRIPT AT ALL REPLICATED SERVERS (06/DBTP) -----
--------------------------------------------------------------------------------------
DECLARE @max_custid INT

SELECT @max_custid = xx

EXEC dbo.[Acc_CustSetting3rd_19] @maxcustid = @max_custid
		,@target = 'REPLICATED'
	
GO		
-- END STEP 2: RUN THIS SCRIPT AT ALL REPLICATED SERVERS (06/DBTP) -----
-----------------------------------------------------------------------------------
 
 
---
---
-- BEGIN STEP 3: RUN THIS SCRIPT AT DBCUST -----
--------------------------------------------------------------------------------------
DECLARE @max_custid INT

SELECT @max_custid = xx


EXEC dbo.[Acc_CustSetting3rd_19] @maxcustid = @max_custid
		,@target = 'DBCUST'
	
GO		
-- END STEP 3: RUN THIS SCRIPT AT DBCUST -----
-----------------------------------------------------------------------------------
  