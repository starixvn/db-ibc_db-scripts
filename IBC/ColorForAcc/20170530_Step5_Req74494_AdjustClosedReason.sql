
/*
	Created: Winnie	
	Task:  Update ClosedReason new cust
	DB: DBCUST/CustDB
	Date: 20170529
*/ 
		DECLARE  @max_logid INT
		SELECT @max_logid = xxx

		CREATE TABLE #temp (CustID INT PRIMARY KEY)
		INSERT INTO #temp (CustID)
		select custid,0 from Custinfo(nolock) where closed=1 and roleid between 2 and 4

		CREATE TABLE #tempMember (CustID INT PRIMARY KEY)
		INSERT INTO #tempMember (CustID)
		select custid,0 from Custinfo(nolock) where closed=1 and roleid =1

		CREATE TABLE #tempNewClosed (CustID INT PRIMARY KEY,ClosedReason TINYINT,LogID BIGINT NULL)
		INSERT INTO #tempNewClosed (CustID,ClosedReason)
		select custid,0 from #temp t
		WHERE t.CustID NOT IN (SELECT Custid FROM TempClosedReason WITH(NOLOCK))

		CREATE TABLE #tempMemberNewClosed (CustID INT PRIMARY KEY,ClosedReason TINYINT,LogID BIGINT NULL)
		INSERT INTO #tempMemberNewClosed (CustID,ClosedReason)
		select custid,0 from #tempMember t
		WHERE t.CustID NOT IN (SELECT Custid FROM TempClosedReasonMember WITH(NOLOCK))

		
		CREATE TABLE #tempNewOpen (CustID INT PRIMARY KEY,ClosedReason TINYINT)
		INSERT INTO #tempNewOpen (CustID,ClosedReason)
		select custid,0 from TempClosedReason WITH(NOLOCK) 
		WHERE CustID NOT IN (SELECT Custid FROM  #temp )

		CREATE TABLE #tempMemberNewOpen (CustID INT PRIMARY KEY,ClosedReason TINYINT)
		INSERT INTO #tempMemberNewOpen (CustID,ClosedReason)
		select t.custid,0 from  TempClosedReasonMember t WITH(NOLOCK) 
		WHERE t.CustID NOT IN (SELECT Custid FROM #tempMember )

		-- update new open
		UPDATE c
		SET c.ClosedReason=NULL
		FROM CustLoginInfo c WITH(ROWLOCK,UPDLOCK)
		INNER JOIN #tempNewOpen t ON c.CustID=t.CustID

		UPDATE c
		SET c.ClosedReason=NULL
		FROM CustLoginInfo_Member c WITH(ROWLOCK,UPDLOCK)
		INNER JOIN #tempMemberNewOpen t ON c.CustID=t.CustID

		-- new closed SMA

		UPDATE t SET Logid=(select top 1 LogId FROM DBLOG.bodb_CustomerLog.dbo.[UserLog_RunSP] u WITH(NOLOCK) 
		WHERE u.logid>@max_logid  AND u.CustID=t.CustID AND u.ActionID IN (1105,1115,2200,1142,1149)  ORDER BY u.logdate DESC)
		FROM #tempNewClosed t 

		UPDATE t SET t.ClosedReason= CASE WHEN u.ActionID IN (1115,1149) OR u.TrackingValue like '%Closed="1"%' THEN 1 ELSE 0 END										 
		FROM #tempNewClosed t 
		INNER JOIN DBLOG.bodb_CustomerLog.dbo.[UserLog_RunSP] u WITH(NOLOCK)  ON t.logid=u.logid		

		UPDATE c
		SET c.ClosedReason=ISNULL(t.ClosedReason,0)
		FROM CustLoginInfo c WITH(ROWLOCK,UPDLOCK)
		INNER JOIN #tempNewClosed t ON c.CustID=t.CustID

		-- new closed member
		UPDATE t SET Logid=(select top 1 LogId FROM DBLOG.bodb_CustomerLog.dbo.[UserLog_RunSP] u WITH(NOLOCK) 
		WHERE u.logid>@max_logid  AND u.CustID=t.CustID AND u.ActionID IN (1105,1115,2200,1142,1149)  ORDER BY u.logdate DESC)
		FROM #tempMemberNewClosed t 

		UPDATE t SET t.ClosedReason= CASE WHEN u.ActionID IN (1115,1149) OR u.TrackingValue like '%Closed="1"%' THEN 1 ELSE 0 END										 
		FROM #tempMemberNewClosed t 
		INNER JOIN DBLOG.bodb_CustomerLog.dbo.[UserLog_RunSP] u WITH(NOLOCK)  ON t.logid=u.logid

		UPDATE c
		SET c.ClosedReason=ISNULL(t.ClosedReason,0)
		FROM CustLoginInfo_Member c WITH(ROWLOCK,UPDLOCK)
		INNER JOIN #tempMemberNewClosed t ON c.CustID=t.CustID




		