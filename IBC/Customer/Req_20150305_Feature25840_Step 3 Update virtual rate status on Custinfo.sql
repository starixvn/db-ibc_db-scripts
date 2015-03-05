 /*
	Created: Johnson
	Date: 2015-03-05
	Task: Virtual Rate - Separate setting into sport types and bet types
	DB: DBTXN/CustDB
	
	Steps:
		RUN AT UM: Update virtual rate status on custinfo
			if VirtualMultiplier = 1 update VirtualMultiplier= 0--disabled
			else update VirtualMultiplier= 1
*/  

 -- BEGIN STEP 1: DEPLOY THIS SP @DBTRANS.CustDB ------
------------------------------------------------------
ALTER PROCEDURE [dbo].[Acc_ExecRep_Cust_09]
	@target		VARCHAR(20)=''
AS
BEGIN	 
	SET NOCOUNT ON;
	IF (@target = 'REPLICATED' AND @@SERVERNAME = 'DBTRANS') RETURN	-- run at all replicated servers
	IF (@target = 'DBTRANS' AND @@SERVERNAME <> 'DBTRANS') RETURN -- run at dbtrans only
		
		
	IF (SELECT COUNT(1)
		FROM sys.objects
		WHERE NAME IN ('CustInfo') AND type = 'U'
		) <> 1
	RETURN
	 
	UPDATE CustInfo WITH(UPDLOCK,ROWLOCK)
	SET VirtualMultiplier = CASE WHEN VirtualMultiplier = 1 THEN 0 ELSE 1 END
	WHERE custid <> 1176092 --member01 : testing account
		AND recommend <> 14228863 --STAFFTWPG
	
END
GO

-- END STEP 1: DEPLOY THIS SP @DBTRANS.CustDB --------
------------------------------------------------------	


---
---
-- BEGIN STEP 2: RUN THIS SCRIPT AT ALL REPLICATED SERVERS (DB052/053/053/054/06 -----) -----
--------------------------------------------------------------------------------------
 


	EXEC dbo.[Acc_ExecRep_Cust_09] @target = 'REPLICATED'
		
GO		
-- END STEP 2: RUN THIS SCRIPT AT ALL REPLICATED SERVERS (DB052/053/053/054/06 -----
-----------------------------------------------------------------------------------

---
---
-- BEGIN STEP 3: RUN THIS SCRIPT AT DBTRANS -----
--------------------------------------------------------------------------------------
 EXEC dbo.[Acc_ExecRep_Cust_09] @target = 'DBTRANS'
			
GO		

-- END STEP 3: RUN THIS SCRIPT AT DBTRANS -----
-----------------------------------------------------------------------------------
