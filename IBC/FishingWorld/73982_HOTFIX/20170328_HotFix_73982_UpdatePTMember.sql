/*
	Created: Elodie
	Date: 20170328
	Task: UPDATE s1 = 70 For RG9T123333
	DB: DBCUST/CustDB
*/

USE CustDB
GO

UPDATE cs
SET cs.SuperPT = 70
FROM dbo.CustPTSetting3rd_Member cs WITH (ROWLOCK,UPDLOCK)		
WHERE cs.SportType = 219 AND cs.custid = 25278295



