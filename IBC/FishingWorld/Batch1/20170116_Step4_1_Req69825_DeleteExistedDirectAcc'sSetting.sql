

/*
	Created: Winnie
	Date: 20170117
	Task: Delete existing Fishing World settings for dummy account 
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
	
	IF dbo.f_CheckRepTable('CustPTSetting3rd_Agent') = 0 RETURN
	IF dbo.f_CheckRepTable('CustPTSetting3rd_Member') = 0 RETURN
	IF dbo.f_CheckRepTable('CustPTGroupSetting3rd_Member') = 0 RETURN	
	IF dbo.f_CheckRepTable('CustWinLossLimit_Agent') = 0 RETURN
	IF dbo.f_CheckRepTable('CustWinLossLimit_Member') = 0 RETURN

	CREATE TABLE #DirectMaster (CustID INT PRIMARY KEY,roleid INT)
	CREATE TABLE #DirectAgent (CustID INT PRIMARY KEY,mrecommend INT,roleid INT)
	CREATE TABLE #DirectMember (CustID INT PRIMARY KEY,recommend INT,mrecommend INT,roleid INT)	
	
	CREATE TABLE #Cust_tmp(CustID INT PRIMARY KEY CLUSTERED,	roleid TINYINT	)
	DECLARE @sporttype INT
	SELECT @sporttype=219	

	INSERT INTO #DirectMaster (CustID,roleid)
	SELECT custid, roleid
	FROM Customer with(nolock)
	WHERE site in ('733333','222223', '222225', '222227', '222229')
		AND custid NOT IN (SELECT custid from Acc_CustDirect WITH(NOLOCK))
		AND srecommend IN (SELECT custid from Acc_CustDirect WITH(NOLOCK))
		AND roleid=3 AND srecommend IN (2,3,4,5,12,13,15) 
	
	--- get direct agent
	INSERT INTO #DirectAgent (CustID,mrecommend,roleid)
	SELECT custid, mrecommend,roleid
	FROM Customer WITH(NOLOCK)
	WHERE site in  ('733333','222223', '222225', '222227', '222229')
		and custid NOT IN (SELECT custid from Acc_CustDirect WITH(NOLOCK))
		and mrecommend IN (SELECT custid from Acc_CustDirect WITH(NOLOCK))
		and roleid=2 AND srecommend IN (2,3,4,5,12,13,15) 
	
	INSERT INTO #DirectMember(CustID,recommend,mrecommend,roleid)
	SELECT c.custid, c.recommend,c.mrecommend,c.roleid
	FROM Customer c WITH(NOLOCK)
	INNER JOIN Customer ca (nolock) on c.recommend=ca.custid 
	WHERE c.custid NOT IN (SELECT custid from Acc_CustDirect WITH(NOLOCK))
		AND c.recommend IN (SELECT custid from Acc_CustDirect WITH(NOLOCK))
		AND c.roleid=1 AND c.srecommend IN (2,3,4,5,12,13,15) 
		AND  ca.site in ('733333','222223', '222225', '222227', '222229')
	
	INSERT INTO #Cust_tmp (CustID,roleid)
	
	SELECT ci.srecommend,4 -- super of Direct Master 
	FROM custInfo CI WITH (NOLOCK)
		INNER JOIN #DirectMaster D ON CI.custid = D.CustID 
	
	UNION 
	
	SELECT CI.CustID,CI.roleid -- Direct Master 
	FROM custInfo CI WITH (NOLOCK)
		INNER JOIN #DirectMaster D ON CI.mrecommend = D.CustID 
	
	UNION 
	
	SELECT CI.CustID,CI.roleid -- Direct Agent
	FROM custInfo CI WITH (NOLOCK)
		INNER JOIN #DirectAgent D ON CI.recommend = D.CustID 
	UNION 
	SELECT DISTINCT CI.srecommend,4 -- super of direct agent
	FROM custInfo CI WITH (NOLOCK)
		INNER JOIN #DirectAgent D ON CI.custid = d.CustID
	
	UNION 	
	
	SELECT DISTINCT CI.CustID,CI.roleid -- Master of direct agent
	FROM Customer CI WITH (NOLOCK)
		INNER JOIN #DirectAgent D ON CI.custid = D.mrecommend 
	WHERE CI.roleid = 3 
	UNION 

	SELECT DISTINCT CI.srecommend,4 -- super of direct member
	FROM custInfo CI WITH (NOLOCK)
		INNER JOIN #DirectMember D ON CI.custid = D.CustID 
	WHERE  ci.Enabled = 1
	
	UNION 

	SELECT DISTINCT CI.CustID,CI.roleid -- Master of direct member
	FROM custInfo CI WITH (NOLOCK)
		INNER JOIN #DirectMember D ON CI.custid = D.mrecommend 
	WHERE  ci.Enabled = 1 

	UNION 
	SELECT DISTINCT CI.CustID,CI.roleid -- agent of direct member
	FROM custInfo CI WITH (NOLOCK)
		INNER JOIN #DirectMember D ON CI.custid = D.recommend 
	WHERE  ci.Enabled = 1 

	UNION 
	
	SELECT CustID,roleid -- DIRECT MEMBER
	FROM #DirectMember
		
	--- PT
	DELETE cg
	FROM CustPTSetting3rd_Agent cg 
		INNER JOIN #Cust_tmp tmp (NOLOCK) ON tmp.custid = cg.custid
	WHERE SportType = @sporttype 
							
	DELETE cg
	FROM CustPTSetting3rd_Member cg 
		INNER JOIN #Cust_tmp tmp (NOLOCK) ON tmp.custid = cg.custid
	WHERE CG.SportType = @sporttype 
	
	DELETE cg
	FROM CustPTGroupSetting3rd_Member cg
		INNER JOIN #Cust_tmp CI (NOLOCK) ON CI.custid = CG.AgentID 
	WHERE CG.SportType = @sporttype 

	-- Winloss - limit
	DELETE cg
	FROM CustWinLossLimit_Agent cg 		
		INNER JOIN #Cust_tmp tmp (NOLOCK) ON tmp.custid = cg.custid
	WHERE SportType = @sporttype 

	DELETE cg
	FROM CustWinLossLimit_Member cg 		
		INNER JOIN #Cust_tmp tmp (NOLOCK) ON tmp.custid = cg.custid
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

