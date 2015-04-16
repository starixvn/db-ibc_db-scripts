--- M8bola
/*
RedmineID:#33973
Licensee Site ID 134 - Launch AG Casino product
*/
USE bodb_licensee

GO
EXEC [dbo].[DBA_Lrf_LaunchProduct]
	@LicenseeName 	  ='M8bola',
	@ProductCode   	  ='AGC',
	@EffectiveDate	  ='2015-04-07'
GO
EXEC [dbo].[DBA_Lrf_ActiveLicenseeSystem]
	@LicenseeName  		='M8bola'
	,@SystemisActive    ='Accounting'	
	
	
	