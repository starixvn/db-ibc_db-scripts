/*
	Created: Winnie
	Date: 2016-11-11
	Task: Adjust Soccer parlay settings (minbet,maxbet) from Soccer for credit customer RedmineID: #66265
	DB: DBCUST/CustDB
*/ 
	CREATE TABLE #tmp (CustID INT  PRIMARY KEY,minbet MONEY, maxbet MONEY)	
	INSERT INTO #tmp(CustID,minbet , maxbet )
	SELECT 	cs1.custid ,cs1.minbet , cs1.maxbet 
	FROM custinfo ci WITH(NOLOCK)	
	INNER JOIN CustSetting cs1 WITH(NOLOCK)  ON cs1.custid = ci.custid AND cs1.sporttype=1 AND cs1.bettype=1
	INNER JOIN CustSetting cs9 WITH(NOLOCK)  ON cs9.custid = ci.custid AND cs9.sporttype=1 AND cs9.bettype=9
	WHERE  cs1.maxbet<>cs9.maxbet OR cs1.minbet<>cs1.minbet
	
	UPDATE a
	SET a.minbet=b.minbet,a.maxbet=b.maxbet
	FROM CustSetting a  WITH(ROWLOCK,UPDLOCK)
	INNER JOIN #tmp b ON a.custid=b.CustID 	
	AND Sporttype=1 AND bettype=9   