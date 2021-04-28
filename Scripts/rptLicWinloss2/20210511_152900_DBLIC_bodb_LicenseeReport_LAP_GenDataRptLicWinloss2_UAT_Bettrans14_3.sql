/*<info serverAlias="DBLIC-bodb_LicenseeReport"></info>*/
/*
	Created: 20210511@Kos
	DB: DBLIC-bodb_LicenseeReport
	Task: Generate data for temp table rptLicWinloss2_UAT for testing [Redmine: #152900]
*/

USE bodb_LicenseeReport
GO

EXEC Task_rptLicWinloss2_UAT_Bettrans14 @FromDate = '2021-05-01 00:00:00', @ToDate = '2021-05-07 00:00:00'
GO