select s.custid, s.username Username, 'Super' [Type], e.Currency, s.Credit, sum(isnull(m.credit,0)) UsedCredit, e.actualrate
into #tmpCust
from custinfo s with (nolock)
	inner join CustSuper cs with (nolock) on s.custid = cs.custid
	left join custinfo m with (nolock) on s.custid = m.srecommend
	left join Dep_CustSuper ds with (nolock) on s.custid = ds.custid
	inner join exchange e with (nolock) on s.currency = e.exchangeid
where m.roleid = 3 and s.custid > 100 and s.credit > 0 and ds.custid is null
	and s.currency <> 20 and s.username not like '%TEST%' and cs.IsInternal = 0
	and s.enabled = 1 --and s.closed = 0
group by s.custid, s.username, e.Currency, s.credit, e.actualrate
UNION ALL
select m.custid, m.username Username, 'Direct Master' [Type], e.Currency, m.Credit, sum(isnull(a.credit,0)) UsedCredit, e.actualrate 
from custinfo m with (nolock)
	inner join CustMaster cm with (nolock) on m.custid = cm.custid
	left join custinfo a with (nolock) on m.custid = a.mrecommend
	inner join exchange e with (nolock) on m.currency = e.exchangeid
where a.roleid = 2 and m.srecommend <= 100 and m.credit > 0
	and m.currency <> 20 and m.username not like '%TEST%' and cm.IsInternal = 0
	and m.enabled = 1 --and m.closed = 0
group by m.custid, m.username, e.Currency, m.credit, e.actualrate
UNION
select m.custid, m.username Username, 'Direct Master' [Type], e.Currency, m.Credit, sum(isnull(a.credit,0)) UsedCredit, e.actualrate 
from custinfo m with (nolock)
	inner join CustMaster cm with (nolock) on m.custid = cm.custid
	left join custinfo a with (nolock) on m.custid = a.mrecommend
	inner join Acc_CustDirect ds with (nolock) on m.srecommend = ds.custid
	inner join exchange e with (nolock) on m.currency = e.exchangeid
where a.roleid = 2 and m.credit > 0
	and m.currency <> 20 and m.username not like '%TEST%' and cm.IsInternal = 0
	and m.enabled = 1 --and m.closed = 0
group by m.custid, m.username, e.Currency, m.credit, e.actualrate
UNION ALL
select a.custid, a.username Username, 'Direct Agent' [Type], e.Currency, a.Credit, sum(isnull(p.credit,0)) UsedCredit, e.actualrate
from custinfo a with (nolock)
	inner join CustAgent ca with (nolock) on a.custid = ca.custid
	left join custinfo p with (nolock) on a.custid = p.recommend
	inner join Acc_CustDirect ds with (nolock) on a.mrecommend = ds.custid
	inner join exchange e with (nolock) on a.currency = e.exchangeid
where p.roleid = 1 and a.credit > 0
	and a.currency <> 20 and a.username not like '%TEST%' and ca.IsInternal = 0
	and a.enabled = 1 --and a.closed = 0
group by a.custid, a.username, e.Currency, a.credit, e.actualrate



select Username, [Type], Currency, 
	Credit, UsedCredit, Credit*actualrate CreditRM, UsedCredit*actualrate UsedCreditRM
from #tmpcust

drop table #tmpcust

/*
--super bal:
SELECT 
	s.custid,
	s.username, 
	s.currency,
	IsNull(sum(case when b.custid=srecommend then winlost-actual_stake else swinlost+scomm-acomm end),0)
	+ IsNull(sum(case when b.custid=mrecommend then winlost-actual_stake else mwinlost+acomm-comm end),0)
	+ IsNull(sum(case when b.custid=recommend  then winlost-actual_stake else awinlost+comm-playercomm end),0)
	+ IsNull(sum(case when b.custid <> recommend and b.custid <> mrecommend and b.custid <> srecommend and b.ruben = 1 then winlost-actual_stake+playercomm else 0 end),0) AS Balance	
FROM #SuperInfo s
	INNER JOIN bettrans b with (READPAST) ON b.srecommend = s.custid
WHERE 
	ruben = 1 
	AND statusID NOT IN (101,102,103) 
GROUP BY s.custid, s.username, s.currency

--master bal:
 SELECT 
	srecommend, mrecommend, 
	isnull(sum(case when custid=mrecommend then winlost-actual_stake else mwinlost+acomm-comm end),0)
	+ isnull(sum(case when custid=recommend then winlost-actual_stake else awinlost+comm-playercomm end),0)
	+ isnull(sum(case when custid <> recommend and custid <> mrecommend and ruben=1 then winlost-actual_stake+playercomm else 0 end),0) AS bal	
FROM bettrans with (nolock) 
WHERE mrecommend in (SELECT custid FROM #MasterInfo WITH (NOLOCK))
	AND srecommend in (SELECT srecommend FROM #MasterInfo WITH (NOLOCK))
	AND ruben = 1 
	AND statusID NOT IN (101,102,103) 
GROUP BY mrecommend, srecommend  

--agent bal:
SELECT	recommend,
		isnull(sum(case custid 
					WHEN mrecommend then 0
					WHEN recommend then winlost-actual_stake else awinlost+comm-playercomm end),0) 
		+ isnull(sum(case when custid <> recommend AND ruben=1 then winlost-actual_stake+playercomm else 0 end),0) Bal
FROM bettrans with (nolock) 
WHERE mrecommend = @masterid
	AND ruben = 1 
	AND statusID NOT IN (101,102,103)
GROUP BY recommend
*/