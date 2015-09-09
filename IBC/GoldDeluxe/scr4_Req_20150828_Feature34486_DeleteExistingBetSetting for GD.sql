 /*
	Created: Johnson
	Date: 2015-08-28
	Task: Delete existing bet settings for GD
	DB: DBCUST/CustDB
 */
 
 
 -- BEGIN STEP 1: DEPLOY THIS SP @DBCUST.CustDB ------
------------------------------------------------------
 
  ALTER PROCEDURE [dbo].[Acc_CustSetting3rd_19]
	@target VARCHAR(20)
AS
BEGIN
	SET NOCOUNT ON
	
	IF (@target = 'REPLICATED' AND @@SERVERNAME = 'DBCUST') RETURN	-- run at all replicated servers
	IF (@target = 'DBCUST' AND @@SERVERNAME <> 'DBCUST') RETURN -- run at dbtrans only
	
	IF ( SELECT COUNT(1) FROM sys.objects WHERE NAME IN ('CustGameType')) <> 1
		RETURN
	
	DELETE cg
	FROM custGameType cg WITH(UPDLOCK,ROWLOCK)		
	WHERE GameTypeID IN (1701,1702)
END	
GO
-- END STEP 1: DEPLOY THIS SP @DBTRANS.CustDB --------
------------------------------------------------------	



---
---
-- BEGIN STEP 2: RUN THIS SCRIPT AT ALL REPLICATED SERVERS (06/DBTP) -----
--------------------------------------------------------------------------------------
EXEC dbo.[Acc_CustSetting3rd_19] 
		@target = 'REPLICATED'
	
GO		
-- END STEP 2: RUN THIS SCRIPT AT ALL REPLICATED SERVERS (06/DBTP) -----
-----------------------------------------------------------------------------------
 
 
---
---
-- BEGIN STEP 3: RUN THIS SCRIPT AT DBCUST -----
--------------------------------------------------------------------------------------

EXEC dbo.[Acc_CustSetting3rd_19]
		@target = 'DBCUST'
	
GO		
-- END STEP 3: RUN THIS SCRIPT AT DBCUST -----
-----------------------------------------------------------------------------------
  