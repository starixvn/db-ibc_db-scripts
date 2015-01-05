USE bodb_Licensee
GO
  /*
	Created: Jim
	Date: 2015-01-05
	Task:  Set up AG Casino for this licensee (#28179)
	DB:DBLIC/bodb_licensee
 */

EXEC dbo.DBA_EnableAGCasino 
	@LicenseeName = 'Aoncash'
	,@ProductName = 'AG Casino'
	,@SettingName = 'AGCasino_VersionKey'