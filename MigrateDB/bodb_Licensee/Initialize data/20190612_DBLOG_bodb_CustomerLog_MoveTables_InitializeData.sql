USE bodb_CustomerLog
GO

/*
	Created: 20190510@Percy
	DB: DBLOG.bodb_CustomerLog
	Task: Initialize data of log
*/

INSERT INTO dbo.LA_UserLog_RunSP (LogID,UserID,SPName,Doing,LogDate,CustID,ActionID,TrackingValue,Duration,TrackingValue2)
SELECT LogID,UserID,SPName,Doing,LogDate,CustID,ActionID,TrackingValue,Duration,TrackingValue2
FROM bodb_Licensee.dbo.OA_UserLog_RunSP WITH (NOLOCK)
GO



INSERT INTO dbo.OAS_UserLog_RunSP (LogID,UserID,SPName,Doing,LogDate,CustID,ActionID,TrackingValue,Duration,TrackingValue2)
SELECT LogID,UserID,SPName,Doing,LogDate,CustID,ActionID,TrackingValue,Duration,TrackingValue2
FROM bodb_Licensee.dbo.OAS_UserLog_RunSP WITH (NOLOCK)
GO



INSERT INTO dbo.OAS_UserLog_Login (LogID,UserID,IP,LogDate,Doing,DomainName,BrowserName,Platform,CountryCode,Duration)
SELECT LogID,UserID,IP,LogDate,Doing,DomainName,BrowserName,Platform,CountryCode,Duration
FROM bodb_Licensee.dbo.OAS_UserLog_Login WITH (NOLOCK)
GO