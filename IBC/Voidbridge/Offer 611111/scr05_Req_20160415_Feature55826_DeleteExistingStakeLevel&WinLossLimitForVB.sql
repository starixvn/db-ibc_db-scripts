/*
	Created: Elodie
	Date: 20160225
	Task: Delete existing StakeLevelGroup and WinLossLimit settings
	DB: DBCust/CustDB
*/
 
 -- BEGIN STEP 1: DEPLOY THIS SP @DBCUST.CustDB ------
------------------------------------------------------
 
ALTER PROCEDURE [dbo].[Acc_DynamicCustSetting3rd_09]
	@target VARCHAR(20)
AS
BEGIN
	SET NOCOUNT ON
	
	IF (@target = 'REPLICATED' AND @@SERVERNAME = 'DBCUST') RETURN	-- run at all replicated servers
	IF (@target = 'DBCUST' AND @@SERVERNAME <> 'DBCUST') RETURN -- run at dbcust only
	
	IF dbo.f_CheckRepTable('CustStakeLevel_Agent') = 0 RETURN
	IF dbo.f_CheckRepTable('CustStakeLevel_Member') = 0 RETURN
	IF dbo.f_CheckRepTable('CustWinLossLimit_Agent') = 0 RETURN
	IF dbo.f_CheckRepTable('CustWinLossLimit_Member') = 0 RETURN	
	
	CREATE TABLE #supers (custid int)

	INSERT INTO #supers(custid)
	SELECT ci.custid
	FROM customer ci WITH (NOLOCK) 
	 INNER JOIN site s WITH (NOLOCK) ON ci.site = s.site
	 LEFT JOIN custsuper cs WITH (NOLOCK) ON ci.custid = cs.custid
	WHERE (ci.roleid = 4  
			 AND ci.username NOT LIKE '3rdSuper%'
			 AND cs.isinternal = 0
			 AND ci.custid NOT IN (SELECT custid FROM Dep_CustSuper WITH(NOLOCK))
			 AND s.islicensee = 0
			 AND ci.site IN ('611111'))
		OR ci.custid IN (5,42,13) --Dummy account
					
	DELETE cg
	FROM CustStakeLevel_Agent cg WITH(UPDLOCK,ROWLOCK)		
		INNER JOIN Customer c WITH (NOLOCK) ON cg.CustID = c.custid
		INNER JOIN #supers s ON c.srecommend = s.custid
	WHERE SportType = 212

	DELETE cg
	FROM CustStakeLevel_Member cg WITH(UPDLOCK,ROWLOCK)		
		INNER JOIN Customer c WITH (NOLOCK) ON cg.CustID = c.custid
		INNER JOIN #supers s ON c.srecommend = s.custid
	WHERE SportType = 212

	DELETE cg
	FROM CustWinLossLimit_Agent cg WITH(UPDLOCK,ROWLOCK)		
		INNER JOIN Customer c WITH (NOLOCK) ON cg.CustID = c.custid
		INNER JOIN #supers s ON c.srecommend = s.custid
	WHERE SportType = 212

	DELETE cg
	FROM CustWinLossLimit_Member cg WITH(UPDLOCK,ROWLOCK)		
		INNER JOIN Customer c WITH (NOLOCK) ON cg.CustID = c.custid
		INNER JOIN #supers s ON c.srecommend = s.custid
	WHERE SportType = 212
END	
GO
-- END STEP 1: DEPLOY THIS SP @DBCUST.CustDB --------
------------------------------------------------------	

-- BEGIN STEP 2: RUN THIS SCRIPT AT ALL REPLICATED SERVERS (06/DBTP) -----
--------------------------------------------------------------------------------------
EXEC dbo.Acc_DynamicCustSetting3rd_09 @target = 'REPLICATED'


-- BEGIN STEP 3: RUN THIS SCRIPT AT DBCUST -----
--------------------------------------------------------------------------------------
EXEC dbo.Acc_DynamicCustSetting3rd_09 @target = 'DBCUST'