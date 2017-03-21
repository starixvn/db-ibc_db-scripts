

/*
	Created: Winnie
	Date: 20170313
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
INNER JOIN custInfo c WITH(NOLOCK) ON ci.custid=c.custid
WHERE (ci.roleid = 4 	
AND ci.custid NOT IN (SELECT custid FROM Dep_CustSuper WITH(NOLOCK)) 
AND c.Enabled=1	
AND ci.site IN ('611111','722222','766666','789y', '7aa666', 'XYZbet', 'Best-odds')	
-- exclude dummy <=100
AND  ci.custid >100
-- exclude dummy >100
AND ci.custid NOT IN (1469577, 21278849, 21278858)
AND ci.currency<>20
) 		
-- CROSS-SITE
OR ci.custid IN (674248,395075,1164457,17721601,1016771,324561,1127269,938136)		
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
WHERE c.custid > @maxcustID AND
	cs.Sporttype = @Sporttype
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

