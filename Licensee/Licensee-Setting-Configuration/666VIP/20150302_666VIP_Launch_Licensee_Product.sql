
USE bodb_licensee
GO
EXEC [dbo].[DBA_Lrf_LaunchProduct]
@LicenseeName ='666VIP',
@ProductCode  	 ='NG',
@EffectiveDate	  ='2015-02-24'
GO
EXEC [dbo].[DBA_Lrf_LaunchProduct]
@LicenseeName ='666VIP',
@ProductCode  	 ='LC',
@EffectiveDate	  ='2015-02-24'
GO
EXEC [dbo].[DBA_Lrf_LaunchProduct]
@LicenseeName ='666VIP',
@ProductCode  	 ='CS',
@EffectiveDate	  ='2015-02-24'
GO
EXEC [dbo].[DBA_Lrf_LaunchProduct]
@LicenseeName ='666VIP',
@ProductCode  	 ='VS',
@EffectiveDate	  ='2015-02-24'
GO
EXEC [dbo].[DBA_Lrf_LaunchProduct]
@LicenseeName ='666VIP',
@ProductCode  	 ='BA',
@EffectiveDate	  ='2015-02-24'
GO
EXEC [dbo].[DBA_Lrf_ActiveLicenseeSystem]
@LicenseeName  		='666VIP'
,@SystemisActive    ='Accounting'