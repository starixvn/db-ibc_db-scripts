
/*
	Created: Winnie	
	Task:   Alpha - Enable New Cash Balance for the rest lines of Thai currency RedmineID:#80093
	DB: DBCUST/CUSTDB
	Date: 20170718
	198 rows will be affected
*/ 


UPDATE cs
SET cs.IsAllDayBalTransfer=1
FROM CustSuper cs WITH(NOLOCK) 
	INNER JOIN custInfo c WITH(NOLOCK) ON cs.custid=c.custid
	INNER JOIN exchange e WITH(NOLOCK) ON c.currency=e.exchangeid
WHERE e.currency='THB'  AND IsAllDayBalTransfer IS NULL