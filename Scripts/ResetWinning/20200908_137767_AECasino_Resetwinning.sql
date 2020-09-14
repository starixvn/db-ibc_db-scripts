/*<info serverAlias="DBACC-bodb_ACC" ></info>*/
use bodb_Acc
GO 

/*
Created: 20200808@Sophia
Task: Update name sexy Gaming to AE Casino [redmine: 140945]
DB: DBACC.bodb_Acc
*/


UPDATE  Acc_DWLList 
SET Product = 'AE Casino'
where productID = 45  

UPDATE  Acc_DWLList_xtest
SET Product = 'AE Casino'
where productID = 45   