/*
	Created: 2017@Helen
	Task : BAIO - [Redmine: 71609]
	DB: DBTXN/bodb02
	
*/	
USE bodb02
GO	
UPDATE Sport_Bettype_Reference_VirtualRate WITH (UPDLOCK, ROWLOCK)
SET isActive = 1
WHERE SportType = 2 AND BetType IN (401,402,603,604,605,606,607,403,404,609,610,611,612,613,615,616,617)