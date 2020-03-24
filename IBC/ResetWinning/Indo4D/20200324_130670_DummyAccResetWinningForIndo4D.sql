/*<info serverAlias="DBACC-bodb_ACC" ></info>*/
USE bodb_ACC
GO
/*
    Created: 20200322@Sophia
	Task:   Insert DWL dummy account for indo 4D - [Redmine: #130670]
	DB: DBACC/bodb_ACC

*/

BEGIN
	SET NOCOUNT ON
	 
	INSERT INTO dbo.ACC_DWLList(Custid,product,seq,Productid, IsDeleted)
	VALUES(42389787, 'Indo 4D', 47, 43, 0)
	
	INSERT INTO dbo.ACC_DWLList_xtest(Custid,product,seq,Productid, IsDeleted)
	VALUES(42389932, 'Indo 4D', 47, 43, 0)
	
END
GO
 