/*
Create :20200415@Sophia
Task: Esports Sporttype 43 - bettype 4 [redmine:#132386]
DB :DBPRO.bodb02

*/



insert into sportbettypematrix (sporttype,bettype,islive,productid,enabled,istest,eventtype,subproduct,RefTable) values (43,4,0,1,1,0,1,'',0)
insert into sportbettypematrix (sporttype,bettype,islive,productid,enabled,istest,eventtype,subproduct,RefTable) values (43,4,1,1,1,0,1,'',0)

insert into CS_sportbettypematrix (sporttype,bettype,islive,productid,enabled,istest,eventtype,subproduct,RefTable, SporttypeGroup, BettypeGroup) values (43,4,0,1,1,0,1,'',0,10,4)
insert into CS_sportbettypematrix (sporttype,bettype,islive,productid,enabled,istest,eventtype,subproduct,RefTable, SporttypeGroup, BettypeGroup) values (43,4,1,1,1,0,1,'',0,10,4)