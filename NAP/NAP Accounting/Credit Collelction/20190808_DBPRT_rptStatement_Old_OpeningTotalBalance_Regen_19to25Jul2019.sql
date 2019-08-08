use bodb_Report
go

/*
	Created: 20190808@Percy
	DB: DBRPT.bodb_Report
	Task: Regen OpeningTotalBalance on rptStatement_Old from [19 Jul 2019] to [25 Jul 2019]
*/

declare @fromdate date = '2019-07-19'
		,@todate date = '2019-07-25'

declare @winlostdate date = @fromdate
declare @tmpwinlostdate date, @msg varchar(200)


while @winlostdate <= @todate
begin
	select @msg = convert(varchar(8), getdate(), 114) + ': Start ' + convert(varchar(10), @winlostdate, 120)
	raiserror (@msg, 1, 1) with nowait
	
	if object_id('tempdb..#__tmpBalance') is not null
		drop table #__tmpBalance

	create table #__tmpBalance (custid int, roleid tinyint, recommend int, mrecommend int, srecommend int, OpeningTotalBalance decimal(37,4))

	if @winlostdate = '2019-07-19'
	begin
		insert into #__tmpBalance (custid, OpeningTotalBalance)
		select custid, OpeningBalance from dbo.rptStatement_Old_Adhoc with (nolock) where winlostdate = '2019-07-19'

		insert into #__tmpBalance (custid, OpeningTotalBalance)
		select custid, OpeningBalance from dbo.rptStatement_Old_Adhoc r with (nolock) where winlostdate = '2019-07-20'
			and not exists (select 1 from #__tmpBalance b where r.custid = b.custid)
	end
	else if @winlostdate = '2019-07-20'
	begin
		insert into #__tmpBalance (custid, OpeningTotalBalance)
		select custid, OpeningBalance from dbo.rptStatement_Old_Adhoc r with (nolock) where winlostdate = '2019-07-20'
	end
	else
	begin
		insert into #__tmpBalance (custid, OpeningTotalBalance)
		select custid, OpeningBalance from dbo.rptStatement_Old_Adhoc r with (nolock) where winlostdate = @winlostdate

		select @tmpwinlostdate = dateadd(day, -1, @winlostdate)
		
		while @tmpwinlostdate >= '2019-07-20'
		begin
			insert into #__tmpBalance (custid, OpeningTotalBalance)
			select custid, ClosingBalance from dbo.rptStatement_Old_Adhoc r with (nolock) where winlostdate = @tmpwinlostdate
				and not exists (select 1 from #__tmpBalance b where r.custid = b.custid)
			
			select @tmpwinlostdate = dateadd(day, -1, @tmpwinlostdate)
		end
	end

	update b
	set b.roleid = c.roleid, b.recommend = c.recommend, b.mrecommend = c.mrecommend, b.srecommend = c.srecommend
	from #__tmpBalance b
		inner join bodb02.dbo.custinfo c with (nolock) on b.custid = c.custid

	create nonclustered index ix_srecommend on #__tmpBalance (srecommend)
	create nonclustered index ix_mrecommend on #__tmpBalance (mrecommend)
	create nonclustered index ix_recommend  on #__tmpBalance (recommend)
	create nonclustered index ix_role_cust  on #__tmpBalance (roleid, custid)

	update b
	set b.OpeningTotalBalance = c.OpeningTotalBalance
	from #__tmpBalance b
		cross apply (
			select sum(s.OpeningTotalBalance) as OpeningTotalBalance from #__tmpBalance s where b.custid = s.srecommend and b.roleid = 4
			union all
			select sum(m.OpeningTotalBalance) as OpeningTotalBalance from #__tmpBalance m where b.custid = m.mrecommend and b.roleid = 3
			union all
			select sum(a.OpeningTotalBalance) as OpeningTotalBalance from #__tmpBalance a where b.custid = a.recommend and b.roleid = 2
		) as c
	where b.roleid in (2,3,4)

	--- Update data
	update r with (rowlock)
	set r.OpeningTotalBalance = b.OpeningTotalBalance
	from dbo.rptStatement_Old_Adhoc r
		inner join #__tmpBalance b on r.custid = b.custid
	where r.winlostdate = @winlostdate

	select @msg = convert(varchar(8), getdate(), 114) + ': End ' + convert(varchar(10), @winlostdate, 120)
	raiserror (@msg, 1, 1) with nowait
	
	select @winlostdate = dateadd(day, 1, @winlostdate)
end