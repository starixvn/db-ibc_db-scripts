/*<info serverAlias="DBACC-bodb_ACC" ></info>*/
use bodb_Acc
GO 

/*
Created: 20201021@Danny
Task: Delete data from Acc_DWLList where Product null  [redmine: 141775]
DB: DBACC.bodb_Acc
*/


DELETE b
FROM Acc_DWLList b with(rowlock)
WHERE CustiD IN(5013852, 19736338)

