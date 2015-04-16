USE bodb_licensee
GO
EXEC  [dbo].[DBA_Lrf_AddUserIntoLicensee]
  @LicenseeName = 'spondemo',
  @UserName	    = 'autoQC1',	
  @isSpecialAdmin  = 0