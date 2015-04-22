-- Doctorgame

/*
RedmineID:#34393
Licensee SiteID 167 - Launch licensee officially
*/
USE bodb_licensee
GO
EXEC [dbo].[DBA_Lrf_LaunchLicensee]
	@LicenseeName = 'Doctorgame',
	@AffectedDate = '2015-04-15'
GO
EXEC [dbo].[DBA_Lrf_LaunchProduct]
	@LicenseeName   = 'Doctorgame',
	@ProductCode  	= 'LC',
	@EffectiveDate	= '2015-04-15'
GO
EXEC [dbo].[DBA_Lrf_LaunchProduct]
	@LicenseeName   = 'Doctorgame',
	@ProductCode  	= 'CS',
	@EffectiveDate	= '2015-04-15'
GO
EXEC [dbo].[DBA_Lrf_ActiveLicenseeSystem]
	@LicenseeName  	  = 'Doctorgame'
	,@SystemisActive  = 'Accounting'