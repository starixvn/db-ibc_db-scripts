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

/* =============================================== */

INSERT INTO dbo.LA_LogAction (ActionID,ActionTypeID,SPName,ActionNameEN,ActionNameCH,ActionNameCS,ActionNameJP,ActionNameIT,ActionNameTH,ActionNameKO,XsltContent,IsInternal)
SELECT ActionID,ActionTypeID,SPName,ActionNameEN,ActionNameCH,ActionNameCS,ActionNameJP,ActionNameIT,ActionNameTH,ActionNameKO,XsltContent,IsInternal
FROM bodb_Licensee.dbo.OA_LogAction WITH (NOLOCK)
WHERE SPName NOT LIKE 'OA_%'
GO

INSERT INTO dbo.LA_LogActionType (ActionTypeID,ActionTypeNameEN,ActionTypeNameCH,ActionTypeNameCS,ActionTypeNameJP,ActionTypeNameIT,ActionTypeNameTH,ActionTypeNameKO)
SELECT ActionTypeID,ActionTypeNameEN,ActionTypeNameCH,ActionTypeNameCS,ActionTypeNameJP,ActionTypeNameIT,ActionTypeNameTH,ActionTypeNameKO
FROM bodb_Licensee.dbo.OA_LogActionType WITH (NOLOCK)
GO
 
 
INSERT INTO dbo.OAS_LogAction (ActionID,ActionTypeID,SPName,ActionNameEN,ActionNameCH,ActionNameCS,ActionNameJP,ActionNameIT,ActionNameTH,ActionNameKO,XsltContent,IsInternal)
SELECT ActionID,ActionTypeID,SPName,ActionNameEN,ActionNameCH,ActionNameCS,ActionNameJP,ActionNameIT,ActionNameTH,ActionNameKO,XsltContent,IsInternal
FROM bodb_Licensee.dbo.OAS_LogAction WITH (NOLOCK)
GO

INSERT INTO dbo.OAS_LogActionType(ActionTypeID,ActionTypeNameEN,ActionTypeNameCH,ActionTypeNameCS,ActionTypeNameJP,ActionTypeNameIT,ActionTypeNameTH,ActionTypeNameKO)
SELECT ActionTypeID,ActionTypeNameEN,ActionTypeNameCH,ActionTypeNameCS,ActionTypeNameJP,ActionTypeNameIT,ActionTypeNameTH,ActionTypeNameKO
FROM bodb_Licensee.dbo.OAS_LogActionType WITH (NOLOCK)
GO