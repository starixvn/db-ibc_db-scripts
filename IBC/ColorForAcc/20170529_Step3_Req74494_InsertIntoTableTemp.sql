
/*
	Created: Winnie	
	Task:  Insert into table temp on db052
	DB:DB052/bodb02
	Date: 20170523
		--ActionID=1149: Admin update closed on NAP-CM
		--ActionID=1105: Update closed on NAP,ALpha,EXT-NAP
		--ActionID=918: Account was closed because of failed Security Code over 5 times
		--ActionID=931: Account was closed because of failed OTP over 5 times
*/ 
		--select max(logdate) from bodb_CustomerLog.dbo.[UserLog_RunSP] u WITH(NOLOCK)
		DECLARE @maxcustid INT,@maxLogDate DATETIME
		SET @maxLogDate=xxx

		TRUNCATE TABLE TempClosedReason
		TRUNCATE TABLE TempClosedReasonMember
		
		INSERT INTO TempClosedReason (CustID,ClosedReason)
		select custid,0 from Custinfo(nolock) where closed=1 and roleid between 2 and 4 AND Enabled=1

		INSERT INTO TempClosedReasonMember (CustID,ClosedReason)
		select custid,0 from Custinfo(nolock) where closed=1 and roleid=1 AND Enabled=1

		-- update logid
		UPDATE t 
		SET Logdate= a.Logdate
		FROM TempClosedReason t 
			CROSS APPLY (SELECT MAX(logdate) logdate
			FROM bodb_CustomerLog.dbo.[UserLog_RunSP] u WITH(NOLOCK) 
			WHERE logdate<=@maxLogDate AND  u.CustID=t.CustID AND u.ActionID IN (1105,1149,918,931) 
			) AS a (Logdate)
		
		UPDATE t 
		SET Logdate= a.Logdate
		FROM TempClosedReasonMember t 
			CROSS APPLY (SELECT MAX(logdate) logdate
			FROM bodb_CustomerLog.dbo.[UserLog_RunSP] u WITH(NOLOCK) 
			WHERE logdate<=@maxLogDate AND u.CustID=t.CustID AND u.ActionID IN (1105,1149,918,931) 
			) AS a (Logdate)

	
		----update ClosedReason
		
		UPDATE t SET t.ClosedReason= CASE	WHEN u.ActionID = 1105 AND u.TrackingValue like '%Closed="1"%' AND c.roleid < 5 THEN 1 
											WHEN u.ActionID = 1105 AND u.TrackingValue like '%Closed="1"%' AND c.roleid >= 5 THEN 2
											WHEN u.ActionID = 1149 AND u.TrackingValue like '%Closed="1"%' THEN 2
											WHEN u.ActionID IN(918,931) THEN 3
											ELSE 0 END										 
		FROM TempClosedReason t 
		INNER JOIN bodb_CustomerLog.dbo.[UserLog_RunSP] u WITH(NOLOCK)  ON t.LogDate=u.LogDate AND t.CustID=u.custid
		INNER JOIN Customer c WITH(NOLOCK) ON u.userid=c.custid

		UPDATE t SET t.ClosedReason= CASE	WHEN u.ActionID = 1105 AND u.TrackingValue like '%Closed="1"%' AND c.roleid < 5 THEN 1 
											WHEN u.ActionID = 1105 AND u.TrackingValue like '%Closed="1"%' AND c.roleid >= 5 THEN 2
											WHEN u.ActionID = 1149 AND u.TrackingValue like '%Closed="1"%' THEN 2
											WHEN u.ActionID IN(918,931) THEN 3
											ELSE 0 END													 
		FROM TempClosedReasonMember t 
		INNER JOIN bodb_CustomerLog.dbo.[UserLog_RunSP] u WITH(NOLOCK)  ON t.LogDate=u.LogDate AND t.CustID=u.custid
		INNER JOIN Customer c WITH(NOLOCK) ON u.userid=c.custid

		/*

		SET @maxLogDate='2017-06-26 03:01:08.947'

		CREATE TABLE #TempClosedReason (CustID INT PRIMARY KEY, ClosedReason TINYINT,LogDate DATETIME NULL)
		CREATE TABLE #TempClosedReasonMember (CustID INT PRIMARY KEY, ClosedReason TINYINT,LogDate DATETIME NULL)

		INSERT INTO #TempClosedReason (CustID,ClosedReason)
		select custid,0 from Custinfo(nolock) where closed=1 and roleid between 2 and 4

		INSERT INTO #TempClosedReasonMember (CustID,ClosedReason)
		select custid,0 from Custinfo(nolock) where closed=1 and roleid=1

		-- update logid
		UPDATE t 
		SET Logdate= a.Logdate
		FROM #TempClosedReason t 
			CROSS APPLY (SELECT MAX(logdate) logdate
			FROM bodb_CustomerLog.dbo.[UserLog_RunSP] u WITH(NOLOCK) 
			WHERE logdate<=@maxLogDate AND  u.CustID=t.CustID AND u.ActionID IN (1105,1149,918,931) 
			) AS a (Logdate)
		
		UPDATE t 
		SET Logdate= a.Logdate
		FROM #TempClosedReasonMember t 
			CROSS APPLY (SELECT MAX(logdate) logdate
			FROM bodb_CustomerLog.dbo.[UserLog_RunSP] u WITH(NOLOCK) 
			WHERE logdate<=@maxLogDate AND u.CustID=t.CustID AND u.ActionID IN (1105,1149,918,931) 
			) AS a (Logdate)

		----update ClosedReason
		
		UPDATE t SET t.ClosedReason= CASE	WHEN u.ActionID = 1105 AND u.TrackingValue like '%Closed="1"%' AND c.roleid < 5 THEN 1 
											WHEN u.ActionID = 1105 AND u.TrackingValue like '%Closed="1"%' AND c.roleid >= 5 THEN 2
											WHEN u.ActionID = 1149 AND u.TrackingValue like '%Closed="1"%' THEN 2
											WHEN u.ActionID IN(918,931) THEN 3
											ELSE 0 END										 
		FROM #TempClosedReason t 
		INNER JOIN bodb_CustomerLog.dbo.[UserLog_RunSP] u WITH(NOLOCK)  ON t.LogDate=u.LogDate AND t.CustID=u.custid
		INNER JOIN Customer c WITH(NOLOCK) ON u.userid=c.custid

		UPDATE t SET t.ClosedReason= CASE	WHEN u.ActionID = 1105 AND u.TrackingValue like '%Closed="1"%' AND c.roleid < 5 THEN 1 
											WHEN u.ActionID = 1105 AND u.TrackingValue like '%Closed="1"%' AND c.roleid >= 5 THEN 2
											WHEN u.ActionID = 1149 AND u.TrackingValue like '%Closed="1"%' THEN 2
											WHEN u.ActionID IN(918,931) THEN 3
											ELSE 0 END													 
		FROM #TempClosedReasonMember t 
		INNER JOIN bodb_CustomerLog.dbo.[UserLog_RunSP] u WITH(NOLOCK)  ON t.LogDate=u.LogDate AND t.CustID=u.custid
		INNER JOIN Customer c WITH(NOLOCK) ON u.userid=c.custid

		drop table #TempClosedReason
		drop table #TempClosedReasonMember
		*/

		