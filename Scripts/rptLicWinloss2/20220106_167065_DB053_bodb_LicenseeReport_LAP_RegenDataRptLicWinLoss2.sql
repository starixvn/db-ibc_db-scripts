/*<info serverAlias="DB053-bodb_LicenseeReport"></info>*/
/*
	Created: 20220106@Kos
	DB: DB053-bodb_LicenseeReport
	Task: Regen data bettrans14 range [Redmine: #167065]
*/

USE bodb_LicenseeReport
GO

EXEC Task_DailyRptLicWinloss2 @WinLostDate = '2021-12-24 00:00:00'
GO

EXEC Task_DailyRptLicWinloss2 @WinLostDate = '2021-12-25 00:00:00'
GO

EXEC Task_DailyRptLicWinloss2 @WinLostDate = '2021-12-26 00:00:00'
GO

EXEC Task_DailyRptLicWinloss2 @WinLostDate = '2021-12-27 00:00:00'
GO

EXEC Task_DailyRptLicWinloss2 @WinLostDate = '2021-12-28 00:00:00'
GO

EXEC Task_DailyRptLicWinloss2 @WinLostDate = '2021-12-29 00:00:00'
GO

EXEC Task_DailyRptLicWinloss2 @WinLostDate = '2021-12-30 00:00:00'
GO

EXEC Task_DailyRptLicWinloss2 @WinLostDate = '2021-12-31 00:00:00'
GO

EXEC Task_DailyRptLicWinloss2 @WinLostDate = '2022-01-01 00:00:00'
GO

EXEC Task_DailyRptLicWinloss2 @WinLostDate = '2022-01-02 00:00:00'
GO