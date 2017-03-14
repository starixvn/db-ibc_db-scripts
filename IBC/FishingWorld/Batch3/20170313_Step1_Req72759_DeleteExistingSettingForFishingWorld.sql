/*
	Created: Winnie
	Date: 20170313
	Task: Delete existing Fishing world settings [RedmineID: #72759]
	DB: DBCust/CustDB
*/
 
 -- BEGIN STEP 1: DEPLOY THIS SP @DBCUST.CustDB ------
ALTER PROCEDURE [dbo].[Acc_DynamicCustSetting3rd_09]
	@target VARCHAR(20)
AS
BEGIN
	SET NOCOUNT ON
	
	IF (@target = 'REPLICATED' AND @@SERVERNAME = 'DBCUST') RETURN	-- run at all replicated servers
	IF (@target = 'DBCUST' AND @@SERVERNAME <> 'DBCUST') RETURN -- run at dbcust only
	
	IF dbo.f_CheckRepTable('CustPTSetting3rd_Agent') = 0 RETURN
	IF dbo.f_CheckRepTable('CustPTSetting3rd_Member') = 0 RETURN
	IF dbo.f_CheckRepTable('CustPTGroupSetting3rd_Member') = 0 RETURN
	IF dbo.f_CheckRepTable('CustWinLossLimit_Agent') = 0 RETURN
	IF dbo.f_CheckRepTable('CustWinLossLimit_Member') = 0 RETURN
	IF dbo.f_CheckRepTable('Customer') = 0 RETURN
	
	CREATE TABLE #supers (custid INT PRIMARY KEY, currency INT)
	INSERT INTO #supers(custid,currency)
	SELECT ci.custid, ci.currency
	FROM Customer ci WITH(NOLOCK)
	INNER JOIN custInfo c WITH(NOLOCK) ON ci.custid=c.custid
	WHERE (ci.roleid = 4 	
	AND ci.custid NOT IN (SELECT custid FROM Dep_CustSuper WITH(NOLOCK)) 
	AND c.Enabled=1	
	AND ci.site IN ('611111','722222','766666','789y', '7aa666', 'XYZbet', 'Best-odds'))
	-- CROSS-SITE	
	OR ci.custid IN (674248,395075,1164457,1016771,17721601,1016771,324561,1127269,938136)		
	
		
	DECLARE @sporttype INT
	SELECT @sporttype=219			
	DELETE cg
	FROM CustPTSetting3rd_Agent cg 
		INNER JOIN Customer C (NOLOCK) ON C.custid = CG.CustID 
		INNER JOIN #supers S ON S.custid = C.srecommend
	WHERE SportType = @sporttype 
						
	DELETE cg
	FROM CustPTSetting3rd_Member cg 
		INNER JOIN Customer C (NOLOCK) ON C.custid = CG.CustID 
		INNER JOIN #supers S ON S.custid = C.srecommend
	WHERE CG.SportType = @sporttype 
	
		
	DELETE cg
	FROM CustPTGroupSetting3rd_Member cg
		INNER JOIN Customer CI (NOLOCK) ON CI.custid = CG.AgentID 
		INNER JOIN #supers S ON S.custid = CI.srecommend
	WHERE CG.SportType = @sporttype 	

	
	DELETE cg
	FROM CustWinLossLimit_Agent cg 		
		INNER JOIN Customer C (NOLOCK) ON C.custid = CG.CustID 
		INNER JOIN #supers S ON S.custid = C.srecommend
	WHERE SportType = @sporttype 

	DELETE cg
	FROM CustWinLossLimit_Member cg 		
		INNER JOIN Customer C (NOLOCK) ON C.custid = CG.CustID 
		INNER JOIN #supers S ON S.custid = C.srecommend
	WHERE CG.SportType = @sporttype 	
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