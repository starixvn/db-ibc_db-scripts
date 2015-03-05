USE bodb_licensee
GO
DECLARE @LicenseeId INT
		,@ResellerID INT

SELECT @LicenseeiD = LicenseeId
FROM dbo.Licensees WITH (NOLOCK)
WHERE LicenseeName ='RYB95'	

SELECT @ResellerID = ResellerID
FROM dbo.LicenseeReseller  WITH (NOLOCK)
WHERE LicenseeId = @LicenseeId
	 AND ResellerID <> 3 -- startlit
 
SELECT @LicenseeId LicenseeID ,	 @ResellerID ResellerID

EXEC [dbo].[DBA_Lrf_OfferProduct]
	@ResellerID		= @ResellerID,
	@LicenseeId  	= @LicenseeId,
	@ProductCode  	='KN',
	@EffectiveDate	=''
	
GO

	