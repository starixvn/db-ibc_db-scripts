/*<info serverAlias="DBACC-bodb_ACC" ></info>*/
USE bodb_ACC
GO
/*
    Created: 20200320@Sophia
	Task:   Insert DWL dummy account for Saba Product - [Redmine: #130781]
	DB: DBACC/bodb_ACC

*/

BEGIN
	SET NOCOUNT ON
	 
	INSERT INTO dbo.ACC_DWLList(Custid,product,seq,Productid, IsDeleted)
	VALUES(42339463, 'Saba.club', 45, 42, 0)
	
	INSERT INTO dbo.ACC_DWLList_xtest(Custid,product,seq,Productid, IsDeleted)
	VALUES(42339520, 'Saba.club', 45, 42, 0)
	
END
GO
 