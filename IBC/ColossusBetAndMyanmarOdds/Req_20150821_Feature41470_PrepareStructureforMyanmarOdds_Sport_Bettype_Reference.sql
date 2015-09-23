/*
	Created by: Helen
	Date: 20150904
	Task: commission setting for MO [Redmine #41470]
	DB: DBTXN.bodb02

*/ 
USE bodb02
GO
INSERT INTO Sport_Bettype_Reference (Bettype,Sporttype,isLicensee,BettypeRef,SporttypeRef,isActive)
SELECT 301,1,0,1,1,1
UNION ALL
SELECT 302,1,0,3,1,1
UNION ALL
SELECT 303,1,0,7,1,1
UNION ALL
SELECT 304,1,0,8,1,1
