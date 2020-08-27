 /*<info serverAlias="DB052-bodb_summary" ></info>*/
USE bodb_summary
GO
/*
    Created: 20200826@Sophia
	Task: Manual run job recover bet 7days on standby server [Redmine:#140403]
	DB: DB052-bodb02

*/


----DB052

EXEC bodb_summary.dbo.Task_CS_SumWinloss_14	'2020-08-17 00:00:00.000',	'44506624,44506651,44608262 '

EXEC bodb_summary.dbo.Task_CS_SumCancelled_14	'2020-08-17 00:00:00.000',	'44506624,44506651,44608262'

EXEC bodb_summary.dbo.Task_CS_SumWinloss_14	'2020-08-18 00:00:00.000',	'44506651,44608262'

EXEC bodb_summary.dbo.Task_CS_SumCancelled_14	'2020-08-18 00:00:00.000',	'44506651,44608262'

EXEC bodb_summary.dbo.Task_CS_SumWinloss_14	'2020-08-19 00:00:00.000',	'44506651,44608262'

EXEC bodb_summary.dbo.Task_CS_SumCancelled_14	'2020-08-19 00:00:00.000',	'44506651,44608262'