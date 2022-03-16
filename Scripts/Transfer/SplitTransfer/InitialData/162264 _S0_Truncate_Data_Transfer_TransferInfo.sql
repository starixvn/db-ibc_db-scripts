/*<info serverAlias="DBTRANS-bodb02"></info>*/
/*
	Create: 20211230@Sol
	DB : DBTRANS-bodb02
	Task: truncate data in new table transfer and transferinfo - [Redmine: #162264]
*/

USE bodb02;

GO  

DELETE FROM [Transfer]

GO

DELETE FROM [TransferInfo]

GO