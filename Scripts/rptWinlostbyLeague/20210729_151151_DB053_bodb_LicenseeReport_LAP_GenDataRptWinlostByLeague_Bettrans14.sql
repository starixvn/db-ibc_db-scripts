/*<info serverAlias="DB053-bodb_LicenseeReport"></info>*/
/*
	Created: 20210729@Kos
	DB: DB053-bodb_LicenseeReport
	Task: Generate data for temp table rptWinlostbyleague [Redmine: #151151]
*/

USE bodb_LicenseeReport
GO

EXEC Task_rptWinlostbyleague_Bettrans14 @Date = '2021-07-16 00:00:00'
GO