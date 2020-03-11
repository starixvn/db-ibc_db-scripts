USE bodb02
GO 

/*
Created: 20200311@Sophia
Task: add SportbettypeMatrix for Midas - CardClub [Redmine: #128977]
DB: DBPRO.bodb02
*/


INSERT INTO sportbettypematrix (sporttype,bettype,islive,productid,enabled,istest,eventtype,subproduct,RefTable) VALUES (165,1902,0,34,1,0,0,'',1)

UPDATE Products
SET VendorID = 33
WHERE ProductID = 34

 