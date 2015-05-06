
USE bodb_licensee
GO

EXEC DBPTCS.bodb_PlaytechCS.[dbo].[DBA_EnableAGCasinoService] @LicenseeName = 'BE7', @SettingName ='AGCasino_VersionKey'
GO	
EXEC DBPTCS.bodb_PlaytechCS.[dbo].[DBA_EnableGoldDeluxeService] @LicenseeName = 'BE7', @SettingName ='GoldDeluxe_VersionKey'

GO
EXEC [dbo].[DBA_Lrf_LaunchProduct]
	@LicenseeName 	='BE7',
	@ProductCode  	='AGC',
	@EffectiveDate	= '2015-04-28'
GO
EXEC [dbo].[DBA_Lrf_LaunchProduct]
	@LicenseeName 	='BE7',
	@ProductCode  	='GD',
	@EffectiveDate	= '2015-04-28'		
GO
EXEC [dbo].[DBA_Lrf_ActiveLicenseeSystem]
	@LicenseeName  		='BE7'
	,@SystemisActive    ='Accounting'	
	
	