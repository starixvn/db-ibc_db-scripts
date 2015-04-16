--- Newhonbet
/*
RedmineID:#34472
Licensee Site ID 173 - Enable BA
*/
USE bodb_licensee
GO
DECLARE @LicenseeId INT
		,@ResellerID INT

SELECT @LicenseeiD = LicenseeId
FROM dbo.Licensees WITH (NOLOCK)
WHERE LicenseeName ='Newhonbet'	
 
SELECT @ResellerID = ResellerID
FROM dbo.LicenseeReseller  WITH (NOLOCK)
WHERE LicenseeId = @LicenseeId
	 AND ResellerID = 3 -- startlit
 
SELECT @LicenseeId LicenseeID ,	 @ResellerID ResellerID

EXEC [dbo].[DBA_Lrf_OfferProduct]
	@ResellerID		= @ResellerID,
	@LicenseeId  	= @LicenseeId,
	@ProductCode  	='BA',
	@EffectiveDate	='2015-04-16'
GO
EXEC [dbo].[DBA_Lrf_ActiveLicenseeSystem]
	@LicenseeName  	  = 'Newhonbet'
	,@SystemisActive  = 'Accounting'

	
	