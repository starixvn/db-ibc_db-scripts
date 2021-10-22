 /*<info serverAlias="DBPTCS-bodb_PlaytechCS"></info>*/
/*
	Create : 20211021@Danny 
	Regen data for AGCasino - [Redmine: #162947] 
	DB: DBPTCS-bodb_PlaytechCS
*/
USE bodb_PlaytechCS

-- Remove wrong ticket

DELETE FROM bettrans_AGCasino WITH(ROWLOCK,UPDLOCK)
where TicketID = 211012073796594  
