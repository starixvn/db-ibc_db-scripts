/*<info serverAlias="DBARC-bodb_Archive"></info>*/
/*
	Created: 20210504@Kos
	DB: DBARC-bodb_Archive
	Task: Generate data for temp table rptLicWinloss2_UAT for testing - range bk [Redmine: #152900]
*/

USE bodb_Archive
GO

EXEC Task_rptLicWinloss2_UAT_BettransBK @FromDate = '2021-04-01 00:00:00', @ToDate = '2021-04-15 00:00:00'
GO