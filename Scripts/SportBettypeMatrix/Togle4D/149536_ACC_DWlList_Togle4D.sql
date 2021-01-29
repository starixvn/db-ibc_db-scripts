/*<info serverAlias="DBACC-bodb_ACC" ></info>*/
use bodb_ACC
GO 

/*
Create : 20210129@Sophia
Task: Rename Indo 4D to Togle 4D for table Reset winning [redmine:#149536]
DB: DBACC/bodb_ACC
*/

 
UPDATE ACC_DWlList 
SET Product = 'Togel 4D' 
WHERE Productid = 43