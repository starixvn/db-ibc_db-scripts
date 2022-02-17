/*<info serverAlias="DBTRANS-bodb02"></info>*/
/*
	Create: 20211230@Sol
	DB : DBTRANS-bodb02
	Task: drop indexes in DBTRANS of transfer table - [Redmine: #162264]
*/


USE [bodb02]

GO

DROP INDEX [IX_CustId] ON [dbo].[Transfer]

GO

DROP INDEX [IX_Recommend] ON [dbo].[Transfer]

GO

DROP INDEX [IX_WinlostDate] ON [dbo].[Transfer]

GO