 /*<info serverAlias="DBLIC-bodb_LicenseeReport"></info>*/
USE [bodb_LicenseeReport]

GO

/*
	Create : 20200804@Sol 
	Regen data for rptBetting [Redmine: #135963] 
	DB: DBLIC.bodb_LicenseeReport
*/
 
EXEC [Task_rptBetting_CheckData_Job]
	@FromDate  = '2020-07-30'
	, @ToDate  = '2020-07-31'
	, @Step  = 0
	, @AllowCorrect = 1
	 
GO