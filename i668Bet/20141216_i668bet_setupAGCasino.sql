USE bodb_Licensee
GO
  /*
	Created: Jim
	Date: 2014-12-16
	Task:  Set up AG Casino for this licensee (#27719)
	DB:DBLIC/bodb_licensee
 */

EXEC dbo.DBA_EnableAGCasino 
	@LicenseeName = 'i668bet'
	,@ProductName = 'AG Casino'
	,@SettingName = 'AGCasino_VersionKey'