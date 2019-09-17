use bodb_ACC 
GO


/*
Create: 20190917@Sophia:
Task: auto add balance of headline -  Add new column IsDisabled [redmine: #115802]
DB: DBACC.bodb_ACC
*/


---tructure
ALTER TABLE Acc_DWLList_ExtraPT ADD IsDisabled BIT DEFAULT (0) 

ALTER TABLE Acc_DWLList_ExtraPT_xtest ADD IsDisabled BIT DEFAULT (0) 

GO 

--- Data

UPDATE Acc_DWLList_ExtraPT 
SET IsDisabled = 0
WHERE GroupID NOT BETWEEN 27 AND 42

UPDATE Acc_DWLList_ExtraPT 
SET IsDisabled = 1
WHERE GroupID BETWEEN 27 AND 42



UPDATE Acc_DWLList_ExtraPT_xtest 
SET IsDisabled = 0
WHERE GroupID NOT BETWEEN 27 AND 42

UPDATE Acc_DWLList_ExtraPT_xtest
SET IsDisabled = 1
WHERE GroupID BETWEEN 27 AND 42


---select 

 SELECT * FROM Acc_DWLList_ExtraPT 
 
 SELECT * FROM Acc_DWLList_ExtraPT_xtest 
 