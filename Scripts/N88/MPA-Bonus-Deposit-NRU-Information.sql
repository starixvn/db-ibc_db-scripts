-- run on DBN88-bodb_N88 (DB052.bodb_N88)

use bodb_N88
go

declare @siteId int = 1 -- 1: Nova88, 2: Goal123, 3: Bwing
		,@fromdate datetime = ''
		,@todate datetime = ''
		,@timezone int = 8

declare @fdate datetime, @tdate datetime -- for convert gmt time
select @fdate = dateadd(hour, -@timezone, @fromdate), @tdate = dateadd(hour, -@timezone, @todate)

declare @CreditAgentName varchar(30) = '', @MainUrl varchar(200)
declare @MainUrls table (Url varchar(200))
create table #Affiliate (CustId int, AffName varchar(50))

if @SiteId = 1
begin
	insert into @MainUrls (Url)
	values ('www.nova88.com'), ('www.nova88.net'), ('m.nova88.net')
	
	insert into #Affiliate (CustId, AffName)
	select mi.CustId, ai.UserName
	from Affiliate_N88.dbo.MemberInfo mi with (nolock)
		INNER JOIN Affiliate_N88.dbo.AffInfo ai with (nolock) on mi.AffId = ai.AffId
end
else if @SiteId = 2
begin
	select @CreditAgentName = 'Goal123Ref01', @MainUrl = 'Goal123.com'

	insert into @MainUrls (Url)
	values ('www.goal123.com'), ('m.goal123.com')

	insert into #Affiliate (CustId, AffName)
	select mi.CustId, ai.UserName
	from Affiliate_N8G.dbo.MemberInfo mi with (nolock)
		INNER JOIN Affiliate_N8G.dbo.AffInfo ai with (nolock) on mi.AffId = ai.AffId
end
else if @SiteId = 3
begin
	select @CreditAgentName = 'BwingRef01', @MainUrl = 'Bwing.com'

	insert into @MainUrls (Url)
	values ('www.bwing.com'), ('m.bwing.com')

	insert into #Affiliate (CustId, AffName)
	select mi.CustId, ai.UserName
	from Affiliate_N8B.dbo.MemberInfo mi with (nolock)
		INNER JOIN Affiliate_N8B.dbo.AffInfo ai with (nolock) on mi.AffId = ai.AffId
end

-- I. Bonus Info
select CustId, BonusCode, SUM(BonusAmount) AS Amount
into #BonusInfo
from dbo.BonusInfo b with (nolock)
where CreateTime >= @fdate and CreateTime < @tdate
	and SiteId = @siteId
group by CustId, BonusCode

select ag.UserName AS AgentName, a.AffName
	,isnull(cg.SignupUrl, 'None') as SignupUrl
	,b.BonusCode
	,count(1) as BonusClaimed
	,count(distinct c.CustId) as TotalPlayers
	,sum(b.Amount) as BonusAmount
from #BonusInfo b
	inner join dbo.Customer c with (nolock) on b.CustId = c.CustId
	inner join dbo.Customer ag with (nolock) on c.AgentId = ag.CustId
	left join #Affiliate a ON c.CustId = a.CustId
	left join dbo.CustRegInfo cg with (nolock) on c.CustId = cg.CustId
where c.IsTest = 0
	and c.SiteId = @siteId
group by ag.UserName, a.AffName, isnull(cg.SignupUrl, 'None'), b.BonusCode
order by BonusAmount desc

drop table #BonusInfo

-----------

-- II. Deposit Info
select custid, sum(amount) as Amount, sum(case when FirstDeposit = 1 then amount else 0 end) as FirstDepositAmount
into #DepositInfo
from dbo.DepositInfo with (nolock)
where CreateTime >= @fdate and CreateTime < @tdate
	and SiteId = @SiteId
	and Status = 3 -- Approved
group by custid

-- II.1 Deposit Detail
select ag.UserName AS AgentName, a.AffName
	, isnull(cg.SignupUrl, 'None') as SignupUrl
	, count(1) as TotalPlayers
	, sum(isnull(d.amount, 0)) as TotalDepositAmount
	, sum(isnull(d.firstdepositamount, 0)) as TotalFirstDepositAmount
from #DepositInfo d
	inner join dbo.Customer c with (nolock) on d.CustId = c.CustId
	inner join dbo.Customer ag with (nolock) on c.AgentId = ag.CustId
	left join #Affiliate a ON c.CustId = a.CustId
	left join dbo.CustRegInfo cg with (nolock) on c.CustId = cg.CustId
	left join @MainUrls mu ON cg.SignupUrl = mu.Url
where c.SiteId = @SiteId and c.IsTest = 0
group by ag.UserName, a.AffName, isnull(cg.SignupUrl, 'None')
order by TotalDepositAmount desc

-- II.1 Deposit Sum
select
	case
		when a.CustId is not null then 'AFF'
		when ag.UserName = @CreditAgentName then 'Bong88/Viva88'
		when mu.Url is not null then @MainUrl
		when cg.SignupUrl is not null then 'Landing pages'
		else 'None' end as SignupUrl
	, count(1) as TotalPlayers
	, sum(isnull(d.amount, 0)) as TotalDepositAmount
	, sum(isnull(d.firstdepositamount, 0)) as TotalFirstDepositAmount
from #DepositInfo d
	inner join dbo.Customer c with (nolock) on d.CustId = c.CustId
	inner join dbo.Customer ag with (nolock) on c.AgentId = ag.CustId
	left join #Affiliate a ON c.CustId = a.CustId
	left join dbo.CustRegInfo cg with (nolock) on c.CustId = cg.CustId
	left join @MainUrls mu ON cg.SignupUrl = mu.Url
where c.SiteId = @SiteId and c.IsTest = 0
group by
	case
		when a.CustId is not null then 'AFF'
		when ag.UserName = @CreditAgentName then 'Bong88/Viva88'
		when mu.Url is not null then @MainUrl
		when cg.SignupUrl is not null then 'Landing pages'
		else 'None' end

drop table #DepositInfo

---------------
-- III. NRU (Newly Registered Users)

-- III.1 NRU Detail
select ag.UserName AS AgentName, a.AffName
	, isnull(cg.SignupUrl, 'None') as SignupUrl
	, count(1) as TotalPlayers
	, sum(isnull(d.amount, 0)) as TotalDepositAmount
	, sum(isnull(d.firstdepositamount, 0)) as TotalFirstDepositAmount
from dbo.Customer c with (nolock)
	inner join dbo.Customer ag with (nolock) on c.AgentId = ag.CustId
	left join #Affiliate a ON c.CustId = a.CustId
	left join dbo.CustRegInfo cg with (nolock) on c.CustId = cg.CustId
	outer apply (
		select sum(d.amount) as amount, sum(case when d.FirstDeposit = 1 then d.amount else 0 end) as firstdepositamount
		from dbo.DepositInfo d with (nolock)
		where c.custid = d.CustId
			and d.Status = 3
			and d.CreateTime >= @fdate and d.CreateTime < @tdate
	) d
where c.RegTime >= @fdate and c.RegTime < @tdate
	and c.SiteId = @siteId
	and c.IsTest = 0
group by ag.UserName, a.AffName, isnull(cg.SignupUrl, 'None')
order by TotalDepositAmount desc

-- III.1 NRU Sum
select
	case
		when a.CustId is not null then 'AFF'
		when ag.UserName = @CreditAgentName then 'Bong88/Viva88'
		when mu.Url is not null then @MainUrl
		when cg.SignupUrl is not null then 'Landing pages'
		else 'None' end as SignupUrl
	, count(1) as TotalPlayers
	, sum(isnull(d.amount, 0)) as TotalDepositAmount
	, sum(isnull(d.firstdepositamount, 0)) as TotalFirstDepositAmount
from dbo.Customer c with (nolock)
	inner join dbo.Customer ag with (nolock) on c.AgentId = ag.CustId
	left join #Affiliate a ON c.CustId = a.CustId
	left join dbo.CustRegInfo cg with (nolock) on c.CustId = cg.CustId
	left join @MainUrls mu on cg.SignupUrl = mu.Url
	outer apply (
		select sum(d.amount) as amount, sum(case when d.FirstDeposit = 1 then d.amount else 0 end) as firstdepositamount
		from dbo.DepositInfo d with (nolock)
		where c.custid = d.CustId
			and d.Status = 3 -- Aprroved
			and d.CreateTime >= @fdate and d.CreateTime < @tdate
	) d
where c.RegTime >= @fdate and c.RegTime < @tdate
	and c.SiteId = @siteId
	and c.IsTest = 0
group by
	case
		when a.CustId is not null then 'AFF'
		when ag.UserName = @CreditAgentName then 'Bong88/Viva88'
		when mu.Url is not null then @MainUrl
		when cg.SignupUrl is not null then 'Landing pages'
		else 'None' end

drop table #Affiliate