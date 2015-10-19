/*
	Created: Elodie
	Date: 2015-10-19
	Task: delete existing Muay Thai settings for Deposit
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
		
	IF NOT (dbo.f_CheckRepTable('Custinfo') = 1 
			AND dbo.f_CheckRepTable('Dep_CustSetting') = 1
			)
		RETURN		
	
	DELETE cs
	FROM Dep_CustSetting cs WITH(UPDLOCK,ROWLOCK)
		INNER JOIN custinfo ci WITH(NOLOCK) ON cs.custid = ci.custid
	WHERE cs.sporttype = 44 and bettype = 3
		AND ci.srecommend IN (SELECT custid FROM Dep_CustSuper WITH(NOLOCK))
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