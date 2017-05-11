/*
	Created: 20170511@Elodie
	Task: Virtual Sport - Missing data of sport 182, 184 - [Redmine: 76020]

*/
USE CustDB
GO

UPDATE ci
SET ci.maxpermatch182 = ci.maxpermatch180,
	ci.maxpermatch184 = ci.maxpermatch180
FROM dbo.custInfo ci WITH (ROWLOCK, UPDLOCK)
WHERE custid IN (13090490,13090791,13094705,13091063)      
       