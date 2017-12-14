USE bodb_licensee
GO

/*
	Created:	20171214@Harper
	Support:	Enable Exchange product for list licensees: 'spondemo', '12bet', 'Alog'
*/

DECLARE @LicenseeID INT,
		@ResellerID INT,
		@n INT,@m INT
-- Licensee

DECLARE @tmpLicensee AS TABLE (ID INT IDENTITY(1,1), LicenseeID INT)
INSERT INTO @tmpLicensee (LicenseeID)
SELECT LicenseeID
FROM dbo.Licensees (NOLOCK)
WHERE LicenseeName IN ('spondemo', '12bet', 'Alog')
	
SELECT @n = 1
	  ,@m = MAX(ID) FROM @tmpLicensee
WHILE (@n <= @m)	  
BEGIN
	SELECT @LicenseeID = LicenseeID FROM @tmpLicensee WHERE ID = @n

	SELECT @ResellerID = ResellerID
	FROM dbo.LicenseeReseller WITH (NOLOCK)
	WHERE LicenseeID = @LicenseeID AND ResellerID <> 3 

	SELECT @LicenseeID LicenseeID ,	 @ResellerID ResellerID

	EXEC [dbo].[DBA_Lrf_OfferProduct]
		@ResellerID		= @ResellerID,
		@LicenseeId  	= @LicenseeID,
		@ProductCode  	= 'BX', -- Exchange
		@EffectiveDate	= ''

	SET @n = @n + 1 	
END
