/*<info serverAlias="DBCUST-bodb_Licensee" step="1"></info>*/
use bodb_Licensee
GO 

/*
Create : 20210415@Sophia
Task: Update name AE Casino to AE Sexy[redmine: 153438]
DB: DBCUST/bodb_Licensee
*/


Update Product3rd WITH (ROWLOCK)
SET Productname = 'AE Sexy', 
Description = 'AE Sexy'
WHERE ProductID = 45
 