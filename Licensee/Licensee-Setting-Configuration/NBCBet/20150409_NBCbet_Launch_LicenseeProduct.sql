--- NBCbet
/*
RedmineID:#33890
Licensee Site ID 158 - Launch licensee officially
*/
USE bodb_licensee
Go
EXEC [dbo].[DBA_Lrf_LaunchLicensee]
	@LicenseeName = 'NBCbet',
	@AffectedDate ='2015-01-28'
GO
EXEC [dbo].[DBA_Lrf_LaunchProduct]
	@LicenseeName 	  ='NBCbet',
	@ProductCode   	  ='NG',
	@EffectiveDate	  ='2015-01-28'
GO
EXEC [dbo].[DBA_Lrf_LaunchProduct]
	@LicenseeName 	 ='NBCbet',
	@ProductCode  	 ='LC',
	@EffectiveDate	 ='2015-01-28'
GO
EXEC [dbo].[DBA_Lrf_LaunchProduct]
	@LicenseeName 	='NBCbet',
	@ProductCode  	='CS',
	@EffectiveDate	='2015-01-28'
GO
EXEC [dbo].[DBA_Lrf_LaunchProduct]
	@LicenseeName 	='NBCbet',
	@ProductCode  	='VS',
	@EffectiveDate	='2015-01-28'
	
	
	
	