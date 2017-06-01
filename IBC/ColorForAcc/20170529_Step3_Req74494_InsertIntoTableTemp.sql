
/*
	Created: Winnie	
	Task:  Insert into table temp on db052
	DB:DB052/bodb02
	Date: 20170523
*/ 

		DECLARE @maxcustid INT,@maxLogID INT
	
		SET @maxLogID=xxx
		TRUNCATE TABLE TempClosedReason
		TRUNCATE TABLE TempClosedReasonMember

		INSERT INTO TempClosedReason (CustID,ClosedReason)
		select custid,0 from Custinfo(nolock) where closed=1 and roleid between 2 and 4

		INSERT INTO TempClosedReasonMember (CustID,ClosedReason)
		select custid,0 from Custinfo(nolock) where closed=1 and roleid=1

		-- update logid
		UPDATE t 
		SET Logid= a.LogID
		FROM TempClosedReason t 
		CROSS APPLY (SELECT MAX(LogID) LogID
		FROM bodb_CustomerLog.dbo.[UserLog_RunSP] u WITH(NOLOCK) 
		WHERE  u.CustID=t.CustID AND u.ActionID IN (1105,1115,1142,1149) 
		) AS a (LogID)
		
		UPDATE t 
		SET Logid= a.LogID
		FROM TempClosedReasonMember t 
		CROSS APPLY (SELECT MAX(LogID) LogID
		FROM bodb_CustomerLog.dbo.[UserLog_RunSP] u WITH(NOLOCK) 
		WHERE  u.CustID=t.CustID AND u.ActionID IN (1105,1115,1142,1149) 
		) AS a (LogID)

		----update ClosedReason
		
		UPDATE t SET t.ClosedReason= CASE WHEN u.ActionID IN (1115,1149) OR u.TrackingValue like '%Closed="1"%' THEN 1 ELSE 0 END										 
		FROM TempClosedReason t 
		INNER JOIN bodb_CustomerLog.dbo.[UserLog_RunSP] u WITH(NOLOCK)  ON t.logid=u.logid

		UPDATE t SET t.ClosedReason= CASE WHEN u.ActionID IN (1115,1149) OR u.TrackingValue like '%Closed="1"%' THEN 1 ELSE 0 END										 
		FROM TempClosedReasonMember t 
		INNER JOIN bodb_CustomerLog.dbo.[UserLog_RunSP] u WITH(NOLOCK)  ON t.logid=u.logid


		