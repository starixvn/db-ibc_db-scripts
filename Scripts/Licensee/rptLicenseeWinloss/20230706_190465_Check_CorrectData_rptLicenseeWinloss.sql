/*<info serverAlias="DBLIC-bodb_LicenseeReport"></info>*/
/*
	Created: 20230706@Evan
	DB: DBLIC-bodb_LicenseeReport
	Task: LAP - Winloss Analysis - Check & Correct Data  
	https://nexdev.net/issues/190465
*/

USE bodb_LicenseeReport
GO
EXEC [dbo].[Task_rptLicenseeWinloss_Bettrans14]  @winlostdate = '2023-07-01', @isCheckDataOnly=0;
GO
EXEC [dbo].[Task_rptLicenseeWinloss_Bettrans14]  @winlostdate = '2023-07-02', @isCheckDataOnly=0;
