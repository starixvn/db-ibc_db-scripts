/*<info serverAlias="DBLIC-bodb_LicenseeReport"></info>*/
/*
	Create: 20220707@Sol
	Task: re-gen data by insert into TicketVoiding_RoutineTasks table - [Redmine: #175167] 
	DB: DBLIC-bodb_LicenseeReport
*/ 
 
USE bodb_LicenseeReport;

GO 

---winlostdate = '2022-06-30 00:00:00.000'
DECLARE @WinlostDate DATETIME = '2022-06-30 00:00:00.000'

EXEC bodb_LicenseeReport.dbo.Task_DailyRptLicWinloss2 @winlostdate = @WinlostDate
EXEC bodb_LicenseeReport.dbo.Task_DailyRptLicWinlossGMT_Bettrans14 @FromDate = @winlostdate

GO

---winlostdate = '2022-07-01 00:00:00.000'
DECLARE @WinlostDate DATETIME = '2022-07-01 00:00:00.000'

EXEC bodb_LicenseeReport.dbo.Task_DailyRptLicWinloss2 @winlostdate = @WinlostDate
EXEC bodb_LicenseeReport.dbo.Task_DailyRptLicWinlossGMT_Bettrans14 @FromDate = @winlostdate

GO

---winlostdate = '2022-07-02 00:00:00.000'
DECLARE @WinlostDate DATETIME = '2022-07-02 00:00:00.000'

EXEC bodb_LicenseeReport.dbo.Task_DailyRptLicWinloss2 @winlostdate = @WinlostDate
EXEC bodb_LicenseeReport.dbo.Task_DailyRptLicWinlossGMT_Bettrans14 @FromDate = @winlostdate

GO

---winlostdate = '2022-07-03 00:00:00.000'
DECLARE @WinlostDate DATETIME = '2022-07-03 00:00:00.000'

EXEC bodb_LicenseeReport.dbo.Task_DailyRptLicWinloss2 @winlostdate = @WinlostDate
EXEC bodb_LicenseeReport.dbo.Task_DailyRptLicWinlossGMT_Bettrans14 @FromDate = @winlostdate

GO