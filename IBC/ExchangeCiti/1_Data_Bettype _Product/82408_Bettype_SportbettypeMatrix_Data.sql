use bodb02
GO 
/*

DB: DBPRO.bodb02
Created 20171214@Sophia: Add bettype, sportbettypematrix For Exchange Citi [redmine: #82408]

*/


--- Bettype 
INSERT INTO  bettype  (TypeId,TypeNamee,typedesc,ParentTypeid, DisplayedTypeID ) VALUES (8000,'Exchange','Exchange','8000','8000')
INSERT INTO  bettype  (TypeId,TypeNamee,typedesc,ParentTypeid, DisplayedTypeID ) VALUES (8001,'Charge Commision','Charge Commision','8001','8001')



--- SportbettypeMatrix
insert into sportbettypematrix (sporttype,bettype,islive,productid,enabled,istest,eventtype,subproduct,RefTable) values (221,8000,0,31,1,0,0,'',0)
insert into sportbettypematrix (sporttype,bettype,islive,productid,enabled,istest,eventtype,subproduct,RefTable) values (221,8001,0,31,1,0,0,'',0)