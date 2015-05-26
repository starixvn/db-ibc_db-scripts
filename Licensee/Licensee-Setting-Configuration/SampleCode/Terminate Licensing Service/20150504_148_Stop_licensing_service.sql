USE bodb_licensee
GO
/*
Redmine: #34908 : Licensee SiteID 148 - Stop licensing service
*/
EXEC [dbo].[DBA_Lrf_ActiveLicenseeSystem]
@LicenseeName  		='Tonybet'
,@SystemDeactivate    ='LRF'
GO
EXEC [dbo].[DBA_Lrf_ActiveLicenseeSystem]
@LicenseeName  		='Tonybet'
,@SystemDeactivate    ='Accounting'
GO
 
 