
USE bodb_Licensee
GO 

/*
Create : 20200331@Sophia 
Task: Change name to Table Game [redmineID: #130684]
DB: DBCUST.bodb_Licensee
*/


 UPDATE  Product3rd 
 SET  ProductName = 'Table Game',Description ='Table Game'
 WHERE PRODUCTID = 40
 
 -----------------------------
 
USE bodb02
GO 

/*
Create : 20200331@Sophia 
Task: Change name to Table Game [redmineID: #130684]
DB: DBPRO.bodb02
*/


 UPDATE  Products
 SET  ProductName = 'Table Game',Description ='Table Game'
 WHERE PRODUCTID = 40
 