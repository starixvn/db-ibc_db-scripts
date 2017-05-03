/*
	Created: Winnie
	Date: 2017-05-03
	Task: Insert colossus settings for deposit customers
	DB: DBCUST/CustDB
*/ 

------------------------------------------------------	
CREATE TABLE #tempCust(custid int,roleid int)

DECLARE @max_custid INT, @srecommend INT

SELECT @max_custid= xxx

INSERT INTO #tempCust(custid,roleid)
SELECT custid,c.roleid
FROM custInfo c WITH(NOLOCK)
WHERE srecommend IN (SELECT custid FROM Dep_CustSuper WITH(NOLOCK) WHERE site in ('Sun988') )	 
	AND Enabled=1
	AND custid NOT IN (SELECT Custid FROM Dep_AgentCommRate  da WITH(NOLOCK) WHERE SportType=204)
	AND custid NOT IN (SELECT Custid FROM Dep_CustCommRate  da WITH(NOLOCK) WHERE SportType=204)
	AND custid>@max_custid

	INSERT INTO Dep_AgentCommRate 
			   ([CustID]
			   ,[SportType]
			   ,[BetType]
			   ,[CommRate])
	SELECT  custid,204,18001,0.1215 FROM #tempCust a WITH(NOLOCK) 
	WHERE a.roleid IN(2,3,4) 
	UNION ALL
	SELECT  custid,204,18002,0.45 FROM #tempCust a WITH(NOLOCK) 
	WHERE a.roleid IN(2,3,4) 

	INSERT INTO [Dep_CustCommRate]
			   ([CustId]
			   ,[Sporttype]
			   ,[Bettype]
			   ,[sdiscount]
			   ,[adiscount]
			   ,[discount]
			   ,[playerdiscount])    
	SELECT  a.custid,204,18001,0.1215,0.1215,0.1215,0 FROM #tempCust a WITH(NOLOCK) 
	WHERE a.roleid =1	
	UNION ALL
	SELECT  a.custid,204,18002,0.45,0.45,0.45,0 FROM #tempCust a WITH(NOLOCK) 
	WHERE a.roleid =1	
-------------------------------------------------

