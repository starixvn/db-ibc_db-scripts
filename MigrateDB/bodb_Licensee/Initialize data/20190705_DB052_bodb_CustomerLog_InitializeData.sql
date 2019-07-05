USE bodb_CustomerLog
GO

/*
	Created: 20190705@Percy
	DB: DBLOG.bodb_CustomerLog
	Task: Initialize data of log
*/

-- 3 LA_ tables + 4 OAS_ tables = 7 tables

-- 1
DELETE TABLE dbo.LA_UserLog_RunSP WITH (ROWLOCK, UPDLOCK)
GO

INSERT INTO dbo.LA_UserLog_RunSP (LogID,UserID,SPName,Doing,LogDate,CustID,ActionID,TrackingValue,Duration,TrackingValue2)
SELECT LogID,UserID,SPName,Doing,LogDate,CustID,ActionID,TrackingValue,Duration,TrackingValue2
FROM bodb_Licensee.dbo.OA_UserLog_RunSP WITH (NOLOCK)
GO

-- 2
DELETE TABLE dbo.LA_LogAction WITH (ROWLOCK, UPDLOCK)
GO

INSERT INTO dbo.LA_LogAction (ActionID,ActionTypeID,SPName,ActionNameEN,ActionNameCH,ActionNameCS,ActionNameJP,ActionNameIT,ActionNameTH,ActionNameKO,XsltContent,IsInternal)
SELECT ActionID,ActionTypeID,SPName,ActionNameEN,ActionNameCH,ActionNameCS,ActionNameJP,ActionNameIT,ActionNameTH,ActionNameKO,XsltContent,IsInternal
FROM bodb_Licensee.dbo.OA_LogAction WITH (NOLOCK)
WHERE SPName NOT LIKE 'OA_%'
GO

-- 3
DELETE TABLE dbo.LA_LogActionType WITH (ROWLOCK, UPDLOCK)
GO

INSERT INTO dbo.LA_LogActionType (ActionTypeID,ActionTypeNameEN,ActionTypeNameCH,ActionTypeNameCS,ActionTypeNameJP,ActionTypeNameIT,ActionTypeNameTH,ActionTypeNameKO)
SELECT ActionTypeID,ActionTypeNameEN,ActionTypeNameCH,ActionTypeNameCS,ActionTypeNameJP,ActionTypeNameIT,ActionTypeNameTH,ActionTypeNameKO
FROM bodb_Licensee.dbo.OA_LogActionType WITH (NOLOCK)
GO

-- 4
DELETE TABLE dbo.OAS_UserLog_RunSP WITH (ROWLOCK, UPDLOCK)
GO

INSERT INTO dbo.OAS_UserLog_RunSP (LogID,UserID,SPName,Doing,LogDate,CustID,ActionID,TrackingValue,Duration,TrackingValue2)
SELECT LogID,UserID,SPName,Doing,LogDate,CustID,ActionID,TrackingValue,Duration,TrackingValue2
FROM bodb_Licensee.dbo.OAS_UserLog_RunSP WITH (NOLOCK)
GO

-- 5
DELETE TABLE dbo.OAS_UserLog_Login WITH (ROWLOCK, UPDLOCK)
GO

INSERT INTO dbo.OAS_UserLog_Login (LogID,UserID,IP,LogDate,Doing,DomainName,BrowserName,Platform,CountryCode,Duration)
SELECT LogID,UserID,IP,LogDate,Doing,DomainName,BrowserName,Platform,CountryCode,Duration
FROM bodb_Licensee.dbo.OAS_UserLog_Login WITH (NOLOCK)
GO

-- 6
DELETE TABLE dbo.OAS_LogAction WITH (ROWLOCK, UPDLOCK)
GO

INSERT INTO dbo.OAS_LogAction (ActionID,ActionTypeID,SPName,ActionNameEN,ActionNameCH,ActionNameCS,ActionNameJP,ActionNameIT,ActionNameTH,ActionNameKO,XsltContent,IsInternal)
SELECT ActionID,ActionTypeID,SPName,ActionNameEN,ActionNameCH,ActionNameCS,ActionNameJP,ActionNameIT,ActionNameTH,ActionNameKO,XsltContent,IsInternal
FROM bodb_Licensee.dbo.OAS_LogAction WITH (NOLOCK)
GO

-- 7
DELETE TABLE dbo.OAS_LogActionType WITH (ROWLOCK, UPDLOCK)
GO

INSERT INTO dbo.OAS_LogActionType(ActionTypeID,ActionTypeNameEN,ActionTypeNameCH,ActionTypeNameCS,ActionTypeNameJP,ActionTypeNameIT,ActionTypeNameTH,ActionTypeNameKO)
SELECT ActionTypeID,ActionTypeNameEN,ActionTypeNameCH,ActionTypeNameCS,ActionTypeNameJP,ActionTypeNameIT,ActionTypeNameTH,ActionTypeNameKO
FROM bodb_Licensee.dbo.OAS_LogActionType WITH (NOLOCK)
GO
