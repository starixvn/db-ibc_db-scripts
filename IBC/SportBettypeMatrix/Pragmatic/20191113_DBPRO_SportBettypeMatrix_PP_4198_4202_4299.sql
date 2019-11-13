use bodb02
go

/*
	Created: 20191113@Percy
	DB: DBPRO.bodb02
	Task: PP - Insert new 5 games + PP Tournament
*/

-- new 5 games (4198 --> 4202)
insert into sportbettypematrix (sporttype,bettype,islive,productid,enabled,istest,eventtype,subproduct,RefTable) values (248,4198,0,32,1,0,0,'',1)
insert into sportbettypematrix (sporttype,bettype,islive,productid,enabled,istest,eventtype,subproduct,RefTable) values (248,4199,0,32,1,0,0,'',1)
insert into sportbettypematrix (sporttype,bettype,islive,productid,enabled,istest,eventtype,subproduct,RefTable) values (248,4200,0,32,1,0,0,'',1)
insert into sportbettypematrix (sporttype,bettype,islive,productid,enabled,istest,eventtype,subproduct,RefTable) values (248,4201,0,32,1,0,0,'',1)
insert into sportbettypematrix (sporttype,bettype,islive,productid,enabled,istest,eventtype,subproduct,RefTable) values (248,4202,0,32,1,0,0,'',1)

-- PP Tournament
insert into sportbettypematrix (sporttype,bettype,islive,productid,enabled,istest,eventtype,subproduct,RefTable) values (248,4299,0,32,1,0,0,'',1)