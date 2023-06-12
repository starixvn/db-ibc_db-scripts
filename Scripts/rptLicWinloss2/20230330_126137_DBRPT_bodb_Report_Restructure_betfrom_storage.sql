/*<info serverAlias="DBRPT-bodb_Report"></info>*/
/*
	Created: 20230330@Evan
	DB: DBRPT-bodb_Report
	Task: Restructure betfrom storage up to nvarchar(4) [Redmine: #126137]
*/

USE bodb_Report

GO

ALTER TABLE [dbo].[rptLicWinlossGMTTmp] 
ALTER COLUMN Betfrom NVARCHAR(4) ;

EXEC sp_rename 'TempMP_bettrans', 'DEL_TempMP_bettrans';

GO
