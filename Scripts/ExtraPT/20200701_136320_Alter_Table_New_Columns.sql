/*<info serverAlias="DBTXN-bodb02"></info>*/
/*
	Create: 20200701@Sol
	DB : DBTXN-bodb02
	Task: Script to add new columns for Extra PT 2 [redmine: #136320]
*/

USE [bodb02]

GO

ALTER TABLE sum_winloss_tmp ADD ExtraWinloss MONEY NULL, ExtraComm  MONEY NULL

GO

ALTER TABLE sum_winloss ADD ExtraWinloss MONEY NULL, ExtraComm  MONEY NULL

GO