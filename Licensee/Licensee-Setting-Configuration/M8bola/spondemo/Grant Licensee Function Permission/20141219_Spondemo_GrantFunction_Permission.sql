USE bodb_licensee
GO
/*
Created: 20141219@Jim
Task: Spondemo - Grant permission for Total Bet / Number Game (#27887)
DB: DBLIC/bodb_licensee
 

Revisions:    
  
*/
DECLARE @FunctionID INT
		,@LicenseeId INT
		
SELECT @FunctionId = FunctionId
FROM dbo.Functions WITH (NOLOCK) 
WHERE Name = 'Number Game'		

SELECT @LicenseeId = LicenseeId
FROM dbo.Licensees WITH (NOLOCK)
WHERE LicenseeName = 'Spondemo'

--LicenseeFunctions
DELETE FROM dbo.LicenseeFunctions WITH (ROWLOCK,UPDLOCK) 
WHERE LicenseeID = @LicenseeID AND FunctionId = @FunctionId

INSERT INTO dbo.LicenseeFunctions (licenseeID,FunctionId) 
SELECT @LicenseeID,@FunctionId

--LicenseeUserFunctions
DELETE FROM dbo.LicenseeUserFunctions WITH (ROWLOCK,UPDLOCK)
WHERE LicenseeId = @LicenseeID AND FunctionId = @FunctionId

INSERT INTO dbo.LicenseeUserFunctions(UserId,FunctionId,LicenseeId)
SELECT UserId,@FunctionId,@LicenseeID
FROM dbo.LicenseeUserFunctions WITH (NOLOCK)
WHERE LicenseeId  = @LicenseeID AND FunctionId = 1 --total bets

 