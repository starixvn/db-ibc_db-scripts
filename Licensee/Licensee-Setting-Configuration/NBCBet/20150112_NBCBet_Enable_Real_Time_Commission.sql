USE bodb_Licensee
GO
 /*
	Task: NBCBet - Enable Real Time Commission
	Create date: 2015-01-12
	Author: Jim.Tran
	Redmine'ID:#29085
	DB: DBLIC/bodb_Licensee
 */
EXEC [dbo].[DBA_Lrf_EnablePlayerComm]
	@LicenseeName  ='NBCBet'