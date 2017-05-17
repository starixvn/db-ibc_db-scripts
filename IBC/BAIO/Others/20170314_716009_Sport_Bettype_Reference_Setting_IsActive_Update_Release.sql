/*
	2. Database: update IsActive =1 for Sport_Bettype_Setting_Reference for bettypes of basketball
*/

/*
	Created: 2017@Helen
	Task : BAIO - [Redmine: 71609]
	DB: DBTXN/bodb02
	
*/	
USE bodb02
GO	
UPDATE Sport_Bettype_Reference_Setting WITH (UPDLOCK, ROWLOCK)
	SET isActive = 1
WHERE SportType = 2 AND BetType IN (401,402,603,604,605,606,607,403,404,609,610,611,612,613,615,616,617)


SELECT SportType,BetType,IsLicensee,IsLIve 
FROM Sport_Bettype_Reference_Setting WITH (NOLOCK)
WHERE SportType = 2 AND IsActive = 0
