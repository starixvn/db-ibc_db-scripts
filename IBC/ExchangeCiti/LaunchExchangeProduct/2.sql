USE bodb_licensee
GO

/*
	Created:	20171214@Harper
	Support:	Launch Exchange product for list licensees: 'spondemo', '12bet', 'Alog'
*/

DECLARE @LicenseeName VARCHAR(50),		
		@n INT,@m INT
-- Licensee

DECLARE @tmpLicensee AS TABLE (ID INT IDENTITY(1,1), LicenseeID INT, LicenseeName VARCHAR(50))
INSERT INTO @tmpLicensee (LicenseeID, LicenseeName)
SELECT LicenseeID, LicenseeName
FROM dbo.Licensees (NOLOCK)
WHERE LicenseeName IN ('spondemo','12bet','Alog')
	
SELECT @n = 1
	  ,@m = MAX(ID) FROM @tmpLicensee
WHILE (@n <= @m)	  
BEGIN
	SELECT @LicenseeName = LicenseeName FROM @tmpLicensee WHERE ID = @n		

	EXEC dbo.DBA_Lrf_LaunchProduct 
	@LicenseeName = @LicenseeName, 
    @ProductCode = 'BX', 
    @EffectiveDate = '2017-12-01' 
	
	EXEC dbo.DBA_Lrf_ActiveLicenseeSystem 
	@LicenseeName = @LicenseeName, 
    @SystemisActive = 'Accounting'

	SET @n = @n + 1 	
END
