--- 9bet
/*
RedmineID:#32853
Licensee 98 - AG Casino officially launch
*/
---9bet
USE bodb_licensee
GO
EXEC [dbo].[DBA_Lrf_LaunchProduct]
	@LicenseeName 	  ='9bet',
	@ProductCode   	  ='AGC',
	@EffectiveDate	  ='2015-03-03'
GO
EXEC [dbo].[DBA_Lrf_ActiveLicenseeSystem]
	@LicenseeName  		='9bet'
	,@SystemisActive    ='Accounting'