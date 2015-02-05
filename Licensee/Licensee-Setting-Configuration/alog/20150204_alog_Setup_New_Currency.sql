USE bodb_Licensee
GO
EXEC [dbo].[DBA_CreateLicenseeAgent]
@LicenseeName = 'alog',
@SuperWildCard = 'alogSuper%'
