 /*<info serverAlias="DBLIC-bodb_LicenseeReport"></info>*/
USE [bodb_LicenseeReport]
GO

/*
Create : 20200603@Sophia:
Regen data GD Repull data 12bet  [rednime: #135296]
DB: DBLIC.bodb_LicenseeReport
*/

EXEC [Task_rptBetting_CheckData_Job]
	@FromDate  = '2020-05-01'
	, @ToDate  = '2020-05-05'
	, @Step  = 3
	, @AllowCorrect = 1
 