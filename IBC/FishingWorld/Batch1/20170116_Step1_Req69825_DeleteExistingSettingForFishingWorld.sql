/*
	Created: Winnie
	Date: 20170116
	Task: Delete existing Fishing world settings [RedmineID: #69825]
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
	
	CREATE TABLE #supers (custid INT PRIMARY KEY, currency INT)
	INSERT INTO #supers(custid,currency)
	SELECT custid, currency
	FROM Customer ci WITH(NOLOCK)
	WHERE ci.roleid = 4 	AND  ci.custid NOT IN (SELECT custid FROM Dep_CustSuper WITH(NOLOCK))		
		AND 
	(((ci.site IN ('733333','222223', '222225', '222227', '222229'))
		-- CROSS-SITE
		AND ci.custid NOT IN (674248,395075,1164457,1016771,993226,2453866,1156957,1156957,17721601,1156957,1036451,993226,1016771,324561,506057,2453866,1127269,1036451,1036451,2042873
		,2042873,1036451,796555,5005322)
		)			
		OR (currency=20 AND ci.custid NOT IN(23003140,14771858,15323100,15744710,17996464,18002026,18011327,18012360,18012400,18012427,18012473,18012480,18012482,18012484,18012696
											,18362423,18524451,18829945,19000014,19295126,19392121,19562449,19562472,20269385,20660425,20669162,20786437,21005407,21005647,21005670
											,21005685,21005748,21005851,21005868,21005888,21305783,21984259,23715203,24338704,1176070))
		)
		
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