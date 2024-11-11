/*<info serverAlias="DBSIC-bodb02,DBTP-bodb02,DBAGE-bodb02,DBRepl-ReplDB"></info>*/
/*
	Created: 20241104@Lewis
	DB: DBSIC-bodb02,DBTP-bodb02,DBAGE-bodb02,DBRepl-ReplDB
	Task: Add column IsTest
*/

USE bodb02
GO
 ALTER TABLE [SabaProgramStatus]
 ADD IsTest BIT CONSTRAINT [DF_SabaProgramStatus_IsTest] DEFAULT (0) 