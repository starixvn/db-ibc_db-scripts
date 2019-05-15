

/*
Create : 20190515@Sophia
DB: DBPRO.bodb02
Task: Update Keno to RNG Keno [redmineId: #113489]

*/
Use bodb02
GO

UPDATE RefResource 
SET Resource_en = 'RNG Keno'
WHERE RefID = 'Product' and ResourceId = 8

UPDATE RefResource 
SET Resource_en = 'RNG Keno'
WHERE RefID = 'Vendor' and ResourceId = 1

 
 UPDATE Products
 SET   ProductName = 'RNG Keno'
 WHERE ProductID = 8
 

 UPDATE sports
 SET   SportName = 'RNG Keno'
 WHERE sporttype = 202 
  
   

   
/*
Create : 20190515@Sophia
DB: DBCUST.bodb_Licensee
Task: Update Keno to RNG Keno [redmineId: #113489]

*/
    
 UPDATE Product3rd
 SET   ProductName = 'RNG Keno'
 WHERE ProductID = 8 