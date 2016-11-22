/*
	Created: Winnie
	Date: 2016-11-18
	Task: Delete VR settings UAT for Cricket
	DB: DBCUST/CustDB
*/ 

------------------------------------------------------

ALTER PROCEDURE [dbo].[Acc_CustSetting3rd_19]	
	@target VARCHAR(30)
AS
BEGIN	
	SET NOCOUNT ON
	
	IF (@target = 'REPLICATED' AND @@SERVERNAME = 'DBCUST') RETURN	-- run at all replicated servers
	IF (@target = 'DBCUST' AND @@SERVERNAME <> 'DBCUST') RETURN -- run at DBCUST only
	
	IF NOT (dbo.f_CheckRepTable('Custinfo') = 1 
			AND dbo.f_CheckRepTable('CustVirtualSetting') = 1
			AND dbo.f_CheckRepTable('ProfileVirtualSetting') = 1
			)
		RETURN
		
	DELETE FROM CustVirtualSetting WITH(ROWLOCK) WHERE seqNo=3
	
END
GO
-- END STEP 1: DEPLOY THIS SP @ DBCUST.CustDB -------
------------------------------------------------------
---
---
-- BEGIN STEP 2: RUN THIS SCRIPT AT ALL REPLICATED SERVERS (DB06/DBTP) -----
--------------------------------------------------------------------------------------



	EXEC dbo.[Acc_CustSetting3rd_19] 		
			@target = 'REPLICATED'	
GO		
-- END STEP 2: RUN THIS SCRIPT AT ALL REPLICATED SERVERS (DB06/DBTP) -----
-----------------------------------------------------------------------------------

---
-- BEGIN STEP 3: RUN THIS SCRIPT AT DBCUST -----
-------------------------------------------------

	EXEC dbo.[Acc_CustSetting3rd_19]		
			@target = 'DBCUST'
	
-- END STEP 3: RUN THIS SCRIPT AT DBCUST -----
-------------------------------------------------

