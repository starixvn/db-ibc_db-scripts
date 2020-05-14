
USE bodb_Licensee
GO 

/*
Create : 20200331@Sophia 
Task: Change name to Table Game [redmineID: #132260]
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
Task: Change name to Table Game [redmineID: #132260]
DB: DBPRO.bodb02
*/


 UPDATE  Products
 SET  ProductName = 'Table Game',Description ='Table Game'
 WHERE PRODUCTID = 40
 
 
  UPDATE  RefResource
 SET  Resource_en = 'Table Game',
 Resource_ch = 'Table Game', 
 Resource_cs = 'Table Game', 
 Resource_jp = 'Table Game',
 Resource_it= 'Table Game', 
 Resource_th= 'Table Game', 
 Resource_ko= 'Table Game', 
 Resource_es= 'Table Game', 
 Resource_el= 'Table Game', 
 Resource_vn= 'Table Game', 
 Resource_pl= 'Table Game',
 Resource_id= 'Table Game', 
 Resource_hi= 'Table Game', 
 Resource_mm= 'Table Game', 
 Resource_fr= 'Table Game', 
 Resource_ru= 'Table Game',
 Resource_pt= 'Table Game', 
 Resource_de= 'Table Game'
 WHERE ResourceId = 40 and refID = 'Product'
 
 
 -------------------------------
 Use bodb_ACC
 GO 
 
  /*
 Create 20200408@Sophia
 Task: Add Reset winning [Redmine: 132260]
 DB DBACC.bodb_ACC
 */
 
 
 UPDATE Acc_DWLList 
 SET  Product = 'Table Game'
 WHERE  ProductId = 40 
 
  UPDATE Acc_DWLList_xtest
 SET  Product = 'Table Game'
 WHERE  ProductId = 40 
 