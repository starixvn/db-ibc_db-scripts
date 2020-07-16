/*<info serverAlias="DBPRO-bodb02" step="1"></info>*/
use bodb02
GO 
/*
Create: 20200713@Sophia
Task: Add Cs_SportBettypeMatrix lottery [Redmine:#137542]
DB: DBPRO.bodb02

*/

insert into CS_sportbettypematrix (sporttype,bettype,islive,productid,enabled,istest,eventtype,subproduct,RefTable, SporttypeGroup, BettypeGroup) values (220,1065,0,28,1,0,0,'',3,12,1065) 