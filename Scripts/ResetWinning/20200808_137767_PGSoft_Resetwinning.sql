/*<info serverAlias="DBACC-bodb_ACC" ></info>*/
use bodb_Acc
GO 

/*
Created: 20200808@Sophia
Task: Add dummy acc for Reset Winning [redmine: #137767]
DB: DBACC.bodb_Acc
*/

INSERT INTO Acc_DWLList (CustID, product, seq, ProductId, IsDeleted)
VALUES (44658119,'PG Soft', 53, 55, 0  )



INSERT INTO Acc_DWLList_xtest (CustID, product, seq, ProductId, IsDeleted)
VALUES (44658294,'PG Soft', 53, 55, 0  ) 



Select * from Acc_DWLList   order by Seq  