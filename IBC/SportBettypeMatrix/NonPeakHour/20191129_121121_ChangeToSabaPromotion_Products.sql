use bodb02
GO 
/*
Created : 20191129@Sophia
DB: DBPRO.bodb02
Task: Update Non peak hour to Saba Promotion [redmine: 121121]
*/

DELETE Products WHERE ProductID = 37

INSERT INTO  Products  (ProductID,ProductName,Description,ProductPrefix,Enabled,BalanceType,SubProductBalanceType, GroupType,CasinoType,IsOfferPlayForFun, VendorId) 
VALUES (37,'Saba Promotion','Saba Promotion','SPR',1,4,NULL,0,0,0,NULL)


UPDATE  Sports 
SET SportName = 'Saba Promotion'
WHERE Sporttype = 246 