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

create table #__statement
(
	custid int primary key,roleid tinyint
	,recommend int,mrecommend int,srecommend int
	,OpeningBalance money,OpeningTotalBalance money
)

while @winlostdate <= @todate
begin
	-- reset data
	truncate table #__statement
	-- prepare data
	begin
		select @weekday = datepart(weekday, @winlostdate)
		select @pre_saturday = dateadd(day, -datepart(weekday, @winlostdate), @winlostdate)

		-- get transfer cust
		begin
			select custid
			into #__transCust
			from bodb_Archive.dbo.transfer_bk with (nolock)
			where winlostdate = @winlostdate
			group by winlostdate, custid
		end
	
		-- member
		begin
			if @weekday = 7
			begin
				insert into #__statement (custid,roleid,recommend,mrecommend,srecommend,OpeningBalance)
				select custid,roleid,recommend,mrecommend,srecommend,OpeningBalance
				from dbo.rptStatement_Old r with (nolock)
					cross apply (
						select roleid,recommend,mrecommend,srecommend from bodb02.dbo.custinfo c with (nolock)
						where r.custid = c.custid and c.roleid = 1
					) as c
				where r.winlostdate = @winlostdate
			end
			else
			begin
				select r.custid,roleid,recommend,mrecommend,srecommend, max(r.winlostdate) as winlostdate
				into #__tmpData1
				from dbo.rptStatement_Old r with (nolock)
					cross apply (
						select roleid,recommend,mrecommend,srecommend from bodb02.dbo.custinfo c with (nolock)
						where r.custid = c.custid and c.roleid = 1
					) as c
				where r.winlostdate >= @pre_saturday and r.winlostdate <= @winlostdate
				group by r.custid,roleid,recommend,mrecommend,srecommend
				option (hash group)
			
				insert into #__statement (custid,roleid,recommend,mrecommend,srecommend,OpeningBalance)
				select custid,roleid,recommend,mrecommend,srecommend,ClosingBalance as OpeningBalance
				from #__tmpData1 c
					cross apply (
						select top 1 ClosingBalance from dbo.rptStatement_Old r with (nolock)
						where r.custid = c.custid and r.winlostdate = c.winlostdate
						order by winlostdate desc
					) as r

				drop table #__tmpData1
			end
		end

		-- SMA
		begin
			select custid,roleid,recommend,mrecommend,srecommend
			into #__SMA
			from bodb02.dbo.custInfo c with (nolock)
			where exists (select 1 from #__transCust t where t.custid = c.custid
							union all select 1 from #__statement s where c.custid in (s.recommend, s.mrecommend, s.srecommend)
							)
				and c.roleid > 1

			if @weekday = 7
			begin
				insert into #__statement (custid,roleid,recommend,mrecommend,srecommend,OpeningBalance)
				select custid,roleid,recommend,mrecommend,srecommend,OpeningBalance
				from dbo.rptStatement_Old r with (nolock)
					cross apply (
						select roleid,recommend,mrecommend,srecommend from #__SMA s
						where r.custid = s.custid
					) as c
				where r.winlostdate = @winlostdate
			end
			else
			begin
				select r.custid,roleid,recommend,mrecommend,srecommend, max(r.winlostdate) as winlostdate
				into #__tmpData2
				from dbo.rptStatement_Old r with (nolock)
					cross apply (
						select roleid,recommend,mrecommend,srecommend from #__SMA c
						where r.custid = c.custid
					) as c
				where r.winlostdate >= @pre_saturday and r.winlostdate <= @winlostdate
				group by r.custid,roleid,recommend,mrecommend,srecommend
				option (hash group)

				insert into #__statement (custid,roleid,recommend,mrecommend,srecommend,OpeningBalance)
				select custid,roleid,recommend,mrecommend,srecommend,ClosingBalance as OpeningBalance
				from #__tmpData2 c
					cross apply (
						select top 1 ClosingBalance from dbo.rptStatement_Old r with (nolock)
						where r.custid = c.custid and r.winlostdate = c.winlostdate
						order by winlostdate desc
					) as r

				drop table #__tmpData2
			end

			drop table #__SMA
			drop table #__transCust
		end
	end

	-- calculate OpeningTotalBalance
	begin
		update s1
		set s1.OpeningTotalBalance = s.OpeningTotalBalance
		from #__statement s1
			cross apply (
				-- super
				select sum(OpeningBalance) as OpeningTotalBalance from #__statement s where s1.custid = s.srecommend
				-- master
				union all
				select sum(OpeningBalance) as OpeningTotalBalance from #__statement s where s1.custid = s.mrecommend
				-- agent
				union all
				select sum(OpeningBalance) as OpeningTotalBalance from #__statement s where s1.custid = s.recommend
				-- member
				union all
				select OpeningBalance as OpeningTotalBalance from #__statement s where s1.custid = s.custid
			) as s
	end

	-- update data
	begin
		update r with (rowlock)
		set r.OpeningTotalBalance = s.OpeningTotalBalance
		from dbo.rptStatement_Old r
			cross apply (
				select s.OpeningTotalBalance from #__statement s where r.custid = s.custid
			) as s
		where r.winlostdate = @winlostdate
	end

	select @errmsg = 'Done ' + convert(varchar(10), @winlostdate, 120)
	raiserror (@errmsg, 1, 1) with nowait

	select @winlostdate = dateadd(day, 1, @winlostdate)
end

drop table #__statement