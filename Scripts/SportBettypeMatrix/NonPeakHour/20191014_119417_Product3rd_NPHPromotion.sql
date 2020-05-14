use bodb_Licensee
GO 

/*
Create : 20191015@Sophia
Task : Product3rd for NHN promotion [redmind: 119417]
DB : DBCUST.bodb_Licensee
*/

 
INSERT INTO  Product3rd  (ProductID,ProductName,Description,ProductPrefix,OfferSingle,ApplyDCS ) VALUES (37,'NPH Promotion','Non-peak hours promotion','NPHP','1',0)


UPDATE  Product3rd 
SET		ApplyDCS = 1
WHERE	ProductID = 34 


