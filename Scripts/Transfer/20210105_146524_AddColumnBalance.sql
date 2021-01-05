/*<info serverAlias="DBARC-bodb_Archive"></info>*/

/*
Create: 20210105@Danny
Task: Add column balance into transfer_bk [Redmine: #146038]
DB: DBCUST-CUSTDB

*/

USE bodb_Archive
GO 

ALTER TABLE dbo.transfer_bk ADD [balance] [money] NULL 
GO
