/*<info serverAlias="DBACC-bodb_ACC" ></info>*/
use bodb_Acc
GO 

/*
Created: 20201008@Sophia
Task: Update name CardClub to Arcadia Gaming [redmine: 142443]
DB: DBACC.bodb_Acc
*/


UPDATE  Acc_DWLList 
SET Product = 'Arcadia Gaming'
where productID = 34  

UPDATE  Acc_DWLList_xtest
SET Product = 'Arcadia Gaming'
where productID = 34   