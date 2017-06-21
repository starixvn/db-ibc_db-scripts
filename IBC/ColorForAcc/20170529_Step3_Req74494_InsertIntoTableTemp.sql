
/*
	Created: Winnie	
	Task:  Insert into table temp on db052
	DB:DB052/bodb02
	Date: 20170523
*/ 


		DECLARE @maxcustid INT,@maxLogDate DATETIME
	
		SET @maxLogDate='2017-06-26 03:01:08.947'
		--TRUNCATE TABLE TempClosedReason
		--TRUNCATE TABLE TempClosedReasonMember

		--select max(logdate) from bodb_CustomerLog.dbo.[UserLog_RunSP] u WITH(NOLOCK)

		CREATE TABLE #TempClosedReason (CustID INT, ClosedReason TINYINT,LogDate DATETIME NULL)
		CREATE TABLE #TempClosedReasonMember (CustID INT, ClosedReason TINYINT,LogDate DATETIME NULL)

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
		WHERE logdate<=@maxLogDate AND  u.CustID=t.CustID AND u.ActionID IN (1105,1115,1142,1149) 
		) AS a (Logdate)
		
		UPDATE t 
		SET Logdate= a.Logdate
		FROM #TempClosedReasonMember t 
		CROSS APPLY (SELECT MAX(logdate) logdate
		FROM bodb_CustomerLog.dbo.[UserLog_RunSP] u WITH(NOLOCK) 
		WHERE logdate<=@maxLogDate AND u.CustID=t.CustID AND u.ActionID IN (1105,1115,1142,1149) 
		) AS a (Logdate)

		----update ClosedReason
		
		UPDATE t SET t.ClosedReason= CASE WHEN u.ActionID IN (1115) OR u.TrackingValue like '%Closed="1"%' THEN 1 ELSE 0 END										 
		FROM #TempClosedReason t 
		INNER JOIN bodb_CustomerLog.dbo.[UserLog_RunSP] u WITH(NOLOCK)  ON t.LogDate=u.LogDate AND t.CustID=u.custid

		UPDATE t SET t.ClosedReason= CASE WHEN u.ActionID IN (1115) OR u.TrackingValue like '%Closed="1"%' THEN 1 ELSE 0 END										 
		FROM #TempClosedReasonMember t 
		INNER JOIN bodb_CustomerLog.dbo.[UserLog_RunSP] u WITH(NOLOCK)  ON t.LogDate=u.LogDate AND t.CustID=u.custid

		drop table #TempClosedReason
		drop table #TempClosedReasonMember

		