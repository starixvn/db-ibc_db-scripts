/*<info serverAlias="DBCUST-bodb_Licensee" ></info>*/
use bodb_Licensee
GO 

/*
Create : 20210129@Sophia
Task: Rename Indo 4D to Togle 4D for table Product3rd [redmine:#149536]
DB: DBCUST/bodb_Licensee
*/

 
UPDATE Product3rd 
SET ProductName = 'Togel 4D', Description ='Togel 4D'
WHERE Productid = 43