/*<info serverAlias="DBLIC-bodb_LicenseeReport"></info>*/
/*
	Created: 20211214@Danny
	DB: DBLIC-bodb_LicenseeReport
	Task: Regen data
*/
USE bodb_LicenseeReport
--GO
--EXEC Task_rptBetting_CheckData_Job @FromDate = '2021-12-06', @ToDate = '2021-12-07', @Step = 0,  @AllowCorrect = 1

--GO
--EXEC Task_rptBetting_CheckData_Job @FromDate = '2021-12-09', @ToDate = '2021-12-10', @Step = 0,  @AllowCorrect = 1

EXEC Task_rptBetting_CheckData_Job @FromDate = '2021-12-10', @ToDate = '2021-12-10', @Step = 0,  @AllowCorrect = 1
