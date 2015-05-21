--- 

/*
RedmineID:#35003
Licensee SiteID 30 - Launch GD Casino
*/

USE bodb_licensee
GO
 
EXEC [dbo].[DBA_Lrf_LaunchProduct]
	@LicenseeName 	  ='12bet',
	@ProductCode   	  ='GD',
	@EffectiveDate	  ='2015-04-21'
GO
EXEC [dbo].[DBA_Lrf_ActiveLicenseeSystem]
	@LicenseeName  		='12bet'
	,@SystemisActive    ='Accounting'