/*
Create : 20190515@Sophia
DB: DBPRO.bodb02
Task: Update Keno to RNG Keno [redmineId: #113489]

*/
Use bodb02
GO


 
 UPDATE Products
 SET   ProductName = 'RNG Keno'
 WHERE ProductID = 8
   

   
/*
Create : 20190515@Sophia
DB: DBCUST.bodb_Licensee
Task: Update Keno to RNG Keno [redmineId: #113489]

*/
    
 UPDATE Product3rd
 SET   ProductName = 'RNG Keno'
 WHERE ProductID = 8 