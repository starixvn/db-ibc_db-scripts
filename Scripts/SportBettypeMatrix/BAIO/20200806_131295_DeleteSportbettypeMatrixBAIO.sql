/*<info serverAlias="DBPRO-bodb02" step="1"></info>*/
/*	

	DB: DBPRO/bodb02
	Create: 2020806@Sophia
	Task: Delete bettype 480 out of SportBettypeMatrix  [redmine: #131295]
*/ 
USE bodb02
GO

DELETE SportBettypeMatrix WITH (ROWlOCK) WHERE bettype = 480 