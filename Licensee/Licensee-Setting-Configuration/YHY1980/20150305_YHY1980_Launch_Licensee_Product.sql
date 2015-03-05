/*
RedmineID:#31598
Licensee site ID 168 - Official launch
*/
USE bodb_licensee
Go
EXEC [dbo].[DBA_Lrf_LaunchLicensee]
	@LicenseeName = 'YHY1980',
	@AffectedDate ='2015-03-02'
GO
EXEC [dbo].[DBA_Lrf_LaunchProduct]
	@LicenseeName ='YHY1980',
	@ProductCode  	 ='NG',
	@EffectiveDate	  ='2015-03-02'
GO
EXEC [dbo].[DBA_Lrf_LaunchProduct]
	@LicenseeName ='YHY1980',
	@ProductCode  	 ='LC',
	@EffectiveDate	  ='2015-03-02'
GO
EXEC [dbo].[DBA_Lrf_LaunchProduct]
	@LicenseeName ='YHY1980',
	@ProductCode  	 ='CS',
	@EffectiveDate	  ='2015-03-02'
GO
EXEC [dbo].[DBA_Lrf_LaunchProduct]
	@LicenseeName ='YHY1980',
	@ProductCode  	 ='VS',
	@EffectiveDate	  ='2015-03-02'
GO
EXEC [dbo].[DBA_Lrf_ActiveLicenseeSystem]
	@LicenseeName  		='YHY1980'
	,@SystemisActive    ='Accounting'