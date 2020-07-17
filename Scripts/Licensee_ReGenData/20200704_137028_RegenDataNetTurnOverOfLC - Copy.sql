 /*<info serverAlias="DBLIC-bodb_LicenseeReport"></info>*/
USE [bodb_LicenseeReport]
GO

/*
Create : 20200717@Sophia 
Regen data of LC NetTurnOver by Data Patch [Redmine: #137604] 
DB: DBLIC.bodb_LicenseeReport
*/
 
 
EXEC [Task_rptBetting_CheckData_Job]
	@FromDate  = '2020-07-06'
	, @ToDate  = '2020-07-07'
	, @Step  = 0
	, @AllowCorrect = 1
	
EXEC Task_DailyRptCasinoTurnover_Bettrans14 '2020-07-06'

EXEC Task_DailyRptCasinoTurnover_Bettrans14 '2020-07-07' 


 