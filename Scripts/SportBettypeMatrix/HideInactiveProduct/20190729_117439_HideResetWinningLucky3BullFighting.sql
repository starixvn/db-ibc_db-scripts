 
USE bodb_ACC
GO 
/*
Create : 20190729@Sophia
Task: Hide inactive product [redmine: 117439]
DB: DBACC.bodb_ACC
*/
 

 
UPDATE Acc_DWLList 
SET IsDeleted = 1 
WHERE ProductId IN (30,26) -- Bullfighting, Lucky 3

UPDATE Acc_DWLList_Xtest
SET IsDeleted = 1 
WHERE ProductId IN (30,26) -- Bullfighting, Lucky 3