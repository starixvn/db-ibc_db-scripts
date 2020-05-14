
/*
Created : 20191129@Sophia
DB: DBCUST.bodb_Licensee
Task: Update Non peak hour to Saba Promotion [redmine: 121121 ]
*/


DELETE Product3rd WHERE ProductID = 37

INSERT INTO  Product3rd  (ProductID,ProductName,Description,ProductPrefix,OfferSingle,ApplyDCS ) VALUES (37,'Saba Promotion','Saba Promotion','SPR','1',0)