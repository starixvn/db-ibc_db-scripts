/*<info serverAlias="DBACC-bodb_ACC" ></info>*/
USE bodb_ACC
GO
/*
    Created: Malcolm
	Date: 2020-02-28
	Task:   Insert DWL dummy account on PRO - [Redmine: #129339]
	DB: DBACC/bodb_ACC

	Revisions:
		- 20200228@Malcolm:  Insert DWL dummy account on PRO - [Redmine: #129339]
	Parameter's explaination:
*/

BEGIN
	SET NOCOUNT ON
	
	INSERT INTO dbo.ACC_DWLList(Custid,product,seq,Productid, IsDeleted)
	VALUES(40699724, 'Virtual Games', 42, 38, 0)
	
	INSERT INTO dbo.ACC_DWLList(Custid,product,seq,Productid, IsDeleted)
	VALUES(41936271, 'SA Gaming', 43, 39, 0)
	
	
END
GO