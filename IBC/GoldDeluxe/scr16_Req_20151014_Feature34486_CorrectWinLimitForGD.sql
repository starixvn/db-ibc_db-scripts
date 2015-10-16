  /*
	Created: Johnson
	Date: 2015-10-14
	Task: correct GD win limit for un-sync customers list
	DB: DBCUST/CUSTDB
 */
 --deploy table CheckGDWinLimit on DBCUST 
 CREATE TABLE CheckGDWinLimit (custid INT, username varchar(30), maxWinLimitA smallmoney, isAutoResetA bit, custidB INT, maxWinLimitB smallmoney, isAutoResetB bit, roleid INT)
 GO
 
 CREATE TABLE ##supers (custid int, isfinished bit default(0))

INSERT INTO ##supers(custid)
SELECT ci.custid
FROM CustInfo ci WITH(NOLOCK)
	INNER JOIN customer c WITH (NOLOCK) ON ci.custid = c.custid
	INNER JOIN site s WITH (NOLOCK) ON c.site = s.site
	LEFT JOIN custsuper cs WITH (NOLOCK) ON ci.custid = cs.custid
WHERE ci.roleid = 4 	
	AND ci.username NOT LIKE '3rdSuper%'
	AND cs.isinternal = 0
	AND ci.custid NOT IN (SELECT custid FROM Dep_CustSuper WITH(NOLOCK))
	and s.islicensee = 0
GO


DECLARE @srecommend INT

WHILE (1 = 1)
BEGIN
	UPDATE TOP (1) ##Supers
	SET isfinished = 1
		,@srecommend = custid			
	WHERE isfinished = 0
	
	IF @@ROWCOUNT = 0 BREAK
	
	INSERT INTO CheckGDWinLimit(custid, username, maxWinLimitA, isAutoResetA, custidB, maxWinLimitB, isAutoResetB, roleid)	
	SELECT ci.custid as custid,ci.username, cs.maxWinLimit as maxWinLimitA, cs.isAutoReset as isAutoResetA, ci.srecommend as custidB,  scs.maxWinLimit as maxWinLimitB, scs.isAutoReset as isAutoResetB, 3
	FROM CustWinLimit cs WITH(NOLOCK)
		INNER JOIN CustInfo ci WITH(NOLOCK) ON cs.custid = ci.custid
		INNER JOIN CustWinLimit scs WITH(NOLOCK) ON scs.custid = ci.srecommend
													AND scs.sporttype = cs.sporttype
													AND scs.bettype = cs.bettype
	WHERE ci.srecommend = @srecommend 
		AND ci.roleid = 3
		AND cs.sporttype = 255
		AND cs.bettype = 1701
		AND (
				(scs.maxWinLimit > 0 AND (cs.maxWinLimit = 0 OR cs.maxWinLimit > scs.maxWinlimit))
				OR (scs.IsAutoReset = 0 AND cs.IsAutoReset = 1)
			)

	INSERT INTO CheckGDWinLimit(custid, username, maxWinLimitA, isAutoResetA, custidB, maxWinLimitB, isAutoResetB, roleid)	
	SELECT ci.custid as custid,ci.username, cs.maxWinLimit as maxWinLimitA, cs.isAutoReset as isAutoResetA, ci.mrecommend as custidB,  mcs.maxWinLimit as maxWinLimitB, mcs.isAutoReset as isAutoResetB, 2
	FROM CustWinLimit cs WITH(NOLOCK)
		INNER JOIN CustInfo ci WITH(NOLOCK) ON cs.custid = ci.custid
		INNER JOIN CustWinLimit scs WITH(NOLOCK) ON scs.custid = ci.srecommend
													AND scs.sporttype = cs.sporttype
													AND scs.bettype = cs.bettype
		INNER JOIN CustWinLimit mcs WITH(NOLOCK) ON mcs.custid = ci.mrecommend
													AND mcs.sporttype = cs.sporttype
													AND mcs.bettype = cs.bettype													
	WHERE ci.srecommend = @srecommend 
		AND ci.roleid = 2
		AND cs.sporttype = 255
		AND cs.bettype = 1701
		AND (
				(scs.maxWinLimit > 0 AND (mcs.maxWinLimit = 0 OR cs.maxWinLimit = 0 OR cs.maxWinLimit > mcs.maxWinlimit))
				OR (scs.maxWinLimit = 0 AND (mcs.maxWinLimit > 0 AND (cs.maxWinLimit = 0 OR cs.maxWinLimit > mcs.maxWinlimit)))
				OR (scs.IsAutoReset = 0 AND (mcs.IsAutoReset = 1 OR cs.IsAutoReset = 1))
				OR (scs.IsAutoReset = 1 AND mcs.IsAutoReset = 0 AND cs.IsAutoReset = 1)
			)

	INSERT INTO CheckGDWinLimit(custid, username, maxWinLimitA, isAutoResetA, custidB, maxWinLimitB, isAutoResetB, roleid)	
	SELECT ci.custid as custid,ci.username, cs.maxWinLimit as maxWinLimitA, cs.isAutoReset as isAutoResetA, ci.recommend as custidB,  acs.maxWinLimit as maxWinLimitB, acs.isAutoReset as isAutoResetB, 1
	FROM CustWinLimit cs WITH(NOLOCK)
		INNER JOIN CustInfo ci WITH(NOLOCK) ON cs.custid = ci.custid
		INNER JOIN CustWinLimit scs WITH(NOLOCK) ON scs.custid = ci.srecommend
													AND scs.sporttype = cs.sporttype
													AND scs.bettype = cs.bettype
		INNER JOIN CustWinLimit mcs WITH(NOLOCK) ON mcs.custid = ci.mrecommend
													AND mcs.sporttype = cs.sporttype
													AND mcs.bettype = cs.bettype													
		INNER JOIN CustWinLimit acs WITH(NOLOCK) ON acs.custid = ci.recommend
													AND acs.sporttype = cs.sporttype
													AND acs.bettype = cs.bettype													
	WHERE ci.srecommend = @srecommend 
		AND ci.roleid = 1
		AND cs.sporttype = 255
		AND cs.bettype = 1701
		AND (
				(scs.maxWinLimit > 0 AND (mcs.maxWinLimit = 0 OR acs.maxWinLimit = 0 OR cs.maxWinLimit = 0 OR cs.maxWinLimit > acs.maxWinlimit))
				OR (scs.maxWinLimit > 0 AND mcs.maxWinLimit > 0 AND (acs.maxWinLimit = 0 OR cs.maxWinLimit = 0 OR cs.maxWinLimit > acs.maxWinlimit))
				OR (scs.maxWinLimit > 0 AND mcs.maxWinLimit > 0 AND acs.maxWinLimit > 0 AND (cs.maxWinLimit = 0 OR cs.maxWinLimit > acs.maxWinlimit))
				OR (scs.maxWinLimit = 0 AND mcs.maxWinLimit = 0 AND acs.maxWinLimit > 0 AND (cs.maxWinLimit = 0 OR cs.maxWinLimit > acs.maxWinlimit))
				OR (scs.maxWinLimit = 0 AND mcs.maxWinLimit > 0 AND acs.maxWinLimit > 0 AND (cs.maxWinLimit = 0 OR cs.maxWinLimit > acs.maxWinlimit))
				OR (scs.maxWinLimit = 0 AND mcs.maxWinLimit > 0 AND acs.maxWinLimit = 0 AND cs.maxWinLimit = 0)
				OR (scs.IsAutoReset = 0 AND (mcs.IsAutoReset = 1 OR acs.IsAutoReset = 1 OR cs.IsAutoReset = 1))--un-sync master
				OR (scs.IsAutoReset = 0 AND mcs.IsAutoReset = 0 AND (acs.IsAutoReset = 1 OR cs.IsAutoReset = 1))--un-sync agent
				OR (scs.IsAutoReset = 0 AND mcs.IsAutoReset = 0 AND acs.IsAutoReset = 0 AND cs.IsAutoReset = 1)	--un-sync member			
				OR (scs.IsAutoReset = 1 AND mcs.IsAutoReset = 0 AND (acs.IsAutoReset = 1 OR cs.IsAutoReset = 1))--un-sync agent
				OR (scs.IsAutoReset = 1 AND mcs.IsAutoReset = 0 AND acs.IsAutoReset = 0 AND cs.IsAutoReset = 1)--un-sync member	
				OR (scs.IsAutoReset = 1 AND mcs.IsAutoReset = 1 AND acs.IsAutoReset = 0 AND cs.IsAutoReset = 1)--un-sync member	
			)
END
		--select count(1) from CheckGDWinLimit							
			
CREATE TABLE #tmp (custid INT)

DELETE #tmp

UPDATE top (10000) CheckGDWinLimit
SET isfinished = 1
OUTPUT DELETED.Custid
INTO #tmp
WHERE isfinished = 0
	AND roleid = 3--run by level , roleid (2,1) run after
GO

--run with roleid = 3
UPDATE cs
SET cs.maxWinLimit = CASE WHEN scs.maxWinLimit > 0 AND (cs.maxWinLimit = 0 OR cs.maxWinLimit > scs.maxWinlimit) THEN scs.maxWinlimit ELSE cs.maxWinLimit END,
	cs.IsAutoReset = CASE WHEN scs.IsAutoReset = 0 AND cs.IsAutoReset = 1 THEN scs.IsAutoReset ELSE cs.IsAutoReset END
FROM CustWinLimit cs WITH(UPDLOCK,ROWLOCK)
		INNER JOIN CustInfo ci WITH(NOLOCK) ON cs.custid = ci.custid
		INNER JOIN CustWinLimit scs WITH(NOLOCK) ON scs.custid = ci.srecommend
													AND scs.sporttype = cs.sporttype
													AND scs.bettype = cs.bettype
	WHERE ci.custid IN (SELECT custid FROM #tmp)
		AND cs.sporttype = 255
		AND cs.bettype = 1701
		AND (
				(scs.maxWinLimit > 0 AND (cs.maxWinLimit = 0 OR cs.maxWinLimit > scs.maxWinlimit))
				OR (scs.IsAutoReset = 0 AND cs.IsAutoReset = 1)
			)

GO

--run with roleid = 2
UPDATE cs
SET cs.maxWinLimit = CASE WHEN scs.maxWinLimit > 0 AND (cs.maxWinLimit = 0 OR cs.maxWinLimit > scs.maxWinlimit) THEN scs.maxWinlimit ELSE cs.maxWinLimit END,
	cs.IsAutoReset = CASE WHEN scs.IsAutoReset = 0 AND cs.IsAutoReset = 1 THEN scs.IsAutoReset ELSE cs.IsAutoReset END
FROM CustWinLimit cs WITH(UPDLOCK,ROWLOCK)
		INNER JOIN CustInfo ci WITH(NOLOCK) ON cs.custid = ci.custid
		INNER JOIN CustWinLimit scs WITH(NOLOCK) ON scs.custid = ci.mrecommend
													AND scs.sporttype = cs.sporttype
													AND scs.bettype = cs.bettype
	WHERE ci.custid IN (SELECT custid FROM #tmp)
		AND cs.sporttype = 255
		AND cs.bettype = 1701
		AND (
				(scs.maxWinLimit > 0 AND (cs.maxWinLimit = 0 OR cs.maxWinLimit > scs.maxWinlimit))
				OR (scs.IsAutoReset = 0 AND cs.IsAutoReset = 1)
			)			
GO

--run with roleid = 1
UPDATE cs
SET cs.maxWinLimit = CASE WHEN scs.maxWinLimit > 0 AND (cs.maxWinLimit = 0 OR cs.maxWinLimit > scs.maxWinlimit) THEN scs.maxWinlimit ELSE cs.maxWinLimit END,
	cs.IsAutoReset = CASE WHEN scs.IsAutoReset = 0 AND cs.IsAutoReset = 1 THEN scs.IsAutoReset ELSE cs.IsAutoReset END
FROM CustWinLimit cs WITH(UPDLOCK,ROWLOCK)
		INNER JOIN CustInfo ci WITH(NOLOCK) ON cs.custid = ci.custid
		INNER JOIN CustWinLimit scs WITH(NOLOCK) ON scs.custid = ci.recommend
													AND scs.sporttype = cs.sporttype
													AND scs.bettype = cs.bettype
	WHERE ci.custid IN (SELECT custid FROM #tmp)
		AND cs.sporttype = 255
		AND cs.bettype = 1701
		AND (
				(scs.maxWinLimit > 0 AND (cs.maxWinLimit = 0 OR cs.maxWinLimit > scs.maxWinlimit))
				OR (scs.IsAutoReset = 0 AND cs.IsAutoReset = 1)
			)	
			

		
		
	    