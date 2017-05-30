
/*
	Created: Winnie	
	Task:  Insert into table temp
	DB: DBCUST/CustDB, DB06/bodb02
	Date: 20170523
*/ 

		DECLARE @maxcustid INT,@maxLogID INT
		SET @maxcustid=1
		SET @maxLogID=2

		INSERT INTO TempClosedReason (CustID,ClosedReason)
		select custid,0 from Custinfo(nolock) where custid<=@maxcustid  AND closed=1 and roleid between 1 and 4

		UPDATE t SET ClosedReason=(select top 1 0 FROM DBLOG.bodb_CustomerLog.dbo.[UserLog_RunSP] u WITH(NOLOCK) 
		WHERE u.logid<@maxLogID AND u.CustID=t.CustID AND u.ActionID=905  AND u.TrackingValue like '%Closed="1"%' ORDER BY u.logdate DESC)
		FROM TempClosedReason t 

		UPDATE t SET ClosedReason=(select top 1 0 FROM DBLOG.bodb_CustomerLog.dbo.[UserLog_RunSP] u WITH(NOLOCK) 
		WHERE u.logid<@maxLogID AND u.CustID=t.CustID AND u.ActionID=906  AND u.TrackingValue like '%Closed="1"%' ORDER BY u.logdate DESC)
		FROM TempClosedReason t 

		UPDATE t SET ClosedReason=(select top 1 0 FROM DBLOG.bodb_CustomerLog.dbo.[UserLog_RunSP] u WITH(NOLOCK) 
		WHERE u.logid<@maxLogID AND u.CustID=t.CustID AND u.ActionID=907  AND u.TrackingValue like '%Closed="1"%' ORDER BY u.logdate DESC)
		FROM TempClosedReason t 

		
		UPDATE t SET ClosedReason=(select top 1 0 FROM DBLOG.bodb_CustomerLog.dbo.[UserLog_RunSP] u WITH(NOLOCK) 
		WHERE u.logid<@maxLogID AND u.CustID=t.CustID AND u.ActionID=908  AND u.TrackingValue like '%Closed="1"%' ORDER BY u.logdate DESC)
		FROM TempClosedReason t 

		UPDATE t SET ClosedReason=(select top 1 0 FROM DBLOG.bodb_CustomerLog.dbo.[UserLog_RunSP] u WITH(NOLOCK) 
		WHERE u.logid<@maxLogID AND u.CustID=t.CustID AND u.ActionID=910  AND u.TrackingValue like '%Closed="1"%' ORDER BY u.logdate DESC)
		FROM TempClosedReason t 

		UPDATE t SET ClosedReason=(select top 1 0 FROM DBLOG.bodb_CustomerLog.dbo.[UserLog_RunSP] u WITH(NOLOCK) 
		WHERE u.logid<@maxLogID AND u.CustID=t.CustID AND u.ActionID=911  AND u.TrackingValue like '%Closed="1"%' ORDER BY u.logdate DESC)
		FROM TempClosedReason t 
		
		
		UPDATE t SET ClosedReason=(select top 1 0 FROM DBLOG.bodb_CustomerLog.dbo.[UserLog_RunSP] u WITH(NOLOCK) 
		WHERE u.logid<@maxLogID AND u.CustID=t.CustID AND u.ActionID=912  AND u.TrackingValue like '%Closed="1"%' ORDER BY u.logdate DESC)
		FROM TempClosedReason t 				
		
		UPDATE t SET ClosedReason=(select top 1 0 FROM DBLOG.bodb_CustomerLog.dbo.[UserLog_RunSP] u WITH(NOLOCK) 
		WHERE u.logid<@maxLogID AND u.CustID=t.CustID AND u.ActionID=913  AND u.TrackingValue like '%Closed="1"%' ORDER BY u.logdate DESC)
		FROM TempClosedReason t 

				
		UPDATE t SET ClosedReason=(select top 1 0 FROM DBLOG.bodb_CustomerLog.dbo.[UserLog_RunSP] u WITH(NOLOCK) 
		WHERE u.logid<@maxLogID AND u.CustID=t.CustID AND u.ActionID=918  AND u.TrackingValue like '%Closed="1"%' ORDER BY u.logdate DESC)
		FROM TempClosedReason t 

		UPDATE t SET ClosedReason=(select top 1 0 FROM DBLOG.bodb_CustomerLog.dbo.[UserLog_RunSP] u WITH(NOLOCK) 
		WHERE u.logid<@maxLogID AND u.CustID=t.CustID AND u.ActionID=922  AND u.TrackingValue like '%Closed="1"%' ORDER BY u.logdate DESC)
		FROM TempClosedReason t 

		
		UPDATE t SET ClosedReason=(select top 1 0 FROM DBLOG.bodb_CustomerLog.dbo.[UserLog_RunSP] u WITH(NOLOCK) 
		WHERE u.logid<@maxLogID AND u.CustID=t.CustID AND u.ActionID=925  AND u.TrackingValue like '%Closed="1"%' ORDER BY u.logdate DESC)
		FROM TempClosedReason t 

		UPDATE t SET ClosedReason=(select top 1 0 FROM DBLOG.bodb_CustomerLog.dbo.[UserLog_RunSP] u WITH(NOLOCK) 
		WHERE u.logid<@maxLogID AND u.CustID=t.CustID AND u.ActionID=931  AND u.TrackingValue like '%Closed="1"%' ORDER BY u.logdate DESC)
		FROM TempClosedReason t 

		
		UPDATE t SET ClosedReason=(select top 1 0 FROM DBLOG.bodb_CustomerLog.dbo.[UserLog_RunSP] u WITH(NOLOCK) 
		WHERE u.logid<@maxLogID AND u.CustID=t.CustID AND u.ActionID=1140  AND u.TrackingValue like '%Closed="1"%' ORDER BY u.logdate DESC)
		FROM TempClosedReason t 

		UPDATE t SET ClosedReason=(select top 1 0 FROM DBLOG.bodb_CustomerLog.dbo.[UserLog_RunSP] u WITH(NOLOCK) 
		WHERE u.logid<@maxLogID AND u.CustID=t.CustID AND u.ActionID=1141  AND u.TrackingValue like '%Closed="1"%' ORDER BY u.logdate DESC)
		FROM TempClosedReason t 





		select top 100 * FROM DBLOG.bodb_CustomerLog.dbo.[UserLog_RunSP] u WITH(NOLOCK) 
		where  u.ActionID=905
		ORDER BY u.logdate DESC


		select top 100 * FROM DBLOG.bodb_CustomerLog.dbo.logaction u WITH(NOLOCK) where actio