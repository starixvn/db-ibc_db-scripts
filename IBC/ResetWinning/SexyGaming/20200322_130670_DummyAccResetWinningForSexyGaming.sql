/*<info serverAlias="DBACC-bodb_ACC" ></info>*/
USE bodb_ACC
GO
/*
    Created: 20200322@Sophia
	Task:   Insert DWL dummy account for sexy gaming  - [Redmine: #130670]
	DB: DBACC/bodb_ACC

*/

BEGIN
	SET NOCOUNT ON
	 
	INSERT INTO dbo.ACC_DWLList(Custid,product,seq,Productid, IsDeleted)
	VALUES(42372045, 'Sexy Gaming', 46, 45, 0)
	
	INSERT INTO dbo.ACC_DWLList_xtest(Custid,product,seq,Productid, IsDeleted)
	VALUES(42372274, 'Sexy Gaming', 46, 45, 0)
	
END
GO
 