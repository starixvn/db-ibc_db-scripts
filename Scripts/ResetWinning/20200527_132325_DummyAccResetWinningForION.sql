/*<info serverAlias="DBACC-bodb_ACC" ></info>*/
USE bodb_ACC
GO
/*
    Created: 20200527@Sophia
	Task:   Insert DWL dummy account for ION - [Redmine: #132325]
	DB: DBACC/bodb_ACC

*/

BEGIN
 SET NOCOUNT ON
	
 INSERT INTO Acc_DWLList (ProductId, Product, Seq,IsDeleted, CustId) VALUES (52,'ION',51,0,43164358)	 
 INSERT INTO Acc_DWLList_xtest (ProductId, Product, Seq,IsDeleted, CustId) VALUES (52,'ION',51,0,42615007)
	
END
GO
 