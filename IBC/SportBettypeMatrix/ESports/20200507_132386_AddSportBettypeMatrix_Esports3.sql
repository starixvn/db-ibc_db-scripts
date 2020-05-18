/*<info serverAlias="DBPRO-bodb02"></info>*/
/*
	Creates: 20200514@Percy
	DB: DBPRO-bodb02
	Task: Eports3 - 9087, 9088 [redmine: 132386]
*/

insert into sportbettypematrix (sporttype,bettype,islive,productid,enabled,istest,eventtype,subproduct,RefTable) values (43,9087,0,1,1,0,1,'',0)
insert into sportbettypematrix (sporttype,bettype,islive,productid,enabled,istest,eventtype,subproduct,RefTable) values (43,9087,1,1,1,0,1,'',0)
insert into sportbettypematrix (sporttype,bettype,islive,productid,enabled,istest,eventtype,subproduct,RefTable) values (43,9088,0,1,1,0,1,'',0)
insert into sportbettypematrix (sporttype,bettype,islive,productid,enabled,istest,eventtype,subproduct,RefTable) values (43,9088,1,1,1,0,1,'',0)
go

insert into CS_sportbettypematrix (sporttype,bettype,islive,productid,enabled,istest,eventtype,subproduct,RefTable, SporttypeGroup, BettypeGroup) values (43,9087,0,1,1,0,1,'',0,10,9087)
insert into CS_sportbettypematrix (sporttype,bettype,islive,productid,enabled,istest,eventtype,subproduct,RefTable, SporttypeGroup, BettypeGroup) values (43,9087,1,1,1,0,1,'',0,10,9087)
insert into CS_sportbettypematrix (sporttype,bettype,islive,productid,enabled,istest,eventtype,subproduct,RefTable, SporttypeGroup, BettypeGroup) values (43,9088,0,1,1,0,1,'',0,10,9088)
insert into CS_sportbettypematrix (sporttype,bettype,islive,productid,enabled,istest,eventtype,subproduct,RefTable, SporttypeGroup, BettypeGroup) values (43,9088,1,1,1,0,1,'',0,10,9088)
go