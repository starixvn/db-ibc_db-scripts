
--DB06.bodb02
select username Trader, count(distinct b.matchid) [Match Count]
from bodb_archive.dbo.Dot_Admin_Assignment_Operator_bk b with (nolock)
	inner join Customer c with (nolock) on b.OperatorID = c.custid
	inner join bodb_archive.dbo.match_bk m with (nolock) on b.matchid = m.matchid
where eventdate >= '2015-8-1' and eventdate < '2015-9-1'
	--AND OperatorType <> 3 --trader
	AND OperatorType = 3 --suspender
group by username