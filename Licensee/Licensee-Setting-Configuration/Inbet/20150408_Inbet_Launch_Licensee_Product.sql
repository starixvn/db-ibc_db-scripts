--- Inbet
/*
RedmineID:#32853
Licensee site ID 160 - Official launch
*/
USE bodb_licensee
Go
EXEC [dbo].[DBA_Lrf_LaunchLicensee]
	@LicenseeName = 'Inbet',
	@AffectedDate ='2015-03-20'
GO
EXEC [dbo].[DBA_Lrf_LaunchProduct]
	@LicenseeName 	  ='Inbet',
	@ProductCode   	  ='NG',
	@EffectiveDate	  ='2015-03-20'
GO
EXEC [dbo].[DBA_Lrf_LaunchProduct]
	@LicenseeName 	 ='Inbet',
	@ProductCode  	 ='BA',
	@EffectiveDate	 ='2015-03-20'
GO
EXEC [dbo].[DBA_Lrf_LaunchProduct]
	@LicenseeName 	='Inbet',
	@ProductCode  	='VS',
	@EffectiveDate	='2015-03-20'

	
	