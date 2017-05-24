
/*
	Created: Winnie	
	Task:  Update WalletFlag new cust
	DB: DBCUST/CustDB
	Date: 20170523
*/ 
		DECLARE  @max_custid INT
		SELECT @max_custid = xxx

		CREATE TABLE #temp (CustID INT PRIMARY KEY,ClosedReason TINYINT)
		INSERT INTO #temp (CustID,ClosedReason)
		select custid,0 from Custinfo(nolock) where custid>@max_custid AND closed=1 and roleid between 1 and 4

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


		