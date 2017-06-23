
/*
	Created: Winnie	
	Task:  Update ClosedReason new cust
	DB: DBCUST/CustDB
	Date: 20170529
		--ActionID=1149: Admin update closed on NAP-CM
		--ActionID=1105: Update closed on NAP,ALpha,EXT-NAP
		--ActionID=918: Account was closed because of failed Security Code over 5 times
		--ActionID=931: Account was closed because of failed OTP over 5 times
*/ 
--select max(logdate) from  DBLOG.bodb_CustomerLog.dbo.[UserLog_RunSP] u WITH(NOLOCK)

		DECLARE  @max_logdate DATETIME
		SELECT @max_logdate =xxx

		CREATE TABLE #temp (CustID INT PRIMARY KEY)
		INSERT INTO #temp (CustID)
		select custid from Custinfo(nolock) where closed=1 and roleid between 2 and 4 AND Enabled=1

		CREATE TABLE #tempMember (CustID INT PRIMARY KEY)
		INSERT INTO #tempMember (CustID)
		select custid from Custinfo(nolock) where closed=1 and roleid =1 AND Enabled=1

		CREATE TABLE #tempNewClosed (CustID INT PRIMARY KEY,ClosedReason TINYINT,Logdate Datetime NULL)
		INSERT INTO #tempNewClosed (CustID,ClosedReason)
		select custid,0 from #temp t
		WHERE t.CustID NOT IN (SELECT Custid FROM TempClosedReason WITH(NOLOCK))

		CREATE TABLE #tempMemberNewClosed (CustID INT PRIMARY KEY,ClosedReason TINYINT,Logdate Datetime NULL)
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

		UPDATE t 
		SET Logdate= a.Logdate
		FROM #tempNewClosed t 
		CROSS APPLY (SELECT MAX(logdate) logdate
					FROM bodb_CustomerLog.dbo.[UserLog_RunSP] u WITH(NOLOCK) 
					WHERE logdate>@max_logdate AND  u.CustID=t.CustID AND u.ActionID IN (1105,1149,918,931)  
					) AS a (Logdate)

		UPDATE  t SET t.ClosedReason= CASE	WHEN u.ActionID = 1105 AND u.TrackingValue like '%Closed="1"%' AND c.roleid < 5 THEN 1 
											WHEN u.ActionID = 1105 AND u.TrackingValue like '%Closed="1"%' AND c.roleid >= 5 THEN 2
											WHEN u.ActionID = 1149 AND u.TrackingValue like '%Closed="1"%' THEN 2
											WHEN u.ActionID IN(918,931) THEN 3
											ELSE 0 END								 
		FROM #tempNewClosed t 
		INNER JOIN DBLOG.bodb_CustomerLog.dbo.[UserLog_RunSP] u WITH(NOLOCK)  ON t.Logdate=u.logdate AND t.CustID=u.custid		
		INNER JOIN Customer c WITH(NOLOCK) ON u.userid=c.custid

		UPDATE c
		SET c.ClosedReason=ISNULL(t.ClosedReason,0)
		FROM CustLoginInfo c WITH(ROWLOCK,UPDLOCK)
		INNER JOIN #tempNewClosed t ON c.CustID=t.CustID

		-- new closed member
		
		UPDATE t 
		SET Logdate= a.Logdate
		FROM #tempMemberNewClosed t 
		CROSS APPLY (SELECT MAX(logdate) logdate
					FROM bodb_CustomerLog.dbo.[UserLog_RunSP] u WITH(NOLOCK) 
					WHERE logdate>@max_logdate AND  u.CustID=t.CustID AND u.ActionID IN (1105,1149,918,931) 
					) AS a (Logdate)

		UPDATE  t SET t.ClosedReason= CASE	WHEN u.ActionID = 1105 AND u.TrackingValue like '%Closed="1"%' AND c.roleid < 5 THEN 1 
											WHEN u.ActionID = 1105 AND u.TrackingValue like '%Closed="1"%' AND c.roleid >= 5 THEN 2
											WHEN u.ActionID = 1149 AND u.TrackingValue like '%Closed="1"%' THEN 2
											WHEN u.ActionID IN(918,931) THEN 3
											ELSE 0 END										 
		FROM #tempMemberNewClosed t 
		INNER JOIN DBLOG.bodb_CustomerLog.dbo.[UserLog_RunSP] u WITH(NOLOCK)  ON t.Logdate=u.logdate AND t.CustID=u.custid
		INNER JOIN Customer c WITH(NOLOCK) ON u.userid=c.custid

		UPDATE c
		SET c.ClosedReason=ISNULL(t.ClosedReason,0)
		FROM CustLoginInfo_Member c WITH(ROWLOCK,UPDLOCK)
		INNER JOIN #tempMemberNewClosed t ON c.CustID=t.CustID

		drop table #temp
		drop table #tempMember
		drop table #tempMemberNewClosed
		drop table #tempMemberNewOpen
		drop table #tempNewClosed
		drop table #tempNewOpen



		