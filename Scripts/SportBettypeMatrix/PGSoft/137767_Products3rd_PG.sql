/*<info serverAlias="DBCUST-bodb_Licensee" step="2"></info>*/
use bodb_Licensee
GO 

/*
Create : 20200808@Sophia
Task: Add PG  Product3rd [redmine :#137767]
DB: DBCUST/bodb_Licensee
*/

INSERT INTO  Product3rd  (ProductID,ProductName,Description,ProductPrefix,OfferSingle,ApplyDCS ) 
VALUES (55,'PG Soft','PG Soft','PGS','1',1)