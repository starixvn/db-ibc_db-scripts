/*<info serverAlias="DBACC-bodb_ACC" ></info>*/
use bodb_Acc
GO 

/*
Created: 20200714@Sophia
Task: Add dummy acc for Reset Winning [redmine: #137270]
DB: DBACC.bodb_Acc
*/

INSERT INTO Acc_DWLList (CustID, product, seq, ProductId, IsDeleted)
VALUES (44224799,'PP (Amount due to Jackpot pool)', 36, 33, 0  )



INSERT INTO Acc_DWLList_xtest (CustID, product, seq, ProductId, IsDeleted)
VALUES (44225061,'PP (Amount due to Jackpot pool)', 36, 33, 0  ) 



Select * from Acc_DWLList   order by Seq  