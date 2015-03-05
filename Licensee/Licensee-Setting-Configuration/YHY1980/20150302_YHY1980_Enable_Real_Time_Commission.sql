USE bodb_Licensee
GO
 /*
	Task: NBCBet - Enable Real Time Commission
	Create date: 2015-02-03
	Author: Jim.Tran
	Redmine'ID:#31507
	DB: DBLIC/bodb_Licensee
 */
EXEC [dbo].[DBA_Lrf_EnablePlayerComm]
	@LicenseeName  ='YHY1980'