
/*
	Created: Winnie	
	Task:  Enable and UnHide Virtual Sports,Keno,OneRNG Casino,Colossus Bets,Racing for new SMA
	DB: DBCUST/CustDB
	Date: 20170515
*/ 
DECLARE	
	@maxcustid INT	
	,@Site VARCHAR(10)
	
CREATE TABLE #tempCusts (custid int,site varchar(10))
SELECT @maxcustid = xxx

INSERT INTO #tempCusts(custid,site)
SELECT c.custid,s.site
FROM dbo.Customer s WITH(NOLOCK)
INNER JOIN custInfo c WITH(NOLOCK) ON c.srecommend=s.custid
WHERE (s.roleid = 4 	
AND s.custid NOT IN (SELECT custid FROM Dep_CustSuper WITH(NOLOCK)) 
AND c.Enabled=1	
AND c.custid>@maxcustid
AND c.roleid IN(2,3,4)
)

-- update casino
UPDATE ci
SET	ci.DisableCasino=0
FROM CustInfo CI WITH (ROWLOCK,UPDLOCK) 
INNER JOIN #tempCusts t ON ci.custid=t.custid
WHERE ci.SyncCasino=1	AND ci.DisableCasino=1	

-- update GD
UPDATE ci
SET	
	ci.[DisableGoldDeluxe]=0
FROM CustInfo CI WITH (ROWLOCK,UPDLOCK) 
INNER JOIN #tempCusts t ON ci.custid=t.custid
WHERE ci.HideGoldDeluxe=0 AND ci.[DisableGoldDeluxe]=1	AND t.site NOT IN ('imbc','789y')
			
--VS
UPDATE ci
SET	ci.DisableVirtualSports=0	
FROM CustInfo CI WITH (ROWLOCK,UPDLOCK) 
INNER JOIN #tempCusts t ON ci.custid=t.custid 
WHERE ci.HideVirtualSports=0

UPDATE ci
SET	ci.DisableColossusBet=0
FROM CustInfo CI WITH (ROWLOCK,UPDLOCK) 
INNER JOIN #tempCusts t ON ci.custid=t.custid
WHERE ci.HideColossusBet=0

UPDATE ci
SET ci.DisableHorseRacing=0,ci.DisableOpenTote=0,ci.Disable151_AU=0,ci.Disable152_AU=0,ci.Disable152_UK=0,ci.Disable153_AU=0	
FROM CustInfo CI WITH (ROWLOCK,UPDLOCK) 
INNER JOIN #tempCusts t ON ci.custid=t.custid

UPDATE ct
SET ct.IsDisabled=0
FROM Custgametype ct WITH (ROWLOCK,UPDLOCK)
INNER JOIN #tempCusts CI WITH(NOLOCK) ON ct.custid=ci.custid
INNER JOIN custInfo c WITH(NOLOCK) ON ci.custid=c.custid
WHERE ct.GameTypeID between 1 and 16 AND c.HideKeno=0 AND ct.IsDisabled=1

DROP TABLE #tempCusts