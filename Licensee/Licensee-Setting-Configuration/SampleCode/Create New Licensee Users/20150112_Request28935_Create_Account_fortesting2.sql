USE bodb_licensee
  /*
	Task: LRF - Accounts for testing
	Create date: 2015-01-12
	Author: Jim.Tran
	Redmine'ID:#28939
	DB: DBLIC/bodb_Licensee
 */
EXEC [dbo].[DBA_CreateLicenseeUser]
	@LicenseeName  ='All',
	@Username ='pgmrafael',
	@FirstName ='pgmrafael',
	@PageAccess   = 'TotalBets,Forecast,Reports,ManageMember,DataWarehouse,CustomerReports,CustomerReports,AgencySystem',
	@Status   = 'Open' 
	