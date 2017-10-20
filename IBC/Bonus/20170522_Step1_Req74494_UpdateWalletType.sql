
/*
	Created: Winnie	
	Task:  Update BonusWalletFlag
	DB: DBCUST/CustDB
	Date: 20171011
*/ 
ALTER PROCEDURE [dbo].Acc_CustomerInfo_Execrep_09
	@srecommend INT	
	,@maxcustid INT
	,@target VARCHAR(20)	
AS
BEGIN
	SET NOCOUNT ON
	
	IF (@target = 'REPLICATED' AND @@SERVERNAME = 'DBCUST') RETURN	-- run at all replicated servers
	IF (@target = 'DBCUST' AND @@SERVERNAME <> 'DBCUST') RETURN -- run at dbtrans only
	
	IF NOT (dbo.f_CheckRepTable('Custinfo') = 1  )
		RETURN		
		UPDATE ci
		SET	
			ci.BonusWalletFlag=0
		FROM CustInfo CI WITH (ROWLOCK,UPDLOCK) 
		WHERE ci.custid<=@maxcustid AND roleid=1 AND ci.srecommend=@srecommend 
END
GO
-- END STEP 1: DEPLOY THIS SP @DBCUST.CustDB --------
------------------------------------------------------	

-- BEGIN STEP 2: RUN THIS SCRIPT AT ALL REPLICATED SERVERS  -----
--------------------------------------------------------------------------------------
CREATE TABLE #supers (custid int,isfinished bit default(0))

DECLARE  @srecommend INT,@max_custid INT
SELECT @max_custid = xxx

INSERT INTO #supers(custid)
SELECT c.custid
FROM
custInfo c WITH(NOLOCK) 
WHERE (c.roleid = 4 	
AND c.custid IN (SELECT custid FROM Dep_CustSuper WITH(NOLOCK)) 
AND c.Enabled=1	
)

WHILE (1 = 1)
BEGIN
	UPDATE TOP (1) #Supers
	SET isfinished = 1
		,@srecommend = custid		
	WHERE isfinished = 0
	
	IF @@ROWCOUNT = 0 BREAK
			
	EXEC dbo.Acc_CustomerInfo_Execrep_09 @srecommend = @srecommend
			,@maxcustid = @max_custid
			,@target = 'REPLICATED'
			
	waitfor delay '00:00:0.280'
END

-- BEGIN STEP 3: RUN THIS SCRIPT AT DBCUST -----
--------------------------------------------------------------------------------------
CREATE TABLE #supers (custid int,isfinished bit default(0))

DECLARE  @srecommend INT,@max_custid INT
SELECT @max_custid = xxx

INSERT INTO #supers(custid)
SELECT c.custid
FROM
custInfo c WITH(NOLOCK) 
WHERE (c.roleid = 4 	
AND c.custid IN (SELECT custid FROM Dep_CustSuper WITH(NOLOCK)) 
AND c.Enabled=1	
)

WHILE (1 = 1)
BEGIN
	UPDATE TOP (1) #Supers
	SET isfinished = 1
		,@srecommend = custid		
	WHERE isfinished = 0
	
	IF @@ROWCOUNT = 0 BREAK

	EXEC dbo.Acc_CustomerInfo_Execrep_09 @srecommend = @srecommend
			,@maxcustid = @max_custid
			,@target = 'DBCUST'	
						
	waitfor delay '00:00:0.280'
END

