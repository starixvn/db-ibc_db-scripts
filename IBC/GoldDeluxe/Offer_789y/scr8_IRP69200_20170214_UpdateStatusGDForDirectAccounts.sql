/*
	Created: Johnson
	Date: 2017-02-14
	Task: update status for direct accounts under 789y site
	DB: DBCust/CustDB
*/
--4 rows affected
--direct masters
select c.* 
into #masters
from custinfo c with(nolock)
inner join customer ci with(nolock) on ci.custid=c.custid
where site='789y'
and c.Enabled=1
and c.roleid=3
and c.srecommend in (select custid from  Acc_CustDirect with(nolock))
and c.custid not in (select custid from Acc_CustDirect with(nolock))
and c.srecommend <> 21278849 --SA-US$789y

--4 rows affected
--direct agents
select c.* 
into #agents
from custinfo c with(nolock)
inner join customer ci with(nolock) on ci.custid=c.custid
where site='789y'
and c.Enabled=1
and c.roleid=2
and c.mrecommend in (select custid from  Acc_CustDirect with(nolock))
and c.custid not in (select custid from Acc_CustDirect with(nolock))
and c.srecommend <> 21278849 --SA-US$789y

--25 rows
UPDATE custinfo WITH(UPDLOCK,ROWLOCK)
SET HideGoldDeluxe = CASE WHEN syncLiveCasino = 1 THEN 0 ELSE 1 END,
	DisableGoldDeluxe = CASE WHEN syncLiveCasino = 1 AND roleid IN (2,3,4) THEN 0 ELSE 1 END
WHERE (mrecommend IN (SELECT custid FROM #masters)
	OR recommend IN (SELECT custid FROM #agents))
	AND enabled = 1
	
--update uplines
UPDATE custinfo WITH(UPDLOCK,ROWLOCK)
SET HideGoldDeluxe = CASE WHEN syncLiveCasino = 1 THEN 0 ELSE 1 END,
	DisableGoldDeluxe = CASE WHEN syncLiveCasino = 1 AND roleid IN (2,3,4) THEN 0 ELSE 1 END
WHERE (custid IN (SELECT srecommend FROM #masters)
	OR custid IN (SELECT mrecommend FROM #agents)
	OR custid IN (SELECT srecommend FROM #agents))
	AND enabled = 1	


