/*
	Created: Dominic
	Date: 2015-10-15
	Task: Initialize PT/Bet Limit of Muay Thai in DCS structure (Before UM)
	DB: DBCust.CustDB
*/  
-- BEGIN STEP 1: DEPLOY THIS SP @DBCUST.CustDB ------
------------------------------------------------------
ALTER PROCEDURE Acc_DynamicCustSetting3rd_09
	@target VARCHAR(20)
AS
BEGIN   
	SET NOCOUNT ON
	
	IF (@target = 'REPLICATED' AND @@SERVERNAME = 'DBCUST') RETURN	-- run at all replicated servers
	IF (@target = 'DBCUST' AND @@SERVERNAME <> 'DBCUST') RETURN -- run at DBCUST only
	
	IF NOT (dbo.f_CheckRepTable('Custinfo') = 1 
	   AND dbo.f_CheckRepTable('CustBetSetting3rd_Member') = 1
	   AND dbo.f_CheckRepTable('CustBetSetting3rd_Agent') = 1
	   AND dbo.f_CheckRepTable('CustPTSetting3rd_Member') = 1
	   AND dbo.f_CheckRepTable('CustPTSetting3rd_Agent') = 1
	   AND dbo.f_CheckRepTable('CustPTGroupSetting3rd_Member') = 1
	   AND dbo.f_CheckRepTable('CustSettingMode3rd') = 1
	   )
	  RETURN


	DELETE cs
	FROM [dbo].CustPTSetting3rd_Agent cs WITH(UPDLOCK,ROWLOCK)
		INNER JOIN custinfo ci WITH(NOLOCK) ON cs.custid = ci.custid
	WHERE ci.roleid IN (2,3,4) AND ci.srecommend NOT IN (SELECT custid FROM Dep_CustSuper WITH(NOLOCK)) 
		AND  ci.Currency = 20
		
		
	DELETE cs
	FROM [dbo].CustPTSetting3rd_Member cs WITH(UPDLOCK,ROWLOCK)
		INNER JOIN custinfo ci WITH(NOLOCK) ON cs.custid = ci.custid
	WHERE ci.roleid = 1 AND ci.srecommend NOT IN (SELECT custid FROM Dep_CustSuper WITH(NOLOCK)) 
		AND  ci.Currency = 20
		
	DELETE cs
	FROM [dbo].CustPTGroupSetting3rd_Member cs WITH(UPDLOCK,ROWLOCK)
		INNER JOIN custinfo ci WITH(NOLOCK) ON cs.agentid = ci.custid
	WHERE ci.roleid = 2 AND ci.srecommend NOT IN (SELECT custid FROM Dep_CustSuper WITH(NOLOCK)) 
		AND  ci.Currency = 20
	
	DELETE cs
	FROM [dbo].CustBetSetting3rd_Agent cs WITH(UPDLOCK,ROWLOCK)
		INNER JOIN custinfo ci WITH(NOLOCK) ON cs.custid = ci.custid
	WHERE ci.roleid IN (2,3,4) AND ci.srecommend NOT IN (SELECT custid FROM Dep_CustSuper WITH(NOLOCK)) 
		AND  ci.Currency = 20
	
	DELETE cs
	FROM [dbo].CustBetSetting3rd_Member cs WITH(UPDLOCK,ROWLOCK)
		INNER JOIN custinfo ci WITH(NOLOCK) ON cs.custid = ci.custid
	WHERE ci.roleid = 1 AND ci.srecommend NOT IN (SELECT custid FROM Dep_CustSuper WITH(NOLOCK)) 
		AND  ci.Currency = 20

	DELETE cs
	FROM [dbo].CustSettingMode3rd cs WITH(UPDLOCK,ROWLOCK)
		INNER JOIN custinfo ci WITH(NOLOCK) ON cs.custid = ci.custid
	WHERE ci.roleid = 1 AND ci.srecommend NOT IN (SELECT custid FROM Dep_CustSuper WITH(NOLOCK)) 
		AND  ci.Currency = 20
END

-- BEGIN STEP 2: RUN THIS SCRIPT AT ALL REPLICATED SERVERS (06/DBTP) -----
--------------------------------------------------------------------------------------
EXEC dbo.Acc_DynamicCustSetting3rd_09 @target = 'REPLICATED'


-- BEGIN STEP 3: RUN THIS SCRIPT AT DBCUST -----
--------------------------------------------------------------------------------------
EXEC dbo.Acc_DynamicCustSetting3rd_09 @target = 'DBCUST'
