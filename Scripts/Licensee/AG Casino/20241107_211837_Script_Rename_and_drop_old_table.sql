/*<info serverAlias="DBRPT-bodb_Report"></info>*/
/*
	Created: 20241107@Kelvin
	DB: DB061.bodb_Report, DB062.bodb_Report
	Task: Rename and drop table RptDepWinlost_AGCasino [RedmineID: #211837]
*/

USE bodb_Report

GO
sp_rename 'RptDepWinlost_AGCasino','DEL_rptDepWinlost_AGCasino'

GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DEL_rptDepWinlost_AGCasino]') AND type in (N'U'))
DROP TABLE [dbo].[DEL_rptDepWinlost_AGCasino]





