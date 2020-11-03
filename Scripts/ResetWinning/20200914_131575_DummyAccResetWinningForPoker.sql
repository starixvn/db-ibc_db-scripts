/*<info serverAlias="DBACC-bodb_ACC" ></info>*/
USE bodb_ACC
GO
/*
    Created: 20200527@Sophia
	Task:   Insert DWL dummy account for Joker - [Redmine: #132325]
	DB: DBACC/bodb_ACC

*/

BEGIN
 SET NOCOUNT ON
	
 INSERT INTO Acc_DWLList (ProductId, Product, Seq,IsDeleted, CustId) VALUES (56,'Joker',55,0,45318362)	 
 INSERT INTO Acc_DWLList_xtest (ProductId, Product, Seq,IsDeleted, CustId) VALUES (56,'Joker',55,0,45376066)
	
END
GO
 