/*
	Created: Elodie
	Date: 20160301
	Task: Delete redundant Voidbridge settings 
	DB: DBCust/CustDB
*/
DECLARE @maxcustID1 INT = xxx, @maxcustID2 INT = xxx
DECLARE @Sporttype INT, @Bettype INT, @IsLive BIT

SELECT @Sporttype = 212, @Bettype = 4001, @IsLive = 0

CREATE TABLE #supers (custid int)

INSERT INTO #supers(custid)
SELECT ci.custid
FROM customer ci WITH(NOLOCK)
	INNER JOIN site s WITH (NOLOCK) ON ci.site = s.site
	LEFT JOIN custsuper cs WITH (NOLOCK) ON ci.custid = cs.custid
WHERE (ci.roleid = 4  
			AND ci.username NOT LIKE '3rdSuper%'
			AND cs.isinternal = 0
			AND ci.custid NOT IN (SELECT custid FROM Dep_CustSuper WITH(NOLOCK))
			AND s.islicensee = 0
			AND ci.site IN ('789y', '733333'))
		OR ci.custid IN (2) --Dummy account

--PT
DELETE cs
FROM [dbo].CustPTSetting3rd_Agent cs WITH(UPDLOCK,ROWLOCK)
	INNER JOIN Customer c WITH (NOLOCK) ON cs.CustID = c.custid
	INNER JOIN #supers s ON c.srecommend = s.custid
WHERE cs.CustID > @maxcustID1
	AND cs.Sporttype = @Sporttype
	AND cs.Bettype = @Bettype
	AND cs.IsLive = @IsLive
	
	
DELETE cs
FROM [dbo].CustPTSetting3rd_Member cs WITH(UPDLOCK,ROWLOCK)
	INNER JOIN Customer c WITH (NOLOCK) ON cs.CustID = c.custid
	INNER JOIN #supers s ON c.srecommend = s.custid
WHERE cs.CustID > @maxcustID1
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

--Commission
DELETE cs
FROM [dbo].CustDiscount3rd_Agent cs WITH(UPDLOCK,ROWLOCK)
	INNER JOIN Customer c WITH (NOLOCK) ON cs.CustID = c.custid
	INNER JOIN #supers s ON c.srecommend = s.custid
WHERE cs.CustID > @maxcustID1
	AND cs.Sporttype = @Sporttype
	AND cs.Bettype = @Bettype

DELETE cs
FROM [dbo].CustDiscount3rd_Member cs WITH(UPDLOCK,ROWLOCK)
	INNER JOIN Customer c WITH (NOLOCK) ON cs.CustID = c.custid
	INNER JOIN #supers s ON c.srecommend = s.custid
WHERE cs.CustID > @maxcustID1
	AND cs.Sporttype = @Sporttype
	AND cs.Bettype = @Bettype

--WinLossLimit
DELETE cs
FROM [dbo].CustWinLossLimit_Agent cs WITH(UPDLOCK,ROWLOCK)
	INNER JOIN Customer c WITH (NOLOCK) ON cs.CustID = c.custid
	INNER JOIN #supers s ON c.srecommend = s.custid
WHERE cs.CustID > @maxcustID2
	AND cs.Sporttype = @Sporttype
	AND cs.Bettype = @Bettype

DELETE cs
FROM [dbo].CustWinLossLimit_Member cs WITH(UPDLOCK,ROWLOCK)
	INNER JOIN Customer c WITH (NOLOCK) ON cs.CustID = c.custid
	INNER JOIN #supers s ON c.srecommend = s.custid
WHERE cs.CustID > @maxcustID2
	AND cs.Sporttype = @Sporttype
	AND cs.Bettype = @Bettype

--StakeLevel
DELETE cs
FROM [dbo].CustStakeLevel_Agent cs WITH(UPDLOCK,ROWLOCK)
	INNER JOIN Customer c WITH (NOLOCK) ON cs.CustID = c.custid
	INNER JOIN #supers s ON c.srecommend = s.custid
WHERE cs.CustID > @maxcustID2
	AND cs.Sporttype = @Sporttype
	AND cs.Bettype = @Bettype

DELETE cs
FROM [dbo].CustStakeLevel_Member cs WITH(UPDLOCK,ROWLOCK)
	INNER JOIN Customer c WITH (NOLOCK) ON cs.CustID = c.custid
	INNER JOIN #supers s ON c.srecommend = s.custid
WHERE cs.CustID > @maxcustID2
	AND cs.Sporttype = @Sporttype
	AND cs.Bettype = @Bettype
