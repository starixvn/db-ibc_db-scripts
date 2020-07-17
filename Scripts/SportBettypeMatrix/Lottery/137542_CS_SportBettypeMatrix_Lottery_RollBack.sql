/*<info serverAlias="DBPRO-bodb02" step="1"></info>*/
use bodb02
GO 
/*
Create: 20200713@Sophia
Task: Rollback Cs_SportBettypeMatrix lottery & keno [Redmine:#137542]
DB: DBPRO.bodb02

*/


DELETE FROM CS_SportBettypeMatrix Where bettype IN (1527,  1528, 1529, 1065)