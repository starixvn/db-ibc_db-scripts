/*
	Created: 20190725@Percy
	DB: DB052/DB053
	Task: Compare Super Balance between LAP vs NAP Report
	
	Information:
		- Data source:
			1. NAP Report	: bodb_LicenseeReport.dbo.rptLicWinloss2
			2. LAP			: bodb_LicenseeReport.dbo.rpt_BettingByProduct
		- Input:
			1. Product		: AG, GD, BX
			2. Date range	: FromDate and ToDate
			3. Currency		: specify currency
			4. Site			: specify licensee
*/

-- input information
declare @productcode varchar(2) = 'GD' -- AG, GD, BX
		,@fromdate	smalldatetime = '2019-06-01'
		,@todate	smalldatetime = '2019-06-30'
		,@currency	int = 61
		,@site		varchar(50) = '12bet'
-- end input information


-- check input
if @fromdate > @todate or datediff(month, @fromdate, @todate) <> 0
begin
	raiserror ('just check 1 month only',16,1)
	return
end

-- end check input

-- declare variables
declare @sporttype int, @productid int, @siteid int
select  @sporttype  = case @productcode when 'AG' then 250 when 'GD' then 255 when 'BX' then 221 end
		,@productid = case @productcode when 'AG' then 10 when 'GD' then 11 when 'BX' then 31 end
select  @siteid = licenseeid from bodb_licensee.dbo.licensees with (nolock) where licenseename = @site

create table #__NAP			(winlostdate smalldatetime, superBalance money)
create table #__LA			(winlostdate smalldatetime, superBalance money)
create table #__rawData		(winlostdate smalldatetime, superBalance money)
create table #__Adjustment	(winlostdate smalldatetime, superBalance money)

declare @rawData table (winlostdate smalldatetime, bettype int, memberWL money, memberComm money,LicenseeComm money)

declare @balanceupday smalldatetime, @movebetsday smalldatetime
declare @mbbu table (balanceupday smalldatetime, movebetsday smalldatetime)
insert into @mbbu (balanceupday, movebetsday)
exec bodb02.dbo.age_selbalanceupday

select @balanceupday = balanceupday, @movebetsday = movebetsday from @mbbu

-- for adjustment data
declare @endofmonth smalldatetime
select  @endofmonth = dateadd(day, -1, dateadd(month, datediff(month, 0, @ToDate) + 1, 0))

declare @adj_endmonth money

declare @tmpfromdate smalldatetime, @tmptodate smalldatetime
declare @tmpAdjustment table
(
	custid int,bettype int,superBalance money,transdesc varchar(300)
	,winlostdate smalldatetime,bt_winlostdate smalldatetime
)

-- licensee wl (charge fee)
declare @partyid int
select  @partyid = partyid from bodb_licensee.dbo.oas_party with (nolock) where partyname = @site

declare @chargeinfo table(partyid int,bettype int,rate money,fromdate smalldatetime,todate smalldatetime)
insert into @chargeinfo(partyid,bettype,rate,fromdate,todate)
select distinct partyid,case when productid = 11 and chargetype = 12 then 1706 else bettype end as chargetype,di_rate,fromdate,todate
from bodb_licensee.dbo.la_f_chargeinfo(@partyid,@fromdate,@todate,@productcode, 'oa', 1)
where di_rate > 0 and licenseeid = @siteid

-- 3rd dummy account
declare @dummyCustId int
select  @dummyCustId = custid
from bodb02.dbo.vw_customer with (nolock)
where mrecommend IN (select custid from bodb02.dbo.vw_customer with (nolock) 
					where username like '%acc%' and roleid = 3 and site = @site and currency = @currency)
	and username like '%dummy3rd%'
	and roleid = 1

-- end declare variables

-- get data
	-- NAP Report
	insert into #__NAP
	select winlostdate, -sum(isnull(b.swinlost, 0) + isnull(b.mwinlost, 0) + isnull(b.awinlost, 0) + isnull(b.winlost, 0) + isnull(b.scomm, 0)) as superBalance
	from bodb_LicenseeReport.dbo.rptLicWinloss2 b with (nolock)
	where winlostdate between @fromdate and @todate
		and sporttype = @sporttype
		and roleid = 4
		and statusid in (111,112,113,114,115)
		and Currency = @currency
		and exists (select 1 from bodb02.dbo.Dep_CustSuper c with (nolock) where b.custid = c.custid and c.site = @site)
	group by winlostdate
	order by winlostdate

	-- LA
	insert into #__LA
	select rptDate as winlostdate, sum(-(b.MemberWL + b.CommissionP + b.CommissionA - b.MemberWL * (1 - p.Rate))) as superBalance
	from bodb_LicenseeReport.dbo.rpt_BettingByProduct b with (nolock)
		inner join @chargeinfo p on b.rptdate between p.fromdate and p.todate and p.bettype = b.bettype
	where rptDate between @fromdate and @todate
		and ProductID = @productid
		and statusid not in (-1, 101, 102, 103)
		and CurrencyId = @currency
		and SiteID = @siteid
		and CustomerCategory not in (27,28)
	group by rptDate
	order by rptDate

	-- raw data
	if @productcode = 'AG'
	begin
		insert into @rawData
		select winlostdate, -1, sum((abs(winlost) - abs(stake))) as memberWL, 0, 0
		from bodb_PlaytechCS.dbo.bettrans_AGCasino b with (nolock)
		where winlostdate between @fromdate and @todate
			and statusid in (111,112,113)
			and Currency = @currency
			and exists (select 1 from bodb02.dbo.Dep_CustSuper c with (nolock) where b.srecommend = c.custid and c.site = @site)
		group by winlostdate
	end
	else if @productcode = 'GD'
	begin
		insert into @rawData
		select winlostdate,bettype, sum(MemberWL) as MemberWL, 0, 0
		from (
			select winlostdate, -1 as bettype, sum((abs(winlost) - abs(stake))) as MemberWL
			from bodb_PlaytechCS.dbo.bettrans_GoldDeluxe b with (nolock)
			where winlostdate between @fromdate and @todate
				and statusid in (111,112,113)
				and Currency = @currency
				and exists (select 1 from bodb02.dbo.Dep_CustSuper c with (nolock) where b.srecommend = c.custid and c.site = @site)
			group by winlostdate

			union all
			select winlostdate, 1706, -sum(abs(Amount)) as MemberWL
			from bodb_PlaytechCS.dbo.GoldDeluxe_Tip b with (nolock)
			where winlostdate between @fromdate and @todate
				and Currency = @currency
				and exists (select 1 from bodb02.dbo.Dep_CustSuper c with (nolock) where b.srecommend = c.custid and c.site = @site)
			group by winlostdate
		) as a
		group by winlostdate, bettype
	end
	else if @productcode = 'BX'
	begin
		insert into @rawData
		select convert(date, settledDate) as winlostdate,
				-1 as bettype,
				sum(marketTotal/ExVirtualRate) as MemberWL,
				sum(commission/ExVirtualRate) as MemberComm,
				sum(agentCommission/ExVirtualRate) as LicenseeComm
		from bodb_3rdProduct.dbo.Sum_winloss_Exchange s with (nolock)
		where settledDate >= @fromdate and settledDate < dateadd(day, 1, @todate)
			and Currency = @currency
			and exists (select 1 from bodb02.dbo.Dep_CustSuper dc with (nolock)
							inner join bodb02.dbo.CustInfo c with (nolock) on dc.custid = c.srecommend
						where s.custid = c.custid and dc.site = @site)
		group by convert(date, settledDate)
	end

	insert into #__rawData
	select winlostdate, -sum(r.memberWL + r.memberComm -r.memberWL*(1-c.rate) + r.licenseeComm) as superBalance
	from @rawData r
		inner join @chargeinfo c on r.winlostdate between c.fromdate and c.todate and r.bettype = c.bettype
	group by winlostdate

	-- data adjustment on bettrans
	if @endofmonth = @todate
	begin
		select @tmpfromdate = @fromdate
		select @tmptodate   = dateadd(day, 7, @endofmonth)
		
		-- bettrans_bk
		if @tmpfromdate < @balanceupday
		begin
			insert into @tmpAdjustment (bt_winlostdate,custid, bettype, transdesc, superBalance)
			select winlostdate,custid, bettype, transdesc, -(winlost-actual_stake+swinlost+mwinlost+awinlost+scomm) as superBalance
			from dbarc.bodb_archive.dbo.bettrans_bk with (nolock)
			where winlostdate between @tmpfromdate and @balanceupday
				and custid = @dummyCustId
				and matchid = 0 and transdesc like '% Adjustment - Date: %'
		end

		-- bettrans14
		if @tmpfromdate <= @movebetsday
		begin
			insert into @tmpAdjustment (bt_winlostdate,custid, bettype, transdesc, superBalance)
			select winlostdate,custid, bettype, transdesc, -(winlost-actual_stake+swinlost+mwinlost+awinlost+scomm) as superBalance
			from bodb02.dbo.bettrans14 with (nolock)
			where winlostdate between @balanceupday and @movebetsday
				and custid = @dummyCustId
				and matchid = 0 and transdesc like '% Adjustment - Date: %'
		end

		-- bettrans
		if @tmptodate > @movebetsday
		begin
			insert into @tmpAdjustment (bt_winlostdate,custid, bettype, transdesc, superBalance)
			select winlostdate,custid, bettype, transdesc, -(winlost-actual_stake+swinlost+mwinlost+awinlost+scomm) as superBalance
			from bodb02.dbo.bettrans with (nolock)
			where winlostdate between @movebetsday and @tmptodate
				and custid = @dummyCustId
				and matchid = 0 and transdesc like '% Adjustment - Date: %'
		end

		delete @tmpAdjustment
		where bettype not in 
				(
					select 1800 as bettype where @productcode = 'AG'
					union all select 1700 as bettype where @productcode = 'GD'
					union all select 1706 as bettype where @productcode = 'GD'
					union all select 8000 as bettype where @productcode = 'BX'
				)

		if exists (select 1 from @tmpAdjustment)
		begin
			

			update @tmpAdjustment
			set winlostdate = substring(transdesc, charindex('date: ', transdesc, 0) + 6, 10)

			insert into #__Adjustment
			select winlostdate, sum(superBalance)
			from (
				-- adjust last month
				select bt_winlostdate as winlostdate, -sum(superBalance) as superBalance
				from @tmpAdjustment
				where bt_winlostdate between @fromdate and @todate
				group by bt_winlostdate

				-- adjust this month
				union all
				select winlostdate, sum(superBalance)
				from @tmpAdjustment
				where winlostdate between @fromdate and @todate
				group by winlostdate
			) as a
			group by winlostdate

			select @adj_endmonth = sum(superBalance) from #__Adjustment where winlostdate = @endofmonth
		end
	end
-- end get data

-- return result
select
	isnull(isnull(isnull(n.winlostdate, l.winlostdate), r.winlostdate), a.winlostdate) as winlostdate
	,isnull(n.superBalance, 0) as NAP_superBalance
	,isnull(l.superBalance, 0) as LA_superBalance
	,isnull(r.superBalance, 0) as rawData_superBalance
	,round(isnull(n.superBalance, 0) - isnull(l.superBalance, 0), 4) as diff_NAP_LA_superBalance
	,isnull(a.superBalance, 0) as Adj_superBalance
	,round(isnull(l.superBalance, 0) - isnull(r.superBalance, 0), 4) as diff_LA_rawData_superBalance
	,round(isnull(n.superBalance, 0) + isnull(a.superBalance, 0)  - isnull(r.superBalance, 0), 4) as diff_superBalance
into #__Details
from #__NAP n
	full outer join #__LA l on n.winlostdate = l.winlostdate
	full outer join #__rawData r on n.winlostdate = r.winlostdate
	full outer join #__Adjustment a on n.winlostdate = a.winlostdate

-- Total
select
	'Total' as Total
	,sum(rawData_superBalance)	as rawData_superBalance
	,sum(LA_superBalance)		as LA_superBalance
	,sum(NAP_superBalance)		as NAP_superBalance
	,sum(Adj_superBalance)		as Adj_superBalance
	,sum(LA_superBalance - NAP_superBalance - Adj_superBalance) as Diff
from #__Details

select *
from #__Details
order by winlostdate

-- end return result

drop table #__LA
drop table #__NAP
drop table #__rawData
drop table #__Adjustment
drop table #__Details