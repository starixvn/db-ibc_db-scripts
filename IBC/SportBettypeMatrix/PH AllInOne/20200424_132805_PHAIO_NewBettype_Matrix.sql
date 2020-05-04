use bodb02
GO 

/*
Create : 20200424@Sophia
Task: Add PHAIO 5 - sportbettypematrix  [redmine: #132805]
DB: DBPRO.bodb02
*/
 
insert into sportbettypematrix (sporttype,bettype,islive,productid,enabled,istest,eventtype,subproduct,RefTable) values (1,376,0,1,1,0,1,'',0)
insert into sportbettypematrix (sporttype,bettype,islive,productid,enabled,istest,eventtype,subproduct,RefTable) values (1,376,1,1,1,0,1,'',0)


  
insert into CS_sportbettypematrix (sporttype,bettype,islive,productid,enabled,istest,eventtype,subproduct,RefTable, SporttypeGroup, BettypeGroup) values (1,376,0,1,1,0,1,'',0,1,376)
insert into CS_sportbettypematrix (sporttype,bettype,islive,productid,enabled,istest,eventtype,subproduct,RefTable, SporttypeGroup, BettypeGroup) values (1,376,1,1,1,0,1,'',0,1,376)