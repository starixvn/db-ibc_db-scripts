/*
	Created: Dominic
	Date: 2015-10-15
	Task: Initialize PT/Bet Limit of Muay Thai in DCS structure
	DB: DBCust.CustDB
*/  
-- BEGIN STEP 1: DEPLOY THIS SP @DBCUST.CustDB ------
------------------------------------------------------
ALTER PROCEDURE Acc_DynamicCustSetting_09
	@srecommend INT	
	,@maxcustid INT
	,@target VARCHAR(20)
AS
BEGIN   
	SET NOCOUNT ON
	
	IF (@target = 'REPLICATED' AND @@SERVERNAME = 'DBCUST') RETURN	-- run at all replicated servers
	IF (@target = 'DBCUST' AND @@SERVERNAME <> 'DBCUST') RETURN -- run at DBCUST only
	
	IF NOT (dbo.f_CheckRepTable('Custinfo') = 1 
	   AND dbo.f_CheckRepTable('CustSetting') = 1
	   AND dbo.f_CheckRepTable('custOverride') = 1 
	   AND dbo.f_CheckRepTable('CustBetSetting3rd_Member') = 1
	   AND dbo.f_CheckRepTable('CustBetSetting3rd_Agent') = 1
	   AND dbo.f_CheckRepTable('CustPTSetting3rd_Member') = 1
	   AND dbo.f_CheckRepTable('CustPTSetting3rd_Agent') = 1
	   )
	  RETURN


	DELETE cs
	FROM [dbo].CustPTSetting3rd_Agent cs WITH(UPDLOCK,ROWLOCK)
		INNER JOIN custinfo ci WITH(NOLOCK) ON cs.custid = ci.custid
	WHERE ci.roleid IN (2,3,4) AND ci.srecommend = @srecommend AND  ci.custid <= @maxcustid
		AND cs.sporttype = 44
		
		
	DELETE cs
	FROM [dbo].CustPTSetting3rd_Member cs WITH(UPDLOCK,ROWLOCK)
		INNER JOIN custinfo ci WITH(NOLOCK) ON cs.custid = ci.custid
	WHERE ci.roleid = 1 AND ci.srecommend = @srecommend AND  ci.custid <= @maxcustid
		AND cs.sporttype = 44
		
	DELETE cs
	FROM [dbo].CustSettingMode3rd cs WITH(UPDLOCK,ROWLOCK)
		INNER JOIN custinfo ci WITH(NOLOCK) ON cs.custid = ci.custid
	WHERE ci.roleid = 1 AND ci.srecommend = @srecommend AND  ci.custid <= @maxcustid
	
	DELETE cs
	FROM [dbo].CustSettingMode3rd cs WITH(UPDLOCK,ROWLOCK)
		INNER JOIN custinfo ci WITH(NOLOCK) ON cs.custid = ci.custid
	WHERE ci.roleid = 1 AND ci.srecommend = @srecommend AND  ci.custid <= @maxcustid
	
	DELETE cs
	FROM [dbo].CustBetSetting3rd_Agent cs WITH(UPDLOCK,ROWLOCK)
		INNER JOIN custinfo ci WITH(NOLOCK) ON cs.custid = ci.custid
	WHERE ci.roleid IN (2,3,4) AND ci.srecommend = @srecommend AND  ci.custid <= @maxcustid
	
	DELETE cs
	FROM [dbo].CustBetSetting3rd_Member cs WITH(UPDLOCK,ROWLOCK)
		INNER JOIN custinfo ci WITH(NOLOCK) ON cs.custid = ci.custid
	WHERE ci.roleid = 1 AND ci.srecommend = @srecommend AND  ci.custid <= @maxcustid


END

-- BEGIN STEP 2: RUN THIS SCRIPT AT ALL REPLICATED SERVERS (06/DBTP) -----
--------------------------------------------------------------------------------------
CREATE TABLE #supers (custid int,isfinished bit default(0))

DECLARE @max_custid INT, @srecommend INT

SELECT @max_custid = xxx


INSERT INTO #supers
SELECT ci.custid
FROM CustInfo ci WITH(NOLOCK)
WHERE ci.roleid = 4 	
	AND ci.custid NOT IN (SELECT custid FROM Dep_CustSuper WITH(NOLOCK))
	AND custid <= @max_custid 
	
WHILE (1 = 1)
BEGIN
	UPDATE TOP (1) #Supers
	SET isfinished = 1
		,@srecommend = custid	
	WHERE isfinished = 0
	
	IF @@ROWCOUNT = 0 BREAK
			
	EXEC dbo.Acc_DynamicCustSetting_09 @srecommend = @srecommend
			,@maxcustid = @max_custid
			,@target = 'REPLICATED'
			
			
	waitfor delay '00:00:0.280'
END

-- BEGIN STEP 3: RUN THIS SCRIPT AT DBCUST -----
--------------------------------------------------------------------------------------
CREATE TABLE #supers (custid int,isfinished bit default(0))

DECLARE @max_custid INT, @srecommend INT

SELECT @max_custid = xxx

INSERT INTO #supers
SELECT ci.custid
FROM CustInfo ci WITH(NOLOCK)
WHERE ci.roleid = 4 	
	AND ci.custid NOT IN (SELECT custid FROM Dep_CustSuper WITH(NOLOCK))
	AND custid <= @max_custid 
	
WHILE (1 = 1)
BEGIN
	UPDATE TOP (1) #Supers
	SET isfinished = 1
		,@srecommend = custid	
	WHERE isfinished = 0
	
	IF @@ROWCOUNT = 0 BREAK

	EXEC dbo.Acc_DynamicCustSetting_09 @srecommend = @srecommend
			,@maxcustid = @max_custid
			,@target = 'DBCUST'
						
	waitfor delay '00:00:0.280'
END