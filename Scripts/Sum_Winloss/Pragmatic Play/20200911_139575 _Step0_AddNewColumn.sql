/*<info serverAlias="DBACC-bodb_Archive" step="2"></info>*/
/*
	Create: 20200910@Malcolm
	DB : DBACC-bodb_Archive
	Task: Add new columns [redmine: #139575]
*/

USE bodb_Archive;
GO

ALTER TABLE sum_winloss_old_tmp
ADD ExtraWinloss	MONEY, 
	ExtraComm		MONEY
GO