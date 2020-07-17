/*<info serverAlias="DBCRM-bodb_CRM"></info>*/

USE bodb_CRM
GO

/*
	Created: 20200717@Malcolm
	DB: DBCRM.bodb_CRM
	Task: delete old logs
	Revisions:
		- 20200717@Malcolm:  delete old logs [RedmineID: #137144]
*/

TRUNCATE TABLE crmUserLog_RunSP
