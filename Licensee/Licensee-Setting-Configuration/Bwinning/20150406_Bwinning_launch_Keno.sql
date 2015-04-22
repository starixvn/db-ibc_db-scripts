--- Bwinning
/*
RedmineID:#33495
Licensee Site ID 57 - Launch Keno product
*/
USE bodb_licensee
GO
EXEC [dbo].[DBA_Lrf_LaunchProduct]
	@LicenseeName 	  ='Bwinning',
	@ProductCode   	  ='KN',
	@EffectiveDate	  ='2015-04-01'
GO
EXEC [dbo].[DBA_Lrf_ActiveLicenseeSystem]
	@LicenseeName  		='MarvelDH'
	,@SystemisActive    ='Accounting'
	
	