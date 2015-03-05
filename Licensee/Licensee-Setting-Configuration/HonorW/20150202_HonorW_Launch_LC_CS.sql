USE bodb_licensee
GO
EXEC [dbo].[DBA_Lrf_LaunchProduct]
@LicenseeName ='HonorW',
@ProductCode  	 ='LC',
@EffectiveDate	  ='2015-01-23'
GO

EXEC [dbo].[DBA_Lrf_LaunchProduct]
@LicenseeName ='HonorW',
@ProductCode  	 ='CS',
@EffectiveDate	  ='2015-01-23'

