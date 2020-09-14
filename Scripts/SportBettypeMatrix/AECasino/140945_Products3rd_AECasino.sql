/*<info serverAlias="DBCUST-bodb_Licensee" step="1"></info>*/
use bodb_Licensee
GO 

/*
Create : 20200808@Sophia
Task: Update name sexy Gaming to AE Casino [redmine: 140945]
DB: DBCUST/bodb_Licensee
*/

update Product3rd 
SET Productname = 'AE Casino', 
Description = 'AE Casino'
Where Productid = 45 