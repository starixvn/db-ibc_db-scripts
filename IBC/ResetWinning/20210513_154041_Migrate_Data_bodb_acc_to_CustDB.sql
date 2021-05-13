/*<info serverAlias="DBCUST-CustDB" ></info>*/
/*
	Create : 20210513@Sol
	Task: migrate data from bodb_acc to custdb - [Redmine: #154041]
	DB: DBCUST-CustDB
*/

USE CustDB;

GO

----delete data from custdb
DELETE FROM dbo.Acc_DWLList

GO

DELETE FROM dbo.Acc_DWLList_xtest

GO

DELETE FROM dbo.Acc_DWLList_ExtraPT

GO

DELETE FROM dbo.Acc_DWLList_ExtraPT_xtest

GO

----insert data from bodb_acc
INSERT INTO dbo.Acc_DWLList(custid, product, seq, ProductId, IsDeleted)
SELECT custid, product, seq, ProductId, IsDeleted 
FROM DBACC.bodb_ACC.dbo.Acc_DWLList a WITH(NOLOCK)

GO

INSERT INTO dbo.Acc_DWLList_xtest(custid, product, seq, ProductId, IsDeleted)
SELECT custid, product, seq, ProductId, IsDeleted
FROM DBACC.bodb_ACC.dbo.Acc_DWLList_xtest a WITH(NOLOCK)

GO

INSERT INTO dbo.Acc_DWLList_ExtraPT(CustId, GroupId, GroupName, IsDisabled)
SELECT CustId, GroupId, GroupName, IsDisabled
FROM DBACC.bodb_ACC.dbo.Acc_DWLList_ExtraPT a WITH(NOLOCK)

GO

INSERT INTO dbo.Acc_DWLList_ExtraPT_xtest(CustId, GroupId, GroupName, IsDisabled)
SELECT CustId, GroupId, GroupName, IsDisabled
FROM DBACC.bodb_ACC.dbo.Acc_DWLList_ExtraPT_xtest a WITH(NOLOCK)

GO