/*<info serverAlias="DBACC-bodb_ACC" ></info>*/
USE bodb_ACC
GO
/*
    Created: Malcolm
	Date: 2020-02-28
	Task:   Insert DWL dummy account on UAT table - [Redmine: #129339]
	DB: DBACC/bodb_ACC

	Revisions:
		- 20200228@Malcolm:  Insert DWL dummy account on UAT - [Redmine: #129339]
	Parameter's explaination:
*/

BEGIN
	SET NOCOUNT ON
	
	INSERT INTO dbo.Acc_DWLList_xtest(Custid,product,seq,Productid, IsDeleted)
	VALUES(41960803, 'Virtual Games', 42, 38, 0)
	
	INSERT INTO dbo.Acc_DWLList_xtest(Custid,product,seq,Productid, IsDeleted)
	VALUES(41960846, 'SA Gaming', 43, 39, 0)
END
GO