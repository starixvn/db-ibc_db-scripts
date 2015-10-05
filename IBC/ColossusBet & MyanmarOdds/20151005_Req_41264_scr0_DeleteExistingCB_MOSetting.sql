﻿﻿/*
	Created: Elodie
	Date: 2015-10-05
	Task: delete existing Colossus Bet and Myanmar Odds settings
	DB: DBCUST/CustDB
*/  

--STEP 1: DEPLOY THIS SP @ DBCUST.CustDB -----
------------------------------------------------------
ALTER PROCEDURE [dbo].[Acc_CustSetting3rd_19]	
	@target VARCHAR(20)
AS
BEGIN	
	SET NOCOUNT ON
	IF (@target = 'REPLICATED' AND @@SERVERNAME = 'DBCUST') RETURN	-- run at all replicated servers
	IF (@target = 'DBCUST' AND @@SERVERNAME <> 'DBCUST') RETURN -- run at DBCUST only
		
	if NOT(dbo.f_CheckRepTable('AgentCommRate') = 1 
		  AND dbo.f_CheckRepTable('CustCommRate') = 1)
		RETURN

	DELETE FROM AgentCommRate WITH(UPDLOCK,ROWLOCK)		

	DELETE FROM CustCommRate WITH(UPDLOCK,ROWLOCK)	
END
GO
-- END STEP 1: DEPLOY THIS SP @ DBCUST.CustDB -------
------------------------------------------------------	


---
---
-- BEGIN STEP 2: RUN THIS SCRIPT AT ALL REPLICATED SERVERS (06/DBTP) -----
--------------------------------------------------------------------------------------

EXEC dbo.[Acc_CustSetting3rd_19] @target = 'REPLICATED' 	
GO			

-- END STEP 2: RUN THIS SCRIPT AT ALL REPLICATED SERVERS (06/DBTP) -----
-----------------------------------------------------------------------------------

---
-- BEGIN STEP 3: RUN THIS SCRIPT AT DBCUST -----
-------------------------------------------------
EXEC dbo.[Acc_CustSetting3rd_19] @target = 'DBCUST' 	
GO

--END STEP 3