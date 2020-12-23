 /*<info serverAlias="DBLIC-bodb_LicenseeReport"></info>*/
/*
	Create : 20201223@Sol 
	Regen data for rptBetting - [Redmine: #147650] 
	DB: DBLIC.bodb_LicenseeReport
*/

USE [bodb_LicenseeReport]

GO

EXEC [Task_rptBetting_CheckData_Job]
	@FromDate  = '2020-12-17'
	, @ToDate  = '2020-12-19'
	, @Step  = 2
	, @AllowCorrect = 1
	 
GO