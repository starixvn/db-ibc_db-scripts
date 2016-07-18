

/*
	Created: Helen
	Date: 20160715
	Task: Delete redundant Outright settings 
	DB: DBCust/CustDB
*/
DECLARE @maxcustID INT = xxx

DELETE cs
FROM [dbo].CustSetting cs WITH(UPDLOCK,ROWLOCK)
WHERE cs.CustID > @maxcustID
	AND cs.Sporttype IN (2,3,5,8,10,11,99)
	AND cs.Bettype = 10
	
DELETE cs
FROM [dbo].custoverride cs WITH(UPDLOCK,ROWLOCK)
WHERE cs.CustID > @maxcustID
	AND cs.Sporttype IN (2,3,5,8,10,11,99)
	AND cs.Bettype = 10