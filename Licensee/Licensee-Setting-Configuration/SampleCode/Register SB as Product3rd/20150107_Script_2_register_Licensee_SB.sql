USE bodb_licensee
GO
/*
Created: 20150107@Jim
Task :  Enhance LRF to allow licensee that doesn't have Sportsbook
DB:     DBLIC/bodb_licensee
Original:
Revisions:
*/

DECLARE @i INT
	    ,@j INT 
		,@LicenseeId INT		
DECLARE @tblLicensee AS TABLE (ID INT IDENTITY(1,1),LicenseeId INT)

INSERT INTO @tblLicensee (LicenseeID)
SELECT LicenseeID
FROM dbo.Licensees WITH (NOLOCK) 
WHERE LicenseeName <> 'Doctorgame'
SELECT @i = 1
		,@j = MAX(ID)
FROM @tblLicensee 		
 WHILE (@i<= @j)
 BEGIN
	SELECT @LicenseeId = LicenseeId
	FROM  @tblLicensee 
	WHERE ID = @i
	IF NOT EXISTS (SELECT 1 FROM dbo.LicenseeProduct3rd  WITH (NOLOCK) WHERE LicenseeId = @LicenseeId AND ProductId = 0)
	BEGIN
		INSERT INTO dbo.LicenseeProduct3rd (LicenseeId,ProductId, Comm,Winloss,EffectiveDate)
		SELECT @LicenseeId 
				,0 AS ProductId
				,0 AS Comm
				,1 AS Winloss
				,NULL EffectiveDate
	END		
	SET @i = @i +1
 
 END
 