/*
create: 20200507@Sophia
Task: Eports3 - 9087 [redmine: 132386]
DB : DBPRO/bodb02
*/

insert into sportbettypematrix (sporttype,bettype,islive,productid,enabled,istest,eventtype,subproduct,RefTable) values (43,9087,0,1,1,0,1,'',0)
insert into sportbettypematrix (sporttype,bettype,islive,productid,enabled,istest,eventtype,subproduct,RefTable) values (43,9087,1,1,1,0,1,'',0)


insert into CS_sportbettypematrix (sporttype,bettype,islive,productid,enabled,istest,eventtype,subproduct,RefTable, SporttypeGroup, BettypeGroup) values (43,9087,0,1,1,0,1,'',0,10,9087)
insert into CS_sportbettypematrix (sporttype,bettype,islive,productid,enabled,istest,eventtype,subproduct,RefTable, SporttypeGroup, BettypeGroup) values (43,9087,1,1,1,0,1,'',0,10,9087)