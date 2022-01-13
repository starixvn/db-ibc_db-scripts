/*<info serverAlias="DBTRANS-bodb02"></info>*/
/*
	Create: 20211230@Sol
	DB : DBTRANS-bodb02
	Task: copy data to new table transfer and transferinfo - [Redmine: #162264]
*/

USE bodb02;

GO  

DELETE FROM dbo.Transfer WHERE TransId IN (108711261451,108711261452) AND Bettype = 20000

GO 