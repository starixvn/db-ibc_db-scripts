---  
/*
RedmineID: #33263
Licensee	SiteId
Bet2day		103
Allbetclub	132
Hbobet		121
Mgm88		120
THBET		136
Winner99	106
				Launch VS
*/
USE bodb_licensee
GO
---- Launch Virtual Sports
EXEC [dbo].[DBA_Lrf_LaunchProduct]
	@LicenseeName 	  ='Bet2day',
	@ProductCode   	  ='VS',
	@EffectiveDate	  ='2015-03-27'
GO
EXEC [dbo].[DBA_Lrf_LaunchProduct]
	@LicenseeName 	  ='Allbetclub',
	@ProductCode   	  ='VS',
	@EffectiveDate	  ='2015-03-27'
GO
EXEC [dbo].[DBA_Lrf_LaunchProduct]
	@LicenseeName 	  ='Hbobet',
	@ProductCode   	  ='VS',
	@EffectiveDate	  ='2015-03-27'
GO
EXEC [dbo].[DBA_Lrf_LaunchProduct]
	@LicenseeName 	  ='Mgm88',
	@ProductCode   	  ='VS',
	@EffectiveDate	  ='2015-03-27'		
GO
EXEC [dbo].[DBA_Lrf_LaunchProduct]
	@LicenseeName 	  ='THBET',
	@ProductCode   	  ='VS',
	@EffectiveDate	  ='2015-03-27'	
GO
EXEC [dbo].[DBA_Lrf_LaunchProduct]
	@LicenseeName 	  ='Winner99',
	@ProductCode   	  ='VS',
	@EffectiveDate	  ='2015-03-27'		
----- Enable in Accounting Site
GO
EXEC [dbo].[DBA_Lrf_ActiveLicenseeSystem]
	@LicenseeName  		='Bet2day'
	,@SystemisActive    ='Accounting'
GO
EXEC [dbo].[DBA_Lrf_ActiveLicenseeSystem]
	@LicenseeName  		='Allbetclub'
	,@SystemisActive    ='Accounting'	
GO
EXEC [dbo].[DBA_Lrf_ActiveLicenseeSystem]
	@LicenseeName  		='Hbobet'
	,@SystemisActive    ='Accounting'
GO
EXEC [dbo].[DBA_Lrf_ActiveLicenseeSystem]
	@LicenseeName  		='Mgm88'
	,@SystemisActive    ='Accounting'
GO
EXEC [dbo].[DBA_Lrf_ActiveLicenseeSystem]
	@LicenseeName  		='THBET'
	,@SystemisActive    ='Accounting'
GO
EXEC [dbo].[DBA_Lrf_ActiveLicenseeSystem]
	@LicenseeName  		='Winner99'
	,@SystemisActive    ='Accounting'
	
		
	