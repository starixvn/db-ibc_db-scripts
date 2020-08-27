 /*<info serverAlias="DB06-bodb_report" ></info>*/
USE bodb_report
GO
/*
    Created: 20200826@Sophia
	Task: Manual run job recover bet 7days on standby server [Redmine:#140403]
	DB: DB06-bodb_report

*/


----DB06


EXEC bodb_report.dbo.Task_rptStatement_14	'2020-08-17 00:00:00.000',	'44506624,44506651,44608262'

EXEC bodb_report.dbo.Task_rptStatement_14	'2020-08-18 00:00:00.000',	'44506651,44608262'

EXEC bodb_report.dbo.Task_rptStatement_14	'2020-08-19 00:00:00.000',	'44506651,44608262'


EXEC bodb02.dbo.Task_rptWinLost_UpdateTable	'2020-08-17 00:00:00.000'
EXEC bodb02.dbo.Task_rptWinLost_UpdateTable	'2020-08-18 00:00:00.000'
EXEC bodb02.dbo.Task_rptWinLost_UpdateTable	'2020-08-19 00:00:00.000'