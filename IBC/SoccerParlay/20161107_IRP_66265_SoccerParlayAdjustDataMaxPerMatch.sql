
/*
	Created by: Winnie
	Date: 2016-11-07
	Task:  Adjust data MaxPerMatch for Parlay Soccer credit customer[Redmine:#66265]
	DB: DBCUST/CustDB
*/ 
CREATE TABLE #supers (custid int)

INSERT INTO #supers(custid)
SELECT custid
FROM custinfo WITH(NOLOCK)
WHERE custid NOT IN (SELECT custid FROM Dep_CustSuper WITH(NOLOCK))
	AND roleid = 4 
	
UPDATE T
	SET MaxPerMatch1MP=Maxpermatch
FROM custInfo T WITH(UPDLOCK,ROWLOCK) 	
	INNER JOIN #supers S ON S.custid = T.srecommend
WHERE  ISNULL(MaxPerMatch1MP,-1) <> Maxpermatch		
