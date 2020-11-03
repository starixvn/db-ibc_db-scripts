/*<info serverAlias="DBACC-bodb_ACC" ></info>*/
USE bodb_ACC
GO
/*
    Created: 20200527@Sophia
	Task:   Insert DWL dummy account for WM - [Redmine: #131555]
	DB: DBACC/bodb_ACC

*/

BEGIN
 SET NOCOUNT ON
	
 INSERT INTO Acc_DWLList (ProductId, Product, Seq,IsDeleted, CustId) VALUES (51,'WM',54,0,45318301)	 
 INSERT INTO Acc_DWLList_xtest (ProductId, Product, Seq,IsDeleted, CustId) VALUES (51,'WM',54,0,45375966)
	
END
GO
 