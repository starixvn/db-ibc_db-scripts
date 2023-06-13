/*<info serverAlias="DBLIC-bodb_LicenseeReport"></info>*/
/*
	Created: 20230612@Evan
	DB: DBLIC-bodb_LicenseeReport
	Task: Drop code related to Saba Promotion -- Remove unused sps   
	https://nexdev.net/issues/189234
*/

USE bodb_LicenseeReport
GO
EXEC sp_rename 'Task_DailySummaryLicPromotion_Job','DEL_Task_DailySummaryLicPromotion_Job' 
EXEC sp_rename 'Task_DailySummaryLicPromotion','DEL_Task_DailySummaryLicPromotion' 
EXEC sp_rename 'Task_DailySummaryLicPromotion_CheckData','DEL_Task_DailySummaryLicPromotion_CheckData' 
EXEC sp_rename 'Task_DailySummaryLicPromotion_Bettrans14','DEL_Task_DailySummaryLicPromotion_Bettrans14' 
