/*
	Created: Helen
	Task: Allbet, SLI Live Casino, GD - Change commission for Super level - Remine: https://nexdev.net/issues/66192
	DB: DBCUST/CustDB
	Date: 20161125	
*/ 

alter PROCEDURE [dbo].[Acc_ExecRep_Cust_09]
	@srecommend INT	
	,@maxcustid INT
	,@target VARCHAR(20) = null
	,@isExistDirectAccount BIT = 0
	
AS
BEGIN
	SET NOCOUNT ON
	
	IF (@target = 'REPLICATED' AND @@SERVERNAME = 'DBCUST') RETURN	-- run at all replicated servers
	IF (@target = 'DBCUST' AND @@SERVERNAME <> 'DBCUST') RETURN -- run at dbtrans only
	
	IF dbo.f_CheckRepTable('CustInfo') = 0 RETURN
	
	IF dbo.f_CheckRepTable('CustDiscount3rd_Member') = 0 RETURN
	IF dbo.f_CheckRepTable('CustDiscount3rd_Agent') = 0 RETURN
	IF dbo.f_CheckRepTable('CustSettingGame') = 0 RETURN

	CREATE TABLE #DirectMaster (CustID INT PRIMARY KEY)
	CREATE TABLE #DirectAgent (CustID INT PRIMARY KEY, mrecommend INT)
	CREATE TABLE #DirectMember (CustID INT PRIMARY KEY, recommend INT, mrecommend INT)
	
	IF @isExistDirectAccount = 0
	BEGIN			
		--SLI Live Casino or GD or Allbet
		-- DCS 
		PRINT  'Updating ALLBET' 
		UPDATE cd
			SET Discount = 0.009
		FROM CustDiscount3rd_Agent  cd (ROWLOCK)
		WHERE cd.CustID = @srecommend AND SportType = 211 
		
		UPDATE cd
			SET SuperDiscount = 0.009
		FROM  CustDiscount3rd_Member cd (ROWLOCK)
			INNER JOIN custInfo ci (NOLOCK) ON cd.CustID = ci.custid AND ci.Enabled = 1 AND  ci.srecommend = @srecommend 
		WHERE SportType = 211 

		PRINT 'Updating SLI Live Casino & GD ' 
		-- SLI & GD
		UPDATE cs
			SET sdiscount = 0.009
		FROM  CustSettingGame cs WITH(ROWLOCK)
			INNER JOIN custinfo ci WITH(NOLOCK) ON ci.custid = cs.custid AND ci.Enabled = 1 AND ci.roleid IN (1,4) AND ci.srecommend = @srecommend
		WHERE cs.sporttype IN (162,255)
				
	END	
	ELSE 
	BEGIN
		
		-- For RoleID = 4
		PRINT  'Updating ALLBET' 
		UPDATE cd
			SET Discount = 0.009
		FROM CustDiscount3rd_Agent  cd (ROWLOCK)
		WHERE CD.SportType = 211 AND CustID = @srecommend
		
		PRINT 'Updating SLI Live Casino & GD ' 
		UPDATE cs
			SET sdiscount = 0.009
		FROM  CustSettingGame cs WITH(ROWLOCK)
		WHERE cs.sporttype IN (162,255) AND custid = @srecommend
				
		----------- Direct Master PROCESSING ----------------------
		INSERT INTO #DirectMaster (CustID)
		SELECT custid
		FROM custInfo with(nolock)
		WHERE srecommend = @srecommend
			AND custid NOT IN (SELECT custid FROM Acc_CustDirect WITH(NOLOCK))
			AND srecommend  IN (SELECT custid FROM Acc_CustDirect WITH(NOLOCK))
			AND roleid=3 AND  custid <= @maxcustid 
			AND Enabled = 1
		
		IF EXISTS (SELECT 1 FROM #DirectMaster)
		BEGIN
			
			PRINT  'Updating ALLBET' 
			-- Role 3
			UPDATE cd
				SET Discount = 0.009
			FROM CustDiscount3rd_Agent  cd (ROWLOCK)
				INNER JOIN #DirectMaster d ON cd.CustID = d.CustID
				INNER JOIN custInfo ci (NOLOCK) ON cd.CustID = ci.custid AND ci.Enabled = 1  AND ci.roleid = 3 
			WHERE SportType = 211 
			-- Role 1 UNDER direct Master
			UPDATE cd
			SET SuperDiscount = 0.009
			FROM  CustDiscount3rd_Member cd (ROWLOCK)
				INNER JOIN custInfo ci (NOLOCK) ON cd.CustID = ci.custid AND ci.Enabled = 1 AND ci.roleid = 1 
				INNER JOIN #DirectMaster d ON ci.mrecommend = d.CustID
			WHERE SportType = 211 
			
			PRINT 'Updating SLI Live Casino & GD ' 
			--Roleid = 3
			UPDATE cs
				SET adiscount = 0.009
			FROM  CustSettingGame cs WITH(ROWLOCK)
				INNER JOIN #DirectMaster d ON cs.CustID = d.CustID
				INNER JOIN custinfo ci WITH(NOLOCK) ON ci.custid = cs.custid AND ci.Enabled = 1 AND ci.roleid = 3 
			WHERE cs.sporttype  IN (162,255)
				
			-- Role 1 UNDER direct Master
			UPDATE cs
				SET sdiscount = 0.009, adiscount = 0.009
			FROM  CustSettingGame cs WITH(ROWLOCK)
				INNER JOIN custinfo ci WITH(NOLOCK) ON ci.custid = cs.custid AND ci.Enabled = 1 AND ci.roleid = 1 
				INNER JOIN #DirectMaster d ON ci.mrecommend = d.CustID
			WHERE cs.sporttype IN (162,255)
					
					
		END
		----------- Direct Agent PROCESSING ----------------------
		INSERT INTO #DirectAgent (CustID,mrecommend)
		SELECT custid,mrecommend
		FROM custInfo with(nolock)
		WHERE srecommend = @srecommend
			AND custid NOT IN (SELECT custid FROM Acc_CustDirect WITH(NOLOCK))
			AND mrecommend  IN (SELECT custid FROM Acc_CustDirect WITH(NOLOCK))
			AND roleid=2 
			AND Enabled = 1
		
		IF EXISTS (SELECT 1 FROM #DirectAgent)
		BEGIN
			
			PRINT  'Updating ALLBET' 
			-- Role 3
			UPDATE cd
				SET Discount = 0.009
			FROM CustDiscount3rd_Agent  cd (ROWLOCK)
				INNER JOIN custInfo ci (NOLOCK) ON cd.CustID = ci.custid AND ci.Enabled = 1  AND ci.roleid = 3 
			WHERE SportType = 211 
				AND cd.CustID IN (SELECT DISTINCT mrecommend FROM #DirectAgent)
			-- Role 2
			UPDATE cd
				SET Discount = 0.009
			FROM CustDiscount3rd_Agent  cd (ROWLOCK)
				INNER JOIN #DirectAgent d ON cd.CustID = d.CustID
				INNER JOIN custInfo ci (NOLOCK) ON cd.CustID = ci.custid AND ci.Enabled = 1  AND ci.roleid = 2 
			WHERE SportType = 211 
			-- Role 1
			UPDATE cd
			SET SuperDiscount = 0.009
			FROM  CustDiscount3rd_Member cd (ROWLOCK)
				INNER JOIN custInfo ci (NOLOCK) ON cd.CustID = ci.custid AND ci.Enabled = 1 AND ci.roleid = 1 
				INNER JOIN #DirectAgent d ON ci.recommend = d.CustID
			WHERE SportType = 211 
			
			PRINT 'Updating SLI Live Casino & GD ' 
			
			--Roleid = 3
			UPDATE cs
				SET adiscount = 0.009
			FROM  CustSettingGame cs WITH(ROWLOCK)
				INNER JOIN custinfo ci WITH(NOLOCK) ON ci.custid = cs.custid AND ci.Enabled = 1 AND ci.roleid = 3 
			WHERE cs.sporttype IN  (162,255)
				AND cs.CustID IN (SELECT DISTINCT mrecommend FROM #DirectAgent)
				
			--Roleid = 2
			UPDATE cs
				SET discount = 0.009
			FROM  CustSettingGame cs WITH(ROWLOCK)
				INNER JOIN #DirectAgent d ON cs.CustID = d.CustID
				INNER JOIN custinfo ci WITH(NOLOCK) ON ci.custid = cs.custid AND ci.Enabled = 1 AND ci.roleid = 2 
			WHERE cs.sporttype IN  (162,255)
			
			-- Roleid = 1
			UPDATE cs
				SET sdiscount = 0.009, adiscount = 0.009,discount = 0.009 
			FROM  CustSettingGame cs WITH(ROWLOCK)
				INNER JOIN custinfo ci WITH(NOLOCK) ON ci.custid = cs.custid AND ci.Enabled = 1 AND ci.roleid = 1 
				INNER JOIN #DirectAgent d ON ci.recommend = d.CustID
			WHERE cs.sporttype  IN (162,255)
				
			
		END
		----------- Direct Member PROCESSING ----------------------
		INSERT INTO #DirectMember(CustID,mrecommend,recommend)
		SELECT custid,mrecommend,recommend
		FROM custInfo with(nolock)
		WHERE srecommend = @srecommend
			AND custid NOT IN (SELECT custid FROM Acc_CustDirect WITH(NOLOCK))
			AND recommend  IN (SELECT custid FROM Acc_CustDirect WITH(NOLOCK))
			AND roleid=1 AND  custid <= @maxcustid 
			AND Enabled = 1	
			
		IF EXISTS (SELECT 1 FROM #DirectMember)
		BEGIN
			
			PRINT  'Updating ALLBET' 
			-- Role 3
			UPDATE cd
				SET Discount = 0.009
			FROM CustDiscount3rd_Agent  cd (ROWLOCK)
				INNER JOIN custInfo ci (NOLOCK) ON cd.CustID = ci.custid AND ci.Enabled = 1  AND ci.roleid = 3 
			WHERE SportType = 211 
				AND cd.CustID IN (SELECT DISTINCT mrecommend FROM #DirectMember)
			-- Role 2
			UPDATE cd
				SET Discount = 0.009
			FROM CustDiscount3rd_Agent  cd (ROWLOCK)
				INNER JOIN custInfo ci (NOLOCK) ON cd.CustID = ci.custid AND ci.Enabled = 1  AND ci.roleid = 2 
			WHERE SportType = 211 
				AND cd.CustID IN (SELECT DISTINCT recommend FROM #DirectMember)
			
			-- Role 1
			UPDATE cd
				SET SuperDiscount = 0.009
			FROM  CustDiscount3rd_Member cd (ROWLOCK)
				INNER JOIN custInfo ci (NOLOCK) ON cd.CustID = ci.custid AND ci.Enabled = 1 AND ci.roleid = 1 
				INNER JOIN #DirectMember d ON ci.custid = d.CustID
			WHERE SportType = 211 
			
			PRINT 'Updating SLI Live Casino & GD ' 
			--Roleid = 3
			UPDATE cs
				SET adiscount = 0.009
			FROM  CustSettingGame cs WITH(ROWLOCK)
				INNER JOIN custinfo ci WITH(NOLOCK) ON ci.custid = cs.custid AND ci.Enabled = 1 AND ci.roleid = 3 
			WHERE cs.sporttype IN (162,255)
				AND cs.CustID IN (SELECT DISTINCT mrecommend FROM #DirectMember)
				
			--Roleid = 2
			UPDATE cs
				SET discount = 0.009
			FROM  CustSettingGame cs WITH(ROWLOCK)
				INNER JOIN custinfo ci WITH(NOLOCK) ON ci.custid = cs.custid AND ci.Enabled = 1 AND ci.roleid = 2 
			WHERE cs.sporttype IN (162,255)
				AND cs.CustID IN (SELECT DISTINCT recommend FROM #DirectMember)
				
			-- Roleid = 1
			UPDATE cs
				SET sdiscount = 0.009, adiscount = 0.009,discount = 0.009 
			FROM  CustSettingGame cs WITH(ROWLOCK)
				INNER JOIN custinfo ci WITH(NOLOCK) ON ci.custid = cs.custid AND ci.Enabled = 1 AND ci.roleid = 1 
				INNER JOIN #DirectMember d ON ci.custid = d.CustID
			WHERE cs.sporttype IN (162,255)
					
		END
	END	
	
	DROP TABLE #DirectAgent
	DROP TABLE #DirectMaster
	DROP TABLE #DirectMember	
		
END
-- END STEP 1: DEPLOY THIS SP @DBCUST.CustDB --------
------------------------------------------------------	

-- BEGIN STEP 2: RUN THIS SCRIPT AT ALL REPLICATED SERVERS (06/DBTP) -----
--------------------------------------------------------------------------------------
CREATE TABLE #supers (custid int,isfinished bit default(0), isExistDirectAccount BIT)

DECLARE @maxcustid INT, @srecommend INT, @isExistDirectAccount BIT

SELECT @maxcustid = xxx

CREATE TABLE #supers_ExistingDirectAccount (custid INT)

INSERT INTO #supers_ExistingDirectAccount (custid)
-- Get direct Master
SELECT DISTINCT srecommend from Customer with(nolock)
WHERE custid not in (select custid from Acc_CustDirect WITH(NOLOCK))
	and srecommend  in (select custid from Acc_CustDirect WITH(NOLOCK))
	and roleid=3 AND srecommend <= @maxcustid 
--- get direct agent
UNION 
SELECT DISTINCT srecommend from Customer with(nolock)
WHERE custid NOT IN (select custid from Acc_CustDirect WITH(NOLOCK))
	and mrecommend IN (select custid from Acc_CustDirect WITH(NOLOCK))
	and roleid=2 AND srecommend <= @maxcustid
-- direct member
UNION
SELECT DISTINCT srecommend from Customer WITH(NOLOCK)
WHERE custid NOT IN (select custid from Acc_CustDirect WITH(NOLOCK))
	AND recommend IN (select custid from Acc_CustDirect WITH(NOLOCK))
	AND roleid=1 AND srecommend <= @maxcustid 

-- list of supers
INSERT INTO #supers(custid,isExistDirectAccount)
SELECT ci.custid,0
FROM dbo.Customer ci WITH(NOLOCK)
WHERE ci.roleid = 4 	
		AND ci.custid NOT IN (SELECT custid FROM Dep_CustSuper WITH(NOLOCK))
		AND ci.custid NOT IN (SELECT custid FROM #supers_ExistingDirectAccount)
UNION ALL
SELECT custid, 1
FROM #supers_ExistingDirectAccount
		
WHILE (1 = 1)
BEGIN
	UPDATE TOP (1) #Supers
	SET isfinished = 1
		,@srecommend = custid	
		,@isExistDirectAccount = isExistDirectAccount
	WHERE isfinished = 0
	
	IF @@ROWCOUNT = 0 BREAK
			
	EXEC dbo.Acc_ExecRep_Cust_09 @srecommend = @srecommend 
			,@maxcustid = @maxcustid, @isExistDirectAccount = @isExistDirectAccount
			,@target = 'REPLICATED'
			
			
	waitfor delay '00:00:0.280'
END

-- BEGIN STEP 3: RUN THIS SCRIPT AT DBCUST -----
--------------------------------------------------------------------------------------
CREATE TABLE #supers (custid int,isfinished bit default(0), isExistDirectAccount BIT)

DECLARE @maxcustid INT, @srecommend INT, @isExistDirectAccount BIT

SELECT @maxcustid = xxx

CREATE TABLE #supers_ExistingDirectAccount (custid INT)
-- Get direct Master
SELECT DISTINCT srecommend from Customer with(nolock)
WHERE custid not in (select custid from Acc_CustDirect WITH(NOLOCK))
	and srecommend  in (select custid from Acc_CustDirect WITH(NOLOCK))
	and roleid=3 AND srecommend <= @maxcustid 
--- get direct agent
UNION 
SELECT DISTINCT srecommend from Customer with(nolock)
WHERE custid NOT IN (select custid from Acc_CustDirect WITH(NOLOCK))
	and mrecommend IN (select custid from Acc_CustDirect WITH(NOLOCK))
	and roleid=2 AND srecommend <= @maxcustid
-- direct member
UNION
SELECT DISTINCT srecommend from Customer WITH(NOLOCK)
WHERE custid NOT IN (select custid from Acc_CustDirect WITH(NOLOCK))
	AND recommend IN (select custid from Acc_CustDirect WITH(NOLOCK))
	AND roleid=1 AND srecommend <= @maxcustid 

-- list of supers
INSERT INTO #supers(custid,isExistDirectAccount)
SELECT ci.custid,0
FROM dbo.Customer ci WITH(NOLOCK)
WHERE ci.roleid = 4 	
		AND ci.custid NOT IN (SELECT custid FROM Dep_CustSuper WITH(NOLOCK))
		
		and ci.custid NOT IN (SELECT custid FROM #supers_ExistingDirectAccount)
UNION ALL
SELECT custid, 1
FROM #supers_ExistingDirectAccount

WHILE (1 = 1)
BEGIN
	UPDATE TOP (1) #Supers
	SET isfinished = 1
		,@srecommend = custid	
		
	WHERE isfinished = 0
	
	IF @@ROWCOUNT = 0 BREAK

	EXEC dbo.Acc_ExecRep_Cust_09 @srecommend = @srecommend
			,@maxcustid = @maxcustid, @isExistDirectAccount = @isExistDirectAccount
			,@target = 'DBCUST'
						
	WAITFOR DELAY '00:00:0.280'
END