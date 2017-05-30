
/*
	Created: Winnie	
	Task:  Insert into table temp
	DB: DBCUST/CustDB, DB06/bodb02
	Date: 20170523
*/ 

		DECLARE @maxcustid INT,@maxLogID INT
	
		SET @maxLogID=xxx

		INSERT INTO TempClosedReason (CustID,ClosedReason)
		select custid,0 from Custinfo(nolock) where closed=1 and roleid between 2 and 4

		INSERT INTO TempClosedReasonMember (CustID,ClosedReason)
		select custid,0 from Custinfo(nolock) where closed=1 and roleid=1
	
		UPDATE t SET ClosedReason=(select top 1 1 FROM DBLOG.bodb_CustomerLog.dbo.[UserLog_RunSP] u WITH(NOLOCK) 
		WHERE u.logid<=@maxLogID AND u.CustID=t.CustID AND u.ActionID=1105  AND u.TrackingValue like '%Closed="1"%' ORDER BY u.logdate DESC)
		FROM TempClosedReason t 
	
		UPDATE t SET ClosedReason=(select top 1 1 FROM DBLOG.bodb_CustomerLog.dbo.[UserLog_RunSP] u WITH(NOLOCK) 
		WHERE u.logid<=@maxLogID AND u.CustID=t.CustID AND u.ActionID=1115 ORDER BY u.logdate DESC)
		FROM TempClosedReason t 
	
		UPDATE t SET ClosedReason=(select top 1 1 FROM DBLOG.bodb_CustomerLog.dbo.[UserLog_RunSP] u WITH(NOLOCK) 
		WHERE u.logid<=@maxLogID AND u.CustID=t.CustID AND u.ActionID=2200  AND u.TrackingValue like '%Closed="1"%' ORDER BY u.logdate DESC)
		FROM TempClosedReason t 
		
		
		UPDATE t SET ClosedReason=(select top 1 1 FROM DBLOG.bodb_CustomerLog.dbo.[UserLog_RunSP] u WITH(NOLOCK) 
		WHERE u.logid<=@maxLogID AND u.CustID=t.CustID AND u.ActionID=1142  AND u.TrackingValue like '%Closed="1"%' ORDER BY u.logdate DESC)
		FROM TempClosedReason t 
		--member
		UPDATE t SET ClosedReason=(select top 1 1 FROM DBLOG.bodb_CustomerLog.dbo.[UserLog_RunSP] u WITH(NOLOCK) 
		WHERE u.logid<=@maxLogID AND u.CustID=t.CustID AND u.ActionID=1105  AND u.TrackingValue like '%Closed="1"%' ORDER BY u.logdate DESC)
		FROM TempClosedReasonMember t 
	
		UPDATE t SET ClosedReason=(select top 1 1 FROM DBLOG.bodb_CustomerLog.dbo.[UserLog_RunSP] u WITH(NOLOCK) 
		WHERE u.logid<=@maxLogID AND u.CustID=t.CustID AND u.ActionID=1115 ORDER BY u.logdate DESC)
		FROM TempClosedReasonMember t 
	
		UPDATE t SET ClosedReason=(select top 1 1 FROM DBLOG.bodb_CustomerLog.dbo.[UserLog_RunSP] u WITH(NOLOCK) 
		WHERE u.logid<=@maxLogID AND u.CustID=t.CustID AND u.ActionID=2200  AND u.TrackingValue like '%Closed="1"%' ORDER BY u.logdate DESC)
		FROM TempClosedReasonMember t 
		
		
		UPDATE t SET ClosedReason=(select top 1 1 FROM DBLOG.bodb_CustomerLog.dbo.[UserLog_RunSP] u WITH(NOLOCK) 
		WHERE u.logid<=@maxLogID AND u.CustID=t.CustID AND u.ActionID=1142  AND u.TrackingValue like '%Closed="1"%' ORDER BY u.logdate DESC)
		FROM TempClosedReasonMember t 

		

		