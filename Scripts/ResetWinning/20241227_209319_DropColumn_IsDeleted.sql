/*<info serverAlias="DBCUST-CustDB,DBACC-bodb02"></info>*/
/*
	Created by: Lewis@20241227
	Task: Drop column IsDeleted for 2 tables (Acc_DWLList ,Acc_DWLList _xtest) [Redmine:#209319] 
	DB:	DBCUST-CustDB,DBACC-bodb02
*/


--=========Acc_DWLList============

ALTER TABLE dbo.Acc_DWLList DROP CONSTRAINT DF_Acc_DWLList_IsDeleted;
ALTER TABLE dbo.Acc_DWLList DROP COLUMN IsDeleted;

--=========Acc_DWLList_xtest============

ALTER TABLE dbo.Acc_DWLList_xtest DROP CONSTRAINT DF_Acc_DWLList_xtest_IsDeleted;
ALTER TABLE dbo.Acc_DWLList_xtest DROP COLUMN IsDeleted;
