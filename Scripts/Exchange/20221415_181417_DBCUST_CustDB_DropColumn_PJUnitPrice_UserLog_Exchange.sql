/*<info serverAlias="DBLOG-bodb_CustomerLog"></info>*/
/*
	Created: 20221612@Evan
	DB:  DBLOG-bodb_CustomerLog
	Task: Drop column PJUnitPrice table UserLog_Exchange
	https://nexdev.net/issues/181417
*/

USE bodb_CustomerLog

ALTER TABLE UserLog_Exchange 
DROP COLUMN PJUnitPrice;
