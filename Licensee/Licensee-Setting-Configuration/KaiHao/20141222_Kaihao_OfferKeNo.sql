 USE bodb_licensee
 GO
 /*
	Created by:  20141222@Jim
	Task: Kaihao - Setup Keno for this licensee (#27877)
	DB: DBLIC.bodb_licensee
	Revisions:
		
*/
 DECLARE @LicenseeId INT
		 ,@ProductId INT
SELECT @LicenseeId = LicenseeId
FROM dbo.Licensees WITH (NOLOCK)
WHERE LicenseeName = 'Kaihao'

SELECT @ProductId = ProductID
FROM dbo.Product3rd WITH (NOLOCK)
WHERE ProductName = 'Keno'

IF NOT EXISTS (SELECT 1 FROM dbo.LicenseeProduct3rd WITH (NOLOCK) WHERE LicenseeId = @LicenseeId AND ProductId = @ProductId)
BEGIN
	INSERT INTO dbo.LicenseeProduct3rd(LicenseeID
										,ProductID
										,Comm
										,Winloss
										,EffectiveDate
										)   
	SELECT  @LicenseeId AS LicenseeId
			,@ProductId AS ProductId
			,0			AS Comm
			,1 			AS Winloss
			,NULL  		AS EffectiveDate

END 
