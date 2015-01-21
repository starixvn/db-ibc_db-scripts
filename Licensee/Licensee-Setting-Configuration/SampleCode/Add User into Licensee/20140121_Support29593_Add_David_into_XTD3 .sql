USE bodb_licensee
GO
EXEC  [dbo].[DBA_Lrf_AddUserIntoLicensee]
  @LicenseeName = 'XTD3',
  @UserName	    = 'twDavid',	
  @isSpecialAdmin  = 0