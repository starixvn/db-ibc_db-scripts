/*<info serverAlias="DBCUST-CUSTDB"></info>*/
/*
	Create : 20231222@Evan 
	Update SpecialPlatfrom (Athena000) [Redmine: #198400] 
	DB: DBCUST.CUSTDB
*/
USE [CUSTDB]

GO

UPDATE site WITH(ROWLOCK) SET SpecialPlatfrom = 0 , RepUpdateTime = GETDATE() WHERE site = 'Athena000'
