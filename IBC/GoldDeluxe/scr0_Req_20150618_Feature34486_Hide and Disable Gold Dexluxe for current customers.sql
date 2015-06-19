/*
	Created: Johnson
	Task: Update hide & disable Gold Deluxe for current customers
	DB: DBTXN/CustDB
	Date: 20150618
*/ 

ALTER PROCEDURE [dbo].[Acc_ExecRep_Cust_09]
	@maxcustid INT
	,@target VARCHAR(20)
AS
BEGIN
	SET NOCOUNT ON
	
	IF (@target = 'REPLICATED' AND @@SERVERNAME = 'DBTRANS') RETURN	-- run at all replicated servers
	IF (@target = 'DBTRANS' AND @@SERVERNAME <> 'DBTRANS') RETURN -- run at dbtrans only
	
	IF ( SELECT COUNT(1) FROM sys.objects WHERE NAME IN ('Custinfo')) <> 1
		RETURN
		
	--update status for Gold Deluxe
	UPDATE CustInfo WITH(UPDLOCK,ROWLOCK)
	SET DisableGoldDeluxe = 1,
		HideGoldDeluxe = 1
	WHERE (HideGoldDeluxe = 0 OR DisableGoldDeluxe = 0 )
		AND currency <> 20
		AND custid <= @maxcustid
END
GO

-- END STEP 1: DEPLOY THIS SP @DBTRANS.CustDB --------
------------------------------------------------------	



---
---
-- BEGIN STEP 2: RUN THIS SCRIPT AT ALL REPLICATED SERVERS (DB052/053/054/06/DBTP) -----
--------------------------------------------------------------------------------------
DECLARE @max_custid INT

SELECT @max_custid = xx

EXEC dbo.[Acc_ExecRep_Cust_09]@maxcustid = @max_custid
		,@target = 'REPLICATED'
		
GO		
-- END STEP 2: RUN THIS SCRIPT AT ALL REPLICATED SERVERS (DB052/053/053/054/06 -----
-----------------------------------------------------------------------------------
 
 
 
---
---
-- BEGIN STEP 3: RUN THIS SCRIPT AT DBTRANS -----
--------------------------------------------------------------------------------------
DECLARE @max_custid INT

SELECT @max_custid = xx

EXEC dbo.[Acc_ExecRep_Cust_09] @maxcustid = @max_custid
		,@target = 'DBTRANS'
		
GO		

-- END STEP 3: RUN THIS SCRIPT AT DBTRANS -----
-----------------------------------------------------------------------------------
 				