/*<info serverAlias="DBCUST-bodb_Licensee" step="2"></info>*/
use bodb_Licensee
GO 

/*
Create : 20200915@Sophia
Task: Add WM Product3rd [redmine :#131555]
DB: DBCUST/bodb_Licensee
*/
INSERT INTO  Product3rd  (ProductID,ProductName,Description,ProductPrefix,OfferSingle,ApplyDCS ) VALUES (51,'WM','WM','WM','1',1)