use bodb02
GO 
/*
Created: 20191002@Sophia
Task: NPH Promotion [redmine:# 120989]
DB: DBPRO.bodb02


*/


INSERT INTO  Products  (ProductID,ProductName,Description,ProductPrefix,Enabled,BalanceType,SubProductBalanceType, GroupType,CasinoType,IsOfferPlayForFun) VALUES (37,'NPH Promotion','Non-peak hours promotion','NPHP',1,2,NULL,0,0,0)

INSERT INTO  Sports  (Sporttype,SportName)VALUES (246,N'NPH Promotion') 

INSERT INTO  bettype  (TypeId,TypeNamee,typedesc,ParentTypeid, DisplayedTypeID ) VALUES (17000,N'Saba Lucky Spin',N'Saba Lucky Spin',17000,17000) 

INSERT INTO sportbettypematrix (sporttype,bettype,islive,productid,enabled,istest,eventtype,subproduct,RefTable) values (246,17000,0,37,1,0,0,'',0)

 