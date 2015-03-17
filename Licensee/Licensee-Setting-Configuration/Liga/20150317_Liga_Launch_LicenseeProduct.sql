/*
RedmineID:#31598
Licensee site ID 168 - Official launch
*/
USE bodb_licensee
Go
EXEC [dbo].[DBA_Lrf_LaunchLicensee]
	@LicenseeName = 'Liga',
	@AffectedDate = '2015-03-12'
GO
EXEC [dbo].[DBA_Lrf_LaunchProduct]
	@LicenseeName   = 'Liga',
	@ProductCode    = 'NG',
	@EffectiveDate  = '2015-03-12'
GO
EXEC [dbo].[DBA_Lrf_LaunchProduct]
	@LicenseeName   = 'Liga',
	@ProductCode  	= 'LC',
	@EffectiveDate	= '2015-03-12'
GO
EXEC [dbo].[DBA_Lrf_LaunchProduct]
	@LicenseeName   = 'Liga',
	@ProductCode  	= 'CS',
	@EffectiveDate	= '2015-03-12'
GO
EXEC [dbo].[DBA_Lrf_LaunchProduct]
	@LicenseeName  = 'Liga',
	@ProductCode   = 'VS',
	@EffectiveDate = '2015-03-12'
GO
EXEC [dbo].[DBA_Lrf_ActiveLicenseeSystem]
	@LicenseeName  	  = 'Liga'
	,@SystemisActive  = 'Accounting'