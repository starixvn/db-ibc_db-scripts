use bodb_Report
go

/*
	Created: 20190722@Percy
	DB: DBRPT.bodb_Report
	Task: rptStatement_Old - Initialize data for new column: OpeningTotalBalance
	RedmineID: #109293

	FromDate: 30 Mar 2019
	ToDate: the day before BalanceUpDay (2019-07-12): 2019-07-11

	exec bodb02.dbo.Age_SelBalanceUpDay
*/

declare @fromdate smalldatetime = '2019-03-30'
		,@todate smalldatetime = '2019-07-11'

declare @winlostdate smalldatetime = @fromdate
		,@errmsg varchar(200)
		,@weekday tinyint
		,@pre_saturday smalldatetime

create table #__statement (custid int,winlostdate smalldatetime,OpeningBalance money,OpeningTotalBalance money)

create table #__cust (custid int, winlostdate smalldatetime)
create table #__balanceCust (custid int, winlostdate smalldatetime)

create table #__SMA (custid int, winlostdate smalldatetime)

while @winlostdate <= @todate
begin
	-- reset data
	truncate table #__statement
	-- prepare data
	begin
		select @weekday = datepart(weekday, @winlostdate)
		select @pre_saturday = dateadd(day, -datepart(weekday, @winlostdate), @winlostdate)

		if @weekday = 7
		begin
			-- member
			insert into #__statement(custid,OpeningTotalBalance)
			select r.custid,r.OpeningBalance
			from bodb_Report.dbo.rptStatement_Old r with (nolock)
				cross apply (
					select c.custid from bodb02.dbo.custinfo c with (nolock)
					where c.roleid = 1
				) as c
			where r.custid = c.custid and r.winlostdate = @winlostdate

			-- agent
			select c.recommend as custid, sum(OpeningTotalBalance) as OpeningTotalBalance
			into #__agent1
			from bodb02.dbo.custinfo c with (nolock)
				inner join #__statement s on c.custid = s.custid
			where c.roleid = 1
			group by c.recommend

			insert into #__statement(custid,OpeningTotalBalance)
			select r.custid,r.OpeningBalance + isnull(a.OpeningTotalBalance, 0)
			from bodb_Report.dbo.rptStatement_Old r with (nolock)
				cross apply (
					select c.custid from bodb02.dbo.custinfo c with (nolock)
					where c.roleid = 2
				) as c
				left join #__agent1 a on r.custid = a.custid
			where r.custid = c.custid and r.winlostdate = @winlostdate

			-- master
			select c.mrecommend as custid, sum(OpeningTotalBalance) as OpeningTotalBalance
			into #__master1
			from bodb02.dbo.custinfo c with (nolock)
				inner join #__statement s on c.custid = s.custid
			where c.roleid = 2
			group by c.mrecommend

			insert into #__statement(custid,OpeningTotalBalance)
			select r.custid,r.OpeningBalance + isnull(m.OpeningTotalBalance, 0)
			from bodb_Report.dbo.rptStatement_Old r with (nolock)
				cross apply (
					select c.custid from bodb02.dbo.custinfo c with (nolock)
					where c.roleid = 3
				) as c
				left join #__master1 m on r.custid = m.custid
			where r.custid = c.custid and r.winlostdate = @winlostdate

			-- super
			select c.srecommend as custid, sum(OpeningTotalBalance) as OpeningTotalBalance
			into #__super1
			from bodb02.dbo.custinfo c with (nolock)
				inner join #__statement s on c.custid = s.custid
			where c.roleid = 3
			group by c.srecommend

			insert into #__statement(custid,OpeningTotalBalance)
			select r.custid,r.OpeningBalance + isnull(s.OpeningTotalBalance, 0)
			from bodb_Report.dbo.rptStatement_Old r with (nolock)
				cross apply (
					select c.custid from bodb02.dbo.custinfo c with (nolock)
					where c.roleid = 4
				) as c
				left join #__super1 s on r.custid = s.custid
			where r.custid = c.custid and r.winlostdate = @winlostdate

			drop table #__agent1
			drop table #__master1
			drop table #__super1
		end
		else
		begin
			-- member
			select r.custid,max(r.winlostdate) as winlostdate
			into #__member2
			from bodb_Report.dbo.rptStatement_Old r with (nolock)
				cross apply (
					select c.custid from bodb02.dbo.custinfo c with (nolock)
					where c.roleid = 1
				) as c
			where r.custid = c.custid and r.winlostdate >= @pre_saturday and r.winlostdate <= @winlostdate
			group by r.custid

			insert into #__statement(custid,OpeningTotalBalance)
			select r.custid,case when r.winlostdate = @winlostdate then r.OpeningBalance else r.ClosingBalance end
			from bodb_Report.dbo.rptStatement_Old r with (nolock)
				cross apply (
					select c.custid, c.winlostdate from #__member2 c
				) as c
			where r.custid = c.custid and r.winlostdate = c.winlostdate

			-- agent
			select r.custid,max(r.winlostdate) as winlostdate
			into #__agent
			from bodb_Report.dbo.rptStatement_Old r with (nolock)
				cross apply (
					select c.custid from bodb02.dbo.custinfo c with (nolock)
					where c.roleid = 2
				) as c
			where r.custid = c.custid and r.winlostdate >= @pre_saturday and r.winlostdate <= @winlostdate
			group by r.custid

			select c.recommend as custid, sum(OpeningTotalBalance) as OpeningTotalBalance
			into #__agent2
			from bodb02.dbo.custinfo c with (nolock)
				inner join #__statement s on c.custid = s.custid
			where c.roleid = 1
			group by c.recommend

			insert into #__statement(custid,OpeningTotalBalance)
			select r.custid,case when r.winlostdate = @winlostdate then r.OpeningBalance else r.ClosingBalance end + isnull(a.OpeningTotalBalance, 0)
			from bodb_Report.dbo.rptStatement_Old r with (nolock)
				cross apply (
					select c.custid, c.winlostdate from #__agent c
				) as c
				left join #__agent2 a on r.custid = a.custid
			where r.custid = c.custid and r.winlostdate = c.winlostdate

			-- master
			select r.custid,max(r.winlostdate) as winlostdate
			into #__master
			from bodb_Report.dbo.rptStatement_Old r with (nolock)
				cross apply (
					select c.custid from bodb02.dbo.custinfo c with (nolock)
					where c.roleid = 3
				) as c
			where r.custid = c.custid and r.winlostdate >= @pre_saturday and r.winlostdate <= @winlostdate
			group by r.custid

			select c.mrecommend as custid, sum(OpeningTotalBalance) as OpeningTotalBalance
			into #__master2
			from bodb02.dbo.custinfo c with (nolock)
				inner join #__statement s on c.custid = s.custid
			where c.roleid = 2
			group by c.mrecommend

			insert into #__statement(custid,OpeningTotalBalance)
			select r.custid,case when r.winlostdate = @winlostdate then r.OpeningBalance else r.ClosingBalance end + isnull(a.OpeningTotalBalance, 0)
			from bodb_Report.dbo.rptStatement_Old r with (nolock)
				cross apply (
					select c.custid, c.winlostdate from #__master c
				) as c
				left join #__master2 a on r.custid = a.custid
			where r.custid = c.custid and r.winlostdate = c.winlostdate
			
			-- super
			select r.custid,max(r.winlostdate) as winlostdate
			into #__super
			from bodb_Report.dbo.rptStatement_Old r with (nolock)
				cross apply (
					select c.custid from bodb02.dbo.custinfo c with (nolock)
					where c.roleid = 4
				) as c
			where r.custid = c.custid and r.winlostdate >= @pre_saturday and r.winlostdate <= @winlostdate
			group by r.custid

			select c.srecommend as custid, sum(OpeningTotalBalance) as OpeningTotalBalance
			into #__super2
			from bodb02.dbo.custinfo c with (nolock)
				inner join #__statement s on c.custid = s.custid
			where c.roleid = 3
			group by c.srecommend

			insert into #__statement(custid,OpeningTotalBalance)
			select r.custid,case when r.winlostdate = @winlostdate then r.OpeningBalance else r.ClosingBalance end + isnull(a.OpeningTotalBalance, 0)
			from bodb_Report.dbo.rptStatement_Old r with (nolock)
				cross apply (
					select c.custid, c.winlostdate from #__super c
				) as c
				left join #__super2 a on r.custid = a.custid
			where r.custid = c.custid and r.winlostdate = c.winlostdate

			drop table #__agent
			drop table #__master
			drop table #__super

			drop table #__agent2
			drop table #__master2
			drop table #__super2
		end
	end

	-- update data
	select @errmsg = 'Done ' + convert(varchar(10), @winlostdate, 120)
	raiserror (@errmsg, 1, 1) with nowait

	select @winlostdate = dateadd(day, 1, @winlostdate)
end

drop table #__statement