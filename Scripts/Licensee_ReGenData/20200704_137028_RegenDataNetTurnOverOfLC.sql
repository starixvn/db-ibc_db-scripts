 /*<info serverAlias="DBLIC-bodb_LicenseeReport"></info>*/
USE [bodb_LicenseeReport]
GO

/*
Create : 20200704@Sophia 
Regen data of LC NetTurnOver by Data Patch on 2002-06-26, 2020-06-27 [rednime: #137028]
DB: DBLIC.bodb_LicenseeReport
*/
 
 
EXEC [Task_rptBetting_CheckData_Job]
	@FromDate  = '2020-06-26'
	, @ToDate  = '2020-06-27'
	, @Step  = 0
	, @AllowCorrect = 1
	
EXEC Task_DailyRptCasinoTurnover_Bettrans14 '2020-06-26'

EXEC Task_DailyRptCasinoTurnover_Bettrans14 '2020-06-27' 