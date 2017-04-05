
/*
	Created: Winnie	
	Task:  Enable and UnHide Virtual Sports,Keno,OneRNG Casino,Colossus Bets,Racing for new SMA
	DB: DBCUST/CustDB
	Date: 20170404
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
	

UPDATE ci
SET	ci.DisableGoldDeluxe= CASE WHEN t.site NOT IN ('imbc','789y') THEN 0 ELSE ci.DisableGoldDeluxe END,
	ci.HideGoldDeluxe= CASE WHEN t.site NOT IN ('imbc','789y') THEN 0 ELSE ci.HideGoldDeluxe END,
	ci.HideVirtualSports=0,ci.DisableVirtualSports=0
	,ci.DisableColossusBet=0,ci.HideColossusBet=0
	,ci.DisableCasino=0,ci.HideKeno=0
	,ci.DisableHorseRacing=0,ci.DisableOpenTote=0,ci.Disable151_AU=0,ci.Disable152_AU=0,ci.Disable152_UK=0,ci.Disable153_AU=0	
FROM CustInfo CI WITH (ROWLOCK,UPDLOCK) 
INNER JOIN #tempCusts t ON ci.custid=t.custid
		

UPDATE ct
SET ct.IsDisabled=0
FROM Custgametype ct WITH (ROWLOCK,UPDLOCK) 
INNER JOIN #tempCusts CI WITH(NOLOCK) ON ct.custid=ci.custid
WHERE ct.GameTypeID between 1 and 16
drop table #tempCusts