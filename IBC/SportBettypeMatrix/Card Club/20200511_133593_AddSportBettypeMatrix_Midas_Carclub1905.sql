/*<info serverAlias="DBPRO-bodb02"></info>*/

Use bodb02
GO 

/*
Create : 20200511@SOphia
DB : DBPRO.bodb02
Task: Add SportBettypeMatrix - Midas - Cardclub 1905 and 1904 [Redmine :#133593, #132254] 
*/


insert into sportbettypematrix (sporttype,bettype,islive,productid,enabled,istest,eventtype,subproduct,RefTable) values (165,1904,0,34,1,0,0,'',1)
insert into sportbettypematrix (sporttype,bettype,islive,productid,enabled,istest,eventtype,subproduct,RefTable) values (165,1905,0,34,1,0,0,'',1)