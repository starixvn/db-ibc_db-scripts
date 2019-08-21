USE bodb_Acc
GO
/*

Created: 20190801@Sophia
Task: Reset winning - add CN88 [redmine: 117809]
*/

ALTER TABLE Acc_DWLList DROP CONSTRAINT  PK_Acc_DWLList 

ALTER TABLE Acc_DWLList ADD CONSTRAINT PK_Acc_DWLList PRIMARY KEY (CustID, Product)


------------------

ALTER TABLE Acc_DWLList_xtest DROP CONSTRAINT  PK_Acc_DWLList_xtest 

ALTER TABLE Acc_DWLList_xtest ADD CONSTRAINT PK_Acc_DWLList_xtest PRIMARY KEY (CustID, Product)
 






