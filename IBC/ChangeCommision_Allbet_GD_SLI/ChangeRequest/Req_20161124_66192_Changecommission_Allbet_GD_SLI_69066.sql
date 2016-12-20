/*
	Created: Helen
	Task: Allbet, SLI Live Casino, GD - Change commission for Super level - Remine:https://nexdev.net/issues/69066
	DB: DBCUST/CustDB
	Date: 20161220	
*/ 

alter PROCEDURE [dbo].[Acc_ExecRep_Cust_09]
	@srecommend INT	
	,@maxcustid INT
	,@target VARCHAR(20) = null
AS
BEGIN
	SET NOCOUNT ON
	
	IF (@target = 'REPLICATED' AND @@SERVERNAME = 'DBCUST') RETURN	-- run at all replicated servers
	IF (@target = 'DBCUST' AND @@SERVERNAME <> 'DBCUST') RETURN -- run at dbtrans only
	
	IF dbo.f_CheckRepTable('CustInfo') = 0 RETURN
	
	IF dbo.f_CheckRepTable('CustDiscount3rd_Member') = 0 RETURN
	IF dbo.f_CheckRepTable('CustDiscount3rd_Agent') = 0 RETURN
	IF dbo.f_CheckRepTable('CustSettingGame') = 0 RETURN

	CREATE TABLE #Cust_tmp (CustID INT PRIMARY KEY,roleID INT)
	
	--SLI Live Casino or GD or Allbet
	-- DCS 
	INSERT INTO #Cust_tmp (CustID,roleID)
	SELECT ci.custid,ci.roleid
	FROM custInfo ci (NOLOCK) 
	WHERE ci.srecommend = @srecommend

	PRINT  'Updating ALLBET' 
	UPDATE cd
		SET Discount = 0.009
	FROM CustDiscount3rd_Agent  cd (ROWLOCK)
		INNER JOIN #Cust_tmp c ON cd.CustID = c.CustID AND roleID IN (3,4)
	WHERE cd.SportType = 211 
	
	UPDATE cd
		SET SuperDiscount = 0.009,MasterDiscount = 0.009
	FROM  CustDiscount3rd_Member cd (ROWLOCK)
		INNER JOIN #Cust_tmp c ON cd.CustID = c.CustID
	WHERE cd.SportType = 211 AND C.roleID = 1

	PRINT 'Updating SLI Live Casino & GD ' 
	-- SLI & GD
	UPDATE cs
		SET sdiscount = 0.009,adiscount = 0.009
	FROM  CustSettingGame cs WITH(ROWLOCK)
		INNER JOIN #Cust_tmp ci WITH(NOLOCK) ON ci.custid = cs.custid AND ci.roleid IN (1,3,4) 
	WHERE cs.sporttype IN (162,255)
				
	DROP TABLE #Cust_tmp
		
END
-- END STEP 1: DEPLOY THIS SP @DBCUST.CustDB --------
------------------------------------------------------	

-- BEGIN STEP 2: RUN THIS SCRIPT AT ALL REPLICATED SERVERS (06/DBTP) -----
--------------------------------------------------------------------------------------
CREATE TABLE #supers (custid int,isfinished bit default(0))

DECLARE @maxcustid INT, @srecommend INT

-- list of supers
INSERT INTO #supers(custid)
SELECT ci.custid
FROM dbo.Customer ci WITH(NOLOCK)
WHERE ci.custid IN (2138601,2251491)
		
WHILE (1 = 1)
BEGIN
	UPDATE TOP (1) #Supers
	SET isfinished = 1
		,@srecommend = custid	
		
	WHERE isfinished = 0
	
	IF @@ROWCOUNT = 0 BREAK
			
	EXEC dbo.Acc_ExecRep_Cust_09 @srecommend = @srecommend 
			,@maxcustid = @maxcustid
			,@target = 'REPLICATED'
			
			
	waitfor delay '00:00:0.280'
END

-- BEGIN STEP 3: RUN THIS SCRIPT AT DBCUST -----
--------------------------------------------------------------------------------------
CREATE TABLE #supers (custid int,isfinished bit default(0))

DECLARE @maxcustid INT, @srecommend INT

SELECT @maxcustid = xxx

-- list of supers
INSERT INTO #supers(custid)
SELECT ci.custid,0
FROM dbo.Customer ci WITH(NOLOCK)
WHERE ci.custid in (1)
WHILE (1 = 1)
BEGIN
	UPDATE TOP (1) #Supers
	SET isfinished = 1
		,@srecommend = custid	
		
		
	WHERE isfinished = 0
	
	IF @@ROWCOUNT = 0 BREAK

	EXEC dbo.Acc_ExecRep_Cust_09 @srecommend = @srecommend
			,@maxcustid = @maxcustid
			,@target = 'DBCUST'
						
	WAITFOR DELAY '00:00:0.280'
END