/*<info serverAlias="DBLIC-bodb_LicenseeReport"></info>*/
/*
	Created: 20251103@Kelvin
	DB: DBLIC-bodb_LicenseeReport
	Task : Re sum data rptLicWinloss2 [RedmineID: #243420]
*/

--DB052
USE bodb_LicenseeReport
GO

EXEC Task_DailyRptLicWinloss2 @WinLostDate = '2025-10-29'