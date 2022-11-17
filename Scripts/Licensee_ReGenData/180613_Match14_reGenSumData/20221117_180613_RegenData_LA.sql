 /*<info serverAlias="DBLIC-bodb_LicenseeReport"></info>*/
USE [bodb_LicenseeReport]

GO

/*
	Create : 20221117@Sophia
	Task : Regen data for LA system [Redmine: #180613] 
	DB: DBLIC.bodb_LicenseeReport
*/
---- #1
EXEC Task_PostStaging
GO
EXEC Task_rptBetting_CheckData_Job @FromDate = '2022-11-07', @ToDate = '2022-11-08', @Step = 2,  @AllowCorrect = 1
GO

---- #2
EXEC Task_PostStaging
GO
EXEC Task_rptBetting_CheckData_Job @FromDate = '2022-11-13', @ToDate = '2022-11-13', @Step = 2,  @AllowCorrect = 1 
GO

 