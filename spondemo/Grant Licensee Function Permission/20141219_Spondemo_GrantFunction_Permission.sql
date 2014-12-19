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

IF NOT EXISTS (SELECT 1 FROM dbo.LicenseeFunctions WITH (NOLOCK) WHERE LicenseeId = @LicenseeId AND FunctionId = @FunctionId)
	BEGIN
		INSERT INTO dbo.LicenseeFunctions (LicenseeID,FunctionId)
		SELECT @LicenseeId,@FunctionId
	END
	