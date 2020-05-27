 /*<info serverAlias="DBACC-bodb_ACC" ></info>*/
USE bodb_ACC
GO
/*
    Created: 20200527@Sophia
	Task:   Insert DWL dummy account for RNGWar - [Redmine: #132013]
	DB: DBACC/bodb_ACC

*/

BEGIN
 SET NOCOUNT ON
 
 
 INSERT INTO Acc_DWLList (ProductId, Product, Seq,IsDeleted, CustId) VALUES (50,'RNG War',52,0,43164403)	 
 INSERT INTO Acc_DWLList_xtest (ProductId, Product, Seq,IsDeleted, CustId) VALUES (50,'RNG War',52,0,42615012) 
	
END
GO
 