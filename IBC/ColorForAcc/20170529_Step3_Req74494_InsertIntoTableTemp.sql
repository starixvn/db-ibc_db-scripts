
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

		-- update logid
		UPDATE t SET Logid=(select top 1 LogId FROM DBLOG.bodb_CustomerLog.dbo.[UserLog_RunSP] u WITH(NOLOCK) 
		WHERE u.logid<=@maxLogID AND u.CustID=t.CustID AND u.ActionID IN (1105,1115,2200,1142,1149)  ORDER BY u.logdate DESC)
		FROM TempClosedReason t 

		
		UPDATE t SET Logid=(select top 1 LogId FROM DBLOG.bodb_CustomerLog.dbo.[UserLog_RunSP] u WITH(NOLOCK) 
		WHERE u.logid<=@maxLogID AND u.CustID=t.CustID AND u.ActionID IN (1105,1115,2200,1142,1149)  ORDER BY u.logdate DESC)
		FROM TempClosedReasonMember t 

		----update ClosedReason
		
		UPDATE t SET t.ClosedReason= CASE WHEN u.ActionID IN (1115,1149) OR u.TrackingValue like '%Closed="1"%' THEN 1 ELSE 0 END										 
		FROM TempClosedReason t 
		INNER JOIN DBLOG.bodb_CustomerLog.dbo.[UserLog_RunSP] u WITH(NOLOCK)  ON t.logid=u.logid

		UPDATE t SET t.ClosedReason= CASE WHEN u.ActionID IN (1115,1149) OR u.TrackingValue like '%Closed="1"%' THEN 1 ELSE 0 END										 
		FROM TempClosedReasonMember t 
		INNER JOIN DBLOG.bodb_CustomerLog.dbo.[UserLog_RunSP] u WITH(NOLOCK)  ON t.logid=u.logid


		

		