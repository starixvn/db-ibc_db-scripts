

/*
	Created: Winnie
	Date: 201701018
	Task: Delete redundant Fishing world settings 
	DB: DBCust/CustDB
*/
DECLARE @maxcustID INT = xxx
DECLARE @Sporttype INT, @Bettype INT, @IsLive BIT

SELECT @Sporttype = 219, @Bettype = 1011, @IsLive = 0

CREATE TABLE #supers (custid int)

INSERT INTO #supers(custid)
SELECT ci.custid
FROM customer ci WITH(NOLOCK)
WHERE (ci.roleid = 4 	
	AND ci.custid NOT IN (SELECT custid FROM Dep_CustSuper WITH(NOLOCK))
	-- Production
	AND ((ci.site   in ('733333','222223', '222225', '222227', '222229')	
	-- CROSS-SITE
		AND ci.custid NOT IN (674248,395075,1164457,1016771,993226,2453866,1156957,1156957,17721601,1156957,1036451,993226,1016771,324561,506057,2453866,1127269,1036451,1036451,2042873
		,2042873,1036451,796555,5005322))
	OR ci.currency=20)	
	)			

--PT
DELETE cs
FROM [dbo].CustPTSetting3rd_Agent cs WITH(UPDLOCK,ROWLOCK)
	INNER JOIN Customer c WITH (NOLOCK) ON cs.CustID = c.custid
	INNER JOIN #supers s ON c.srecommend = s.custid
WHERE cs.CustID > @maxcustID
	AND cs.Sporttype = @Sporttype
	AND cs.Bettype = @Bettype
	AND cs.IsLive = @IsLive
	
DELETE cs
FROM [dbo].CustPTSetting3rd_Member cs WITH(UPDLOCK,ROWLOCK)
	INNER JOIN Customer c WITH (NOLOCK) ON cs.CustID = c.custid
	INNER JOIN #supers s ON c.srecommend = s.custid
WHERE cs.CustID > @maxcustID
	AND cs.Sporttype = @Sporttype
	AND cs.Bettype = @Bettype
	AND cs.IsLive = @IsLive

DELETE cs
FROM [dbo].CustPTGroupSetting3rd_Member cs WITH(UPDLOCK,ROWLOCK)
	INNER JOIN Customer c WITH (NOLOCK) ON cs.AgentID = c.custid
	INNER JOIN #supers s ON c.srecommend = s.custid
WHERE cs.Sporttype = @Sporttype
	AND cs.Bettype = @Bettype
	AND cs.IsLive = @IsLive

--WinLossLimit
DELETE cs
FROM [dbo].CustWinLossLimit_Agent cs WITH(UPDLOCK,ROWLOCK)
	INNER JOIN Customer c WITH (NOLOCK) ON cs.CustID = c.custid
	INNER JOIN #supers s ON c.srecommend = s.custid
WHERE cs.CustID > @maxcustID
	AND cs.Sporttype = @Sporttype
	AND cs.Bettype = @Bettype

DELETE cs
FROM [dbo].CustWinLossLimit_Member cs WITH(UPDLOCK,ROWLOCK)
	INNER JOIN Customer c WITH (NOLOCK) ON cs.CustID = c.custid
	INNER JOIN #supers s ON c.srecommend = s.custid
WHERE cs.CustID > @maxcustID
	AND cs.Sporttype = @Sporttype
	AND cs.Bettype = @Bettype

