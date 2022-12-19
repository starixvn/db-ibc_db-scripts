/*<info serverAlias="DBCUST-CustDB"></info>*/
/*
	Created: 20221412@Evan
	DB:  DBCUST-CustDB
	Task: Drop column PJUnitPrice table Exchange
	https://nexdev.net/issues/181417
*/

USE CustDB
GO

ALTER TABLE Exchange 
DROP COLUMN PJUnitPrice;

