--- Q8bola
/*
RedmineID:#34153
Licensee site 143 - Enable BA on approriate site
*/
USE bodb_licensee
GO 
EXEC [dbo].[DBA_Lrf_LaunchProduct]
	@LicenseeName 	  ='Q8bola',
	@ProductCode   	  ='BA',
	@EffectiveDate	  ='2014-09-01'
GO
 
EXEC [dbo].[DBA_Lrf_ActiveLicenseeSystem]
	@LicenseeName  		='Q8bola'
	,@SystemisActive    ='Accounting'	
	
	
	

	
	