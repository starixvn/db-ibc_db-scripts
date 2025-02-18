/*<info serverAlias="DBRPT-bodb_report"></info>*/
/*
	Created: 20250217@Kelvin
	DB: DBRPT-bodb_report
	Task: Regen data on rptCustomerMatch[Redmine: #217407]
		S4: Drop temp table rptCustomerMatch_staging_217407
*/

USE bodb_report
GO

DROP TABLE [dbo].[rptCustomerMatch_staging_217407]