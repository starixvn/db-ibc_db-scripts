
/*
	Created: Winnie	
	Task:  Update WalletFlag
	DB: DBCUST/CustDB
	Date: 20170523
*/ 
ALTER PROCEDURE [dbo].Acc_CustomerInfo_Execrep_09	
	@maxcustid INT,
	@srecommend INT,
	@target VARCHAR(20)	
AS
BEGIN
	SET NOCOUNT ON
	
	IF (@target = 'REPLICATED' AND @@SERVERNAME = 'DBCUST') RETURN	-- run at all replicated servers
	IF (@target = 'DBCUST' AND @@SERVERNAME <> 'DBCUST') RETURN -- run at dbtrans only

		CREATE TABLE #temp (CustID INT PRIMARY KEY,ClosedReason TINYINT)
		INSERT INTO #temp (CustID,ClosedReason)
		select custid,0 from Custinfo(nolock) where custid<=@maxcustid AND srecommend=@srecommend AND closed=1 and roleid between 1 and 4

		UPDATE t SET ClosedReason=(select top 1 1 FROM DBLOG.bodb_CustomerLog.dbo.[UserLog_RunSP] u WITH(NOLOCK) 
		WHERE u.CustID=t.CustID AND u.ActionID=1105  AND u.TrackingValue like '%Closed="1"%')
		FROM #temp t 

		UPDATE c
		SET c.ClosedReason=ISNULL(t.ClosedReason,0)
		FROM CustLoginInfo c WITH(ROWLOCK,UPDLOCK)
		INNER JOIN #temp t ON c.CustID=t.CustID

		UPDATE c
		SET c.ClosedReason=ISNULL(t.ClosedReason,0)
		FROM CustLoginInfo_Member c WITH(ROWLOCK,UPDLOCK)
		INNER JOIN #temp t ON c.CustID=t.CustID

		UPDATE c
		SET c.ClosedReason=ISNULL(t.ClosedReason,0)
		FROM CustLoginInfoSub c WITH(ROWLOCK,UPDLOCK)
		INNER JOIN #temp t ON c.CustID=t.CustID

END
GO
-- END STEP 1: DEPLOY THIS SP @DBCUST.CustDB --------
------------------------------------------------------	

-- BEGIN STEP 2: RUN THIS SCRIPT AT ALL REPLICATED SERVERS (06/DBTP) -----
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
AND c.custid <=@max_custid
)

WHILE (1 = 1)
BEGIN
	UPDATE TOP (1) #Supers
	SET isfinished = 1
		,@srecommend = custid		
	WHERE isfinished = 0
	
	IF @@ROWCOUNT = 0 BREAK
			
	EXEC dbo.Acc_CustomerInfo_Execrep_09 
			@maxcustid = @max_custid
			,@srecommend=@srecommend
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
AND c.custid <=@max_custid
)

WHILE (1 = 1)
BEGIN
	UPDATE TOP (1) #Supers
	SET isfinished = 1
		,@srecommend = custid		
	WHERE isfinished = 0
	
	IF @@ROWCOUNT = 0 BREAK

	EXEC dbo.Acc_CustomerInfo_Execrep_09 
			@maxcustid = @max_custid
			,@srecommend=@srecommend
			,@target = 'DBCUST'	
						
	waitfor delay '00:00:0.280'
END

