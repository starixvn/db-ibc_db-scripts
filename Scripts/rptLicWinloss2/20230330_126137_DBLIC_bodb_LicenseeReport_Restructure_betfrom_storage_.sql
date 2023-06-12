/*<info serverAlias="DBLIC-bodb_LicenseeReport,DBBAL-bodb_LicenseeReport"></info>*/
/*
	Created: 20230330@Evan
	DB: DBLIC-bodb_LicenseeReport,DBBAL-bodb_LicenseeReport
	Task: Restructure betfrom storage up to nvarchar(4) [Redmine: #126137]
*/

USE bodb_LicenseeReport

GO

ALTER TABLE [dbo].[rptLicWinloss2] 
ALTER COLUMN betfrom NVARCHAR(4) ; 

ALTER TABLE [dbo].[rptLicWinlossGMT] 
ALTER COLUMN Betfrom NVARCHAR(4) ;
