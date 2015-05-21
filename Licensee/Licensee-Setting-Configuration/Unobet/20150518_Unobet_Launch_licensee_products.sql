--- Unobet
/*
RedmineID: #35742
Licensee Site ID 170 - Launch licensee officially
*/
USE bodb_licensee
Go
EXEC [dbo].[DBA_Lrf_LaunchLicensee]
	@LicenseeName = 'Unobet',
	@AffectedDate ='2015-05-11'
GO
EXEC [dbo].[DBA_Lrf_LaunchProduct]
	@LicenseeName 	  ='Unobet',
	@ProductCode   	  ='VS',
	@EffectiveDate	  ='2015-05-11'
GO
EXEC [dbo].[DBA_Lrf_LaunchProduct]
	@LicenseeName 	 ='Unobet',
	@ProductCode  	 ='BA',
	@EffectiveDate	 ='2015-05-11'
GO
EXEC [dbo].[DBA_Lrf_LaunchProduct]
	@LicenseeName 	='Unobet',
	@ProductCode  	='NG',
	@EffectiveDate	='2015-05-11'

GO
EXEC [dbo].[DBA_Lrf_LaunchProduct]
	@LicenseeName 	='Unobet',
	@ProductCode  	='LC',
	@EffectiveDate	='2015-05-11'	
GO
EXEC [dbo].[DBA_Lrf_LaunchProduct]
	@LicenseeName 	='Unobet',
	@ProductCode  	='CS',
	@EffectiveDate	='2015-05-11'	
GO
EXEC [dbo].[DBA_Lrf_LaunchProduct]
	@LicenseeName 	='Unobet',
	@ProductCode  	='KN',
	@EffectiveDate	='2015-05-11'		
GO
EXEC [dbo].[DBA_Lrf_ActiveLicenseeSystem]
	@LicenseeName  	  = 'Unobet'
	,@SystemisActive  = 'Accounting'		