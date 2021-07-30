/*<info serverAlias="DBLIC-bodb_LicenseeReport"></info>*/
/*
	Created: 20210728@Kos
	DB: DBLIC-bodb_LicenseeReport
	Task: Generate data for temp table rptWinlostbyleague [Redmine: #151151]
*/

USE bodb_LicenseeReport
GO

EXEC Task_rptWinlostbyleague_Bettrans14 @Date = '2021-07-16 00:00:00'
GO