/*<info serverAlias="DBSUM-bodb_Summary"></info>*/
/*
	Create: 20200701@Sol
	DB : DBSUM-bodb_Summary
	Task: Script to add new columns for Extra PT 2 [redmine: #136320]
*/

USE bodb_Summary

GO

ALTER TABLE sum_winloss_old ADD ExtraWinloss MONEY NULL, ExtraComm  MONEY NULL

GO