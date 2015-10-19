/*
	Created: Johnson
	Date: 2015-10-19
	Task: get customer list enabled GD but no have bet limit
	DB: DBCUST/CUSTDB
*/ 
CREATE TABLE #supers (custid int)

INSERT INTO #supers
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
	AND ci.currency NOT IN (20,44,45,62)
GO
	

SELECT DISTINCT a.custid, a.recommend, a.mrecommend, a.srecommend
INTO #tmpCust
FROM custinfo a WITH(NOLOCK)
	INNER JOIN CustGameType cg WITH(NOLOCK) ON a.custid = cg.custid
												AND cg.gameTypeID IN (1701,1702)	 
													
WHERE a.srecommend IN (SELECT custid FROM #supers)
	AND a.DisableGoldDeluxe = 0
	AND a.roleid = 1
	AND cg.StakeLevelList = ''
	

SELECT DISTINCT a.custid, a.username, ag.username as agent, mag.username as master, ci.username as super, hl.username as Headline
FROM custinfo a WITH(NOLOCK)
	INNER JOIN customer ag with(nolock) on a.recommend = ag.custid
	INNER JOIN custinfo mag with(nolock) on a.mrecommend = mag.custid
	INNER JOIN custinfo ci with(nolocK) on a.srecommend = ci.custid
	INNER JOIN Exchange e with (nolock) on ci.currency =e.exchangeid
	INNER JOIN customer c with (nolock) on ci.custid = c.custid
	INNER JOIN site s with (nolock) on c.site = s.site
	LEFT JOIN custsuper cs with (nolock) on ci.custid = cs.custid
	LEFT JOIN custAccount ca with (nolock) on ca.custid = ci.custid
	LEFT JOIN (select aa.custid, groupid, username from custaccount aa with (nolock)
				   inner join custinfo bb with (nolock) on aa.custid = bb.custid
				   where isgroupheadline = 1) hl on hl.groupid = ca.groupid
WHERE a.custid IN (SELECT custid FROM #tmpCust)
	AND ag.site <> '789y'
order by Headline, super,master, agent, username				   
GO



SELECT DISTINCT a.custid, a.mrecommend, a.srecommend
INTO #tmpAgent
FROM custinfo a WITH(NOLOCK)
	INNER JOIN CustGameType cg WITH(NOLOCK) ON a.custid = cg.custid
												AND cg.gameTypeID IN (1701,1702)	 
													
WHERE a.srecommend IN (SELECT custid FROM #supers)
	AND a.custid NOT IN (SELECT recommend FROM #tmpCust)
	AND a.DisableGoldDeluxe = 0
	AND a.roleid = 2
	AND cg.StakeLevelList = ''
	

SELECT DISTINCT a.custid, a.username, mag.username as master, ci.username as super, hl.username as Headline
FROM customer a with(nolock) 
	INNER JOIN custinfo mag with(nolock) on a.mrecommend = mag.custid
	INNER JOIN custinfo ci with(nolocK) on a.srecommend = ci.custid
	INNER JOIN Exchange e with (nolock) on ci.currency =e.exchangeid
	INNER JOIN customer c with (nolock) on ci.custid = c.custid
	INNER JOIN site s with (nolock) on c.site = s.site
	LEFT JOIN custsuper cs with (nolock) on ci.custid = cs.custid
	LEFT JOIN custAccount ca with (nolock) on ca.custid = ci.custid
	LEFT JOIN (select aa.custid, groupid, username from custaccount aa with (nolock)
				   inner join custinfo bb with (nolock) on aa.custid = bb.custid
				   where isgroupheadline = 1) hl on hl.groupid = ca.groupid
WHERE a.custid IN (SELECT custid FROM #tmpAgent)
	AND a.site <> '789y'
order by Headline, super,master, username				   
GO	



SELECT DISTINCT a.custid, a.srecommend
INTO #tmpMaster
FROM custinfo a WITH(NOLOCK)
	INNER JOIN CustGameType cg WITH(NOLOCK) ON a.custid = cg.custid
												AND cg.gameTypeID IN (1701,1702)	 
WHERE a.srecommend IN (SELECT custid FROM #supers)
	AND a.custid NOT IN (SELECT mrecommend FROM #tmpCust)
	AND a.custid NOT IN (SELECT mrecommend FROM #tmpAgent)
	AND a.DisableGoldDeluxe = 0
	AND a.roleid = 2
	AND cg.StakeLevelList = ''
	

SELECT DISTINCT a.custid, a.username, ci.username as super, hl.username as Headline
FROM customer a with(nolock) 
	INNER JOIN custinfo ci with(nolocK) on a.srecommend = ci.custid
	INNER JOIN Exchange e with (nolock) on ci.currency =e.exchangeid
	INNER JOIN customer c with (nolock) on ci.custid = c.custid
	INNER JOIN site s with (nolock) on c.site = s.site
	LEFT JOIN custsuper cs with (nolock) on ci.custid = cs.custid
	LEFT JOIN custAccount ca with (nolock) on ca.custid = ci.custid
	LEFT JOIN (select aa.custid, groupid, username from custaccount aa with (nolock)
				   inner join custinfo bb with (nolock) on aa.custid = bb.custid
				   where isgroupheadline = 1) hl on hl.groupid = ca.groupid
WHERE a.custid IN (SELECT custid FROM #tmpMaster)
	AND a.site <> '789y'
order by Headline, super,  username				   
GO	


SELECT DISTINCT a.custid
INTO #tmpSuper
FROM custinfo a WITH(NOLOCK)
	INNER JOIN CustGameType cg WITH(NOLOCK) ON a.custid = cg.custid
												AND cg.gameTypeID IN (1701,1702)	 
WHERE a.custid IN (SELECT custid FROM #supers)
	AND a.custid NOT IN (SELECT srecommend FROM #tmpCust)
	AND a.custid NOT IN (SELECT srecommend FROM #tmpAgent)
	AND a.custid NOT IN (SELECT srecommend FROM #tmpMaster)
	AND a.DisableGoldDeluxe = 0
	AND cg.StakeLevelList = ''
	

SELECT DISTINCT ci.custid, ci.username, hl.username as Headline
FROM customer ci with(nolocK) 
	INNER JOIN Exchange e with (nolock) on ci.currency =e.exchangeid
	INNER JOIN customer c with (nolock) on ci.custid = c.custid
	INNER JOIN site s with (nolock) on c.site = s.site
	LEFT JOIN custsuper cs with (nolock) on ci.custid = cs.custid
	LEFT JOIN custAccount ca with (nolock) on ca.custid = ci.custid
	LEFT JOIN (select aa.custid, groupid, username from custaccount aa with (nolock)
				   inner join custinfo bb with (nolock) on aa.custid = bb.custid
				   where isgroupheadline = 1) hl on hl.groupid = ca.groupid
WHERE ci.custid IN (SELECT custid FROM #tmpSuper)
	AND ci.site <> '789y'
order by Headline, username				   
GO	