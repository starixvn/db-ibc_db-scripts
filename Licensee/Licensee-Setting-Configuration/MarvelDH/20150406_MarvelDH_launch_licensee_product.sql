--- MarvelDH
/*
RedmineID:#33579
Licensee site 146 - Launch of new licensee
*/
USE bodb_licensee
Go
EXEC [dbo].[DBA_Lrf_LaunchLicensee]
	@LicenseeName = 'MarvelDH',
	@AffectedDate ='2015-03-25'
GO
EXEC [dbo].[DBA_Lrf_LaunchProduct]
	@LicenseeName 	  ='MarvelDH',
	@ProductCode   	  ='NG',
	@EffectiveDate	  ='2015-03-25'
GO
EXEC [dbo].[DBA_Lrf_LaunchProduct]
	@LicenseeName 	 ='MarvelDH',
	@ProductCode  	 ='BA',
	@EffectiveDate	 ='2015-03-25'
GO
EXEC [dbo].[DBA_Lrf_LaunchProduct]
	@LicenseeName 	='MarvelDH',
	@ProductCode  	='VS',
	@EffectiveDate	='2015-03-25'
GO
EXEC [dbo].[DBA_Lrf_LaunchProduct]
	@LicenseeName 	='MarvelDH',
	@ProductCode  	='CS',
	@EffectiveDate	='2015-03-25'
GO
EXEC [dbo].[DBA_Lrf_LaunchProduct]
	@LicenseeName 	='MarvelDH',
	@ProductCode  	='LC',
	@EffectiveDate	='2015-03-25'
GO
EXEC [dbo].[DBA_Lrf_ActiveLicenseeSystem]
	@LicenseeName  		='MarvelDH'
	,@SystemisActive    ='Accounting'
	
	