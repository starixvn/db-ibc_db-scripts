use bodb02
go


/*
	Created: 20200218@Sophia
	DB: DBPRO.bodb02
	Task: SportBettypeMatrix for Vitual Games [Redmine: #121062]
*/

insert into sportbettypematrix (sporttype,bettype,islive,productid,enabled,istest,eventtype,subproduct,RefTable) values (245,4601,0,38,1,0,0,'',3)
insert into sportbettypematrix (sporttype,bettype,islive,productid,enabled,istest,eventtype,subproduct,RefTable) values (245,4602,0,38,1,0,0,'',3)
insert into sportbettypematrix (sporttype,bettype,islive,productid,enabled,istest,eventtype,subproduct,RefTable) values (245,4603,0,38,1,0,0,'',3)
insert into sportbettypematrix (sporttype,bettype,islive,productid,enabled,istest,eventtype,subproduct,RefTable) values (245,4604,0,38,1,0,0,'',3)



Update Products
SET Enabled = 1
WHERE ProductID = 38 