/*
	Created: 20170316@Helen
	Task: [BAIO] - Customer Setting - https://nexdev.net/issues/71609
	DB: DBCUST/CustDB
*/
DECLARE @maxcustID INT = xxx

DELETE cs
FROM [dbo].CustSetting cs WITH(UPDLOCK,ROWLOCK)
WHERE cs.CustID > @maxcustID
	AND cs.Sporttype = 2
	AND cs.Bettype = 9999
	
DELETE cs
FROM [dbo].custoverride cs WITH(UPDLOCK,ROWLOCK)
WHERE cs.CustID > @maxcustID
	AND cs.Sporttype = 2
	AND cs.Bettype = 9999