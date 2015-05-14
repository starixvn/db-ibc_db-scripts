USE bodb_Licensee
GO
EXEC [dbo].[DBA_CreateLicenseeAgent]
@LicenseeName = 'TLC',
@SuperWildCard = 'TLCSuper%'