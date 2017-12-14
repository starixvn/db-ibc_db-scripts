Use bodb_licensee
GO

/*
Create : 20171106@Sophia
 Task : Add Func Licensee WinLoss By TimeZone  [redmine:#84932 ]

*/

SET IDENTITY_INSERT   Functions ON


INSERT INTO  Functions 
(FunctionId,
Name,
Description,
ParentId,
Url,
IsMenu,
IsActive,
DisplayOrder,
IsNew,
FunctionKey,
Environment,
IsFunction)
VALUES (76, 'Licensee WinLoss By Time Zone'
, '', 3,'LicenseeWinLossByTimeZoneReport',1,1,27,1,'LicenseeWinLossByTimeZone76','UAT',1)
  


  -----

  
DECLARE @FunctionId INT , @LicenseeID INT
Select @FunctionId = FunctionId FROM [Functions] (NOLOCK) WHERE FunctionKey = 'LicenseeWinLossByTimeZone76'


SELECT @LicenseeID = LicenseeID
FROM dbo.Licensees WITH (NOLOCK)
WHERE LicenseeName = '12bet'  
 
  
SELECT @FunctionID, @LicenseeID

INSERT INTO LicenseeFunctions (LicenseeId, FunctionId)
SELECT @LicenseeID, @FunctionID

INSERT INTO LicenseeUserFunctions(UserId, FunctionId, LicenseeId)
SELECT userid, @FunctionID, @LicenseeID
FROM LicenseeUser
WHERE LicenseeID = @LicenseeID
	AND UserID NOT IN (SELECT UserId FROM LicenseeUserFunctions WITH (NOLOCK) WHERE LicenseeId = @LicenseeID and FunctionId = @FunctionID)



	-------------
	
SELECT @LicenseeID = LicenseeID
FROM dbo.Licensees WITH (NOLOCK)
WHERE LicenseeName = 'keenOcean'  
 
  
SELECT @FunctionID, @LicenseeID

INSERT INTO LicenseeFunctions (LicenseeId, FunctionId)
SELECT @LicenseeID, @FunctionID

INSERT INTO LicenseeUserFunctions(UserId, FunctionId, LicenseeId)
SELECT userid, @FunctionID, @LicenseeID
FROM LicenseeUser
WHERE LicenseeID = @LicenseeID
	AND UserID NOT IN (SELECT UserId FROM LicenseeUserFunctions WITH (NOLOCK) WHERE LicenseeId = @LicenseeID and FunctionId = @FunctionID)
	AND UserID IN (Select userID  from Users Where isInternal = 0)
