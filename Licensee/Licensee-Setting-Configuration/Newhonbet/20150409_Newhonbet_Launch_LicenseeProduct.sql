--- Newhonbet
/*
RedmineID:#33974
Licensee Site ID 173 - Launch licensee officially
*/
USE bodb_licensee
Go
EXEC [dbo].[DBA_Lrf_LaunchLicensee]
	@LicenseeName = 'Newhonbet',
	@AffectedDate = '2015-04-08'
GO
EXEC [dbo].[DBA_Lrf_LaunchProduct]
	@LicenseeName 	  ='Newhonbet',
	@ProductCode   	  ='NG',
	@EffectiveDate	  ='2015-04-08'
GO
EXEC [dbo].[DBA_Lrf_LaunchProduct]
	@LicenseeName 	 ='Newhonbet',
	@ProductCode  	 ='LC',
	@EffectiveDate	 ='2015-04-08'
GO
EXEC [dbo].[DBA_Lrf_LaunchProduct]
	@LicenseeName 	='Newhonbet',
	@ProductCode  	='CS',
	@EffectiveDate	='2015-04-08'
GO
EXEC [dbo].[DBA_Lrf_LaunchProduct]
	@LicenseeName 	='Newhonbet',
	@ProductCode  	='VS',
	@EffectiveDate	='2015-04-08'
GO
EXEC [dbo].[DBA_Lrf_LaunchProduct]
	@LicenseeName 	='Newhonbet',
	@ProductCode  	='KN',
	@EffectiveDate	='2015-04-08'
	
GO
EXEC [dbo].[DBA_Lrf_ActiveLicenseeSystem]
	@LicenseeName  		='Newhonbet'
	,@SystemisActive    ='Accounting'	
	
	
	